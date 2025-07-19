/// GENERATED FILE - DO NOT MODIFY BY HAND
/// Use modules Generator, Script : WhereFilterIndexGenerator.dart v.1 
/// Author E.H 18/07/2025 

///  Use : Map access in files : 
///        WhereFilterIndex['entityName']!()


import '../../Model/AbstractModels/AddressEntity.dart';
import '../../Model/AbstractModels/AdministratorEntity.dart';
import '../../Model/AbstractModels/AssuranceEntity.dart';
import '../../Model/AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import '../../Model/AbstractModels/CommandEntity.dart';
import '../../Model/AbstractModels/Interface/DocumentInterface.dart';
import '../../Model/AbstractModels/DriverEntity.dart';
import '../../Model/AbstractModels/DrivingLicenceEntity.dart';
import '../../Model/AbstractModels/EmployeeEntity.dart';
import '../../Model/Index/Entity_Index.dart';
import '../../Model/AbstractModels/ItineraryEntity.dart';
import '../../Model/AbstractModels/NoticeEntity.dart';
import '../../Model/Abstract/PersonEntity.dart';
import '../../Model/AbstractModels/PhotoEntity.dart';
import '../../Model/AbstractModels/TravelEntity.dart';
import '../../Model/AbstractModels/UserEntity.dart';
import '../../Model/RelationMtoM/UserNoticeMtoMEntity.dart';
import '../../Model/AbstractModels/VehiculeEntity.dart';

