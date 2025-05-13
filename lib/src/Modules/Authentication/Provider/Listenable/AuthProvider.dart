import 'package:ecodrive_server/src/Modules/Authentication/Entities/AuthUser.dart';
import 'package:ecodrive_server/src/Modules/Authentication/Provider/Abstract/AbstractAuthProvider.dart';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystemBDD.dart';
import 'package:flutter/cupertino.dart';
import 'package:ecodrive_server/src/Modules/Authentication/Controllers/AuthUserController.dart';
import 'package:flutter/foundation.dart';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystem.dart';



class AuthProvider extends ChangeNotifier implements AbstractAuthProvider {

  static final AuthProvider _instance = AuthProvider._internal();
  AuthUserController? authUserController;

  factory AuthProvider() {
    return _instance;
  }

  AuthProvider._internal(){
    this.authUserController = AuthUserController();
  }


  AuthUser? _currentUser;
  bool __isAuthenticated = false;

  bool get isAuthenticated {
    return __isAuthenticated;
  }


  Future<void> connect(String identifiant, String password) async {
    try {
    AuthUser authUser=  this.authUserController?.reifyAuthUser(username: identifiant, password: password);
      __isAuthenticated =
      (await this.authUserController?.authenticator?.authenticate(authUser))!;
    }
    catch (e) {
      debugPrint("AuthProvider, Connexion error : ${e}");
      if (kIsWeb) {
        LogSystemBDD().error("AuthProvider, Connexion error : ${e}",
            stackTrace: StackTrace.current.toString());
      }
      else {
        LogSystem().error("AuthProvider, Connexion error : ${e}",
            stackTrace: StackTrace.current.toString());
      }

      notifyListeners();
    }
  }
    Future<AuthUser?> disconnect() async {
      bool res = false;

      try {
        res = (await this.authUserController?.authenticator?.deconnect());
      } catch (e) {
        debugPrint("AuthProvider, Disconnetion error : ${e}");
        if (kIsWeb) {
          LogSystemBDD().error("AuthProvider, Disconnetion error : ${e}",
              stackTrace: StackTrace.current.toString());
        }
        else {
          LogSystem().error("AuthProvider, Disconnetion error : ${e}",
              stackTrace: StackTrace.current.toString());
        }

        //TODO To check here if i don't make a mistake when i will implement the server side logic
        if (res == true) {
          __isAuthenticated = false;
        }
        notifyListeners();
      }
    }




  @override
  AuthUser? get currentUser => _currentUser != null ? _currentUser : authUserController?.authUser;



// TODO: Voir si le User could be util too
}



/*Configure :
*return MaterialApp.router(
  routerConfig: _appRouter.config(
    reevaluateListenable: authProvider
  ),
);
*/
