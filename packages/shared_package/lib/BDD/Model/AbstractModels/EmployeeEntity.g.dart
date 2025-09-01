// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmployeeEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class EmployeeMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('employees', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('firstname', length: 64);
      table.varChar('lastname', length: 64);
      table.integer('age');
      table.varChar('gender', length: 8);
      table.double('credits');
      table.varChar('email', length: 128);
      table.declare('person_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('employees', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class EmployeeQuery extends Query<Employee, EmployeeQueryWhere> {
  EmployeeQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    if (trampoline.contains(tableName)) return; // Modification E.H 6/08/2025 17h56 Prevent recursion!
    trampoline.add(tableName);
    _where = EmployeeQueryWhere(this);
    leftJoin(
      _person = PersonQuery(trampoline: trampoline, parent: this),
      'person_id',
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
        'address_id',
        'photo_id',
        'auth_user_id',
        'user_id',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final EmployeeQueryValues values = EmployeeQueryValues();

  List<String> _selectedFields = [];

  EmployeeQueryWhere? _where;

  late PersonQuery _person;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'employees';
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
      'person_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  EmployeeQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  EmployeeQueryWhere? get where {
    return _where;
  }

  @override
  EmployeeQueryWhere newWhereClause() {
    return EmployeeQueryWhere(this);
  }

  Optional<Employee> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Employee(
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
      personId: fields.contains('email') ? int.parse(row[9] ) : null,
    );
    if (row.length > 10) {
      var modelOpt = PersonQuery().parseRow(row.skip(10).take(15).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Employee> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }
}

class EmployeeQueryWhere extends QueryWhere {
  EmployeeQueryWhere(EmployeeQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      firstname = StringSqlExpressionBuilder(query, 'firstname'),
      lastname = StringSqlExpressionBuilder(query, 'lastname'),
      age = NumericSqlExpressionBuilder<int>(query, 'age'),
      gender = StringSqlExpressionBuilder(query, 'gender'),
      credits = NumericSqlExpressionBuilder<double>(query, 'credits'),
      email = StringSqlExpressionBuilder(query, 'email'),
      personId = NumericSqlExpressionBuilder<int>(query, 'person_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder firstname;

  final StringSqlExpressionBuilder lastname;

  final NumericSqlExpressionBuilder<int> age;

  final StringSqlExpressionBuilder gender;

  final NumericSqlExpressionBuilder<double> credits;

  final StringSqlExpressionBuilder email;

  final NumericSqlExpressionBuilder<int> personId;

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
      personId,
    ];
  }
}

class EmployeeQueryValues extends MapQueryValues {
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

  int get personId {
    return (values['person_id'] as int);
  }

  set personId(int value) => values['person_id'] = value;

  void copyFrom(Employee model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    credits = model.credits;
    email = model.email;
    if (model.personId != null) {
      values['person_id'] = model.personId;
    }
    if (model.person != null) {
      values['person'] =model.person;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Employee extends EmployeeEntity {
  Employee({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.firstname,
    this.lastname,
    this.age,
    this.gender,
    required this.credits,
    this.email,
    this.address,
    this.addressId,
    this.photo,
    this.photoId,
    //this.authUser,
    this.user,
    this.userId,
    //this.administrator,
    //this.employee,
     this.person,
    this.personId
  }) ;

  /// A unique identifier corresponding to this item.
  @override
  String? id;

  String? cascadeTempKey;

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
  double credits;

  @override
  String? email;

  @override
  AddressEntity? address;

  int? addressId;


  @override
  PhotoEntity? photo;


  @override
  int? photoId;

  @override
  AuthUserEntity? get authUser=> throw(UnimplementedError);

  @override
  UserEntity? user;
  int? userId;


  @override
  AdministratorEntity? get administrator=> throw(UnimplementedError);

  @override
  EmployeeEntity? get employee=> throw(UnimplementedError);


  @override
  PersonEntity? person;

  @override
  int? personId;

  Employee copyWith({
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
    int? photoId,
    AuthUserEntity? authUser,
    int? AuthUserEntityId,
    UserEntity? user,
    int? userId,
    EmployeeEntity? employee,
    PersonEntity? person,
    int? personId
  }) {
    return Employee(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      credits: credits ?? this.credits,
      email: email ?? this.email,
      address: address?? this.address,
      addressId: addressId?? this.addressId,
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
     // authUser: authUser ?? this.authUser,
       user: user ?? this.user,
       userId: userId ?? this.userId,
    //  administrator: administrator ?? this.administrator,
     // employee: employee ?? this.employee,
      person: person ?? this.person,
      personId: personId ?? this.personId,
    );
  }

  @override
  bool operator ==(other) {
    return other is EmployeeEntity &&
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
       // other.authUser == authUser &&
        other.user == user &&
        other.userId == userId &&
        //other.administrator == administrator &&
        //other.employee == employee &&
        other.person == person &&
        other.personId == personId;
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
      photo,
      photoId,
      //authUser,
      user,
      userId,
      //administrator,
      //employee,
      person,
      personId,
    ]);
  }

  @override
  String toString() {
    return 'Employee(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email, photo=$photo, authUser=$authUser,authUserId=$authUserId,user=$user, userId=$userId,person=$person,personId=$personId)';    //administrator=$administrator, //employee=$employee,
  }

  Map<String, dynamic> toJson() {
    return EmployeeSerializer.toMap(this)!;
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const EmployeeSerializer employeeSerializer = EmployeeSerializer();

class EmployeeEncoder extends Converter<Employee, Map> {
  const EmployeeEncoder();

  @override
  Map convert(Employee model) => EmployeeSerializer.toMap(model)!;
}

class EmployeeDecoder extends Converter<Map, Employee> {
  const EmployeeDecoder();

  @override
  Employee convert(Map map) => EmployeeSerializer.fromMap(map);
}

class EmployeeSerializer extends Codec<Employee, Map> {
  const EmployeeSerializer();

  @override
  EmployeeEncoder get encoder => const EmployeeEncoder();

  @override
  EmployeeDecoder get decoder => const EmployeeDecoder();

  static Employee fromMap(Map map) {
    map=StringLib().camelToSnakeKeyFromMap(map);

    return Employee(
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
      age: int.parse(map['age'])  as int?,
      gender: map['gender'] as String?,
      credits: map['credits']!=null ?  double.parse(map['credits'])  as double:0.0,
      email: map['email'] as String?,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      photoId: map['photo_id'] as int?,
     /* authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
              : null, */
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map)
              : null,
      userId:map['user_id'] as int?,
     /* employee:
          map['employee'] != null
              ? EmployeeSerializer.fromMap(map['employee'] as Map)
              : null,*/
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] as Map) as PersonEntity
              : null,
      personId: map['person_id'] as int?
    );
  }

  static Map<String, dynamic>? toMap(EmployeeEntity? model) {
    if (model == null) {
      return null; // Modified 7/07/2025
      throw FormatException("EmployeeEntity L521, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'firstname': model.firstname,
      'lastname': model.lastname,
      'age': model.age,
      'gender': model.gender,
      'credits': model.credits,
      'email': model.email,
      'photo': PhotoSerializer.toMap(model.photo),
      'photoId': model.photoId,
      'authUser': AuthUserSerializer.toMap(model.authUser),
      'authUserId':model.authUserId,
      'user': UserSerializer.toMap(model.user),
      'userId':model.userId,
     // 'administrator': AdministratorSerializer.toMap(model.administrator),
      //'employee': EmployeeSerializer.toMap(model.employee),

      'person': PersonSerializer.toMap(model.person),
      'personId': model.personId
    };
  }
}

abstract class EmployeeFields {
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
    //authUser,
    //authUserId,
    user,
    userId,
    //administrator,
    //employee,
    person,
    personId
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

  //static const String authUser = 'auth_user';

  static const String user = 'user';

  static const String userId = 'user_id';

  //static const String administrator = 'administrator';

  //static const String employee = 'employee';

  static const String person = 'person';

  static const String personId = 'person_id';
}
