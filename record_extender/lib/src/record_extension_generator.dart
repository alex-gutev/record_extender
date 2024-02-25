import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:record_extender/src/extension_visitor.dart';
import 'package:record_extender/src/type_substitution_visitor.dart';
import 'package:source_gen/source_gen.dart';
import 'package:record_extender_annotations/record_extender_annotations.dart';

/// Generates record extensions using annotated extensions as a template.
class RecordExtensionGenerator extends GeneratorForAnnotation<RecordExtension> {
  @override
  String generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) {
    if (element is! ExtensionElement) {
      throw InvalidGenerationSourceError(
          'The RecordExtension annotation is only applicable to extensions.',
          todo: 'Remove the RecordExtension annotation',
          element: element
      );
    }

    final size = annotation.read('size').intValue;

    final visitor = ExtensionVisitor();
    element.visitChildren(visitor);

    final buffer = StringBuffer();

    for (int i = 2; i <= size; i++) {
      buffer.writeln(_generateExtensionRecord(
        baseName: element.displayName,
        typeParams: element.typeParameters,
        extendedType: element.extendedType,
        size: i,
        elements: visitor.elements
      ));
    }

    return buffer.toString();
  }

  /// Generate a record extensions with [size] elements.
  String _generateExtensionRecord({
    required String baseName,
    required List<TypeParameterElement> typeParams,
    required DartType extendedType,
    required int size,
    required List<ElementSpec> elements
  }) {
    final recordTypeParams = _recordTypeParams(elements: typeParams, size: size)
        .join(',');

    final recordType = _recordElementTypes(extendedType: extendedType, size: size)
        .join(',');

    final recordElements = Iterable.generate(size, (i) => '\$${i + 1}')
        .join(',');

    final buffer = StringBuffer();

    buffer.write('extension $baseName$size<$recordTypeParams> on ($recordType) {');

    for (final spec in elements) {
      switch (spec.element) {
        case PropertyAccessorElement():
          buffer.write(_generateGetter(
              element: spec.element as PropertyAccessorElement,
              spec: spec,
              recordType: recordType,
              recordElements: recordElements,
              recordTypeParams: recordTypeParams
          ));
      }
    }

    buffer.writeln('}');

    return buffer.toString();
  }

  /// Generate a record extension property getter.
  String _generateGetter({
    required PropertyAccessorElement element,
    required ElementSpec spec,
    required String recordType,
    required String recordElements,
    required String recordTypeParams,
  }) {
    final returnType = _replacePlaceholders(
        spec.returnType,
        recordType: recordType,
        recordElements: recordElements,
        recordTypeParams: recordTypeParams
    );

    final buffer = StringBuffer();
    buffer.writeln('$returnType get ${element.name} {');

    buffer.writeln(_replacePlaceholders(
        spec.implementation,
        recordType: recordType,
        recordElements: recordElements,
        recordTypeParams: recordTypeParams
    ));

    buffer.writeln('}');

    return buffer.toString();
  }

  /// Get the type parameters to add to the generated extension
  static List<String> _recordTypeParams({
    required List<TypeParameterElement> elements,
    required int size
  }) {
    final params = <String>[];

    for (var i = 0; i < size; i++) {
      for (final element in elements) {
        params.add('${element.displayName}\$${i + 1}');
      }
    }

    return params;
  }

  /// Get the types of the record elements
  static List<String> _recordElementTypes({
    required DartType extendedType,
    required int size,
  }) {
    return Iterable.generate(size, (i) => extendedType
        .acceptWithArgument(TypeSubstitutionVisitor(), i + 1))
        .toList();
  }

  /// Replace placeholders in [str].
  static String _replacePlaceholders(String str, {
    required String recordType,
    required String recordElements,
    required String recordTypeParams
  }) {
    return str.replaceAll('\{types\}', recordType)
        .replaceAll('\{elements\}', recordElements)
        .replaceAll('\{type-params\}', recordTypeParams);
  }
}