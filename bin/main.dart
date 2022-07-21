import 'dart:io';

import 'package:path/path.dart';

void main(List<String> arguments) {
  clean(Directory.current);
}

void clean(Directory directory) {
  var file = File(join(directory.path, 'pubspec.yaml'));
  if (file.existsSync()) {
    processRun(
      executable: 'flutter',
      arguments: 'clean',
      runInShell: true,
      workingDirectory: directory.path,
    );
  }
  for (FileSystemEntity child in directory.listSync()) {
    FileSystemEntityType type = FileSystemEntity.typeSync(child.path);
    String name = basename(directory.path);
    if (type == FileSystemEntityType.directory &&
        !name.startsWith('.') &&
        name != 'ios' &&
        name != 'android') {
      clean(Directory(child.path));
    }
  }
}

void processRun({
  required String executable,
  required String arguments,
  bool runInShell = false,
  String? workingDirectory,
}) {
  final ProcessResult result = Process.runSync(
    executable,
    arguments.split(' '),
    runInShell: runInShell,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode != 0) {
    throw Exception(result.stderr);
  }
  print('$workingDirectory :\n${result.stdout}\n');
}
