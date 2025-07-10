import 'package:application_package/src/Modules/Authentication/Entities/AuthUser.dart';
import 'package:application_package/src/Modules/Authentication/Provider/Abstract/AbstractAuthProvider.dart';
import 'package:shared_package/Services/LogSystem/LogSystemBDD.dart';
import 'package:application_package/src/Modules/Authentication/Controllers/AuthUserController.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_package/Services/LogSystem/LogSystem.dart';

 

class AuthProvider extends ChangeNotifier implements AbstractAuthProvider {

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
    AuthUser authUser=  authUserController?.reifyAuthUser(username: identifiant, password: password);
      __isAuthenticated =
      (await authUserController?.authenticator?.authenticate(authUser))!;
    }
    catch (e) {
      debugPrint("AuthProvider, Connexion error : $e");
      if (kIsWeb) {
        LogSystemBDD().error("AuthProvider, Connexion error : $e",
            stackTrace: StackTrace.current.toString());
      }
      else {
        LogSystem().error("AuthProvider, Connexion error : $e",
            stackTrace: StackTrace.current.toString());
      }

      notifyListeners();
    }
  }
    @override
  Future<AuthUser?> disconnect() async {
      bool res = false;

      try {
        res = (await authUserController?.authenticator?.deconnect());
      } catch (e) {
        debugPrint("AuthProvider, Disconnetion error : $e");
        if (kIsWeb) {
          LogSystemBDD().error("AuthProvider, Disconnetion error : $e",
              stackTrace: StackTrace.current.toString());
        }
        else {
          LogSystem().error("AuthProvider, Disconnetion error : $e",
              stackTrace: StackTrace.current.toString());
        }

        //TODO To check here if i don't make a mistake when i will implement the server side logic
        if (res == true) {
          __isAuthenticated = false;
        }
        notifyListeners();
      }
      return null;
    }




  @override
  AuthUser? get currentUser => _currentUser ?? authUserController?.authUser;



// TODO: Voir si le User could be util too
}



/*Configure :
*return MaterialApp.router(
  routerConfig: _appRouter.config(
    reevaluateListenable: authProvider
  ),
);
*/
