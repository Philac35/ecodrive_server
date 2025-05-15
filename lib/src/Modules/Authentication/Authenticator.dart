
import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:ecodrive_server/src/Modules/Authentication/Controllers/AuthUserController.dart';
import 'package:ecodrive_server/src/Services/CryptService/EncryptService.dart';
import 'package:ecodrive_server/src/Services/CryptService/TokenService.dart';
import 'package:ecodrive_server/src/Services/HTMLService/HTMLService.dart';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystem.dart';
import 'package:ecodrive_server/src/Services/LogSystem/LogSystemBDD.dart';
import 'package:ecodrive_server/src/Services/Parser/ParserEntityJson.dart';
import 'package:flutter/foundation.dart';

import '../../Controller/Controller.dart';
import '../../Entities/Driver.dart';
import '../../Entities/User.dart';

import 'Entities/AuthUser.dart';



class Authenticator{
  bool isConnected=false;
  EncryptService? encryptService;
 // HTMLService? htmlService;  //Manage in intern



  AuthUserController? authUserController;
  Authenticator(AuthUserController authUserController){
    encryptService= EncryptService();
    //htmlService= HTMLService();
    this.authUserController=authUserController;
  }




 Future<bool> authenticate(AuthUser authUser) async {
   bool value=false;

   var encryptedInfo=await encryptService?.encryptMessage( authUser.toJson().toString(),EncryptService().publicKey!, );  //If i use this informations are encrypted twice
 //   String donnees = jsonEncode(authUser.toJson());
     //Doit retourner si l'utilisateur est bien connecté, auquel cas l'id de authUser et à quel Utilisateur il correspond.
     //{'connected':true,'id':1,'user:{id='',firstname:'',lastname:'' ....}'}


   // debugPrint("Authenticator L49 encryptedInfo: ${await encryptedInfo}");
    //TODO parser le Json pour avoir les infos de l'utilisateur
 //  htmlService?.isEncrypted=false; //Datas already encrypted, if i let it true, they will be encrypted twice
   //  var response= await htmlService?.send(htmlRequest:'/api/authenticate',method:"POST",data:await encryptedInfo, isEncrypted: false); //idem for encryption
   //debugPrint(" Authentication L52 response: ${response.toString()}");

     /*TODO var result=await htmlService?.parseResult();
   debugPrint(" Authentication L55 response: ${result.toString()}");
   if( result['connected']== true) {   //TODO  It will not work until the server will be made
         try{
          await authUserController?.fetchUser(result["user"]);
         }catch(e){if(kIsWeb){LogSystemBDD().error('Authenticator, authenticate, Fetch User Error :${e}');}
                     else{LogSystem().error('Authenticator, authenticate, Fetch User Error :${e}');}}}
       else{debugPrint("Authentication L56: Authentication failed");};

   value=result['connected'];


      */

   // Set Bearer :    // response.headers.set(HttpHeaders.authorizationHeader,'Bearer <token>',);
   return value;
 }






 deconnect(){
 AuthUser?  authUser=authUserController?.authUser;
 var encryptedInfo=encryptService?.encryptMessage( authUser!.toJson().toString(),EncryptService().publicKey!, );
  // Future<dynamic>? response= htmlService?.send(htmlRequest:'/api/deconnection/',method:"POST",data:encryptedInfo);
   // bool deconnection= htmlService?.parseResult();
  // return deconnection;
 }
}


