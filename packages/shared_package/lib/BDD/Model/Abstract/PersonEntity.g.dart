// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PersonEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class PersonMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('people', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('firstname', length: 64);
      table.varChar('lastname', length: 64);
      table.integer('age');
      table.varChar('gender', length: 8);
      table.double('credits');
      table.varChar('email', length: 128);
      table.declare('address_id', ColumnType('int'))
          .references('addresses', 'id');
      table.declare('photo_id', ColumnType('int'))
          .references('photos', 'id');
      table.declare('auth_user_id', ColumnType('int'))  //for administrator and employee others got one in users
          .references('auth_user', 'id');
      table.declare('user_id', ColumnType('int'))
          .references('users', 'id');
      table.declare('administrator_id', ColumnType('int'))
          .references('administrator', 'id');
      table.declare('employee_id', ColumnType('int'))
          .references('employee', 'id');
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
  PersonQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};    bool isActive = !(trampoline?.contains(tableName) ?? false);

    trampoline.add(tableName);
    _where = PersonQueryWhere(this);
    if(isActive){

    leftJoin(
      _address = AddressQuery(trampoline: trampoline, parent: this),
      'address_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'person_id',
        'itinerary_id',
        'number',
        'type',
        'address',
        'complement_address',
        'post_code',
        'city',
        'country',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _photo = PhotoQuery(trampoline: trampoline, parent: this),
      'photo_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'title',
        'uri',
        'description',
        'photo',
        'person_id',
        'vehicule_id',
        'driving_licence_id',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _authuser = AuthUserQuery(trampoline: trampoline, parent: this),
      'auth_user_id',   // /!\
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'identifiant',
        'password',
        'role',
        'person_id',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _user = UserQuery(trampoline: trampoline, parent: this),
      'user_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'firstname',
        'lastname',
        'age',
        'gender',
        'credits',
        'email',
        'photo_id',
        'user_id',
        'person_id',
        'driver_id',
        'command_id_list',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _administrator = AdministratorQuery(trampoline: trampoline, parent: this),
      'administrator_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'firstname',
        'lastname',
        'age',
        'gender',
        'credits',
        'email',
        'person_id'
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _employee = EmployeeQuery(trampoline: trampoline, parent: this),
      'employee_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'firstname',
        'lastname',
        'age',
        'gender',
        'credits',
        'email',
      ],
      trampoline: trampoline,
    );}
  }

  late AddressQuery _address;
  late PhotoQuery _photo;
  late AuthUserQuery _authuser;
  late UserQuery _user;
  late AdministratorQuery _administrator;
  late EmployeeQuery _employee ;

  @override
  final PersonQueryValues values = PersonQueryValues();

  List<String> _selectedFields = [];

  PersonQueryWhere? _where;

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
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'firstname',
      'lastname',
      'age',
      'gender',
      'credits',
      'email',
      'address_id',
      'photo_id',
      'auth_user_id',
      'user_id',
      'administrator_id',
      'employee_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
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
    var model = Person(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      firstname: fields.contains('firstname') ? (row[3] as String?) : null,
      lastname: fields.contains('lastname') ? (row[4] as String?) : null,
      age: fields.contains('age') ? mapToInt(row[5]) : null,
      gender: fields.contains('gender') ? (row[6] as String?) : null,
      credits: fields.contains('credits') ? mapToDouble(row[7]) : 0.0,
      email: fields.contains('email') ? (row[8] as String?) : null,
      addressId: fields.contains('address_id') ?  (int.parse(row[9]) as int?): null,
      photoId: fields.contains('photo_id') ?  (int.parse(row[10]) as int?): null,
      authUserId:fields.contains('auth_user_id') ?  (int.parse(row[11]) as int?): null,
      userId:  fields.contains('user_id') ?  (int.parse(row[12]) as int?): null,
      administratorId:fields.contains('administrator_id') ?  (int.parse(row[13]) as int?): null,
      employeeId:   fields.contains('employee_id') ?  (int.parse(row[14]) as int?): null,


    );
    if (row.length > 15) {
      var modelOpt = AddressQuery().parseRow(row.skip(15).take(10).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(address: m);
      });
    };
    if (row.length > 26) {
      var modelOpt = PhotoQuery().parseRow(row.skip(26).take(10).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(photo: m);
      });
    };
    if (row.length > 37) {
      var modelOpt = AuthUserQuery().parseRow(row.skip(37).take(7).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(authUser: m);
      });
    }
      if (row.length > 45) {
        var modelOpt = AdministratorQuery().parseRow(row.skip(45).take(10).toList());
        modelOpt.ifPresent((m) {
          model = model.copyWith(administrator: m);
        });
    };
    if (row.length > 56) {
      var modelOpt = EmployeeQuery().parseRow(row.skip(56).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(employee: m);
      });
    };
    return Optional.of(model);
  }

  @override
  Optional<Person> deserialize(List row) {
    return parseRow(row);
  }
}

