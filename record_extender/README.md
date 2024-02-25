This package provides a code generator for generating extensions on records, with multiple sizes, 
using a template.

## Features

* Generates record extensions for records with multiple sizes using one template.
* Documentation and implementation written in one place only.
* You only need to test one record extension, even if 20 are generated, since they are all
  generated using the same template.

## Getting started

Add [`record_extender_annotations`](https://pub.dev/packages/record_extender_annotations) to the
dependencies of your `pubspec.yaml`:

```yaml
dependencies:
  ...
  record_extender_annotations: ^0.1.0
```

Add `build_runner` and this package to the `dev_dependencies` of your `pubspec.yaml`:

```yaml
dev_dependencies:
  ...
  build_runner: ^2.4.8
  record_extender: ^0.1.0
```

To generate record extensions for annotated extension templates, run:

```shell
dart run build_runner build
```

## Usage

1. Annotate an extension with `@RecordExtension(size: ...)`. The annotated extension is used as a
   template to generate `size` record extensions with the number of elements varying from `2` to
   `size`.

2. Annotate the elements you would like included in the generated extensions, with
   `@RecordExtensionElement` while providing the return type and implementation.

3. Run `dart run build_runner build` in your project's root directory.

Example:

```dart
import 'my_extension.g.dart';

@RecordExtension(size: 3)
extension MyExtension<T> on MyType<T> {
  @RecordExtensionElement(
    type: 'MyType<({type-params})>',
    implementation: 'return MyType(({elements}));'
  )
  MyType<T> get combine => this;
}
```

This results in the following three (since `size: 3` was specified) extensions being generated:

```dart
extension MyExtension2<T$1, T$2> on (MyType<T$1>, MyType<T$2>) {
  MyType<(T$1, T$2)> get combine {
    return MyType(($1, $2));
  }
}
```

```dart
extension MyExtension3<T$1, T$2, T$3> on (MyType<T$1>, MyType<T$2>, MyType<T$3>) {
  MyType<(T$1, T$2, T$3)> get combine {
    return MyType(($1, $2, $3));
  }
}
```

### Placeholders

The `RecordExtensionElement` annotation takes two required parameters:

* `type` -- The code defining the return type of the generated elements.
* `implementation` -- The code defining the implementation of the generated elements.

Within these two parameters the following placeholders will be substituted when generating the
extensions:

Within `type` and `implementation` the following placeholders can be used:

* `{types}`

   Substituted with the comma-separated list of the record element types,
   e.g. 'MyType<T$1>, MyType<T$1>, MyType<T$3>'.

* `{elements}`

   Substituted with the comma-separated list of accessors for each element,
   e.g. '$1, $2, $3'.

* `{type-params}`

   Substituted with the comma-separated List of the generated extension type
   parameters, e.g. 'T$1, T$2, T$3'.

The only supported elements on which `RecordExtensionElement` can be used are property getters.

### Documentation Comments

To add a documentation comment to each generated record extension, provide the content of the comment
in the `documentation` parameter of `@RecordExtension(...)`.

```dart
@RecordExtension(
  size: 3,
  documentation: 'Provides the [combine] property.'
)
extension MyExtension<T> on MyType<T> {
  ...
}
```

To add a documentation comment to the elements within each generated record extension, 
provide the content of the comment in the `documentation` parameter of `@RecordExtensionElement(...)`.

```dart
@RecordExtensionElement(
    type: 'MyType<({type-params})>',
    implementation: 'return MyType(({elements}));',
    documentation: '''Combine a record of [MyType]s into a single [MyType] holding a record.

The returned [MyType] holds a record containing the values held in the [MyTypes] in this.'''
)
MyType<T> get combine => this;
```

## Additional information

If you discover any issues or have any feature requests, please open an issue on the package's Github
repository.
