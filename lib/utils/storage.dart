import 'package:get_storage/get_storage.dart';

class AppStorage {
  static final _box = GetStorage();

  // Save JWT token
  static Future<void> saveToken(String token) async {
    await _box.write('token', token);
  }

  static String? getToken() {
    return _box.read('token');
  }

  // Save user ID
  static Future<void> saveUserId(String id) async {
    await _box.write('user_id', id);
  }

  static String? getUserId() {
    return _box.read('user_id');
  }

  // Clear all storage
  static Future<void> clear() async {
    await _box.erase();
  }
}
