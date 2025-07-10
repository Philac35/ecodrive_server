import "dart:convert";
import "dart:io";
import "dart:math";

import "package:asn1lib/asn1lib.dart";
import 'package:basic_utils/basic_utils.dart';
import "package:ecodrive_server/src/Services/Interface/Service.dart";
import 'package:pointycastle/export.dart';

import "package:ecodrive_server/src/Library/CryptageLibrary/CryptageLibrary.dart";
import "package:ecodrive_server/src/Services/LogSystem/LogSystem.dart";
import "package:ecodrive_server/src/Services/LogSystem/LogSystemBDD.dart";
import "package:pointycastle/api.dart" as pointycasteldapi;
import "package:pointycastle/asymmetric/api.dart";
import 'package:flutter/foundation.dart';
import "package:pointycastle/digests/sha256.dart";

import "package:pointycastle/random/fortuna_random.dart";
import "package:pointycastle/signers/rsa_signer.dart" as pointycastelsigner;

//Intern Dependences
import "package:ecodrive_server/src/Services/CryptService/SignToken.dart";
import "../EmbededBdd/SecureStorage.dart";
import "EncryptService.dart";

class TokenService implements Service {
  CryptageLibrary? cryptageLibrary;
  late EncryptService encryptService;
  File privateKeyFile = File(
      "package:ecodrive_server/src/Configuration/.Securite/Certificate/Authentication/private/privateKey.key");
  File publicKeyFile = File(
      "/src/Configuration/.Securite/Certificate/Authentication/public/publicKey.key");

  String? token;
  String? tokenName;

  TokenService() {
    // cryptageLibrary = CryptageLibrary();
    this.encryptService = EncryptService();
  }

