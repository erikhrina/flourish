import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  final String _databaseName = "plants";

  Future<String> getDbPath() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    return p.join(docsDir.path, _databaseName);
  }

  Future<bool> delteDb() async {
    Directory databaseDir = Directory(await getDbPath());
    try {
      if (await databaseDir.exists()) {
        await databaseDir.delete(recursive: true);
      }
      return true;
    } catch (_) {
      return false;
    }
  }
}
