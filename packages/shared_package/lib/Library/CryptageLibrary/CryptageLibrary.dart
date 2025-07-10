import 'dart:isolate';
import 'dart:math';

import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/foundation.dart';
//import 'package:blake2/blake2.dart';
import 'dart:convert';

import 'package:pointycastle/export.dart';

class CryptageLibrary {
  final signer = Signer('SHA-256/RSA');
  late AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;

  CryptageLibrary();

  Uint8List rsaSign(RSAPrivateKey privateKey, Uint8List dataToSign,
      String privateExponent, Uint8List uint8list) {
    final signer = RSASigner(SHA256Digest(), '0609608648016503040201');
    signer.init(true, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final sig = signer.generateSignature(dataToSign);
    return sig.bytes;
  }

  static RSAPrivateKey createRSAPrivateKey(
      String modulus, String privateExponent) {
    return RSAPrivateKey(BigInt.parse(modulus, radix: 16),
        BigInt.parse(privateExponent, radix: 16), null, null);
  }



  SecureRandom getSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  //Generate RSA Key Pair
  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> generateRSAKeyPair(
      SecureRandom secureRandom,
      {int bitLength = 2048}) {
    final keyGen = RSAKeyGenerator()
      ..init(ParametersWithRandom(
          RSAKeyGeneratorParameters(BigInt.parse('65537'), bitLength, 64),
          secureRandom));

    final pair = keyGen.generateKeyPair();
    final publicKey = pair.publicKey as RSAPublicKey;
    final privateKey = pair.privateKey as RSAPrivateKey;

    return AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey>(
        publicKey, privateKey);
  }



  Future<void> generateKeyPair() async {
    keyPair =
        await Isolate.run(() => generateRSAKeyPair(getSecureRandom()));
  }

  // SHA-1
  static String sha1(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha1.convert(bytes);
    return digest.toString();
  }

  // SHA-224
  static String sha224(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha224.convert(bytes);
    return digest.toString();
  }

  // SHA-256
  static String sha256(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha256.convert(bytes);
    return digest.toString();
  }

  // SHA-384
  static String sha384(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha384.convert(bytes);
    return digest.toString();
  }

  // SHA-512
  static String sha512(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha512.convert(bytes);
    return digest.toString();
  }

  // SHA-512/224
  static String sha512224(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha512224.convert(bytes);
    return digest.toString();
  }

  // SHA-512/256
  static String sha512256(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.sha512256.convert(bytes);
    return digest.toString();
  }

  // MD5
  static String md5(String input) {
    var bytes = utf8.encode(input);
    var digest = crypto.md5.convert(bytes);
    return digest.toString();
  }

  // HMAC (generic implementation)
  static String hmac(String key, String message, crypto.Hash hashFunction) {
    var hmac = crypto.Hmac(hashFunction, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(message));
    return digest.toString();
  }

  // HMAC-MD5
  static String hmacMd5(String key, String message) {
    return hmac(key, message, md5 as crypto.Hash);
  }

  // HMAC-SHA1
  static String hmacSha1(String key, String message) {
    return hmac(key, message, sha1 as crypto.Hash);
  }

  // HMAC-SHA256
  static String hmacSha256(String key, String message) {
    return hmac(key, message, sha256 as crypto.Hash);
  }

   /*  There is a pd to use black2 on the web few numbers in hexadecimal are not recognized by javascript
  I must fork the package to make the changes 7/03/2025
  and change by :List<BigInt> iv = [
  BigInt.parse('0x6a09e667f3bcc908'),
  BigInt.parse('0xbb67ae8584caa73b'),
  BigInt.parse('0x3c6ef372fe94f82b'),
  BigInt.parse('0xa54ff53a5f1d36f1'),
  BigInt.parse('0x510e527fade682d1'),
  BigInt.parse('0x9b05688c2b3e6c1f'),
  BigInt.parse('0x1f83d9abfb41bd6b'),
  BigInt.parse('0x5be0cd19137e2179'),


  String blake2bHash(String input, {int digestLength = 64}) {
    var bytes = utf8.encode(input);
    var hasher = Blake2b(digestLength: digestLength);
    hasher.update(bytes);
    var digest = hasher.digest();
    return digest.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }

  String blake2sHash(String input, {int digestLength = 32}) {
    var bytes = utf8.encode(input);
    var hasher = Blake2s(digestLength: digestLength);
    hasher.update(bytes);
    var digest = hasher.digest();
    return digest.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
  }
*/

  // HMAC algorithms
  static String hmacHS256(String key, String message) {
    var hmac = crypto.Hmac(crypto.sha256, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(message));
    return digest.toString();
  }

  static String hmacHS384(String key, String message) {
    var hmac = crypto.Hmac(crypto.sha384, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(message));
    return digest.toString();
  }

  static String hmacHS512(String key, String message) {
    var hmac = crypto.Hmac(crypto.sha512, utf8.encode(key));
    var digest = hmac.convert(utf8.encode(message));
    return digest.toString();
  }

  // RSA-PSS algorithms
  static Uint8List rsaPSS(
      RSAPrivateKey privateKey, Uint8List message, String algorithm) {
    final signer = Signer('$algorithm/PSS');
    final params = ParametersWithRandom<PrivateKeyParameter<RSAPrivateKey>>(
        PrivateKeyParameter<RSAPrivateKey>(privateKey),
        SecureRandom('Fortuna')..seed(KeyParameter(Uint8List(32))));
    signer.init(true, params);
    final signature = signer.generateSignature(message) as RSASignature;
    return signature.bytes;
  }

  static String rs256bis(RSAPrivateKey privateKey, String message) {
    return base64Url.encode(rsaPSS(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-256'));
  }

  // Function rs256
  // modulus A very large integer, typically 2048 or 4096 bits long is part of public and private key
  // Exponent :   A large positive integer that forms the core of the RSA private key
  static Uint8List rs256(
      String modulus, String privateExponent, String message) {
    RSAPrivateKey privateKey;
    Uint8List? bytesSignature;

    try {
      privateKey = RSAPrivateKey(
        BigInt.parse(modulus, radix: 16),
        BigInt.parse(privateExponent, radix: 16),
        BigInt.from(65537), // Common public exponent
        BigInt.parse(modulus, radix: 16), // Use modulus for consistency
      );

      final signer = Signer('SHA-256/RSA');
      final params = PrivateKeyParameter<RSAPrivateKey>(privateKey);
      signer.init(true, params);
      final signature = signer.generateSignature(Uint8List.fromList(utf8.encode(message))) as RSASignature;
      bytesSignature = signature.bytes;

      return bytesSignature;
    } catch (e) {
      if (e is FormatException) {
        print('Error parsing modulus or private exponent: $e');
      } else {
        rethrow;
      }
      throw Exception('Failed to generate signature');
    }
  }


  static String rsa384(RSAPrivateKey privateKey, String message) {
    return base64Url.encode(rsaPSS(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-384'));
  }

  static String rsa512(RSAPrivateKey privateKey, String message) {
    return base64Url.encode(rsaPSS(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-512'));
  }

// RSA-PKCS1-v1_5 algorithms
  static String rsaPKCS1v15(
      RSAPrivateKey privateKey, String message, String algorithm) {
    final signer = Signer('$algorithm/PKCS1');
    final params = PrivateKeyParameter<RSAPrivateKey>(privateKey);
    signer.init(true, params);

    final signature =
        signer.generateSignature(Uint8List.fromList(utf8.encode(message)))
            as RSASignature;
    return base64Encode(signature.bytes);
  }

  static String rs384(RSAPrivateKey privateKey, String message) {
    return rsaPKCS1v15(privateKey, message, 'SHA-384');
  }

  static String rs512(RSAPrivateKey privateKey, String message) {
    return rsaPKCS1v15(privateKey, message, 'SHA-512');
  }

  // ECDSA algorithms
  static String ecdsaSign(
      ECPrivateKey privateKey, Uint8List message, String algorithm) {
    final signer = Signer('$algorithm/DET-ECDSA');
    final params = PrivateKeyParameter<ECPrivateKey>(privateKey);
    signer.init(true, params);
    final signature = signer.generateSignature(message) as ECSignature;

    // Combine r and s into a single byte array
    final r = _bigIntToBytes(signature.r);
    final s = _bigIntToBytes(signature.s);
    final combined = Uint8List(r.length + s.length)
      ..setAll(0, r)
      ..setAll(r.length, s);

    return base64Url.encode(combined);
  }

// Helper function to convert BigInt to bytes
  static Uint8List _bigIntToBytes(BigInt bigInt) {
    var data = BigInt.parse(bigInt.toString());
    var size = (data.bitLength + 7) >> 3;
    var result = Uint8List(size);
    for (var i = 0; i < size; i++) {
      result[size - i - 1] = data.toUnsigned(8).toInt();
      data = data >> 8;
    }
    return result;
  }

  static String es256(ECPrivateKey privateKey, String message) {
    return ecdsaSign(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-256');
  }

  static String es256k(ECPrivateKey privateKey, String message) {
    return ecdsaSign(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-256');
  }

  static String es384(ECPrivateKey privateKey, String message) {
    return ecdsaSign(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-384');
  }

  static String es512(ECPrivateKey privateKey, String message) {
    return ecdsaSign(
        privateKey, Uint8List.fromList(utf8.encode(message)), 'SHA-512');
  }

  static String edDSA(ECPrivateKey privateKey, String message) {
    final signer = Signer('Ed25519');
    final params = PrivateKeyParameter<ECPrivateKey>(privateKey);
    signer.init(true, params);
    final signature =
        signer.generateSignature(Uint8List.fromList(utf8.encode(message)))
            as RSASignature;
    return base64Encode(signature as List<int>);
  }
}
