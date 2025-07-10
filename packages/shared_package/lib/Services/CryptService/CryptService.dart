
import 'dart:io';
import 'dart:isolate';
import 'dart:math';


import 'package:shared_package/Services/LogSystem/LogSystem.dart';
import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'package:flutter/foundation.dart';

import 'dart:convert';

import 'package:shared_package/Services/Interface/Service.dart';
import 'package:pointycastle/export.dart';
import 'package:shared_package/Library/CryptageLibrary/CryptageLibrary.dart';


//ToDo Debug this class else use EncryptService which is fonctionnal
class CryptService implements Service {

  File privateKeyFile = File(
      "package:shared_package/Configuration/.Securite/Certificate/HTMLCryptage/private/privateKey.key");
  File publicKeyFile = File(
      "/src/Configuration/.Securite/Certificate/HTMLCryptage/public/publicKey.key");

late RSAPrivateKey privateKey;
late RSAPublicKey publicKey;

 late  AsymmetricKeyPair<RSAPublicKey, RSAPrivateKey> keyPair;

  final signer = Signer('SHA-256/RSA');
 late CryptageLibrary criptageLib;

  CryptService(){
    criptageLib= CryptageLibrary();
    init();  }

  List<bool> init() {
    List<bool> exit = [false, false];

    try {
      privateKey = privateKeyFile.readAsString() as RSAPrivateKey;
      exit[0] = true;
    }
    catch (e) {
      exit[0] = false;
      debugPrint("CryptService L40, Error to read RSAPrivateKey : e");
      debugPrint("Check RSAPrivateKey file, if it is empty generate the files");
      if (kIsWeb) {
        LogSystem().error("CryptService L40, Error to read RSAPrivateKey : e");
        LogSystem().error("Check RSAPrivateKey file, if it is empty generate the files");
      }
      else {
        LogSystemBDD().log("CryptService L40, Error to read RSAPrivateKey : e");
        LogSystemBDD().log("Check RSAPrivateKey file, if it is empty generate the files");
      }
    }

    try {
      publicKey = publicKeyFile.readAsString() as RSAPublicKey;
      exit[1] = true;
    }
    catch (e2) {
      exit[1] = false;
      debugPrint("CryptService L40, Error to read RSAPublicKey : e");
      debugPrint("Check RSAPublicKey file, if it is empty generate the files");
      if (kIsWeb) {
        LogSystem().error("CryptService L40, Error to read RSAPublicKey : e");
        LogSystem().error("Check RSAPublicKey file, if it is empty generate the files");
      }
      else {
        LogSystemBDD().log("CryptService L40, Error to read RSAPublicKey : e");
        LogSystemBDD().log("Check RSAPublicKey file, if it is empty generate the files");
      }

    }
    return exit;

  }




  //Functions de Cryptage
  Future<Uint8List> rsaEncryptStr({required String dataToEncrypt, RSAPublicKey? publicKey}) async {
    Uint8List stringBytes = utf8.encode(dataToEncrypt);
    if(publicKey!=null) {
      return rsaEncrypt(publicKey, stringBytes);
    } else { return rsaEncrypt(this.publicKey, stringBytes);}

  }

  Future<Uint8List> rsaEncrypt(RSAPublicKey publicKey, Uint8List dataToEncrypt) async {
    final encryptor = RSAEngine()
      ..init(true, PublicKeyParameter<RSAPublicKey>(publicKey));
    final encrypted = encryptor.process(dataToEncrypt);
    return encrypted;
  }




//Functions de Decryptage
  Future<Uint8List> rsaDecryptStr(RSAPrivateKey privateKey, String dataToEncrypt) async {
    Uint8List stringBytes = utf8.encode(dataToEncrypt);
    return rsaDecrypt(privateKey, stringBytes);
  }

 /*
  * Function rsaDecrypt
  */
 // Uint8List stringBytes = utf8.encode(myString);
  Future<Uint8List> rsaDecrypt(RSAPrivateKey privateKey, Uint8List encryptedData) async {
    final decryptor = RSAEngine()
      ..init(false, PrivateKeyParameter<RSAPrivateKey>(privateKey));
    final decrypted = decryptor.process(encryptedData);
    return decrypted;
  }

  rsaDecryptObjectJson(RSAPrivateKey privateKey,String ObjectJsonStr){
    var decrypted=rsaDecryptStr(privateKey, ObjectJsonStr);
    Map<String, dynamic> decryptedObjectJson = jsonDecode(decrypted as String);
    return decryptedObjectJson;
  }





  //Signer une clée
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

  SecureRandom _getSecureRandom() {
    final secureRandom = FortunaRandom();
    final random = Random.secure();
    final seeds = List<int>.generate(32, (_) => random.nextInt(256));
    secureRandom.seed(KeyParameter(Uint8List.fromList(seeds)));
    return secureRandom;
  }

  /*
   * Function generateKeyPair()
   * @Return void
   * Use a new Isolate to Generate and Record KeyPair in File
   */
  Future<void> generateKeyPair() async {
    keyPair =
        await Isolate.run(() => generateRSAKeyPair(_getSecureRandom()));

    //Write pairs in Files :
    try {
      privateKeyFile.writeAsString(keyPair.privateKey as String);
    } catch (e) {
      print("TokenService L18, Pb to generate privateKey, error : $e");
    }
    try {
      publicKeyFile.writeAsString(keyPair.publicKey as String);
    } catch (e) {
      print("TokenService L18, Pb to generate publicKey, error : $e");
    }
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