class PersonQueryWhere extends QueryWhere {
  PersonQueryWhere(PersonQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      firstname = StringSqlExpressionBuilder(query, 'firstname'),
      lastname = StringSqlExpressionBuilder(query, 'lastname'),
      age = NumericSqlExpressionBuilder<int>(query, 'age'),
      gender = StringSqlExpressionBuilder(query, 'gender'),
      credits = NumericSqlExpressionBuilder<double>(query, 'credits'),
      email = StringSqlExpressionBuilder(query, 'email'),
      photoId = NumericSqlExpressionBuilder<int>(query, 'photo_id'),
      authUserId = NumericSqlExpressionBuilder<int>(query, 'auth_user_id'),
      userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
      administratorId = NumericSqlExpressionBuilder<int>(query, 'administrator_id'),
      employeeId = NumericSqlExpressionBuilder<int>(query, 'employee_id')
  ;

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder firstname;

  final StringSqlExpressionBuilder lastname;

  final NumericSqlExpressionBuilder<int> age;


  final StringSqlExpressionBuilder gender;

  final NumericSqlExpressionBuilder<double> credits;

  final StringSqlExpressionBuilder email;

  final NumericSqlExpressionBuilder<int> photoId;

  final NumericSqlExpressionBuilder<int> authUserId;

  final NumericSqlExpressionBuilder<int> userId;

  final NumericSqlExpressionBuilder<int> administratorId;

  final NumericSqlExpressionBuilder<int> employeeId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      firstname,
      lastname,
      age,
      gender,
      credits,
      email,
      photoId,
      authUserId,
      userId,
      administratorId,
      employeeId
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

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;

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

  double get credits {
    return (values['credits'] as double?) ?? 0.0;
  }

  set credits(double value) => values['credits'] = value;

  String? get email {
    return (values['email'] as String?);
  }

  set email(String? value) => values['email'] = value;

  Photo? get photo {
    return (values['photo'] as Photo?);
  }

  set photo (Photo? value) => values['photo'] = value;

  int? get photoId {
    return (values['photo_id'] as int?);
  }
  set photoId (int? value) => values['photo_id'] = value;

  AuthUser? get authUser {
    return (values['auth_user'] as AuthUser?);
  }

  set authuser (AuthUser? value) => values['auth_user'] = value;

  int? get authUserId {
    return (values['auth_user_id'] as int?);
  }
  set authUserId (int? value) => values['auth_user_id'] = value;


  Photo? get user {
    return (values['user'] as Photo?);
  }

  set user (Photo? value) => values['user'] = value;

  int? get userId {
    return (values['user_id'] as int?);
  }
  set userId (int? value) => values['user_id'] = value;

  Photo? get administrator {
    return (values['administrator'] as Photo?);
  }

  set administrator (Photo? value) => values['administrator'] = value;

  int? get administratorId {
    return (values['administrator_id'] as int?);
  }
  set administratorId (int? value) => values['administrator_id'] = value;


  Photo? get employee {
    return (values['employee'] as Photo?);
  }

  set employee (Photo? value) => values['employee'] = value;

  int? get employeeId {
    return (values['employee_id'] as int?);
  }
  set employeeId (int? value) => values['employee_id'] = value;



  void copyFrom(Person model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    credits = model.credits!;
    email = model.email;

    if (model.photoId != null) {
      values['photo_id'] = model.photoId;
    }
    if (model.authUserId != null) {
      values['auth_user_id'] = model.authUserId;
    }
    if (model.userId != null) {
      values['user_id'] = model.userId;
    }
    if (model.administratorId != null) {
      values['administrator_id'] = model.administratorId;
    }
    if (model.employeeId != null) {
      values['employee_id'] = model.employeeId;
    }

  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Person extends PersonEntity {
  Person({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.firstname,
    this.lastname,
    this.age,
    this.gender,
    this.credits,
    this.email,
    this.address,
    this.addressId,
    this.photo,
    this.photoId,
    this.administrator,
    this.administratorId,
    this.authUser,
    this.authUserId,
    this.user,
    this.userId,
    this.employee,
    this.employeeId
  }) ;
 static final empty= Person(credits: 0.0) ;


  /// A unique identifier corresponding to this item.
  @override
  String? id;

  /// The time at which this item was created.
  @override
  DateTime? createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  String? firstname;

  @override
  String? lastname;

  @override
  int? age;

  @override
  String? gender;

  @override
  double? credits;

  @override
  String? email;

  @override
  AddressEntity? address;

  int? addressId;

  @override
  PhotoEntity? photo;

  int? photoId;

  @override
  AuthUserEntity? authUser;
  int? authUserId;

  @override
  UserEntity? user;
  int? userId;

  @override
  AdministratorEntity? administrator;
  int? administratorId;

  @override
  EmployeeEntity? employee;
  int? employeeId;


  Person copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstname,
    String? lastname,
    int? age,
    String? gender,
    double? credits,
    String? email,
    AddressEntity? address,
    int? addressId,
    PhotoEntity? photo,
    AuthUserEntity? authUser,
    int? authUserId,
    UserEntity? user,
    int? userId,
    AdministratorEntity? administrator,
    int? administratorId,
    EmployeeEntity? employee,
    int? employeeId
  }) {
    return Person(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      credits: credits ?? this.credits,
      email: email ?? this.email,
      address: address ?? this.address,
      addressId:addressId ?? this.addressId,
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
      authUser: authUser ?? this.authUser,
      authUserId: authUserId ?? this.authUserId,
      user: user ?? this.user,
      userId: userId ?? this.userId,
      administrator: administrator ?? this.administrator,
      administratorId: administratorId ?? this.administratorId,
      employee: employee ?? this.employee,
      employeeId: employeeId ?? this.employeeId,
    );
  }

  @override
  bool operator ==(other) {
    return other is PersonEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.age == age &&
        other.gender == gender &&
        other.credits == credits &&
        other.email == email &&
        other.address == address &&
        other.addressId == addressId &&
        other.photo == photo &&
        other.photoId == photoId &&
        other.authUser == authUser &&
        other.authUserId == authUserId &&
        other.user == user &&
        other.userId == userId &&
        other.administrator == administrator &&
        other.administratorId == administratorId &&
        other.employee == employee &&
        other.employeeId == employeeId;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      firstname,
      lastname,
      age,
      gender,
      credits,
      email,
      address,
      photo,
      authUser,
      user,
      administrator,
      employee,
    ]);
  }

  @override
  String toString() {
    return 'Person(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email,address=$address, photo=$photo,photoId=$photoId, authUser=$authUser,authUserId=$authUserId, user=$user,userId=$userId, administrator=$administrator,administratorId=$administratorId, employee=$employee, employeeId=$employeeId)';
  }

  Map<String, dynamic>? toJson() {
    return PersonSerializer?.toMap(this);
  }


}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const PersonSerializer personSerializer = PersonSerializer();

