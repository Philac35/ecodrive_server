import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';
import 'package:shared_package/Services/EnvService/EnvService.dart';
import 'package:shared_package/Services/Interface/Service.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:pointycastle/key_generators/api.dart';
import 'package:pointycastle/key_generators/rsa_key_generator.dart';
import 'package:pointycastle/random/fortuna_random.dart';
import 'package:basic_utils/basic_utils.dart';

//classe fonctionnelle au 6/03/2025
class EncryptService implements Service{
  File privateKeyFile = File(
      "package:shared_package/Configuration/.Securite/Certificate/HTMLCryptage/private/privateKey.key");
  File publicKeyFile = File(
      "/src/Configuration/.Securite/Certificate/HTMLCryptage/public/publicKey.key");

  late RSAPrivateKey privateKey;
  late RSAPublicKey? publicKey;

  EncryptService(){
    setPublicKeyFromFile();
  }





  ASN1Sequence _createPrivateKeyASN1Sequence(RSAPrivateKey privateKey) {
    final topLevel = ASN1Sequence();
    topLevel.add(ASN1Integer(BigInt.from(0))); // Version
    topLevel.add(ASN1Integer(privateKey.n!)); // Modulus
    topLevel.add(ASN1Integer(privateKey.exponent!)); // Public exponent
    topLevel.add(ASN1Integer(privateKey.d!)); // Private exponent
    topLevel.add(ASN1Integer(privateKey.p!)); // Prime 1
    topLevel.add(ASN1Integer(privateKey.q!)); // Prime 2
    topLevel.add(ASN1Integer(privateKey.d! % (privateKey.p! - BigInt.one))); // Exponent 1
    topLevel.add(ASN1Integer(privateKey.d! % (privateKey.q! - BigInt.one))); // Exponent 2
    topLevel.add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!))); // Coefficient
    return topLevel;
  }

  String encodePrivateKeyToPEM(RSAPrivateKey privateKey, {bool usePKCS8 = true}) {
    if (usePKCS8) {
      // PKCS#8 Encoding
      final privateKeyASN1 = _createPrivateKeyASN1Sequence(privateKey);

      final privateKeyInfo = ASN1Sequence()
        ..add(ASN1Integer(BigInt.from(0))) // Version
        ..add(ASN1Sequence()
          ..add(ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 1, 1])) // RSA Encryption OID
          ..add(ASN1Null())) // No parameters for RSA
        ..add(ASN1OctetString(privateKeyASN1.encodedBytes)); // Private key bytes

      final der = privateKeyInfo.encodedBytes;
      return "-----BEGIN PRIVATE KEY-----\n${base64.encode(der)}\n-----END PRIVATE KEY-----";
    } else {
      // PKCS#1 Encoding
      final topLevel = ASN1Sequence()
        ..add(ASN1Integer(BigInt.from(0)))
        ..add(ASN1Integer(privateKey.n!))
        ..add(ASN1Integer(privateKey.exponent!))
        ..add(ASN1Integer(privateKey.d!))
        ..add(ASN1Integer(privateKey.p!))
        ..add(ASN1Integer(privateKey.q!))
        ..add(ASN1Integer(privateKey.d! % (privateKey.p! - BigInt.one)))
        ..add(ASN1Integer(privateKey.d! % (privateKey.q! - BigInt.one)))
        ..add(ASN1Integer(privateKey.q!.modInverse(privateKey.p!)));

      final der = topLevel.encodedBytes;
      return "-----BEGIN RSA PRIVATE KEY-----\n${base64.encode(der)}\n-----END RSA PRIVATE KEY-----";
    }
  }
  String encodePublicKeyToPEM(RSAPublicKey publicKey, {bool usePKCS8 = true}) {
    if (usePKCS8) {

      final sequence = ASN1Sequence()
        ..add(ASN1Integer(publicKey.modulus!))
        ..add(ASN1Integer(publicKey.exponent!));

      final encodedBytes = sequence.encodedBytes;
      // PKCS#8 Encoding
      final subjectPublicKeyInfo = ASN1Sequence()
        ..add(ASN1Sequence()
          ..add(ASN1ObjectIdentifier([1, 2, 840, 113549, 1, 1, 1])) // RSA Encryption OID
          ..add(ASN1Null())) // No parameters for RSA
        ..add(ASN1BitString(
            (sequence) as List<int>
        ));

      final der = subjectPublicKeyInfo.encodedBytes;
      return "-----BEGIN PUBLIC KEY-----\n${base64.encode(der)}\n-----END PUBLIC KEY-----";
    } else {
      // PKCS#1 Encoding
      final topLevel = ASN1Sequence()
        ..add(ASN1Integer(publicKey.modulus!))
        ..add(ASN1Integer(publicKey.exponent!));

      final der = topLevel.encodedBytes;
      return "-----BEGIN RSA PUBLIC KEY-----\n${base64.encode(der)}\n-----END RSA PUBLIC KEY-----";
    }
  }


  Future<RSAPrivateKey> readPrivateKey(String pemPrivateKey) async {
    try {
      final lines = pemPrivateKey.split('\n');
      final header = lines.first.trim();

      // Validate header
      if (header != '-----BEGIN RSA PRIVATE KEY-----' &&
          header != '-----BEGIN PRIVATE KEY-----') {
        throw FormatException('Invalid PEM private key header');
      }

      // Remove header, footer, and any whitespace
      final base64String = lines
          .where((line) =>
      !line.contains('-----BEGIN') &&
          !line.contains('-----END'))
          .join('')
          .replaceAll(RegExp(r'\s'), '');

      final keyBytes = base64.decode(base64String);
      final asn1Parser = ASN1Parser(keyBytes);
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      // Common parsing logic for both key formats
      BigInt modulus, publicExponent, privateExponent, primeFactor1, primeFactor2;

      if (header == '-----BEGIN PRIVATE KEY-----') {
        final octetString = topLevelSeq.elements[0] as ASN1OctetString;
        final wrappedKeyBytes = octetString.valueBytes;
        final wrappedAsn1Parser = ASN1Parser(wrappedKeyBytes as Uint8List);
        final wrappedTopLevelSeq = wrappedAsn1Parser.nextObject() as ASN1Sequence;

        modulus = (wrappedTopLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
        publicExponent = (wrappedTopLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;
        privateExponent = (wrappedTopLevelSeq.elements[3] as ASN1Integer).valueAsBigInteger;
        primeFactor1 = (wrappedTopLevelSeq.elements[4] as ASN1Integer).valueAsBigInteger;
        primeFactor2 = (wrappedTopLevelSeq.elements[5] as ASN1Integer).valueAsBigInteger;
      } else {
        modulus = (topLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
        publicExponent = (topLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;
        privateExponent = (topLevelSeq.elements[3] as ASN1Integer).valueAsBigInteger;
        primeFactor1 = (topLevelSeq.elements[4] as ASN1Integer).valueAsBigInteger;
        primeFactor2 = (topLevelSeq.elements[5] as ASN1Integer).valueAsBigInteger;
      }

      // Strict modulus validation
      final calculatedModulus = primeFactor1 * primeFactor2;
      if (modulus != calculatedModulus) {
        throw Exception('''
        RSA Key Validation Failed:
        - Original Modulus: $modulus
        - Calculated Modulus: $calculatedModulus
        Key appears to be invalid or corrupted.
      ''');
      }

      return RSAPrivateKey(
        modulus,
        privateExponent,
        primeFactor1,
        primeFactor2,
      );
    } catch (e) {
      print("Error parsing RSA private key: $e");
      rethrow;
    }
  }


  /// Function SafeRSAKeyParse
  /// @Param String PKCS1 or PKCS8 privateKey

  Future<RSAPrivateKey> safeRSAPrivateKeyParse(String pemPrivateKey) async {
    try {
      // Validate input key
      if (pemPrivateKey.isEmpty) {
        throw Exception('Empty PEM private key provided');
      }

      // Logging for debugging
      print('Original Key Length: ${pemPrivateKey.length}');
      print('Original Key First 50 chars: ${pemPrivateKey.substring(0, pemPrivateKey.length > 50 ? 50 : pemPrivateKey.length)}...');

      // Normalize the PEM key
      pemPrivateKey = pemPrivateKey.trim().replaceAll('\r\n', '\n');

      // Remove header and footer
      final keyLines = pemPrivateKey.split('\n');
      final headerIndex = keyLines.indexWhere((line) => line.contains('-----BEGIN'));
      final footerIndex = keyLines.indexWhere((line) => line.contains('-----END'));

      if (headerIndex == -1 || footerIndex == -1) {
        throw Exception('Invalid PEM key format: Missing header or footer');
      }

      final header = keyLines[headerIndex];
      var base64Content = keyLines.sublist(headerIndex + 1, footerIndex).join('').replaceAll(RegExp(r'\s'), '');
      print('Extracted Base64 Content Length: ${base64Content.length}');

      // Detect format (PKCS#8 or PKCS#1)
      bool isPKCS8 = header.contains('PRIVATE KEY') && !header.contains('RSA PRIVATE KEY');
      bool isPKCS1 = header.contains('RSA PRIVATE KEY');

      if (!isPKCS8 && !isPKCS1) {
        throw Exception('Unsupported private key format');
      }

      // Ensure base64 string is padded correctly
      while (base64Content.length % 4 != 0 && base64Content[base64Content.length - 1] != '=') {
        base64Content += '=';
      }

      // Decode the base64 content
      late Uint8List keyBytes;
      try {
        keyBytes = base64.decode(base64Content);
      } catch (decodeError) {
        print('Base64 Decoding Error: $decodeError');
        throw Exception('Failed to decode base64 key content');
      }

      print('Decoded Key Bytes Length: ${keyBytes.length}');

      final asn1Parser = ASN1Parser(keyBytes);
      ASN1Sequence topLevelSeq;

      if (isPKCS8) {
        // PKCS#8 Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('PKCS#8 Top Level Sequence Parsed');

        // Extract private key octet string from PKCS#8 structure
        final privateKeyOctetString = topLevelSeq.elements[2] as ASN1OctetString;
        final privateKeyBytes = privateKeyOctetString.valueBytes();
        final privateKeyParser = ASN1Parser(privateKeyBytes);
        topLevelSeq = privateKeyParser.nextObject() as ASN1Sequence; // PKCS#1 structure inside PKCS#8
      } else if (isPKCS1) {
        // PKCS#1 Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('PKCS#1 Top Level Sequence Parsed');
      } else {
        throw Exception('Unsupported RSA key format');
      }

      // Extract relevant parameters (may need adjustments based on key structure)
      final version = (topLevelSeq.elements[0] as ASN1Integer).valueAsBigInteger;
      final modulus = (topLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
      final publicExponent = (topLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;
      final privateExponent = (topLevelSeq.elements[3] as ASN1Integer).valueAsBigInteger;
      final p = (topLevelSeq.elements[4] as ASN1Integer).valueAsBigInteger;
      final q = (topLevelSeq.elements[5] as ASN1Integer).valueAsBigInteger;
      final dp = (topLevelSeq.elements[6] as ASN1Integer).valueAsBigInteger;
      final dq = (topLevelSeq.elements[7] as ASN1Integer).valueAsBigInteger;
      final qInv = (topLevelSeq.elements[8] as ASN1Integer).valueAsBigInteger;

      // Construct RSAPrivateKey
      final rsaPrivateKey = RSAPrivateKey(
        BigInt.parse(modulus.toString()),
        BigInt.parse(privateExponent.toString()),
        BigInt.parse(p.toString()),
        BigInt.parse(q.toString()),

      );

      return rsaPrivateKey;
    } catch (e) {
      throw Exception('Error parsing private key: $e');
    }
  }


  Future<RSAPrivateKey> SafeRSAPrivateKeyParse2(String pemPrivateKey) async {
    try {
      // Validate input key
      if (pemPrivateKey.isEmpty) {
        throw Exception('Empty PEM private key provided');
      }

      // Logging for debugging
      print('Original Key Length: ${pemPrivateKey.length}');
      print('Original Key First 50 chars: ${pemPrivateKey.substring(0, pemPrivateKey.length > 50 ? 50 : pemPrivateKey.length)}...');

      // Normalize the PEM key
      pemPrivateKey = pemPrivateKey.trim().replaceAll('\r\n', '\n');

      // Remove header and footer
      final keyLines = pemPrivateKey.split('\n');
      final headerIndex = keyLines.indexWhere((line) => line.contains('-----BEGIN'));
      final footerIndex = keyLines.indexWhere((line) => line.contains('-----END'));

      if (headerIndex == -1 || footerIndex == -1) {
        throw Exception('Invalid PEM key format: Missing header or footer');
      }

      final header = keyLines[headerIndex];
      var base64Content = keyLines.sublist(headerIndex + 1, footerIndex).join('').replaceAll(RegExp(r'\s'), '');
      print('Extracted Base64 Content Length: ${base64Content.length}');

      // Detect format (PKCS#8 or PKCS#1)
      bool isPKCS8 = header.contains('PRIVATE KEY') && !header.contains('RSA PRIVATE KEY');
      bool isPKCS1 = header.contains('RSA PRIVATE KEY');

      if (!isPKCS8 && !isPKCS1) {
        throw Exception('Unsupported private key format');
      }
      // Ensure base64 string is padded correctly
      while (base64Content.length % 4 != 0) {
        base64Content += '=';
      }
      // Decode the base64 content
      late Uint8List keyBytes;
      try {
        keyBytes = base64.decode(base64Content);
      } catch (decodeError) {
        print('Base64 Decoding Error: $decodeError');
        throw Exception('Failed to decode base64 key content');
      }

      print('Decoded Key Bytes Length: ${keyBytes.length}');

      final asn1Parser = ASN1Parser(keyBytes);
      ASN1Sequence topLevelSeq;

      if (isPKCS8) {
        // PKCS#8 Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('PKCS#8 Top Level Sequence Parsed');

        // Extract private key octet string from PKCS#8 structure
        final privateKeyOctetString = topLevelSeq.elements[2] as ASN1OctetString;
        final privateKeyBytes = privateKeyOctetString.valueBytes();
        final privateKeyParser = ASN1Parser(privateKeyBytes);
        topLevelSeq = privateKeyParser.nextObject() as ASN1Sequence; // PKCS#1 structure inside PKCS#8
      } else if (isPKCS1) {
        // PKCS#1 Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('PKCS#1 Top Level Sequence Parsed');
      } else {
        throw Exception('Unsupported RSA key format');
      }

      // Extract RSA components from the sequence
      final sequenceElements = topLevelSeq.elements;

      if (sequenceElements.length < 9) {
        throw Exception('Invalid RSA private key structure (expected at least 9 elements)');
      }

      // Extract RSA components for PKCS#1 format
      final modulus = (sequenceElements[1] as ASN1Integer).valueAsBigInteger;
      final publicExponent = (sequenceElements[2] as ASN1Integer).valueAsBigInteger;
      final privateExponent = (sequenceElements[3] as ASN1Integer).valueAsBigInteger;
      final prime1 = (sequenceElements[4] as ASN1Integer).valueAsBigInteger;
      final prime2 = (sequenceElements[5] as ASN1Integer).valueAsBigInteger;

      // Optional CRT components
      final exponent1 = (sequenceElements[6] as ASN1Integer).valueAsBigInteger;
      final exponent2 = (sequenceElements[7] as ASN1Integer).valueAsBigInteger;
      final coefficient = (sequenceElements[8] as ASN1Integer).valueAsBigInteger;

      print('Extracted RSA Components:');
      print('Modulus: $modulus');
      print('Public Exponent: $publicExponent');
      print('Private Exponent: $privateExponent');
      print('Prime 1: $prime1');
      print('Prime 2: $prime2');

      // Validate modulus calculation
      final calculatedModulus = prime1 * prime2;

      if (modulus != calculatedModulus) {
        throw Exception('Modulus validation failed: modulus does not match p * q');
      }

      print('Modulus Validation Passed');

      return RSAPrivateKey(
        modulus,
        privateExponent,
        prime1,
        prime2,
     //   coefficient, // Optional but included for CRT optimization  (It doesn't work with this 6/03/2025 10h37
      );
    } catch (e, stackTrace) {
      print('Comprehensive Key Parsing Error: $e');

      // Log a clean version of the stack trace for debugging purposes.
      print(stackTrace.toString().split('\n').take(5).join('\n'));
      // Only logs first few lines of trace.

      throw Exception("Critical parsing failure");
    }
  }


/*
 * Function safeRSAPublicKeyParse
 * work for KPCS1 and KPCS8
 */
  Future<RSAPublicKey> safeRSAPublicKeyParse(String pemPublicKey) async {
    try {
      // Validate input key
      if (pemPublicKey.isEmpty) {
        throw Exception('Empty PEM public key provided');
      }

      // Logging for debugging
      print('Original Key Length: ${pemPublicKey.length}');
      print('Original Key First 50 chars: ${pemPublicKey.substring(0, pemPublicKey.length > 50 ? 50 : pemPublicKey.length)}...');

      // Normalize the PEM key
      pemPublicKey = pemPublicKey.trim().replaceAll('\r\n', '\n');

      // Remove header and footer
      final keyLines = pemPublicKey.split('\n');
      final headerIndex = keyLines.indexWhere((line) => line.contains('-----BEGIN'));
      final footerIndex = keyLines.indexWhere((line) => line.contains('-----END'));

      if (headerIndex == -1 || footerIndex == -1) {
        throw Exception('Invalid PEM key format: Missing header or footer');
      }

      final header = keyLines[headerIndex];
      var base64Content = keyLines.sublist(headerIndex + 1, footerIndex).join('').replaceAll(RegExp(r'\s'), '');
      print('Extracted Base64 Content Length: ${base64Content.length}');

      // Detect format (PKCS#1 or X.509 SubjectPublicKeyInfo)
      bool isPKCS1 = header.contains('RSA PUBLIC KEY');
      bool isX509 = header.contains('PUBLIC KEY');

      if (!isPKCS1 && !isX509) {
        throw Exception('Unsupported public key format');
      }

      // Ensure base64 string is padded correctly
      while (base64Content.length % 4 != 0 && base64Content[base64Content.length - 1] != '=') {
        base64Content += '=';
      }

      // Decode the base64 content
      late Uint8List keyBytes;
      try {
        keyBytes = base64.decode(base64Content);
      } catch (decodeError) {
        print('Base64 Decoding Error: $decodeError');
        throw Exception('Failed to decode base64 key content');
      }

      print('Decoded Key Bytes Length: ${keyBytes.length}');

      final asn1Parser = ASN1Parser(keyBytes);
      ASN1Sequence topLevelSeq;

      if (isPKCS1) {
        // PKCS#1 Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('PKCS#1 Top Level Sequence Parsed');

        // Extract modulus and public exponent
        final modulus = (topLevelSeq.elements[1] as ASN1Integer).valueAsBigInteger;
        final publicExponent = (topLevelSeq.elements[2] as ASN1Integer).valueAsBigInteger;

        // Construct RSAPublicKey
        final rsaPublicKey = RSAPublicKey(
          BigInt.parse(modulus.toString()),
          BigInt.parse(publicExponent.toString()),
        );

        return rsaPublicKey;
      } else if (isX509) {
        // X.509 SubjectPublicKeyInfo Parsing
        topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
        print('X.509 Top Level Sequence Parsed');

        // Extract Algorithm ID and SubjectPublicKey
        final algorithmId = topLevelSeq.elements[0] as ASN1Sequence;
        final subjectPublicKey = topLevelSeq.elements[1] as ASN1BitString;

        // Check if the algorithm is RSA
        if ((algorithmId.elements[0] as ASN1ObjectIdentifier).toString()!= '1.2.840.113549.1.1.1') {
          throw Exception('Unsupported algorithm for RSA public key');
        }

        // Extract the RSA public key from the subjectPublicKey
        final rsaPublicKeyBytes = subjectPublicKey.valueBytes();
        final rsaPublicKeyParser = ASN1Parser(rsaPublicKeyBytes);
        final rsaPublicKeySequence = rsaPublicKeyParser.nextObject() as ASN1Sequence;

        // Extract modulus and public exponent
        final modulus = (rsaPublicKeySequence.elements[0] as ASN1Integer).valueAsBigInteger;
        final publicExponent = (rsaPublicKeySequence.elements[1] as ASN1Integer).valueAsBigInteger;

        // Construct RSAPublicKey
        final rsaPublicKey = RSAPublicKey(
          BigInt.parse(modulus.toString()),
          BigInt.parse(publicExponent.toString()),
        );

        return rsaPublicKey;
      } else {
        throw Exception('Unsupported RSA key format');
      }
    } catch (e) {
      throw Exception('Error parsing public key: $e');
    }
  }

  /*
   * Function advancedKeyDiagnostic
   * function 6/03/2025 valid 10h27
   * Function created to debug  SafeRSAKeyParse
   */
  Future<RSAPrivateKey> advancedKeyDiagnostic(String pemPrivateKey) async {
    try {
      // Normalize the PEM key
      pemPrivateKey = pemPrivateKey.trim().replaceAll('\r\n', '\n');

      // Remove header and footer
      final base64Content = pemPrivateKey
          .split('\n')
          .where((line) =>
      !line.contains('-----BEGIN') &&
          !line.contains('-----END'))
          .join('');

      // Decode the base64 content
      final keyBytes = base64.decode(base64Content);

      final asn1Parser = ASN1Parser(keyBytes);
      final topLevelSeq = asn1Parser.nextObject();

      // Detailed type and structure inspection
      print('Top Level Object Type: ${topLevelSeq.runtimeType}');
      print('Top Level Object String Representation: $topLevelSeq');

      // Extract all elements with their types
      List<dynamic> elements;
      if (topLevelSeq is ASN1Sequence) {
        elements = topLevelSeq.elements;
      } else {
        throw Exception('Unexpected top-level ASN.1 object type');
      }

      print('Total Elements: ${elements.length}');
      elements.asMap().forEach((index, element) {
        print('Element $index: ${element.runtimeType} - $element');
      });

      // Explicit extraction with type checking
      dynamic extractElement(int index, Type expectedType) {
        if (index >= elements.length) {
          throw Exception('Element index out of bounds');
        }
        final element = elements[index];
        if (element.runtimeType != expectedType) {
          throw Exception('Unexpected element type at index $index. '
              'Expected $expectedType, got ${element.runtimeType}');
        }
        return element;
      }

      // Carefully extract key components
      final versionElement = extractElement(0, ASN1Integer);
      final modulusElement = extractElement(1, ASN1Integer);
      final publicExponentElement = extractElement(2, ASN1Integer);
      final privateExponentElement = extractElement(3, ASN1Integer);
      final prime1Element = extractElement(4, ASN1Integer);
      final prime2Element = extractElement(5, ASN1Integer);

      // Detailed big integer extraction
      BigInt extractBigInt(dynamic element) {
        try {
          // Try different methods to extract BigInt
          if (element.hasMethod('valueAsBigInteger')) {
            return element.valueAsBigInteger;
          }
          return BigInt.parse(element.toString());
        } catch (e) {
          throw Exception('Failed to extract BigInt from $element');
        }
      }

      // Extract key components
      final version = extractBigInt(versionElement);
      final modulus = extractBigInt(modulusElement);
      final publicExponent = extractBigInt(publicExponentElement);
      final privateExponent = extractBigInt(privateExponentElement);
      final prime1 = extractBigInt(prime1Element);
      final prime2 = extractBigInt(prime2Element);

      // Comprehensive validation
      print('Version: $version');
      print('Modulus Length: ${modulus.bitLength} bits');
      print('Public Exponent: $publicExponent');
      print('Private Exponent Length: ${privateExponent.bitLength} bits');
      print('Prime 1 Length: ${prime1.bitLength} bits');
      print('Prime 2 Length: ${prime2.bitLength} bits');

      // Verify prime factors
      final calculatedModulus = prime1 * prime2;
      print('Modulus Validation:');
      print('Original Modulus:   $modulus');
      print('Calculated Modulus: $calculatedModulus');
      print('Modulus Match: ${modulus == calculatedModulus}');

      // Additional cryptographic validations
      if (modulus != calculatedModulus) {
        throw Exception('''
      Modulus Inconsistency Detected:
      - Original Modulus:   $modulus
      - Calculated Modulus: $calculatedModulus
      ''');
      }

      // Attempt to create RSA Private Key with verbose error handling
      try {
        return RSAPrivateKey(
          modulus,
          publicExponent,
          privateExponent,
          prime1,
          prime2,
        );
      } on Error catch (e) {
        print('RSAPrivateKey Construction Error: $e');
        rethrow;
      }
    } catch (e, stackTrace) {
      print('Comprehensive Parsing Error: $e');
      print('Detailed Stack Trace: $stackTrace');
      rethrow;
    }
  }








  /*
   * Function SafeRSAKeyParsePKCS8
   * function 6/03/2025 valid 10h28
   */
Future<RSAPrivateKey> SafeRSAKeyParsePKCS8(String pemPrivateKey) async {
  try {
    // Normalize the PEM key
    pemPrivateKey = pemPrivateKey.trim().replaceAll('\r\n', '\n');

    // Remove header and footer
    final base64Content = pemPrivateKey
        .split('\n')
        .where((line) => !line.contains('-----BEGIN') && !line.contains('-----END'))
        .join('');

    // Decode the base64 content
    final keyBytes = base64.decode(base64Content);

    final asn1Parser = ASN1Parser(keyBytes);
    final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

    // PKCS#8 structure
    print('PKCS#8 Structure:');
    print('Total Elements in top-level sequence: ${topLevelSeq.elements.length}');


    final algorithmIdentifier = topLevelSeq.elements[1] as ASN1Sequence;
    final privateKeyOctetString = topLevelSeq.elements[2] as ASN1OctetString;

    print('Algorithm Identifier: $algorithmIdentifier');
    print('Private Key Octet String length: ${privateKeyOctetString.valueBytes().length}');

    // Parse the private key octet string
    final privateKeyAsn1Parser = ASN1Parser(privateKeyOctetString.valueBytes());
    final privateKeySeq = privateKeyAsn1Parser.nextObject() as ASN1Sequence;

    final rsaPrivateKeyElements = privateKeySeq.elements;
    print('RSA Private Key Elements: ${rsaPrivateKeyElements.length}');
    final version = (rsaPrivateKeyElements[0] as ASN1Integer).valueAsBigInteger;
    final modulus = (rsaPrivateKeyElements[1] as ASN1Integer).valueAsBigInteger;
    final publicExponent = (rsaPrivateKeyElements[2] as ASN1Integer).valueAsBigInteger;
    final privateExponent = (rsaPrivateKeyElements[3] as ASN1Integer).valueAsBigInteger;
    final prime1 = (rsaPrivateKeyElements[4] as ASN1Integer).valueAsBigInteger;
    final prime2 = (rsaPrivateKeyElements[5] as ASN1Integer).valueAsBigInteger;
    final exponent1 = (rsaPrivateKeyElements[6] as ASN1Integer).valueAsBigInteger;
    final exponent2 = (rsaPrivateKeyElements[7] as ASN1Integer).valueAsBigInteger;
    final coefficient = (rsaPrivateKeyElements[8] as ASN1Integer).valueAsBigInteger;



    // Perform detailed checks
    print('Detailed RSA Component Checks:');
    print('1. n = p * q check:');

    //modulus Check
    final calculatedModulus = prime1 * prime2;
    print('   Modulus from key: $modulus');
    print('   Calculated n = p * q: $calculatedModulus');
    print('   Match: ${modulus == calculatedModulus}');

    //Public and Private Exponant Check
    print('\n2. e * d ≡ 1 (mod φ(n)) check:');
    final phi = (prime1 - BigInt.one) * (prime2 - BigInt.one);
    final edModPhi = (publicExponent * privateExponent) % phi;
    print('   e * d mod φ(n): $edModPhi');
    print('   Should be 1: ${edModPhi == BigInt.one}');

    //Coefficient Check
    print('\n3. d_p and d_q check:');
    final calculatedExponent1 = privateExponent % (prime1 - BigInt.one);
    final calculatedExponent2 = privateExponent % (prime2 - BigInt.one);
    print('   d_p (exponent1) from key: $exponent1');
    print('   Calculated d_p: $calculatedExponent1');
    print('   d_p Match: ${exponent1 == calculatedExponent1}');
    print('   d_q (exponent2) from key: $exponent2');
    print('   Calculated d_q: $calculatedExponent2');
    print('   d_q Match: ${exponent2 == calculatedExponent2}');

    print('\n4. q_inv check:');
    final calculatedCoefficient = prime2.modInverse(prime1);
    print('   q_inv (coefficient) from key: $coefficient');
    print('   Calculated q_inv: $calculatedCoefficient');
    print('   q_inv Match: ${coefficient == calculatedCoefficient}');


//Prime Factor Validation

    bool primesValid = verifyPrimeFactors(modulus, prime1, prime2);
    print('Prime factors valid: $primesValid');


    //Additional Exponent Verification
    BigInt result = verifyExponents(publicExponent, privateExponent, prime1, prime2);
    print('e * d mod φ(n) should be 1. Actual result: $result');

    // Attempt to create RSA Private Key
    final rsaPrivateKey = RSAPrivateKey(
      modulus,
      privateExponent,
      prime1,
      prime2,
    );
    final publicKey =  generatePublicKey(rsaPrivateKey);
    print( 'Public Key : $publicKey');
    print('\nRSA Private Key successfully created!');
    return rsaPrivateKey;
  } catch (e, stackTrace) { 
    print('Comprehensive Parsing Error: $e');
    print('Detailed Stack Trace: $stackTrace');
    rethrow;
  }
}


RSAPublicKey generatePublicKey(RSAPrivateKey privateKey) {
  return RSAPublicKey(
    privateKey.modulus!,
    privateKey.publicExponent!,
  );
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

Future<String> encryptMessage(String message, RSAPublicKey publicKey) async {
  final encrypter = encrypt.Encrypter(
    encrypt.RSA(
      publicKey: publicKey,
      encoding: encrypt.RSAEncoding.OAEP,
    ),
  );

  final encrypted = encrypter.encrypt(message);
  return encrypted.base64;
}

Future<String> decryptMessage(String encryptedMessage, RSAPrivateKey privateKey) async {
  final encrypter = encrypt.Encrypter(
    encrypt.RSA(
      publicKey: generatePublicKey(privateKey),
      privateKey: privateKey,
      encoding: encrypt.RSAEncoding.OAEP,
    ),
  );

  final decrypted = encrypter.decrypt64(encryptedMessage);
  return decrypted;
}
  FortunaRandom getSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }


  BigInt verifyExponents(BigInt e, BigInt d, BigInt p, BigInt q) {
    BigInt phi = (p - BigInt.one) * (q - BigInt.one);
    return (e * d) % phi;
  }
  bool verifyPrimeFactors(BigInt n, BigInt p, BigInt q) {
    return n == p * q;
  }


    setPublicKeyFromFile() async {
    publicKey= CryptoUtils.rsaPublicKeyFromPem(EnvService.CRYTOPUBLICKEY);
    // safeRSAPublicKeyParse algorithm must be review
    // this.publicKey=  await safeRSAPublicKeyParse( await publicKeyFile.readAsString());
  }
  setPrivateKeyFromFile()async{
    privateKey=  await safeRSAPrivateKeyParse(EnvService.CRYTOPRIVATEKEY);
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

void main() async {

  //PKCS8 key
  final pemPrivateKey = ''' 
  -----BEGIN PRIVATE KEY-----
MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCSn59z71ko+fyE
7Hv66GHBq68+Sy2uFxl09R3b6fAXG0vldnLRuTaZRsgLvqK4UYJYoArMZIzK479U
AcWibqDG87pRHB2x96OxVgMJLN9t/OYL1DKosJirEkCR1lbNbmoNY9y+yhQdzRX8
d9Kst6ak0EGQVXmL2NmP71wbr+bJpO44hD7DBLR4oFM1BKbWAyPQmH13NIDdrL+k
5wWuGtgDDDz+9ItwIAsB69hukDKUo9+ViXFW9HuiyK/b+fR8YPxLwc++XPZ3QlhV
2b7uk+A2n7A19ySs+dx6+6hzx/1FSuDgnjSJQj9qaNbWawjQfCKmIqNCz6Fk+xmL
/cXL0SZNAgMBAAECggEAFLtKLffZSQBz0o2niBYkgGBYonu5xURR3qYr5yTgRDwh
UpwZZwsDq8+EyJhXZK1tuz9B152eBLAIJQYtHib7R7Y9kWtizX+g3xm0yy7Tlrcs
Bd8mnJB/vaySgaxnUJu8lhEZLMbg6kfNxIliufYrs2EY7CIR0hLCzGXBRc7s2HTp
RsG7j/nStl8VECpJ77i2UN5gdHlil4M7EPBogBoP1SxJucos+r4emn3TQdyQZMFQ
F9VSZfA2XAQWPLv8XzyAhFfdZD5lOOeUXtXD62nB3vU0JasKpJRgplc7C8FpMWW4
DQuB+YK7ZhdVGEg0RvuJlloXtUUprtW3/AKVUu4PBwKBgQDGGhLomdflkX5TvUyT
9XLwG+27kUOXXe8XjuYXZJjqDwnImWay7aksy0nHm7awSP2xtWgXMPCGtndkBNWN
FZ47MCmaDpOMMSbix+ZoMeYfTnfRPiAolSJeztPsAvWSw6VfDOvSw7S/vHXB0zRF
F3IuApgEPXghN/copfISVczf3wKBgQC9efR02RbalV1FrF1/b1GO3t/0+D960RBl
PTvcDa5Mn1FKFbBbhCkeJtGlMykCvFFUM/4YLuwCnpeZMwHza27fo6Tes7OpCGGt
iq/XKs50kbXv0uJfPazwnrDOvltK3Z4CDC1m1zNGAB4skyAYbxoZ8AGiT+w+FGqz
z3IIpYmPUwKBgFW2il/h0Kwfm40X5r5OAQEq1F3HqHshxYVn6t5MRG1hPFZzKSBZ
/EzJWI7pLM5xhnMRjowaPLfM0zOPc+arZ98sI5PooqaRzcVpwKNsk6kQBn+eZcOp
Y0mqK79+OErcI/1QVejHjLk5Dapje8Y5Msn9jVCoWAXndSU9R9PvE8n5AoGBAJNs
Av6zNevmUQb3wFt5klx2HoxsZn+5kGckyKFDZ70oLEhXLbtWzeMu0ukVMDB3s1Ov
jGDmiSzUliFVpYvup/qLSakY6o12/wDWqk/gd3gNMyCg1Q7DXv5siiahx0gtvFXd
ganFgJhTWSbXZh58uzM5IRxX0PjQS+ERY6lEmw4PAoGBAL/txlAJrWKm7q8DpaNW
zAbaKWgchtWT3OdjzB5ZiV3MLlwli5yvxfs5lEih40DGWzs7vq4sI5RwTA3aPViS
Yz3G9sTrL+JV8sNAIW+MAQQemURi178OWjwndCEHvtkBbmLJlBptCRrVAaSF2t0L
xdg0RdTS2tBtEWqjUM5kOfk3
-----END PRIVATE KEY-----
''';

  final pemPrivateKeyV1 = ''' 
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAjNFWgk1tmKzqa9Wtlb0ovMzhcqH3gnG4Y4Owk2JZOBUzJkQR
vnVpaqV+4TQrjNGAgOZRm/awC5XtOiqNyJnQExczMIihwQaV+kWCRbkqDyoN+W6L
iNRQFjEScisDMjzbMAsrEcpsDV7ghak1yQFTdlrX/5dwBZ92c3BZxIBFFOaYG6lm
iLSU2buLdrDf2laFwE3LNufXwhMz2BM6AcQ1remGv8jqzyVRVCZau3Crf1NNwx4b
owJPYJHjuLtzStlGcTdpEsZMgv5z+Kiu0CTKMLusfu+6iALiz3UUXNt0rY+eQUff
jYmizUeSbhJQSGFb52VzHs+q3f5leiCP8PvcMQIDAQABAoIBAAVrQOL+y8rmTJcd
v/JVNy4czEg3B2lTqv7ZYIArdrd7yV4dnHkx136tI7bS5SIkJcfQFS/lTF0Fxf1J
Ce/AS4uQhv3FJERjVn4tEphQSdgPjD4fDOuVEAfql4UhNpxGT0EIDP5ARew1zHoY
SuOTU3zofgtt7neo7Uv/9NRlA0OMlXey+hsx4l+vo7mygnH/00/hzMrU+BD2WMOX
CU2C/1WuDxZvrmcw8bZllBAZzsDUMA3t7L7PO9OE9kHVBrgNpj3yetup/qZUmylX
3jyqbxJ02B6S8xTjpq0iKy7uVzF+632WiaUJfWNyVeZcsLez8A48ybDcVcgs7Kg6
hIX1KckCgYEA0zZzZ/Z4fsru+SaOvywmfWKy7zwlBg6jGMV1BnvwEBYOVL4TE13q
Val8Z2tYHdRixtF7p34dU+ngX9AMo42sB7xe1jy9q0dNj0gbZnwVcDDAglsDBmLe
xc8daItsg0eHUPjuTjSuetc55MFiVhraAsWC39KXEZjm4+YfZM+zvcsCgYEAqq2K
Q8gIxH1wqon34umkod+fqcVkh5uktspdjWbwr5LXqovia1m/QZH33GeomzR8uEOn
deWObxrZ8AjU7A0gbNTZTcv/3k6lk31JuL5e9Z7y/FF+gJiU1HIlspvi2d2Yi1pq
SvHQJnHrb3tLlDmkm0wGuBQvzcxuG8BYY1EFjnMCgYBlCbxFdIOJ7BxLteU9kKpM
+wUsKrJvZlshQ3xLAMkDePmcEl1fu2KZXf20H4bEplAmWhn0MwFmnhAG5ajWKLSt
8q/PfrkhEXgJ3e21phA/XiMJeO5GhM+bAwxHccMUPgh+dMbTRKJfA0yfoN8g37GA
9+k2lzBLa8CwLuq/uBh85wKBgBvhBvG1bgEygEHLEYumIHc0gO8JSDeCa/BTs95S
D0SOlt3LxatFWKFMR5Ff+UGI3Ep4+pSeb5qkZy73MlhweHhueCRmCyBz9kXWNEGS
Dw7N7ODcKu60fbMKBjBbmD2AHde9aBlf0GFHQG7QU/MdS072py5QVdKm7uFnlMh8
Ro0TAoGAOCi2ecpLKPsxS3deASbb8q+zID+gjWogpl2FjpYpYdnCxfmCdF1Jw3pS
EWeExvghQZyZfDuYevpUVx+EUyqwJnH3tSg38j60nx+NyTm5AgGKileBMZPwnk50
eDBxBhFeeuc15R3ItdJKacvbW8C9x4Lwnv916YvF1upOv/1rwQk=
-----END RSA PRIVATE KEY-----
''';
  final encryptService = EncryptService();


  //final privateKey1 = await encryptService.advancedKeyDiagnosticPKCS8(pemPrivateKey);
  final privateKey = await encryptService.safeRSAPrivateKeyParse(pemPrivateKeyV1);
  final publicKey = encryptService. generatePublicKey(privateKey);
  print( 'Public Key : $publicKey');

  final message = 'Hello, World!';
  final encryptedMessage = await encryptService.  encryptMessage(message, publicKey);
  final decryptedMessage = await encryptService.  decryptMessage(encryptedMessage, privateKey);

  print('Original Message: $message');
  print('Encrypted Message: $encryptedMessage');
  print('Decrypted Message: $decryptedMessage');
}
