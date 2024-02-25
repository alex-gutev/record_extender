library record_extender_annotations;

/// Annotation for generating record type extensions.
///
/// This annotation is applicable to extensions. When applied it specifies
/// that the extension should be used as template for generating extensions
/// on record types.
///
/// [size] record extensions are generated with the number of elements varying
/// from 2 to [size].
///
/// For example:
///
/// ```dart
/// @RecordExtension(size: 3)
/// extension MyExtension<T> on MyType<T> {
/// ...
/// }
/// ```
///
/// Specifies that the following record extensions should be generated:
///
/// ```dart
/// extension MyExtension2<T$1, T$2> on (MyType<T$1>, MyType<T$2> {
/// ...
/// }
///
/// extension MyExtension3<T$1, T$2, T$3> on (
///   MyType<T$1>,
///   MyType<T$2>,
///   MyType<T$3>
/// ) {
/// ...
/// }
/// ```
class RecordExtension {
  /// Number of record extensions to generate
  final int size;

  /// Documentation comment to insert if not null.
  final String? documentation;

  /// Specifies that [size] record extensions should be generated using the annotated element as a template.
  ///
  /// If [documentation] is the non-null it is insert above every generated
  /// element as a documentation comment.
  const RecordExtension({
    required this.size,
    this.documentation
  });
}

/// Specify that the annotated element should be included in a generated record extension.
///
/// This annotation is applicable to elements within an extension annotated
/// with [RecordExtension]. When applied it specifies that the annotated
/// element should be included in all generated record extensions for the
/// extension in which the element is defined.
///
/// This annotation defines the return type ([type]) and the code
/// ([implementation]) serving as the implementation.
///
/// Within [type] and [implementation] the following placeholders can be used:
///
/// * `{types}`
///
///   Substituted with the comma-separated list of the record element types,
///   e.g. 'MyType<T$1>, MyType<T$1>, MyType<T$3>'.
///
/// * `{elements}`
///
///   Substituted with the comma-separated list of accessors for each element,
///   e.g. '$1, $2, $3'.
///
/// * `{type-params}`
///
///   Substituted with the comma-separated List of the generated extension type
///   parameters, e.g. 'T$1, T$2, T$3'.
///
/// The following elements are supported:
///
/// - Property getters
class RecordExtensionElement {
  /// The return type and implementation code of this element
  final String type, implementation;

  /// Documentation comment to insert if not null.
  final String? documentation;

  /// Specify that the annotated element should be included in a generated record extension.
  ///
  /// [type] is the code defining the return type of the generated element.
  ///
  /// [implementation] is the code defining the implementation of the
  /// generated element.
  ///
  /// [documentation] is the documentation comment to insert above the generated
  /// element, if non-null.
  const RecordExtensionElement({
    required this.type,
    required this.implementation,
    this.documentation
  });
}