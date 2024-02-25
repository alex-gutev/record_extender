import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_visitor.dart';
import 'package:record_extender/src/nullability_extension.dart';

/// Visit types and substitute references to generic type parameters.
class TypeSubstitutionVisitor extends UnifyingTypeVisitorWithArgument<String, int> {
  @override
  String visitDartType(DartType type, int size) {
    switch (type) {
      case ParameterizedType(:var typeArguments):
        final args = typeArguments.map((e) => e.acceptWithArgument(this, size));

        return type.getDisplayString(withNullability: type.nullabilitySuffix.isNullable)
            .replaceAll(RegExp(r'<(.+)>'), '<${args.join(',')}>');

      case TypeParameterType():
        final name = type.getDisplayString(withNullability: false);
        final nullable = type.nullabilitySuffix.isNullable ? '?' : '';

        return '$name\$$size$nullable';

      case _:
        return type.getDisplayString(
            withNullability: type.nullabilitySuffix.isNullable
        );
    }
  }
}