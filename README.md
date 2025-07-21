# ecodrive_server

ECF Ecodrive 2025 - Serveur

## Getting Started 

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Première installation  

Créer le fichier de configuration de bdd dans : 
shared_package/lib/Configuration/Bdd/ConfigurationBDD.prod.env:
USERNAME = NEWUSERNAME
PASSWORD = NEWPASSWORD
HOST = localhost
PORT = port
DATABASE = ecodrives  
USE_SSL = true 
  
De la même façon créer un fichier ConfigurationServer.env dans:
shared_package/lib/Configuration/
Env=prod
USE_TLS=true/false

Si vous choisissez true vous devez créer une clef key.pem et un certificat.pem 
via openssh avec l'algo sha256. Vous le placerez dans
shared_package/lib/Configuration/.Security

Si la base de donnée n'a pas déjà été créée vous pouvez utiliser le fichier de création de base de donnée situé dans le
dossier : Première installation
ou lancer dart run packages/shared_package/lib/BDD/MigrationRunner/run_migration.dart

Vous devez démarrer le Serveur de l'API avec la commande:
dart run packages/server_package/lib/Bin/EcodriveServer.dart -start
                                                             -stop ou ctrl-c pour l'arrêter   

L'interface d'administration peut être démarrée à ce jour avec 
flutter run -d chrome packages/application_package/lib/main.dart

Vous pourrez ensuite vous connecter au compte administrateur avec les identifiants de connexion suivant:
identifiant : admin 
password :    1u68F935
Vous devrez alors personnaliser votre mot de passe.

Vous aurez accès à votre espace d'administration qui vous permettra de créer les différents employés 
et d'accéder aux différentes données nécessaires au bon fonctionnement de votre commerce en ligne.

Pour utiliser l'application en tant qu'utilisateur, il vous faudra télécharger le client ecodrive sur le store.
Créer votre compte utilisateur.
Vous pourrez dès lors créer des trajets disponibles à vos passagers.   
  

 