final Map<String, Map<String, Map<String, dynamic>>> WhereFilterIndex = {
  'Address': {
    'number': {
      'whereField': ({where, value}) => where.number.equals(value),
      'type': 'int?',
    },
    'type': {
      'whereField': ({where, value}) => where.type.equals(value),
      'type': 'String?',
    },
    'address': {
      'whereField': ({where, value}) => where.address.equals(value),
      'type': 'String?',
    },
    'complementAddress': {
      'whereField': ({where, value}) => where.complementAddress.equals(value),
      'type': 'String?',
    },
    'postCode': {
      'whereField': ({where, value}) => where.postCode.equals(value),
      'type': 'String?',
    },
    'city': {
      'whereField': ({where, value}) => where.city.equals(value),
      'type': 'String?',
    },
    'country': {
      'whereField': ({where, value}) => where.country.equals(value),
      'type': 'String?',
    },
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'PersonEntity?',
    },
    'itinerary': {
      'whereField': ({where, value}) => where.itinerary.equals(value),
      'type': 'ItineraryEntity?',
    },
  },
  'Administrator': {
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'PersonEntity?',
    },
    'authUserEntity': {
      'whereField': ({where, value}) => where.authUserEntity.equals(value),
      'type': 'AuthUserEntity?',
    },
  },
  'Assurance': {
    'identificationNumber': {
      'whereField': ({where, value}) => where.identificationNumber.equals(value),
      'type': 'int',
    },
    'documentPdf': {
      'whereField': ({where, value}) => where.documentPdf.equals(value),
      'type': 'Uint8List?',
    },
    'photo': {
      'whereField': ({where, value}) => where.photo.equals(value),
      'type': 'PhotoEntity?',
    },
    'title': {
      'whereField': ({where, value}) => where.title.equals(value),
      'type': 'String',
    },
    'vehicule': {
      'whereField': ({where, value}) => where.vehicule.equals(value),
      'type': 'VehiculeEntity',
    },
  },
  'AuthUser': {
    'identifiant': {
      'whereField': ({where, value}) => where.identifiant.equals(value),
      'type': 'String?',
    },
    'password': {
      'whereField': ({where, value}) => where.password.equals(value),
      'type': 'String?',
    },
    'role': {
      'whereField': ({where, value}) => where.role.equals(value),
      'type': 'List<String>?',
    },
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'Person?',
    },
  },
  'Command': {
    'reference': {
      'whereField': ({where, value}) => where.reference.equals(value),
      'type': 'String',
    },
    'credits': {
      'whereField': ({where, value}) => where.credits.equals(value),
      'type': 'double',
    },
    'unitaryPrice': {
      'whereField': ({where, value}) => where.unitaryPrice.equals(value),
      'type': 'double',
    },
    'totalHT': {
      'whereField': ({where, value}) => where.totalHT.equals(value),
      'type': 'double',
    },
    'totalTTC': {
      'whereField': ({where, value}) => where.totalTTC.equals(value),
      'type': 'double',
    },
    'status': {
      'whereField': ({where, value}) => where.status.equals(value),
      'type': 'String',
    },
    'user': {
      'whereField': ({where, value}) => where.user.equals(value),
      'type': 'UserEntity',
    },
  },
  'DocumentInterface': {
    'title': {
      'whereField': ({where, value}) => where.title.equals(value),
      'type': 'String',
    },
    'identificationNumber': {
      'whereField': ({where, value}) => where.identificationNumber.equals(value),
      'type': 'int',
    },
    'photo': {
      'whereField': ({where, value}) => where.photo.equals(value),
      'type': 'PhotoEntity?',
    },
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity?',
    },
  },
  'Driver': {
    'preferences': {
      'whereField': ({where, value}) => where.preferences.equals(value),
      'type': 'List<String>?',
    },
    'user': {
      'whereField': ({where, value}) => where.user.equals(value),
      'type': 'UserEntity?',
    },
    'drivingLicence': {
      'whereField': ({where, value}) => where.drivingLicence.equals(value),
      'type': 'DrivingLicenceEntity?',
    },
  },
  'DrivingLicence': {
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity?',
    },
    'identificationNumber': {
      'whereField': ({where, value}) => where.identificationNumber.equals(value),
      'type': 'int',
    },
    'documentPdf': {
      'whereField': ({where, value}) => where.documentPdf.equals(value),
      'type': 'Uint8List?',
    },
    'title': {
      'whereField': ({where, value}) => where.title.equals(value),
      'type': 'String',
    },
  },
  'Employee': {
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'Person?',
    },
  },
  'Itinerary': {
    'price': {
      'whereField': ({where, value}) => where.price.equals(value),
      'type': 'double?',
    },
    'eco': {
      'whereField': ({where, value}) => where.eco.equals(value),
      'type': 'bool?',
    },
    'duration': {
      'whereField': ({where, value}) => where.duration.equals(value),
      'type': 'DateTime?',
    },
    'geoPointList': {
      'whereField': ({where, value}) => where.geoPointList.equals(value),
      'type': 'List<Uint8List>?',
    },
    'travel': {
      'whereField': ({where, value}) => where.travel.equals(value),
      'type': 'TravelEntity?',
    },
  },
  'Notice': {
    'title': {
      'whereField': ({where, value}) => where.title.equals(value),
      'type': 'String',
    },
    'description': {
      'whereField': ({where, value}) => where.description.equals(value),
      'type': 'String',
    },
    'note': {
      'whereField': ({where, value}) => where.note.equals(value),
      'type': 'int?',
    },
    'createdAt': {
      'whereField': ({where, value}) => where.createdAt.equals(value),
      'type': 'DateTime?',
    },
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity?',
    },
  },
  'Person': {
    'firstname': {
      'whereField': ({where, value}) => where.firstname.equals(value),
      'type': 'String?',
    },
    'lastname': {
      'whereField': ({where, value}) => where.lastname.equals(value),
      'type': 'String?',
    },
    'age': {
      'whereField': ({where, value}) => where.age.equals(value),
      'type': 'int?',
    },
    'gender': {
      'whereField': ({where, value}) => where.gender.equals(value),
      'type': 'String?',
    },
    'credits': {
      'whereField': ({where, value}) => where.credits.equals(value),
      'type': 'double?',
    },
    'email': {
      'whereField': ({where, value}) => where.email.equals(value),
      'type': 'String?',
    },
    'photo': {
      'whereField': ({where, value}) => where.photo.equals(value),
      'type': 'PhotoEntity?',
    },
    'authUser': {
      'whereField': ({where, value}) => where.authUser.equals(value),
      'type': 'AuthUserEntity?',
    },
    'user': {
      'whereField': ({where, value}) => where.user.equals(value),
      'type': 'UserEntity?',
    },
    'administrator': {
      'whereField': ({where, value}) => where.administrator.equals(value),
      'type': 'AdministratorEntity?',
    },
    'employee': {
      'whereField': ({where, value}) => where.employee.equals(value),
      'type': 'EmployeeEntity?',
    },
  },
  'Photo': {
    'title': {
      'whereField': ({where, value}) => where.title.equals(value),
      'type': 'String?',
    },
    'uri': {
      'whereField': ({where, value}) => where.uri.equals(value),
      'type': 'String?',
    },
    'description': {
      'whereField': ({where, value}) => where.description.equals(value),
      'type': 'String?',
    },
    'photo': {
      'whereField': ({where, value}) => where.photo.equals(value),
      'type': 'Uint8List?',
    },
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'PersonEntity?',
    },
  },
  'Travel': {
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity',
    },
    'user': {
      'whereField': ({where, value}) => where.user.equals(value),
      'type': 'List?',
    },
    'validate': {
      'whereField': ({where, value}) => where.validate.equals(value),
      'type': 'List?',
    },
    'departureTime': {
      'whereField': ({where, value}) => where.departureTime.equals(value),
      'type': 'DateTime?',
    },
    'arrivalTime': {
      'whereField': ({where, value}) => where.arrivalTime.equals(value),
      'type': 'DateTime?',
    },
  },
  'User': {
    'person': {
      'whereField': ({where, value}) => where.person.equals(value),
      'type': 'PersonEntity?',
    },
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity?',
    },
    'commandList': {
      'whereField': ({where, value}) => where.commandList.equals(value),
      'type': 'List<CommandEntity>?',
    },
    'authUserEntity': {
      'whereField': ({where, value}) => where.authUserEntity.equals(value),
      'type': 'AuthUserEntity?',
    },
  },
  'UserNoticeMtoM': {
    'notice': {
      'whereField': ({where, value}) => where.notice.equals(value),
      'type': 'NoticeEntity?',
    },
    'user': {
      'whereField': ({where, value}) => where.user.equals(value),
      'type': 'UserEntity?',
    },
  },
  'Vehicule': {
    'brand': {
      'whereField': ({where, value}) => where.brand.equals(value),
      'type': 'String?',
    },
    'modele': {
      'whereField': ({where, value}) => where.modele.equals(value),
      'type': 'String?',
    },
    'color': {
      'whereField': ({where, value}) => where.color.equals(value),
      'type': 'String?',
    },
    'energy': {
      'whereField': ({where, value}) => where.energy.equals(value),
      'type': 'String?',
    },
    'immatriculation': {
      'whereField': ({where, value}) => where.immatriculation.equals(value),
      'type': 'String?',
    },
    'firstImmatriculation': {
      'whereField': ({where, value}) => where.firstImmatriculation.equals(value),
      'type': 'DateTime?',
    },
    'nbPlaces': {
      'whereField': ({where, value}) => where.nbPlaces.equals(value),
      'type': 'int?',
    },
    'photoList': {
      'whereField': ({where, value}) => where.photoList.equals(value),
      'type': 'List<PhotoEntity>?',
    },
    'driver': {
      'whereField': ({where, value}) => where.driver.equals(value),
      'type': 'DriverEntity',
    },
    'preferences': {
      'whereField': ({where, value}) => where.preferences.equals(value),
      'type': 'List<String>?',
    },
    'assurance': {
      'whereField': ({where, value}) => where.assurance.equals(value),
      'type': 'AssuranceEntity?',
    },
  },
};

