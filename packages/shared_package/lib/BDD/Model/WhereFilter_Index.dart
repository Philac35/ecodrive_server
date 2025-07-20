/// GENERATED FILE - DO NOT MODIFY BY HAND
/// Use modules Generator, Script : WhereFilterIndexGenerator.dart v.1
/// Author E.H 18/07/2025
///  Use : Map access in files : 
///        WhereFilterIndex['entityName']!()

import './AbstractModels/AddressEntity.dart';
import './AbstractModels/AdministratorEntity.dart';
import './AbstractModels/AssuranceEntity.dart';
import './AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import './AbstractModels/CommandEntity.dart';
import './AbstractModels/Interface/DocumentInterface.dart';
import './AbstractModels/DriverEntity.dart';
import './AbstractModels/DrivingLicenceEntity.dart';
import './AbstractModels/EmployeeEntity.dart';
import './Index/Entity_Index.dart';
import './AbstractModels/ItineraryEntity.dart';
import './AbstractModels/NoticeEntity.dart';
import './Abstract/PersonEntity.dart';
import './AbstractModels/PhotoEntity.dart';
import './AbstractModels/TravelEntity.dart';
import './AbstractModels/UserEntity.dart';
import './RelationMtoM/UserNoticeMtoMEntity.dart';
import './AbstractModels/VehiculeEntity.dart';


