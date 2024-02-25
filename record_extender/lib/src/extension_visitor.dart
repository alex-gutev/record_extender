import 'dart:collection';

import 'package:analyzer/dart/constant/value.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/visitor.dart';

/// Visit and extract information about the elements to include in generated record extensions.
class ExtensionVisitor extends SimpleElementVisitor<void> {
  /// The elements to include in the generated extensions
  List<ElementSpec> get elements =>
      UnmodifiableListView(_elements);

  @override
  void visitPropertyAccessorElement(PropertyAccessorElement element) {
    if (element.isGetter) {
      _addElement(element);
    }
  }

  /*@override
  void visitMethodElement(MethodElement element) {
    _addElement(element);
  }*/

  // Private

  final _elements = <ElementSpec>[];

  /// Add an element to the list of included elements.
  ///
  /// The element is added if its annotated with [RecordExtensionElement]
  void _addElement(Element element) {
    for (final annotation in element.metadata) {
      final object = annotation.computeConstantValue();

      if (object != null &&
          object.type?.getDisplayString(withNullability: false) == 'RecordExtensionElement') {
        _elements.add(ElementSpec.parse(element, object));
      }
    }
  }
}

/// Specification defining the code that should be generated for an element.
class ElementSpec {
  /// The element
  final Element element;

  /// Code defining the return type
  final String returnType;

  /// Code defining the implementation
  final String implementation;

  ElementSpec({
    required this.element,
    required this.returnType,
    required this.implementation
  });

  factory ElementSpec.parse(Element element, DartObject object) => ElementSpec(
      element: element,
      returnType: object.getField('type')!.toStringValue()!,
      implementation: object.getField('implementation')!.toStringValue()!
  );
}