  ASN1Sequence _createPrivateKeyASN1Sequence(RSAPrivateKey privateKey) {
    final sequence = ASN1Sequence();
    sequence.add(ASN1Integer(BigInt.zero)); // version
    sequence.add(ASN1Integer(privateKey.modulus!)); // modulus
    sequence.add(ASN1Integer(privateKey.publicExponent!)); // public exponent
    sequence.add(ASN1Integer(privateKey.privateExponent!)); // private exponent
    sequence.add(ASN1Integer(privateKey.p!)); // prime1
    sequence.add(ASN1Integer(privateKey.q!)); // prime2
    sequence.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.p! - BigInt.one))); // exp1
    sequence.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.q! - BigInt.one))); // exp2
    sequence.add(
        ASN1Integer(privateKey.q!.modInverse(privateKey.p!))); // coefficient
    return sequence;
  }

  /*
    * Function encodePrivateKeyTOPEM
    * @Param: RSAPrivateKey
    * @Param: bool usePKCS8
    * @Return PEM in PKCS8 or PKCS1
    */
  String encodePrivateKeyToPEM(RSAPrivateKey privateKey,
      {bool usePKCS8 = true}) {
    if (usePKCS8) {
      // PKCS#8 Encoding
      final privateKeyASN1 = _createPrivateKeyASN1Sequence(privateKey);

      final privateKeyInfo = ASN1Sequence()
        ..add(ASN1Integer(BigInt.from(0))) // Version
        ..add(ASN1Sequence()
          ..add(ASN1ObjectIdentifier(
              [1, 2, 840, 113549, 1, 1, 1])) // RSA Encryption OID
          ..add(ASN1Null())) // No parameters for RSA
        ..add(
            ASN1OctetString(privateKeyASN1.encodedBytes)); // Private key bytes

      // Encode to DER
      final der = privateKeyInfo.encodedBytes;
      final pem = "-----BEGIN PRIVATE KEY-----\n" +
          base64.encode(der) +
          "\n-----END PRIVATE KEY-----";

      return pem;
    } else {
      // PKCS#1 Encoding
      final topLevel = ASN1Sequence();

      // Add RSA key components in PKCS#1 order
      topLevel.add(ASN1Integer(BigInt.from(0))); // Version
      topLevel.add(ASN1Integer(privateKey.n!)); // Modulus (n)
      topLevel.add(ASN1Integer(privateKey.exponent!)); // Public Exponent (e)
      topLevel.add(ASN1Integer(privateKey.d!)); // Private Exponent (d)
      topLevel.add(ASN1Integer(privateKey.p!)); // Prime 1 (p)
      topLevel.add(ASN1Integer(privateKey.q!)); // Prime 2 (q)
      topLevel.add(ASN1Integer(
          privateKey.d! % (privateKey.p! - BigInt.one))); // d mod (p-1)
      topLevel.add(ASN1Integer(
          privateKey.d! % (privateKey.q! - BigInt.one))); // d mod (q-1)
      topLevel.add(ASN1Integer(
          privateKey.q!.modInverse(privateKey.p!))); // Coefficient (q^-1 mod p)

      // Encode to DER
      final der = topLevel.encodedBytes;
      final pem = "-----BEGIN RSA PRIVATE KEY-----\n" +
          base64.encode(der) +
          "\n-----END RSA PRIVATE KEY-----";

      return pem;
    }
  }

  /*
    * Function encodePublicKeyTOPEM
    * @Param: RSAPrivateKey
    * @Param: bool usePKCS8
    * @Return PEM in PKCS8 or PKCS1 (default PKCS8, set usePKCS8 false for PKCS1)
    */
  String encodePublicKeyToPEM(RSAPublicKey publicKey, {bool usePKCS8 = true}) {
    if (usePKCS8) {
      // PKCS#8 Encoding
      final subjectPublicKeyInfo = ASN1Sequence()
        ..add(ASN1Sequence()
          ..add(ASN1ObjectIdentifier(
              [1, 2, 840, 113549, 1, 1, 1])) // RSA Encryption OID
          ..add(ASN1Null())) // No parameters for RSA
        ..add(
          (ASN1Sequence()
            ..add(ASN1Integer(publicKey.modulus!))
            ..add(ASN1Integer(publicKey.exponent!))
            ..encodedBytes),
        );

      // Encode to DER and then to PEM
      final der = subjectPublicKeyInfo.encodedBytes;
      final pem = "-----BEGIN PUBLIC KEY-----\n" +
          base64.encode(der) +
          "\n-----END PUBLIC KEY-----";

      return pem;
    } else {
      // PKCS#1 Encoding
      final publicKeyASN1 = ASN1Sequence()
        ..add(ASN1Integer(publicKey.modulus!)) // Modulus (n)
        ..add(ASN1Integer(publicKey.exponent!)); // Public Exponent (e)

      // Encode to DER and then to PEM
      final der = publicKeyASN1.encodedBytes;
      final pem = "-----BEGIN RSA PUBLIC KEY-----\n" +
          base64.encode(der) +
          "\n-----END RSA PUBLIC KEY-----";

      return pem;
    }
  }

  /*
   * generateKeyPair
   * can be encode in  PKCS1 or PKCS2 depend of PEM generation
   */
  Future<void> generateKeyPair(pointycasteldapi.SecureRandom secureRandom,
      {bool usePKCS8 = true}) async {
    final keyPair =
        encryptService.generateRSAKeyPair(encryptService.getSecureRandom());

    final myPublic = keyPair.publicKey as RSAPublicKey;
    final myPrivate = keyPair.privateKey as RSAPrivateKey;

    final privateKeyPEM = encodePrivateKeyToPEM(myPrivate, usePKCS8: usePKCS8);
    final publicKeyPEM = encodePublicKeyToPEM(myPublic, usePKCS8: usePKCS8);

    try {
      print(this.privateKeyFile.path);
      File writedfile = await this.privateKeyFile.writeAsString(privateKeyPEM);
      if (writedfile.existsSync()) {
        print('privateKey wrote  in file successfully');
      } else {
        print("privateKey wasn't wrote in file");
      }
      ;
      //  File writedfile = privateKeyFile.writeAsStringSync(privateKeyPEM);
      // if( writedfile.existsSync()){print('privateKey wrote  in file successfully');};
    } catch (e) {
      debugPrint("TokenService L109, Pb to generate privateKey, error : ${e}");
      debugPrint("Error writing private key: $e");
    }
    ;

    try {
      File writedpublickeyfile =
          await this.publicKeyFile.writeAsString(publicKeyPEM);
      if (writedpublickeyfile.existsSync()) {
        print('publicKey wrote  in file successfully');
      } else {
        print("publicKey wasn't wrote in file");
      }
      ;
    } catch (e) {
      if (kIsWeb) {
        LogSystemBDD().error(
            "TokenService L118, Pb to generate publicKey, error : ${e}",
            stackTrace: StackTrace.current.toString());
      } else {
        LogSystem().error(
          "TokenService L118, Pb to generate publicKey, error : ${e}",
        );
      }
      debugPrint("TokenService L118, Pb to generate publicKey, error : ${e}");
      debugPrint("Error writing public key: $e");
    }
  }

