
import 'dart:typed_data';

import 'package:asn1lib/asn1lib.dart';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/export.dart';
import 'dart:convert';

class PemBlock {
  late final String label;
  late final String content;

  PemBlock(String pemString) {
    final lines = pemString.split('\n');
    final label = lines.first.replaceFirst('-----BEGIN ', '').replaceFirst('-----', '');
    final content = lines.sublist(1, lines.length - 2).join('');
    this.label = label;
    this.content = content;
  }

  Uint8List getContentBytes() {
    return Uint8List.fromList(base64.decode(content));
  }
}
Future<RSAPrivateKey> parsePrivateKeyFromPem(String pemString) async {
  try {
    final pemBlock = PemBlock(pemString);
    final privateKeyDER = pemBlock.getContentBytes();
    final asn1Parser = ASN1Parser(privateKeyDER as Uint8List);

    // Assuming privateKeyDER is a PrivateKeyInfo ASN.1 structure
    final privateKeyInfo = asn1Parser.nextObject();

    // Assuming privateKeyInfo contains the private key data directly
    final rsaPrivateKey = RSAKeyParser().parse(privateKeyInfo as String);

    return rsaPrivateKey as RSAPrivateKey;
  } catch (e) {
    throw Exception('Error parsing private key: $e');
  }
}