final Map<String, Map<String, Map<String, dynamic>>> WhereFilterIndex = {
  'AddressEntity': {
    'number': {
      'whereField': (where, value) => where.number.equals(value),
      'type': 'int?',
      'level': 1,
    },
    'type': {
      'whereField': (where, value) => where.type.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'address': {
      'whereField': (where, value) => where.address.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'complementAddress': {
      'whereField': (where, value) => where.complementAddress.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'postCode': {
      'whereField': (where, value) => where.postCode.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'city': {
      'whereField': (where, value) => where.city.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'country': {
      'whereField': (where, value) => where.country.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
    'itinerary': {
      'whereField': (where, value) => where.itinerary.equals(value),
      'type': 'ItineraryEntity?',
      'level': 1,
    },
  },
  'AdministratorEntity': {
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
    'authUserEntity': {
      'whereField': (where, value) => where.authUserEntity.equals(value),
      'type': 'AuthUserEntity?',
      'level': 1,
    },
  },
  'AssuranceEntity': {
    'identificationNumber': {
      'whereField': (where, value) => where.identificationNumber.equals(value),
      'type': 'int',
      'level': 1,
    },
    'documentPdf': {
      'whereField': (where, value) => where.documentPdf.equals(value),
      'type': 'Uint8List?',
      'level': 1,
    },
    'photo': {
      'whereField': (where, value) => where.photo.equals(value),
      'type': 'PhotoEntity?',
      'level': 1,
    },
    'title': {
      'whereField': (where, value) => where.title.equals(value),
      'type': 'String',
      'level': 1,
    },
    'vehicule': {
      'whereField': (where, value) => where.vehicule.equals(value),
      'type': 'VehiculeEntity',
      'level': 1,
    },
  },
  'AuthUserEntity': {
    'identifiant': {
      'whereField': (where, value) => where.identifiant.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'password': {
      'whereField': (where, value) => where.password.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'role': {
      'whereField': (where, value) => where.role.equals(value),
      'type': 'List<String>?',
      'level': 1,
    },
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
  },
  'CommandEntity': {
    'reference': {
      'whereField': (where, value) => where.reference.equals(value),
      'type': 'String',
      'level': 1,
    },
    'credits': {
      'whereField': (where, value) => where.credits.equals(value),
      'type': 'double',
      'level': 1,
    },
    'unitaryPrice': {
      'whereField': (where, value) => where.unitaryPrice.equals(value),
      'type': 'double',
      'level': 1,
    },
    'totalHT': {
      'whereField': (where, value) => where.totalHT.equals(value),
      'type': 'double',
      'level': 1,
    },
    'totalTTC': {
      'whereField': (where, value) => where.totalTTC.equals(value),
      'type': 'double',
      'level': 1,
    },
    'status': {
      'whereField': (where, value) => where.status.equals(value),
      'type': 'String',
      'level': 1,
    },
    'user': {
      'whereField': (where, value) => where.user.equals(value),
      'type': 'UserEntity',
      'level': 1,
    },
  },
  'DocumentInterface': {
    'title': {
      'whereField': (where, value) => where.title.equals(value),
      'type': 'String',
      'level': 1,
    },
    'identificationNumber': {
      'whereField': (where, value) => where.identificationNumber.equals(value),
      'type': 'int',
      'level': 1,
    },
    'photo': {
      'whereField': (where, value) => where.photo.equals(value),
      'type': 'PhotoEntity?',
      'level': 1,
    },
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity?',
      'level': 1,
    },
  },
  'DriverEntity': {
    'preferences': {
      'whereField': (where, value) => where.preferences.equals(value),
      'type': 'List<String>?',
      'level': 1,
    },
    'user': {
      'whereField': (where, value) => where.user.equals(value),
      'type': 'UserEntity?',
      'level': 1,
    },
    'drivingLicence': {
      'whereField': (where, value) => where.drivingLicence.equals(value),
      'type': 'DrivingLicenceEntity?',
      'level': 1,
    },
  },
  'DrivingLicenceEntity': {
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity?',
      'level': 1,
    },
    'identificationNumber': {
      'whereField': (where, value) => where.identificationNumber.equals(value),
      'type': 'int',
      'level': 1,
    },
    'documentPdf': {
      'whereField': (where, value) => where.documentPdf.equals(value),
      'type': 'Uint8List?',
      'level': 1,
    },
    'title': {
      'whereField': (where, value) => where.title.equals(value),
      'type': 'String',
      'level': 1,
    },
  },
  'EmployeeEntity': {
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
  },
  'EntityIndex': {
  },
  'ForeignTableSqlExpressionBuilder': {
  },
  'ItineraryEntity': {
    'price': {
      'whereField': (where, value) => where.price.equals(value),
      'type': 'double?',
      'level': 1,
    },
    'eco': {
      'whereField': (where, value) => where.eco.equals(value),
      'type': 'bool?',
      'level': 1,
    },
    'duration': {
      'whereField': (where, value) => where.duration.equals(value),
      'type': 'DateTime?',
      'level': 1,
    },
    'geoPointList': {
      'whereField': (where, value) => where.geoPointList.equals(value),
      'type': 'List<Uint8List>?',
      'level': 1,
    },
    'travel': {
      'whereField': (where, value) => where.travel.equals(value),
      'type': 'TravelEntity?',
      'level': 1,
    },
  },
  'NoticeEntity': {
    'title': {
      'whereField': (where, value) => where.title.equals(value),
      'type': 'String',
      'level': 1,
    },
    'description': {
      'whereField': (where, value) => where.description.equals(value),
      'type': 'String',
      'level': 1,
    },
    'note': {
      'whereField': (where, value) => where.note.equals(value),
      'type': 'int?',
      'level': 1,
    },
    'createdAt': {
      'whereField': (where, value) => where.createdAt.equals(value),
      'type': 'DateTime?',
      'level': 1,
    },
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity?',
      'level': 1,
    },
  },
  'PersonEntity': {
    'firstname': {
      'whereField': (where, value) => where.firstname.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'lastname': {
      'whereField': (where, value) => where.lastname.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'age': {
      'whereField': (where, value) => where.age.equals(value),
      'type': 'int?',
      'level': 1,
    },
    'gender': {
      'whereField': (where, value) => where.gender.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'credits': {
      'whereField': (where, value) => where.credits.equals(value),
      'type': 'double?',
      'level': 1,
    },
    'email': {
      'whereField': (where, value) => where.email.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'photo': {
      'whereField': (where, value) => where.photo.equals(value),
      'type': 'PhotoEntity?',
      'level': 1,
    },
    'authUser': {
      'whereField': (where, value) => where.authUser.equals(value),
      'type': 'AuthUserEntity?',
      'level': 1,
    },
    'user': {
      'whereField': (where, value) => where.user.equals(value),
      'type': 'UserEntity?',
      'level': 1,
    },
    'administrator': {
      'whereField': (where, value) => where.administrator.equals(value),
      'type': 'AdministratorEntity?',
      'level': 1,
    },
    'employee': {
      'whereField': (where, value) => where.employee.equals(value),
      'type': 'EmployeeEntity?',
      'level': 1,
    },
  },
  'PhotoEntity': {
    'title': {
      'whereField': (where, value) => where.title.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'uri': {
      'whereField': (where, value) => where.uri.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'description': {
      'whereField': (where, value) => where.description.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'photo': {
      'whereField': (where, value) => where.photo.equals(value),
      'type': 'Uint8List?',
      'level': 1,
    },
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
  },
  'TravelEntity': {
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity',
      'level': 1,
    },
    'user': {
      'whereField': (where, value) => where.user.equals(value),
      'type': 'List?',
      'level': 1,
    },
    'validate': {
      'whereField': (where, value) => where.validate.equals(value),
      'type': 'List?',
      'level': 1,
    },
    'departureTime': {
      'whereField': (where, value) => where.departureTime.equals(value),
      'type': 'DateTime?',
      'level': 1,
    },
    'arrivalTime': {
      'whereField': (where, value) => where.arrivalTime.equals(value),
      'type': 'DateTime?',
      'level': 1,
    },
  },
  'UserEntity': {
    'person': {
      'whereField': (where, value) => where.person.equals(value),
      'type': 'PersonEntity?',
      'level': 1,
    },
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity?',
      'level': 1,
    },
    'commandList': {
      'whereField': (where, value) => where.commandList.equals(value),
      'type': 'List<CommandEntity>?',
      'level': 1,
    },
    'authUserEntity': {
      'whereField': (where, value) => where.authUserEntity.equals(value),
      'type': 'AuthUserEntity?',
      'level': 1,
    },
  },
  'UserNoticeMtoMEntity': {
    'notice': {
      'whereField': (where, value) => where.notice.equals(value),
      'type': 'NoticeEntity?',
      'level': 1,
    },
    'user': {
      'whereField': (where, value) => where.user.equals(value),
      'type': 'UserEntity?',
      'level': 1,
    },
  },
  'VehiculeEntity': {
    'brand': {
      'whereField': (where, value) => where.brand.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'modele': {
      'whereField': (where, value) => where.modele.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'color': {
      'whereField': (where, value) => where.color.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'energy': {
      'whereField': (where, value) => where.energy.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'immatriculation': {
      'whereField': (where, value) => where.immatriculation.equals(value),
      'type': 'String?',
      'level': 1,
    },
    'firstImmatriculation': {
      'whereField': (where, value) => where.firstImmatriculation.equals(value),
      'type': 'DateTime?',
      'level': 1,
    },
    'nbPlaces': {
      'whereField': (where, value) => where.nbPlaces.equals(value),
      'type': 'int?',
      'level': 1,
    },
    'photoList': {
      'whereField': (where, value) => where.photoList.equals(value),
      'type': 'List<PhotoEntity>?',
      'level': 1,
    },
    'driver': {
      'whereField': (where, value) => where.driver.equals(value),
      'type': 'DriverEntity',
      'level': 1,
    },
    'preferences': {
      'whereField': (where, value) => where.preferences.equals(value),
      'type': 'List<String>?',
      'level': 1,
    },
    'assurance': {
      'whereField': (where, value) => where.assurance.equals(value),
      'type': 'AssuranceEntity?',
      'level': 1,
    },
  },
  'WhereFilterIndex': {
  },
};

