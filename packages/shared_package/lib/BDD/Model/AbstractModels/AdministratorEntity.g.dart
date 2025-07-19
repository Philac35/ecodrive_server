// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AdministratorEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class AdministratorMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('administrators', (table) {
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
    schema.drop('administrators', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class AdministratorQuery extends Query<Administrator, AdministratorQueryWhere> {
  AdministratorQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AdministratorQueryWhere(this);
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
      ],
      trampoline: trampoline,
    );
  }

  @override
  final AdministratorQueryValues values = AdministratorQueryValues();

  List<String> _selectedFields = [];

  AdministratorQueryWhere? _where;

  late PersonQuery _person;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'administrators';
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

  AdministratorQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  AdministratorQueryWhere? get where {
    return _where;
  }

  @override
  AdministratorQueryWhere newWhereClause() {
    return AdministratorQueryWhere(this);
  }

  Optional<Administrator> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Administrator(
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
      person: {} as PersonEntity,
    );
    if (row.length > 10) {
      var modelOpt = PersonQuery().parseRow(row.skip(10).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Administrator> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }
}

class AdministratorQueryWhere extends QueryWhere {
  AdministratorQueryWhere(AdministratorQuery query)
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

class AdministratorQueryValues extends MapQueryValues {
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

  void copyFrom(Administrator model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    credits = model.credits;
    email = model.email;
    if (model.person != null) {
      values['person_id'] = model.person?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Administrator extends AdministratorEntity {
  Administrator({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.firstname,
    this.lastname,
    this.age,
    this.gender,
    required this.credits,
    this.email,
    this.photo,
    this.authUser,
    this.user,
    this.administrator,
    this.employee,
    required this.person,
    this.authUserEntity,
  }) ;

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
  double credits;

  @override
  String? email;

  @override
  PhotoEntity? photo;

  @override
  AuthUserEntity? authUser;

  @override
  UserEntity? user;

  @override
  AdministratorEntity? administrator;

  @override
  EmployeeEntity? employee;

  @override
  PersonEntity? person;

  @override
  AuthUserEntity? authUserEntity;

  Administrator copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? firstname,
    String? lastname,
    int? age,
    String? gender,
    double? credits,
    String? email,
    PhotoEntity? photo,
    AuthUserEntity? authUser,
    UserEntity? user,
    AdministratorEntity? administrator,
    EmployeeEntity? employee,
    PersonEntity? person,
    AuthUserEntity? authUserEntity,
  }) {
    return Administrator(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      firstname: firstname ?? this.firstname,
      lastname: lastname ?? this.lastname,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      credits: credits ?? this.credits,
      email: email ?? this.email,
      photo: photo ?? this.photo,
      authUser: authUser ?? this.authUser,
      user: user ?? this.user,
      administrator: administrator ?? this.administrator,
      employee: employee ?? this.employee,
      person: person ?? this.person,
      authUserEntity: authUserEntity ?? this.authUserEntity,
    );
  }

  @override
  bool operator ==(other) {
    return other is AdministratorEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.age == age &&
        other.gender == gender &&
        other.credits == credits &&
        other.email == email &&
        other.photo == photo &&
        other.authUser == authUser &&
        other.user == user &&
        other.administrator == administrator &&
        other.employee == employee &&
        other.person == person &&
        other.authUserEntity == authUserEntity;
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
      authUser,
      user,
      administrator,
      employee,
      person,
      authUserEntity,
    ]);
  }

  @override
  String toString() {
    return 'Administrator(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email, photo=$photo, authUser=$authUser, user=$user, administrator=$administrator, employee=$employee, person=$person, authUserEntity=$authUserEntity)';
  }

  Map<String, dynamic> toJson() {
    return AdministratorSerializer.toMap(this)!;
  }

  @override
  bool delete(PersonEntity person) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  pay(double price) {
    // TODO: implement pay
    throw UnimplementedError();
  }

  @override
  bool suspend(PersonEntity person) {
    // TODO: implement suspend
    throw UnimplementedError();
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const AdministratorSerializer administratorSerializer =
    AdministratorSerializer();

class AdministratorEncoder extends Converter<Administrator, Map> {
  const AdministratorEncoder();

  @override
  Map convert(Administrator model) => AdministratorSerializer.toMap(model)!;
}

class AdministratorDecoder extends Converter<Map, Administrator> {
  const AdministratorDecoder();

  @override
  Administrator convert(Map map) => AdministratorSerializer.fromMap(map);
}

class AdministratorSerializer extends Codec<Administrator, Map> {
  const AdministratorSerializer();

  @override
  AdministratorEncoder get encoder => const AdministratorEncoder();

  @override
  AdministratorDecoder get decoder => const AdministratorDecoder();

  static Administrator fromMap(Map map) {
    return Administrator(
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
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      credits: map['credits'] is Null ? 0.0: map['credits'] as double,
      email: map['email'] as String?,
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
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] as Map) as PersonEntity
              : null,
      authUserEntity:
          map['auth_user_entity'] != null
              ? AuthUserSerializer.fromMap(map['auth_user_entity'] as Map)
              : null,
    );
  }

  static Map<String, dynamic>? toMap(AdministratorEntity? model) {
    if (model == null) {
      return null;
      throw FormatException("AdministratorEntity L552, Required field [model] cannot be null");
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
      'auth_user': AuthUserSerializer.toMap(model.authUser),
      'user': UserSerializer.toMap(model.user),
      'administrator': AdministratorSerializer.toMap(model.administrator),
      'employee': EmployeeSerializer.toMap(model.employee),
      'person': PersonSerializer.toMap(model.person),
      'auth_user_entity': AuthUserSerializer.toMap(model.authUserEntity),
    };
  }
}

abstract class AdministratorFields {
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
    authUser,
    user,
    administrator,
    employee,
    person,
    authUserEntity,
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

  static const String authUser = 'auth_user';

  static const String user = 'user';

  static const String administrator = 'administrator';

  static const String employee = 'employee';

  static const String person = 'person';

  static const String authUserEntity = 'auth_user_entity';
}
