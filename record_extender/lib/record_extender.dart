library record_extender;

import 'package:build/build.dart';
import 'package:record_extender/src/record_extension_generator.dart';
import 'package:source_gen/source_gen.dart';

Builder generateRecordExtension(BuilderOptions options) {
  return SharedPartBuilder(
      [RecordExtensionGenerator()],
      'record_extension_generator'
  );
}