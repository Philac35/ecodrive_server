import 'package:angel3_serialize/angel3_serialize.dart';
import 'package:ecodrive_server/src/BDD/Model/AbstractModels/Abstract/Person.dart';

// As i use part file  i keep it in part.
// But it could be better to set each file in specific directories when i will have all
// the files well configured.
/*

class PersonModel extends Person {
  @override
  String? id;

  @override
  DateTime? updatedAt;

  @override
  int? idInt;

  @override
  String? firstname;

  @override
  String? lastname;

  @override
  int? age;

  @override
  String? gender;

  @override
  Address? address;

  @override
  String? email;

  @override
  Photo? photo;

  @override
  AuthUser? authUser;

  @override
  DateTime? createdAt;

  PersonModel({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? idInt,
    String? firstname,
    String? lastname,
    int? age,
    String? gender,
    Address? address,
    String? email,
    Photo? photo,
    AuthUser? authUser,
  }) : super(
    id: id,
    createdAt: createdAt,
    updatedAt: updatedAt,
    idInt: idInt,
    firstname: firstname,
    lastname: lastname,
    age: age,
    gender: gender,
    address: address,
    email: email,
    photo: photo,
    authUser: authUser,
  );

  @override
  PersonModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? idInt,
    String? firstname,
    String? lastname,
    int? age,
    String? gender,
    Address? address,
    String? email,
    Photo? photo,
    AuthUser? authUser,
  }) {
    return PersonModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      idInt: idInt ?? this.idInt,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      authUser: authUser ?? this.authUser,
    );
  }

  @override
  bool operator ==(other) {
    return other is PersonModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.age == age &&
        other.gender == gender &&
        other.address == address &&
        other.email == email &&
        other.photo == photo &&
        other.authUser == authUser;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      idInt,
      firstname,
      lastname,
      age,
      gender,
      address,
      email,
      photo,
      authUser,
    ]);
  }

  @override
  String toString() {
    return 'PersonModel(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, idInt=$idInt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, address=$address, email=$email, photo=$photo, authUser=$authUser)';
  }

  @override
  Map<String, dynamic> toJson() {
    return PersonSerializer.toMap(this);
  }
}*/