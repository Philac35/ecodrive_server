import 'package:shared_package/Modules/Authentication/Entities/AuthUserEntity.dart';
import 'package:shared_package/Modules/Authentication/Provider/Abstract/AbstractAuthProvider.dart';
//import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'package:shared_package/Modules/Authentication/Controllers/AuthUserController.dart';
//import 'package:flutter/foundation.dart';
//import 'package:shared_package/Services/LogSystem/LogSystem.dart';
import '../../Entities/AuthUser.dart';

//extends ChangeNotifier need foundation, not allowed in shared-package
class AuthProvider implements AbstractAuthProvider {

  static final AuthProvider _instance = AuthProvider._internal();
  AuthUserController? authUserController;

  factory AuthProvider() {
    return _instance;
  }

  AuthProvider._internal(){
    authUserController = AuthUserController();
  }


  AuthUser? _currentUser;
  bool __isAuthenticated = false;

  bool get isAuthenticated {
    return __isAuthenticated;
  }


  @override
  Future<void> connect(String identifiant, String password) async {
    try {
    AuthUser authUser=  authUserController?.reifyAuthUser(identifiant: identifiant, password: password);
      __isAuthenticated =
      (await authUserController?.authenticator?.authenticate(authUser))!;
    }
    catch (e) {
      print("AuthProvider, Connexion error : $e");
      /*
      if (kIsWeb) {
        LogSystemBDD().error("AuthProvider, Connexion error : $e",
            stackTrace: StackTrace.current.toString());
      }
      else {
        LogSystem().error("AuthProvider, Connexion error : $e",
            stackTrace: StackTrace.current.toString());
      }*/

     // notifyListeners();
    }
  }
    @override
  Future<AuthUser?> disconnect() async {
      bool res = false;

      try {
        res = (await authUserController?.authenticator?.deconnect());
      } catch (e) {
        print("AuthProvider, Disconnetion error : $e");
      /*  if (kIsWeb) {
          LogSystemBDD().error("AuthProvider, Disconnetion error : $e",
              stackTrace: StackTrace.current.toString());
        }
        else {
          LogSystem().error("AuthProvider, Disconnetion error : $e",
              stackTrace: StackTrace.current.toString());
      }*/

        //TODO To check here if i don't make a mistake when i will implement the server side logic
        if (res == true) {
          __isAuthenticated = false;
        }
        //notifyListeners();
      }
      return null;
    }




  @override
  AuthUser? get currentUser => _currentUser ?? authUserController?.authUser as AuthUser;  // /!\ cast  AuthUserEntity



// TODO: Voir si le User could be util too
}



/*Configure :
*return MaterialApp.router(
  routerConfig: _appRouter.config(
    reevaluateListenable: authProvider
  ),
);
*/
