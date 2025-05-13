import 'dart:convert';
import 'dart:typed_data';
import 'package:asn1lib/asn1lib.dart';

import 'package:pointycastle/asymmetric/api.dart';


//import for PEM Lib function
import 'package:pem/pem.dart';


class ReadPemFile {

  //The code handles both traditional RSA private key and PKCS#8 formats.
// This doesn't work 5/03/2025 11h33
  RSAPrivateKey decodePEM(String pemPrivateKey) {
    try {
      // Remove header and footer from PEM string
      final lines = pemPrivateKey.split('\n');
      final header = lines.first.trim();
      final footer = lines.last.trim();

      if (header != '-----BEGIN RSA PRIVATE KEY-----' && header != '-----BEGIN PRIVATE KEY-----' ||
          footer != '-----END RSA PRIVATE KEY-----' && footer != '-----END PRIVATE KEY-----') {
        throw Exception('Invalid PEM private key format');
      }

      // Extract base64 content
      final base64String = lines.sublist(1, lines.length - 1).join('');

      // Decode base64 string
      final keyBytes = base64.decode(base64String);

      // Parse the key bytes into an RSAPrivateKey
      final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      if (header == '-----BEGIN PRIVATE KEY-----') {
        // PKCS#8 format
        final octetString = topLevelSeq.elements[0] as ASN1OctetString;
        final wrappedKeyBytes = octetString.valueBytes;
        final wrappedAsn1Parser = ASN1Parser(Uint8List.fromList(wrappedKeyBytes as List<int>));
        final wrappedTopLevelSeq = wrappedAsn1Parser.nextObject() as ASN1Sequence;

        final version = wrappedTopLevelSeq.elements[0] as ASN1Integer;
        final modulus = wrappedTopLevelSeq.elements[1] as ASN1Integer;
        final publicExponent = wrappedTopLevelSeq.elements[2] as ASN1Integer;
        final privateExponent = wrappedTopLevelSeq.elements[3] as ASN1Integer;
        final p = wrappedTopLevelSeq.elements[4] as ASN1Integer;
        final q = wrappedTopLevelSeq.elements[5] as ASN1Integer;

        // Validate modulus consistency
        final calculatedModulus = p.valueAsBigInteger * q.valueAsBigInteger;
        if (modulus.valueAsBigInteger != calculatedModulus) {
          print('Warning: Modulus inconsistent with RSA p and q. Using calculated modulus.');
          return RSAPrivateKey(
            calculatedModulus,
            privateExponent.valueAsBigInteger,
            p.valueAsBigInteger,
            q.valueAsBigInteger,
          );
        } else {
          return RSAPrivateKey(
            modulus.valueAsBigInteger,
            privateExponent.valueAsBigInteger,
            p.valueAsBigInteger,
            q.valueAsBigInteger,
          );
        }
      } else {
        // Traditional RSA private key format
        final version = topLevelSeq.elements[0] as ASN1Integer;
        final modulus = topLevelSeq.elements[1] as ASN1Integer;
        final publicExponent = topLevelSeq.elements[2] as ASN1Integer;
        final privateExponent = topLevelSeq.elements[3] as ASN1Integer;
        final p = topLevelSeq.elements[4] as ASN1Integer;
        final q = topLevelSeq.elements[5] as ASN1Integer;

        // Validate modulus consistency
        final calculatedModulus = p.valueAsBigInteger * q.valueAsBigInteger;
        if (modulus.valueAsBigInteger != calculatedModulus) {
          print('Warning: Modulus inconsistent with RSA p and q. Using calculated modulus.');
          return RSAPrivateKey(
            calculatedModulus,
            privateExponent.valueAsBigInteger,
            p.valueAsBigInteger,
            q.valueAsBigInteger,
          );
        } else {
          return RSAPrivateKey(
            modulus.valueAsBigInteger,
            privateExponent.valueAsBigInteger,
            p.valueAsBigInteger,
            q.valueAsBigInteger,
          );
        }
      }
    } catch (e) {
      print("Error parsing RSA private key: $e");
      throw Exception('Error parsing RSA private key: $e');
    }
  }

//Work for traditionnal RSA private keys
  // This doesn't work 5/03/2025 11h33
  RSAPrivateKey decodePEM1(String pemPrivateKey) {
    try {
      // Remove header and footer from PEM string
      final lines = pemPrivateKey.split('\n');
      final header = lines.first.trim();
      final footer = lines.last.trim();

      if (header != '-----BEGIN RSA PRIVATE KEY-----' ||
          footer != '-----END RSA PRIVATE KEY-----') {
        throw Exception('Invalid PEM private key format');
      }

      // Extract base64 content
      final base64String = lines.sublist(1, lines.length - 1).join('');

      // Decode base64 string
      final keyBytes = base64.decode(base64String);

      // Parse the key bytes into an RSAPrivateKey
      final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      final version = topLevelSeq.elements[0] as ASN1Integer;
      final modulus = topLevelSeq.elements[1] as ASN1Integer;
      final publicExponent = topLevelSeq.elements[2] as ASN1Integer;
      final privateExponent = topLevelSeq.elements[3] as ASN1Integer;
      final p = topLevelSeq.elements[4] as ASN1Integer;
      final q = topLevelSeq.elements[5] as ASN1Integer;

      // Validate modulus consistency
      final calculatedModulus = p.valueAsBigInteger * q.valueAsBigInteger;
      if (modulus.valueAsBigInteger != calculatedModulus) {
        print('Warning: Modulus inconsistent with RSA p and q. Using calculated modulus.');
        return RSAPrivateKey(
          calculatedModulus,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      } else {
        return RSAPrivateKey(
          modulus.valueAsBigInteger,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      }
    } catch (e) {
      print("Error parsing RSA private key: $e");
      throw Exception('Error parsing RSA private key: $e');
    }
  }

  //Function decodePem with PEM Library
  RSAPrivateKey decodePEMLib(String pemPrivateKey) {
    try {
      // Use pem library to decode the PEM string
      final pemBlocks = decodePemBlocks(PemLabel.privateKey, pemPrivateKey);
      if (pemBlocks.isEmpty) {
        throw Exception('No valid PEM blocks found');
      }

      final keyBytes = pemBlocks.first;

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

      // Validate modulus consistency
      final calculatedModulus = p.valueAsBigInteger * q.valueAsBigInteger;
      if (modulus.valueAsBigInteger != calculatedModulus) {
        print('Warning: Modulus inconsistent with RSA p and q. Using calculated modulus.');
        return RSAPrivateKey(
          calculatedModulus,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      } else {
        return RSAPrivateKey(
          modulus.valueAsBigInteger,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      }
    } catch (e) {
      print("Error parsing RSA private key: $e");
      throw Exception('Error parsing RSA private key: $e');
    }
  }
decodePEMencrypt(pemPublicKey)async{
  Future<RSAPrivateKey> readPrivateKey(String pemPrivateKey) async {
    try {
      final lines = pemPrivateKey.split('\n');
      final header = lines.first.trim();
      final footer = lines.last.trim();

      if (header != '-----BEGIN RSA PRIVATE KEY-----' && header != '-----BEGIN PRIVATE KEY-----' ||
          footer != '-----END RSA PRIVATE KEY-----' && footer != '-----END PRIVATE KEY-----') {
        throw Exception('Invalid PEM private key format');
      }

      final base64String = lines.sublist(1, lines.length - 1).join('');
      final keyBytes = base64.decode(base64String);

      final asn1Parser = ASN1Parser(Uint8List.fromList(keyBytes));
      final topLevelSeq = asn1Parser.nextObject() as ASN1Sequence;

      if (header == '-----BEGIN PRIVATE KEY-----') {
        final octetString = topLevelSeq.elements[0] as ASN1OctetString;
        final wrappedKeyBytes = octetString.valueBytes;
        final wrappedAsn1Parser = ASN1Parser(Uint8List.fromList(wrappedKeyBytes as List<int>));
        final wrappedTopLevelSeq = wrappedAsn1Parser.nextObject() as ASN1Sequence;

        final version = wrappedTopLevelSeq.elements[0] as ASN1Integer;
        final modulus = wrappedTopLevelSeq.elements[1] as ASN1Integer;
        final publicExponent = wrappedTopLevelSeq.elements[2] as ASN1Integer;
        final privateExponent = wrappedTopLevelSeq.elements[3] as ASN1Integer;
        final p = wrappedTopLevelSeq.elements[4] as ASN1Integer;
        final q = wrappedTopLevelSeq.elements[5] as ASN1Integer;

        return RSAPrivateKey(
          modulus.valueAsBigInteger,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      } else {
        final version = topLevelSeq.elements[0] as ASN1Integer;
        final modulus = topLevelSeq.elements[1] as ASN1Integer;
        final publicExponent = topLevelSeq.elements[2] as ASN1Integer;
        final privateExponent = topLevelSeq.elements[3] as ASN1Integer;
        final p = topLevelSeq.elements[4] as ASN1Integer;
        final q = topLevelSeq.elements[5] as ASN1Integer;

        return RSAPrivateKey(
          modulus.valueAsBigInteger,
          privateExponent.valueAsBigInteger,
          p.valueAsBigInteger,
          q.valueAsBigInteger,
        );
      }
    } catch (e) {
      print("Error parsing RSA private key: $e");
      throw Exception('Error parsing RSA private key: $e');
    }
  }


}


void main() {
  final pemPrivateKey = '''
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

  //key format PKCS#8
  final pemPrivateKey1 = '''
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
  try {
    final privateKey = ReadPemFile().decodePEMLib(pemPrivateKey1);
    print('Private key read successfully: $privateKey');
  } catch (e) {
    print('Error reading private key: $e');
  }
}}