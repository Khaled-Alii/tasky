import 'package:get_storage/get_storage.dart';

class StorageManager {
  static final _instance = StorageManager._();

  StorageManager._();

  factory StorageManager() => _instance;

  late final GetStorage _getStorage;

  Future<void> init() async {
    await GetStorage.init();
    _getStorage = GetStorage();
  }

  dynamic read(String key) {
    return _getStorage.read(key);
  }

  Future<void> write(String key, dynamic value) async {
    await _getStorage.write(key, value);
  }
  Future<void> remove(String key) async {
    await _getStorage.remove(key);
  }

  Future<void> erase() async {
    await _getStorage.erase();
  }
}
