/// GENERATED FILE - DO NOT MODIFY BY HAND
/// Use modules Generator, Script : ClassesIndexGenerator.dart v.1 
/// Author E.H 27/06/2025 
library;

import '../Abstract/PersonEntity.dart';
///  Use : Instanciated classes access in files :
///        classIndex['entityName']!()

import '../AbstractModels/AddressEntity.dart';
import '../AbstractModels/AdministratorEntity.dart';
import '../AbstractModels/AssuranceEntity.dart';
import '../AbstractModels/CommandEntity.dart';
import '../AbstractModels/DriverEntity.dart';
import '../AbstractModels/DrivingLicenceEntity.dart';
import '../AbstractModels/EmployeeEntity.dart';
import '../AbstractModels/ItineraryEntity.dart';
import '../AbstractModels/Modules/Authentication/Entities/AuthUserEntity.dart';
import '../AbstractModels/NoticeEntity.dart';
import '../AbstractModels/PhotoEntity.dart';
import '../AbstractModels/TravelEntity.dart';
import '../AbstractModels/UserEntity.dart';
import '../AbstractModels/VehiculeEntity.dart';
import '../RelationMtoM/UserNoticeMtoMEntity.dart';

final Map<String, dynamic> Entity_Index = {
  'Address': { 'type': Address,'queryClass':()=>AddressQuery(),'serializerClass': ()=>AddressSerializer(),'fromMap': AddressSerializer.fromMap, 'toMap': AddressSerializer.toMap,'fields': AddressFields.allFields},
  'Administrator': { 'type': Administrator,'queryClass':()=>AdministratorQuery(),'serializerClass': ()=>AdministratorSerializer(),'fromMap': AdministratorSerializer.fromMap,'toMap': AdministratorSerializer.toMap, 'fields': AdministratorFields.allFields},
  'Assurance': { 'type': Assurance,'queryClass':()=>AssuranceQuery(),'serializerClass': ()=>AssuranceSerializer(),'fromMap': AssuranceSerializer.fromMap,'toMap': AssuranceSerializer.toMap, 'fields': AssuranceFields.allFields},
  'AuthUser': { 'type': AuthUser,'queryClass':()=>AuthUserQuery(),'serializerClass':()=> AuthUserSerializer(),'fromMap': AuthUserSerializer.fromMap,'toMap': AuthUserSerializer.toMap, 'fields': AuthUserFields.allFields},
  'Command': { 'type': Command,'queryClass':()=>CommandQuery(),'serializerClass':()=> CommandSerializer(),'fromMap': CommandSerializer.fromMap, 'toMap': CommandSerializer.toMap,'fields': CommandFields.allFields},
  'Driver': { 'type': Driver,'queryClass':()=>DriverQuery(),'serializerClass':()=> DriverSerializer(),'fromMap': DriverSerializer.fromMap, 'toMap': DriverSerializer.toMap,'fields': DriverFields.allFields},
  'DrivingLicence': { 'type': DrivingLicence,'queryClass':()=>DrivingLicenceQuery(),'serializerClass': ()=>DrivingLicenceSerializer(),'fromMap': DrivingLicenceSerializer.fromMap, 'toMap': DrivingLicenceSerializer.toMap,'fields': DrivingLicenceFields.allFields},
  'Employee': { 'type': Employee,'queryClass':()=>EmployeeQuery(),'serializerClass': ()=>EmployeeSerializer(),'fromMap': EmployeeSerializer.fromMap, 'toMap': AddressSerializer.toMap,'fields': EmployeeFields.allFields},
  'Itinerary': { 'type': Itinerary,'queryClass':()=>ItineraryQuery(),'serializerClass': ()=>ItinerarySerializer(),'fromMap': ItinerarySerializer.fromMap, 'toMap': ItinerarySerializer.toMap,'fields': ItineraryFields.allFields},
  'Notice': { 'type': Notice,'queryClass':()=>NoticeQuery(),'serializerClass': ()=>NoticeSerializer(),'fromMap': NoticeSerializer.fromMap, 'toMap': NoticeSerializer.toMap,'fields': NoticeFields.allFields},
  'Person': { 'type': Person,'queryClass':()=>PersonQuery(),'serializerClass': ()=>PersonSerializer(),'fromMap': PersonSerializer.fromMap, 'toMap': PersonSerializer.toMap,'fields': PersonFields.allFields},
  'Photo': { 'type': Photo,'queryClass':()=>PhotoQuery(),'serializerClass': ()=>PhotoSerializer(),'fromMap': PhotoSerializer.fromMap,'toMap': PhotoSerializer.toMap, 'fields': PhotoFields.allFields},
  'Travel': { 'type': Travel,'queryClass':()=>TravelQuery(),'serializerClass': ()=>TravelSerializer(),'fromMap': TravelSerializer.fromMap,'toMap': TravelSerializer.toMap, 'fields': TravelFields.allFields},
  'User': { 'type': User,'queryClass':()=>UserQuery(),'serializerClass':()=> UserSerializer(),'fromMap': UserSerializer.fromMap, 'toMap': UserSerializer.toMap,'fields': UserFields.allFields},
  'Vehicule': { 'type': Vehicule,'queryClass':()=>VehiculeQuery(),'serializerClass':()=> VehiculeSerializer(),'fromMap': VehiculeSerializer.fromMap, 'toMap': VehiculeSerializer.toMap,'fields': VehiculeFields.allFields},
  'UserNoticeMtoM': { 'type': UserNoticeMtoM,'queryClass':()=>UserNoticeMtoMQuery(),'serializerClass':()=> UserNoticeMtoMSerializer(),'fromMap': UserNoticeMtoMSerializer.fromMap, 'toMap': UserNoticeMtoMSerializer.toMap,'fields': UserNoticeMtoMFields.allFields},

};



