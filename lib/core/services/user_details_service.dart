import 'package:to_do/core/constants/storage_key.dart';
import 'package:to_do/core/services/storage_manager.dart';

class UserDetailsService {
  final StorageManager service;

  UserDetailsService(this.service);

  String getUserName() {
    return service.read(StorageKey.userName) ?? 'Guest';
  }

  String getUserMotivationQuote() {
    return service.read(StorageKey.motivationQuote) ??
        'One task at a time.One step closer.';
  }

  Future<void> setUserName(String name) async {
    await service.write(StorageKey.userName, name);
  }

  Future<void> setUserMotivationQuote(String motivationQuote) async {
    await service.write(StorageKey.motivationQuote, motivationQuote);
  }

  String? getUserProfilePicture() {
    return service.read(StorageKey.profilePicture);
  }

  Future<void> setUserProfilePicture(String path) async {
    await service.write(StorageKey.profilePicture, path);
  }
}
