This package provides annotations for generating extensions on records, with multiple sizes, using 
a template.

## Usage

1. Annotate an extension with `@RecordExtension(size: ...)`. The annotated extension is used as a
   template to generate `size` record extensions with the number of elements varying from `2` to
   `size`.

2. Annotate the elements you would like included in the generated extensions, with 
   `@RecordExtensionElement` while providing the return type and implementation.

Example:

```dart
@RecordExtension(size: 3)
extension MyExtension<T> on MyType<T> {
  @RecordExtensionElement(
    type: 'MyType<({type-params})>'
    implementation: 'return MyType(({elements}));'
  )
  MyType<T> get combine => this;
}
```

This specifies that the following three (since `size: 3` was specified) extensions should be generated:

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

## Additional information

Visit the `record_extender` package for full usage instructions.
