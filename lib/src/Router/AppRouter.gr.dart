// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:ecodrive_server/src/Modules/Authentication/View/Page/ConnexionModalPage.dart'
    as _i4;
import 'package:ecodrive_server/src/Views/Accueil.dart' as _i1;
import 'package:ecodrive_server/src/Views/Administrateur.dart' as _i2;
import 'package:ecodrive_server/src/Views/Connexion.dart' as _i3;
import 'package:ecodrive_server/src/Views/Contact.dart' as _i5;
import 'package:ecodrive_server/src/Views/Credits.dart' as _i6;
import 'package:ecodrive_server/src/Views/Employe.dart' as _i7;
import 'package:flutter/cupertino.dart' as _i9;

/// generated route for
/// [_i1.Accueil]
class Accueil extends _i8.PageRouteInfo<void> {
  const Accueil({List<_i8.PageRouteInfo>? children})
    : super(Accueil.name, initialChildren: children);

  static const String name = 'Accueil';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i1.Accueil();
    },
  );
}

/// generated route for
/// [_i2.Administrateur]
class Administrateur extends _i8.PageRouteInfo<void> {
  const Administrateur({List<_i8.PageRouteInfo>? children})
    : super(Administrateur.name, initialChildren: children);

  static const String name = 'Administrateur';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i2.Administrateur();
    },
  );
}

/// generated route for
/// [_i3.Connexion]
class Connexion extends _i8.PageRouteInfo<ConnexionArgs> {
  Connexion({_i9.Key? key, List<_i8.PageRouteInfo>? children})
    : super(
        Connexion.name,
        args: ConnexionArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'Connexion';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ConnexionArgs>(
        orElse: () => const ConnexionArgs(),
      );
      return _i3.Connexion(key: args.key);
    },
  );
}

class ConnexionArgs {
  const ConnexionArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'ConnexionArgs{key: $key}';
  }
}

/// generated route for
/// [_i4.ConnexionModalPage]
class ConnexionModalRoute extends _i8.PageRouteInfo<void> {
  const ConnexionModalRoute({List<_i8.PageRouteInfo>? children})
    : super(ConnexionModalRoute.name, initialChildren: children);

  static const String name = 'ConnexionModalRoute';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i4.ConnexionModalPage();
    },
  );
}

/// generated route for
/// [_i5.Contact]
class Contact extends _i8.PageRouteInfo<void> {
  const Contact({List<_i8.PageRouteInfo>? children})
    : super(Contact.name, initialChildren: children);

  static const String name = 'Contact';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i5.Contact();
    },
  );
}

/// generated route for
/// [_i6.Credits]
class Credits extends _i8.PageRouteInfo<void> {
  const Credits({List<_i8.PageRouteInfo>? children})
    : super(Credits.name, initialChildren: children);

  static const String name = 'Credits';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i6.Credits();
    },
  );
}

/// generated route for
/// [_i7.Employe]
class Employe extends _i8.PageRouteInfo<void> {
  const Employe({List<_i8.PageRouteInfo>? children})
    : super(Employe.name, initialChildren: children);

  static const String name = 'Employe';

  static _i8.PageInfo page = _i8.PageInfo(
    name,
    builder: (data) {
      return const _i7.Employe();
    },
  );
}
