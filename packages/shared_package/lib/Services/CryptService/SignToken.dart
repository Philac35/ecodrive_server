import 'dart:convert';
import 'package:asn1lib/asn1lib.dart';
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:pem/pem.dart';
import "package:pointycastle/api.dart" as pcapi;
import "package:flutter/foundation.dart";

//Intern dependencies
import 'package:shared_package/Services/CryptService/EncryptService.dart';

class SignToken {

  EncryptService? encryptService;
  SignToken(){
    encryptService= EncryptService();
  }
  void main() {
    final pemPrivateKey = '''
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDWJZL2/+xkX+Xp
...
-----END PRIVATE KEY-----
''';

    try {
      final privateKey = decodePEM(pemPrivateKey);
      print('Private key read successfully: $privateKey');
    } catch (e) {
      print('Error reading private key: $e');
    }
  }

  Future<List<int>> signData(String pemPrivateKey, String data) async{
  RSAKeyParser? parser;

  RSAPrivateKey? privateKey;




    // Parse the PEM private key
  try {
    RSAPrivateKey? key=  await  encryptService?.readPrivateKey(pemPrivateKey);

    if (key is RSAPrivateKey) {
      privateKey = key;
    } else {
      throw Exception('signToken L38 Parsed key is not an RSAPrivateKey');
    }
  } catch (e) {
    debugPrint("signToken L41 Error parsing RSA private key: $e");
    throw Exception('signToken L42, Error parsing RSA private key: $e');
  }


    // Create a signer
    final signer =pcapi.Signer('SHA-256/RSA');
    final privParams = PrivateKeyParameter<RSAPrivateKey>(privateKey);
    signer.init(true, privParams);

    // Sign the data
    final signatureBytes = signer.generateSignature(Uint8List.fromList(utf8.encode(data)))as RSASignature;


    return signatureBytes.bytes;
  }


  decodePEM(pemPrivateKey){

    debugPrint ('pemPrivateKey : '+pemPrivateKey);
    RSAPrivateKey privateKey;
    try {
      //final pemBlock = PemBlock(pemPrivateKey);
      final pemBlocks = decodePemBlocks(PemLabel.privateKey, pemPrivateKey);

      if (pemBlocks.isEmpty) {
        throw Exception('signToken L38, No valid PEM blocks found');}
      // Extract the base64 string from the PEM block
      final keyBytes = pemBlocks.first;
      // Decode the base64 string




      final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
      final modulus = topLevelSeq.elements[1] as ASN1Integer;
      final privateExponent = topLevelSeq.elements[3] as ASN1Integer;


      return privateKey = RSAPrivateKey(
        modulus.valueAsBigInteger,
        privateExponent.valueAsBigInteger,
        null, // p
        null, // q
      );

    } catch (e) {
      debugPrint("signToken L58, Error parsing RSA private key: $e");
      throw Exception('signToken L59, Error parsing RSA private key: $e');
    }

  }



  RSAPrivateKey decodePEMManually(String pemPrivateKey) {

    print(pemPrivateKey);


    try {
      // Remove header and footer from PEM string
      final lines = pemPrivateKey.split('\n');
      final header = lines.first.trim();
      final footer = lines.last.trim();

      if (header != '-----BEGIN PRIVATE KEY-----' || footer != '-----END PRIVATE KEY-----') {
        throw Exception('Invalid PEM private key format');
      }

      // Extract base64 content
      final base64String = lines.sublist(1, lines.length - 1).join('');

      // Decode base64 string
      final keyBytes = base64.decode(base64String);

      // Parse the key bytes into an RSAPrivateKey
      final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      if (topLevelSeq.elements.length < 9) {
        throw Exception('Invalid RSA private key structure');
      }

      final version = topLevelSeq.elements[0] as ASN1Integer;
      final modulus = topLevelSeq.elements[1] as ASN1Integer;
      final publicExponent = topLevelSeq.elements[2] as ASN1Integer;
      final privateExponent = topLevelSeq.elements[3] as ASN1Integer;
      final p = topLevelSeq.elements[4] as ASN1Integer;
      final q = topLevelSeq.elements[5] as ASN1Integer;

      // Debug prints to inspect values
      print('Modulus: ${modulus.valueAsBigInteger}');
      print('Public Exponent: ${publicExponent.valueAsBigInteger}');
      print('Private Exponent: ${privateExponent.valueAsBigInteger}');
      print('p: ${p.valueAsBigInteger}');
      print('q: ${q.valueAsBigInteger}');

      RSAPrivateKey privateKey;
      // Validate modulus consistency
      final calculatedModulus = p.valueAsBigInteger * q.valueAsBigInteger;
      if (modulus.valueAsBigInteger != calculatedModulus) {
        print('Warning: Modulus inconsistent with RSA p and q. Using calculated modulus.');
        privateKey = RSAPrivateKey(
          calculatedModulus,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      } else {
        privateKey = RSAPrivateKey(
          modulus.valueAsBigInteger,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      }

      return privateKey;
    } catch (e) {
      print("Error parsing RSA private key: $e");
      throw Exception('Error parsing RSA private key: $e');
    }
    }


}



  class RSAKeyParser {
  RSAAsymmetricKey parse(String key) {
  final rows = key.split('\n'); // Split the key into rows
  final header = rows.first;

  if (header == '-----BEGIN RSA PRIVATE KEY-----') {
  return _parsePrivateKey(rows);
  } else if (header == '-----BEGIN PUBLIC KEY-----') {
  return _parsePublicKey(rows);
  }

  throw FormatException('Unable to parse key, invalid format.');
  }

  RSAPrivateKey _parsePrivateKey(List<String> rows) {
  final keyString = rows
      .skipWhile((row) => row.startsWith('-----BEGIN'))
      .takeWhile((row) => !row.startsWith('-----END'))
      .map((row) => row.trim())
      .join('');

  final keyBytes = base64.decode(keyString);
  final asn1Parser = ASN1Parser(keyBytes);
  final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;
  final modulus = topLevelSeq.elements[1] as ASN1Integer;
  final privateExponent = topLevelSeq.elements[3] as ASN1Integer;

  return RSAPrivateKey(
  modulus.valueAsBigInteger,
  privateExponent.valueAsBigInteger,
  null, // p
  null, // q
  );
  }



  RSAPublicKey _parsePublicKey(List<String> rows) {
  // Implementation for public key parsing (not needed for signing)
  throw UnimplementedError('Public key parsing not implemented');
  }
  }