class PersonEncoder extends Converter<Person, Map> {
  const PersonEncoder();

  @override
  Map convert(Person model) => PersonSerializer.toMap(model)!;
}

class PersonDecoder extends Converter<Map, Person> {
  const PersonDecoder();

  @override
  Person convert(Map map) => PersonSerializer.fromMap(map);
}

class PersonSerializer extends Codec<Person, Map> {
  const PersonSerializer();

  @override
  PersonEncoder get encoder => const PersonEncoder();

  @override
  PersonDecoder get decoder => const PersonDecoder();

  static Person fromMap(Map map) {
    return Person(
      id: map['id'] as String?,
      createdAt:
          map['created_at'] != null
              ? (map['created_at'] is DateTime
                  ? (map['created_at'] as DateTime)
                  : DateTime.parse(map['created_at'].toString()))
              : null,
      updatedAt:
          map['updated_at'] != null
              ? (map['updated_at'] is DateTime
                  ? (map['updated_at'] as DateTime)
                  : DateTime.parse(map['updated_at'].toString()))
              : null,
      firstname: map['firstname'] as String?,
      lastname: map['lastname'] as String?,
      age: map['age'] != null ? map['age'] is String ? int.parse(map['age']) as int?:map['age'] as int?:null,

      gender: map['gender'] as String?,
      credits: map['credits']!=null ?
                 map['credits'] is String
                     ? double.parse(map['credits']) as double
                     :map['credits']
               : null,
      email: map['email'] as String?,
      addressId: map['address_id'] != null
                   ? map['address_id'] is String
                       ? int.parse(map['address_id'])
                       :map['address_id']
                 :null ,
      address: map['address']!=null
                ? AddressSerializer.fromMap(map['address'] as Map)
                :null,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
              : null,
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map)
              : null,
      administrator:
          map['administrator'] != null
              ? AdministratorSerializer.fromMap(map['administrator'] as Map)
              : null,
      employee:
          map['employee'] != null
              ? EmployeeSerializer.fromMap(map['employee'] as Map)
              : null,
    );
  }

  static Map<String, dynamic>? toMap(PersonEntity? model) {
    if (model == null) {
      return null;
      //throw FormatException("PersonEntity L464,Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'createdAt': model.createdAt?.toIso8601String(),
      'updatedAt': model.updatedAt?.toIso8601String(),
      'firstname': model.firstname,
      'lastname': model.lastname,
      'age': model.age,
      'gender': model.gender,
      'credits': model.credits,
      'email': model.email,
      'photo': PhotoSerializer.toMap(model.photo),
      'photoId':model.photoId,
      'auth_user': AuthUserSerializer.toMap(model.authUser),
      'authUserId':model.authUserId,
      'user': UserSerializer.toMap(model.user),
      'userId': model.userId,
      'administrator': AdministratorSerializer.toMap(model.administrator),
      'administratorId':model.administratorId,
      'employee': EmployeeSerializer.toMap(model.employee),
      'employeeId':model.employeeId,
    };
  }
}

abstract class PersonFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    firstname,
    lastname,
    age,
    gender,
    credits,
    email,
    photo,
    photoId,
    authUser,
    authUserId,
    user,
    userId,
    administrator,
    administratorId,
    employee,
    employeeId
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String firstname = 'firstname';

  static const String lastname = 'lastname';

  static const String age = 'age';

  static const String gender = 'gender';

  static const String credits = 'credits';

  static const String email = 'email';

  static const String photo = 'photo';

  static const String photoId = 'photo_id';

  static const String authUser = 'auth_user';

  static const String authUserId = 'auth_user_id';

  static const String user = 'user';

  static const String userId = 'user_id';

  static const String administrator = 'administrator';

  static const String administratorId = 'administrator_id';

  static const String employee = 'employee';

  static const String employeeId = 'employee_id';
}
