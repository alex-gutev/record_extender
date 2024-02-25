import 'package:analyzer/dart/element/nullability_suffix.dart';

extension NullabilityExtension on NullabilitySuffix {
  /// Is this type is nullable?
  bool get isNullable => [NullabilitySuffix.star, NullabilitySuffix.question]
      .contains(this);
}