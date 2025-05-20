// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Person.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class PersonMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('people', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('updated_at');
      table.integer('id_int');
      table.varChar('firstname', length: 255);
      table.varChar('lastname', length: 255);
      table.integer('age');
      table.varChar('gender', length: 255);
      table.varChar('email', length: 255);
      table.timeStamp('created_at');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('people', cascade: true);
  }
}







// **************************************************************************
// OrmGenerator
// **************************************************************************

class PersonQuery extends Query<Person, PersonQueryWhere> {
  PersonQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = PersonQueryWhere(this);
    leftJoin(
      _address = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'person_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _photo = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'person_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _authUser = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'person_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final PersonQueryValues values = PersonQueryValues();

  List<String> _selectedFields = [];

  PersonQueryWhere? _where;

  late FAngelModelQuery _address;

  late FAngelModelQuery _photo;

  late FAngelModelQuery _authUser;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'people';
  }

  @override
  List<String> get fields {
    const _fields = [
      'id',
      'updated_at',
      'id_int',
      'firstname',
      'lastname',
      'age',
      'gender',
      'email',
      'created_at',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
  }

  PersonQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  PersonQueryWhere? get where {
    return _where;
  }

  @override
  PersonQueryWhere newWhereClause() {
    return PersonQueryWhere(this);
  }

  Optional<Person> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = PersonModel(
      id: fields.contains('id') ? row[0].toString() : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[1]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[2]) : null,
      firstname: fields.contains('firstname') ? (row[3] as String?) : null,
      lastname: fields.contains('lastname') ? (row[4] as String?) : null,
      age: fields.contains('age') ? mapToInt(row[5]) : null,
      gender: fields.contains('gender') ? (row[6] as String?) : null,
      email: fields.contains('email') ? (row[7] as String?) : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[8]) : null,
      authUser: fields.contains('authUser') ? (row[9] as AuthUser?) : null,
    );
    if (row.length > 9) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(9).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(address: m);
      });
    }
    if (row.length > 12) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(12).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(photo: m);
      });
    }
    if (row.length > 15) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(15).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(authUser: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Person> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get address {
    return _address;
  }

  FAngelModelQuery get photo {
    return _photo;
  }

  FAngelModelQuery get authUser {
    return _authUser;
  }
}

class PersonQueryWhere extends QueryWhere {
  PersonQueryWhere(PersonQuery query)
      : id = NumericSqlExpressionBuilder<int>(
          query,
          'id',
        ),
        updatedAt = DateTimeSqlExpressionBuilder(
          query,
          'updated_at',
        ),
        idInt = NumericSqlExpressionBuilder<int>(
          query,
          'id_int',
        ),
        firstname = StringSqlExpressionBuilder(
          query,
          'firstname',
        ),
        lastname = StringSqlExpressionBuilder(
          query,
          'lastname',
        ),
        age = NumericSqlExpressionBuilder<int>(
          query,
          'age',
        ),
        gender = StringSqlExpressionBuilder(
          query,
          'gender',
        ),
        email = StringSqlExpressionBuilder(
          query,
          'email',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final StringSqlExpressionBuilder firstname;

  final StringSqlExpressionBuilder lastname;

  final NumericSqlExpressionBuilder<int> age;

  final StringSqlExpressionBuilder gender;

  final StringSqlExpressionBuilder email;

  final DateTimeSqlExpressionBuilder createdAt;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      updatedAt,
      idInt,
      firstname,
      lastname,
      age,
      gender,
      email,
      createdAt,
    ];
  }
}

class PersonQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
  }

  String? get id {
    return (values['id'] as String?);
  }

  set id(String? value) => values['id'] = value;

  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;

  int? get idInt {
    return (values['id_int'] as int?);
  }

  set idInt(int? value) => values['id_int'] = value;

  String? get firstname {
    return (values['firstname'] as String?);
  }

  set firstname(String? value) => values['firstname'] = value;

  String? get lastname {
    return (values['lastname'] as String?);
  }

  set lastname(String? value) => values['lastname'] = value;

  int? get age {
    return (values['age'] as int?);
  }

  set age(int? value) => values['age'] = value;

  String? get gender {
    return (values['gender'] as String?);
  }

  set gender(String? value) => values['gender'] = value;

  String? get email {
    return (values['email'] as String?);
  }

  set email(String? value) => values['email'] = value;

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  void copyFrom(Person model) {
    updatedAt = model.updatedAt;
    idInt = model.idInt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    email = model.email;
    createdAt = model.createdAt;
  }
}



// **************************************************************************
// JsonModelGenerator
// **************************************************************************

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
}


abstract class PersonSerializer {
  static Person fromMap(Map map) {

    Address? address = AddressSerializer.fromMap(map['address']);
    Photo? photo= PhotoSerializer.fromMap(map['photo']) as Photo?;
    AuthUser? authuser= AuthUserSerializer.fromMap(map['authuser']);
    return PersonModel(
      id: map['id'] as String?,
      createdAt: map['created_at'] != null
          ? (map['created_at'] is DateTime
          ? (map['created_at'] as DateTime)
          : DateTime.parse(map['created_at'].toString()))
          : null,
      updatedAt: map['updated_at'] != null
          ? (map['updated_at'] is DateTime
          ? (map['updated_at'] as DateTime)
          : DateTime.parse(map['updated_at'].toString()))
          : null,
      idInt: map['id_int'] as int?,
      firstname: map['firstname'] as String?,
      lastname: map['lastname'] as String?,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      address: map['address'] != null? address : null,
      email: map['email'] as String?,
      photo: map['photo'] != null
          ? photo: null,
      authUser: map['auth_user'] != null
          ? authuser : null,
    );
  }

  static Map<String, dynamic> toMap(Person? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'firstname': model.firstname,
      'lastname': model.lastname,
      'age': model.age,
      'gender': model.gender,
      'address': AddressSerializer.toMap(model.address),
      'email': model.email,
      'photo': PhotoSerializer.toMap(model.photo),
      'auth_user': AuthUserSerializer.toMap(model.authUser),
    };
  }
}





abstract class PersonFields {
  static const List<String> allFields = <String>[
    id,
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
    createdAt,
  ];

  static const String id = 'id';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String firstname = 'firstname';

  static const String lastname = 'lastname';

  static const String age = 'age';

  static const String gender = 'gender';

  static const String address = 'address';

  static const String email = 'email';

  static const String photo = 'photo';

  static const String authUser = 'auth_user';

  static const String createdAt = 'created_at';
}
