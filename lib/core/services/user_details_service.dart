import 'package:to_do/core/services/storage_manager.dart';

class UserDetailsService {
  final StorageManager service;

  UserDetailsService(this.service);

  String getUserName() {
    return service.read('username') ?? 'Guest';
  }

  String getUserMotivationQuote() {
    return service.read('MotivationQuote') ??
        'One task at a time.One step closer.';
  }

  Future<void> setUserName(String name) async {
    await service.write('username', name);
  }

  Future<void> setUserMotivationQuote(String motivationQuote) async {
    await service.write('MotivationQuote', motivationQuote);
  }
}
