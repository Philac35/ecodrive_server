import 'package:envied/envied.dart';

part 'EnvService.g.dart';

@Envied(path: '.env.dev')
abstract class EnvService {
  @EnviedField(varName: 'CRYTOPRIVATEKEY',obfuscate: false)
  static String CRYTOPRIVATEKEY = _EnvService.CRYTOPRIVATEKEY;
  @EnviedField(varName: 'CRYTOPUBLICKEY',obfuscate: false)
  static String CRYTOPUBLICKEY = _EnvService.CRYTOPUBLICKEY;

//Rq : _Env is generated automatically with the build command
// Run to build: flutter pub run build_runner build
}