//Is it PKCS1 or PKCS2 ?
  Future<RSAPrivateKey> generateAndValidateRSAKeyPair() async {
    final secureRandom = encryptService.getSecureRandom();
    if (secureRandom == null) {
      throw Exception('Secure random is null');
    }

    try {
      final keyPair =
          await this.encryptService!.generateRSAKeyPair(secureRandom);

      final privateKey = keyPair.privateKey as RSAPrivateKey;
      final modulus = privateKey.modulus;
      final p = privateKey.p;
      final q = privateKey.q;

      if (modulus == null || p == null || q == null) {
        throw Exception('Modulus, p, or q is null');
      }

      final pBigInt = BigInt.parse(p.toRadixString(16), radix: 16);
      final qBigInt = BigInt.parse(q.toRadixString(16), radix: 16);

      final calculatedModulus = pBigInt * qBigInt;
      final modulusBigInt = BigInt.parse(modulus.toRadixString(16), radix: 16);

      if (modulusBigInt != calculatedModulus) {
        throw Exception('Modulus is inconsistent with RSA p and q');
      }

      return privateKey;
    } catch (e) {
      throw Exception('Error generating or validating RSA key pair: $e');
    }
  }

  void createKeyPairIfFilesDontExist() async {
    if (!await privateKeyFile.exists() || !await publicKeyFile.exists()) {
      final secureRandom = FortunaRandom();
      final random = Random.secure();
      final seeds = List<int>.generate(32, (i) => random.nextInt(255));
      secureRandom
          .seed(pointycasteldapi.KeyParameter(Uint8List.fromList(seeds)));
      generateKeyPair(secureRandom);
    }
  }

  /*
   * Function generateJWT
   * fonctionnel au 6/03/2025 11h32
   */
  Future<String> generateJWT(
      String privateKey, Map<String, dynamic> payload) async {
    RSAPrivateKey? privateRSAKey =
        await encryptService?.safeRSAPrivateKeyParse(privateKey);

    // Convert RSA private key to PEM format
    String pemPrivateKey;
    try {
      pemPrivateKey = _encodePrivateKeyToPem(privateRSAKey!);

      print('PEM private key generated successfully');
    } catch (e) {
      print('Error encoding private key to PEM: $e');
      throw Exception('Error encoding private key to PEM: $e');
    }
    try {
      // Continue with the JWT generation logic
      // Example of creating a JWT (this is a placeholder and should be replaced with actual JWT generation logic)
      final header = {'alg': 'RS256', 'typ': 'JWT'};
      final headerBase64 = base64Url.encode(json.encode(header).codeUnits);
      final payloadBase64 = base64Url.encode(json.encode(payload).codeUnits);
      if (pemPrivateKey == null) {
        throw Exception('PEM private key is null');
      }
      if (headerBase64 == null || payloadBase64 == null) {
        throw Exception('Header or payload is null');
      }
      List<int> signature;
      try {
        signature = await SignToken()
            .signData(pemPrivateKey, '$headerBase64.$payloadBase64');
        if (kDebugMode) {
          print('Signature generated successfully');
        }
      } catch (e, stackTrace) {
        if (kDebugMode) {
          print('Error in SignToken().signData(): $e');

          print('Stack trace: $stackTrace');
        }
        throw Exception('Error signing data: $e');
      }
      final signatureBase64 = base64Url.encode(signature);

      // Print debug information

      if (kDebugMode) {
        print('generateJWT - headerBase64: $headerBase64');
        print('generateJWT - payloadBase64: $payloadBase64');
        print('generateJWT - signatureBase64: $signatureBase64');
      }
      var outValue = '$headerBase64.$payloadBase64.$signatureBase64';
      if (kDebugMode) {
        print(outValue);
      }
      return outValue;
    } catch (e) {
      throw Exception('Error generating JWT: $e');
    }
  }

  String _encodePrivateKeyToPem(RSAPrivateKey privateKey) {
    final topLevel = ASN1Sequence();

    topLevel.add(ASN1Integer(BigInt.from(0))); // Version
    topLevel.add(ASN1Integer(privateKey.modulus!));
    topLevel.add(ASN1Integer(privateKey.publicExponent!));
    topLevel.add(ASN1Integer(privateKey.privateExponent!));
    topLevel.add(ASN1Integer(privateKey.p!));
    topLevel.add(ASN1Integer(privateKey.q!));
    topLevel.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.p! - BigInt.from(1))));
    topLevel.add(ASN1Integer(
        privateKey.privateExponent! % (privateKey.q! - BigInt.from(1))));
    topLevel.add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

    final dataBase64 = base64.encode(topLevel.encodedBytes);
    final pemHeader = '-----BEGIN RSA PRIVATE KEY-----\n';
    final pemFooter = '\n-----END RSA PRIVATE KEY-----';

    // Wrap the Base64 encoded data to 64 characters per line
    final wrappedBase64 = dataBase64.replaceAllMapped(
        RegExp('.{1,64}'), (match) => '${match.group(0)}\n');

    return '$pemHeader$wrappedBase64$pemFooter';
  }

