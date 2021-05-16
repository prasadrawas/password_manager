import 'package:encrypt/encrypt.dart' as encrypts;
import 'package:encrypt/encrypt.dart';
import 'package:password_manager/utils/databasehelper.dart';

class Encryption {
  static final _key = encrypts.Key.fromLength(32);
  static final _iv = encrypts.IV.fromLength(16);
  static final _encrypter = encrypts.Encrypter(encrypts.AES(_key));

  static encryptText(text) {
    final encryptedText = _encrypter.encrypt(text, iv: _iv);
    return encryptedText.base64;
  }

  static decryptText(text) {
    return _encrypter.decrypt(Encrypted.from64(text), iv: _iv);
  }
}