// Placeholder function for signing data (this should be replaced with actual signing logic)
  List<int> signData(String pemPrivateKey, String data) {
    // Implement the signing logic here
    // This is a placeholder and should be replaced with actual signing logic
    return List<int>.from(data.codeUnits);
  }

  String generateSignature(RSAPrivateKey privateKey, String data) {
    final signer = pointycastelsigner.RSASigner(SHA256Digest(), 'SHA-256')
      ..init(true,
          pointycasteldapi.PrivateKeyParameter<RSAPrivateKey>(privateKey));

    final signature =
        signer.generateSignature(Uint8List.fromList(utf8.encode(data))).bytes;

    return base64Url.encode(signature).replaceAll('=', '');
  }

  /*
  * Function parsePrivateKeyFromPem
  * this function it works 4/03/2025 12h15
  */

  Future<RSAPrivateKey> parsePrivateKeyFromPem(String pemString) async {
    return encryptService.safeRSAPrivateKeyParse(pemString);
  }

  Future<RSAPrivateKey> parsePrivateKeyFromPem4(String pemString) async {
    try {
      final privateKey = CryptoUtils.rsaPrivateKeyFromPem(pemString);
      return privateKey;
    } catch (e) {
      throw Exception('Error parsing private key: $e');
    }
  }

  Future<RSAPrivateKey> parsePrivateKeyFromPemPrevious(String pemString) async {
    try {
      final privateKey = RSAKeyParser().parse(pemString) as RSAPrivateKey;
      return privateKey;
    } catch (e) {
      throw Exception('Error parsing private key: $e');
    }
  }

  RSAPrivateKey parsePrivateKeyFromPemPrevious3(String pemString) {
    final pem = pemString
        .replaceAll(RegExp(r'-----BEGIN RSA PRIVATE KEY-----'), '')
        .replaceAll(RegExp(r'-----END RSA PRIVATE KEY-----'), '')
        .replaceAll('\n', '');
    final bytes = base64Decode(pem);
    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // RSA Private Key Structure:
    // 0. version (ASN1Integer)
    // 1. modulus (ASN1Integer)
    // 2. publicExponent (ASN1Integer)
    // 3. privateExponent (ASN1Integer)
    // 4. prime1 (ASN1Integer)
    // 5. prime2 (ASN1Integer)
    // 6. exponent1 (ASN1Integer)
    // 7. exponent2 (ASN1Integer)
    // 8. coefficient (ASN1Integer)

    final version = topLevelSeq.elements?[0] as ASN1Integer;
    final n = topLevelSeq.elements?[1] as ASN1Integer;
    final e = topLevelSeq.elements?[2] as ASN1Integer;
    final d = topLevelSeq.elements?[3] as ASN1Integer;
    final p = topLevelSeq.elements?[4] as ASN1Integer;
    final q = topLevelSeq.elements?[5] as ASN1Integer;
    final exp1 = topLevelSeq.elements?[6] as ASN1Integer;
    final exp2 = topLevelSeq.elements?[7] as ASN1Integer;
    final coeff = topLevelSeq.elements?[8] as ASN1Integer;

    return RSAPrivateKey(
      n.valueAsBigInteger,
      d.valueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
      //exp1.valueAsBigInteger,
      // exp2.valueAsBigInteger,
      //coeff.valueAsBigInteger,
    );
  }

  RSAPrivateKey parsePrivateKeyFromPemPrevious2(String pemString) {
    final pem = pemString
        .replaceAll(RegExp(r'-----BEGIN RSA PRIVATE KEY-----'), '')
        .replaceAll(RegExp(r'-----END RSA PRIVATE KEY-----'), '')
        .replaceAll('\n', '');
    final bytes = base64Decode(pem);
    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    // RSA Private Key Structure:
    // 0. version (ASN1Integer)
    // 1. modulus (ASN1Integer)
    // 2. publicExponent (ASN1Integer)
    // 3. privateExponent (ASN1Integer)
    // 4. prime1 (ASN1Integer)
    // 5. prime2 (ASN1Integer)
    // 6. exponent1 (ASN1Integer)
    // 7. exponent2 (ASN1Integer)
    // 8. coefficient (ASN1Integer)

    final version = topLevelSeq.elements?[0] as ASN1Integer;
    final n = topLevelSeq.elements?[1] as ASN1Integer;
    final e = topLevelSeq.elements?[2] as ASN1Integer;
    final d = topLevelSeq.elements?[3] as ASN1Integer;
    final p = topLevelSeq.elements?[4] as ASN1Integer;
    final q = topLevelSeq.elements?[5] as ASN1Integer;

    return RSAPrivateKey(
      n.valueAsBigInteger,
      d.valueAsBigInteger,
      p.valueAsBigInteger,
      q.valueAsBigInteger,
    );
  }

  bool isValidHex(String hex) {
    return RegExp(r'^[0-9a-fA-F]+$').hasMatch(hex);
  }

  RSASignature generateSignaturePrevious(
      String modulus, String privateExponent, String message) {
    final modulusBigInt = BigInt.parse(modulus, radix: 16);
    final modulusHex = modulusBigInt.toRadixString(16);

    late RSASignature signature;
    try {
      final privateKey = RSAPrivateKey(
        BigInt.parse(modulusHex, radix: 16),
        BigInt.parse(privateExponent, radix: 16),
        BigInt.from(65537), // Common public exponent
        BigInt.parse(modulus, radix: 16), // Use modulus for consistency
      );

      final signer = pointycasteldapi.Signer('SHA-256/RSA');
      final params =
          pointycasteldapi.PrivateKeyParameter<RSAPrivateKey>(privateKey);
      signer.init(true, params);
      signature =
          signer.generateSignature(Uint8List.fromList(utf8.encode(message)))
              as RSASignature;

      // Use the signature
    } catch (e) {
      if (e is FormatException) {
        print('Error parsing modulus or private exponent: $e');
      } else {
        rethrow;
      }
    }
    return signature;
  }

  BigInt extractModulusFromPublicKey(RSAPublicKey publicKey) {
    return publicKey.modulus!;
  }

  BigInt extractModulusFromPrivateKey(RSAPrivateKey privateKey) {
    return privateKey.modulus!;
  }

  // Function to extract p and q from an RSA private key
  // Function to extract p and q from an RSA private key
  Map<String, BigInt> extractPQFromPrivateKey(RSAPrivateKey privateKey) {
    // Ensure p and q are non-nullable
    final p = privateKey.p ?? BigInt.zero;
    final q = privateKey.q ?? BigInt.zero;

    return {
      'p': p,
      'q': q,
    };
  }

  Future<String> readFileAsString(File file) async {
    try {
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      throw Exception('Error reading file: $e');
    }
  }

  Future<String> createToken(String issuer) async {
    // try {
    // Parse the private key from the PEM file
    final privateKeyContent = await readFileAsString(this.privateKeyFile);
    // Parse the private key from the PEM file content
    final privateKeyObject = await parsePrivateKeyFromPem(privateKeyContent);

    // Extract the RSA private key components
    final RSAPrivateKey privateKey = privateKeyObject as RSAPrivateKey;

    // Create the JWT payload
    final payload = {
      'iss': issuer != null ? issuer : 'Ecodrive',
      'sub': 'authentication token',
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'exp':
          DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    };

    // Generate the JWT token
    return this.token = await generateJWT(
        encodePrivateKeyToPEM(privateKey, usePKCS8: false), payload);
    //} catch (e) {
    // Handle any errors that occur during the token generation process
    //throw Exception('Error creating token: $e');
    //}
  }

  persist() {
    try {
      SecureStorage().record('token', this.token!);
    } catch (e) {
      debugPrint(
          "TokenService L85, There was an issue with token record in EmbededBDD : ${e}");
    }
  }

  deleteToken() {
    SecureStorage().delete('token');
  }

  /*
   * Function deleteFileWithRetry
   * implement a retry mecanisme or ensure that the file is not in use before attempting to delete it
   */
  Future<void> deleteFileWithRetry(String filePath,
      {int maxAttempts = 3,
      Duration delay = const Duration(milliseconds: 500)}) async {
    int attempts = 0;
    while (attempts < maxAttempts) {
      try {
        await File(filePath).delete();
        return;
      } catch (e) {
        attempts++;
        if (attempts < maxAttempts) {
          await Future.delayed(delay);
        } else {
          throw Exception('Failed to delete file after $maxAttempts attempts');
        }
      }
    }
  }

  RSAPublicKey parsePublicKeyFromPem(String pemString) {
    final bytes =
        base64Decode(pemString.replaceAll('\n', '').split('-----')[2]);
    final asn1Parser = ASN1Parser(bytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
    final publicKeyBitString = topLevelSeq.elements?[1];
    final publicKeyAsn =
        ASN1Parser(publicKeyBitString?.valueBytes! as Uint8List);
    final publicKeySeq = publicKeyAsn.nextObject() as ASN1Sequence;
    final modulus = publicKeySeq.elements?[0] as ASN1Integer;
    final exponent = publicKeySeq.elements?[1] as ASN1Integer;

    return RSAPublicKey(
      (modulus as ASN1Integer).valueAsBigInteger,
      (exponent as ASN1Integer).valueAsBigInteger,
    );
  }

  /*
   *Function getId
   * @Return create and return Id of Service
   */
  @override
  int getId() {
    var random = Random();
    int randomNumber = random.nextInt(10 ^ 15);
    return randomNumber;
  }
}
