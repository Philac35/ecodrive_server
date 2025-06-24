// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class DriverMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('drivers', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('firstname', length: 64);
      table.varChar('lastname', length: 64);
      table.integer('age');
      table.varChar('gender', length: 8);
      table.double('credits');
      table.varChar('email', length: 128);
      table.declareColumn(
        'preferences',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.declare('person_id', ColumnType('int')).references('people', 'id');
      table.declare('user_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('drivers', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class DriverQuery extends Query<Driver, DriverQueryWhere> {
  DriverQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = DriverQueryWhere(this);
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
    leftJoin(
      _notices = NoticeQuery(trampoline: trampoline, parent: this),
      'id',
      'driver_id',
      additionalFields: const [
        'id',
        'updated_at',
        'title',
        'description',
        'note',
        'created_at',
        'driver_id',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _user = PersonQuery(trampoline: trampoline, parent: this),
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
      ],
      trampoline: trampoline,
    );
  }

  @override
  final DriverQueryValues values = DriverQueryValues();

  List<String> _selectedFields = [];

  DriverQueryWhere? _where;

  late PersonQuery _person;

  late NoticeQuery _notices;

  late PersonQuery _user;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'drivers';
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
      'preferences',
      'user_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  DriverQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  DriverQueryWhere? get where {
    return _where;
  }

  @override
  DriverQueryWhere newWhereClause() {
    return DriverQueryWhere(this);
  }

  Optional<Driver> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Driver(
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
      preferences:
          fields.contains('preferences') ? (row[10] as List<String>?) : null,
      person: {} as PersonEntity,
      user: {} as UserEntity,

    );
    if (row.length > 12) {
      var modelOpt = PersonQuery().parseRow(row.skip(12).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    if (row.length > 21) {
      var modelOpt = NoticeQuery().parseRow(row.skip(21).take(7).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(notices: [m]);
      });
    }
    if (row.length > 28) {
      var modelOpt = PersonQuery().parseRow(row.skip(28).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(user: m as UserEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Driver> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }

  NoticeQuery get notices {
    return _notices;
  }

  PersonQuery get user {
    return _user;
  }

  @override
  Future<List<Driver>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Driver>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
              notices: List<NoticeEntity>.from(l.notices as Iterable)
                ..addAll(model.notices as Iterable<NoticeEntity>),
            );
        }
      });
    });
  }

  @override
  Future<List<Driver>> update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<Driver>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
              notices: List<NoticeEntity>.from(l.notices as Iterable)
                ..addAll(model.notices as Iterable<NoticeEntity>),
            );
        }
      });
    });
  }

  @override
  Future<List<Driver>> delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<Driver>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
              notices: List<NoticeEntity>.from(l.notices as Iterable)
                ..addAll(model.notices as Iterable<NoticeEntity>),
            );
        }
      });
    });
  }
}

class DriverQueryWhere extends QueryWhere {
  DriverQueryWhere(DriverQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      firstname = StringSqlExpressionBuilder(query, 'firstname'),
      lastname = StringSqlExpressionBuilder(query, 'lastname'),
      age = NumericSqlExpressionBuilder<int>(query, 'age'),
      gender = StringSqlExpressionBuilder(query, 'gender'),
      credits = NumericSqlExpressionBuilder<double>(query, 'credits'),
      email = StringSqlExpressionBuilder(query, 'email'),
      personId = NumericSqlExpressionBuilder<int>(query, 'person_id'),
      preferences = ListSqlExpressionBuilder(query, 'preferences'),
      userId = NumericSqlExpressionBuilder<int>(query, 'user_id');

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

  final ListSqlExpressionBuilder preferences;

  final NumericSqlExpressionBuilder<int> userId;

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
      preferences,
      userId,
    ];
  }
}

class DriverQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'preferences': 'jsonb'};
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

  List<String>? get preferences {
    return json.decode((values['preferences'] as String)).cast();
  }

  set preferences(List<String>? value) =>
      values['preferences'] = json.encode(value);

  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;

  void copyFrom(Driver model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    credits = model.credits;
    email = model.email;
    preferences = model.preferences;
    if (model.person != null) {
      values['person_id'] = model.person?.id;
    }
    if (model.user != null) {
      values['user_id'] = model.user?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Driver extends DriverEntity {
  Driver({
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
    this.administrator,
    this.employee,
    required this.person,

    List<CommandEntity>? commandList = const [],
    this.authUserEntity,
    List<NoticeEntity>? notices = const [],
    List<String>? preferences = const [],
    required this.user,
    this.drivingLicence,
    this.vehicule,
  }) : commandList = List.unmodifiable(commandList ?? []),
       notices = List.unmodifiable(notices ?? []),
       preferences = List.unmodifiable(preferences ?? []);

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
  AdministratorEntity? administrator;

  @override
  EmployeeEntity? employee;

  @override
  PersonEntity person;

  @override
  List<CommandEntity>? commandList;

  @override
  AuthUserEntity? authUserEntity;

  @override
  List<NoticeEntity>? notices;

  @override
  List<String>? preferences;

  @override
  UserEntity user;

  @override
  DrivingLicenceEntity? drivingLicence;

  @override
  VehiculeEntity? vehicule;

  Driver copyWith({
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
    AdministratorEntity? administrator,
    EmployeeEntity? employee,
    PersonEntity? person,
    DriverEntity? driver,
    List<CommandEntity>? commandList,
    AuthUserEntity? authUserEntity,
    List<NoticeEntity>? notices,
    List<String>? preferences,
    UserEntity? user,
    DrivingLicenceEntity? drivingLicence,
    VehiculeEntity? vehicule,
  }) {
    return Driver(
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
      administrator: administrator ?? this.administrator,
      employee: employee ?? this.employee,
      person: person ?? this.person,
      commandList: commandList ?? this.commandList,
      authUserEntity: authUserEntity ?? this.authUserEntity,
      notices: notices ?? this.notices,
      preferences: preferences ?? this.preferences,
      user: user ?? this.user,
      drivingLicence: drivingLicence ?? this.drivingLicence,
      vehicule: vehicule ?? this.vehicule,
    );
  }

  @override
  bool operator ==(other) {
    return other is DriverEntity &&
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
        other.administrator == administrator &&
        other.employee == employee &&
        other.person == person &&
             ListEquality<CommandEntity>(
          DefaultEquality<CommandEntity>(),
        ).equals(other.commandList, commandList) &&
        other.authUserEntity == authUserEntity &&
        ListEquality<NoticeEntity>(
          DefaultEquality<NoticeEntity>(),
        ).equals(other.notices, notices) &&
        ListEquality<String>(
          DefaultEquality<String>(),
        ).equals(other.preferences, preferences) &&
        other.user == user &&
        other.drivingLicence == drivingLicence &&
        other.vehicule == vehicule;
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
      administrator,
      employee,
      person,
      commandList,
      authUserEntity,
      notices,
      preferences,
      user,
      drivingLicence,
      vehicule,
    ]);
  }

  @override
  String toString() {
    return 'Driver(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email, photo=$photo, authUser=$authUser, administrator=$administrator, employee=$employee, person=$person,  commandList=$commandList, authUserEntity=$authUserEntity, notices=$notices, preferences=$preferences, user=$user, drivingLicence=$drivingLicence, vehicule=$vehicule)';
  }

  Map<String, dynamic> toJson() {
    return DriverSerializer.toMap(this);
  }

  @override
  // TODO: implement driver
  DriverEntity get driver => user.driver;



}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const DriverSerializer driverSerializer = DriverSerializer();

class DriverEncoder extends Converter<Driver, Map> {
  const DriverEncoder();

  @override
  Map convert(Driver model) => DriverSerializer.toMap(model);
}

class DriverDecoder extends Converter<Map, Driver> {
  const DriverDecoder();

  @override
  Driver convert(Map map) => DriverSerializer.fromMap(map);
}

class DriverSerializer extends Codec<Driver, Map> {
  const DriverSerializer();

  @override
  DriverEncoder get encoder => const DriverEncoder();

  @override
  DriverDecoder get decoder => const DriverDecoder();

  static Driver fromMap(Map map) {
    return Driver(
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
      credits: map['credits'] as double,
      email: map['email'] as String?,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
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
              : {} as PersonEntity,
      commandList:
          map['command_list'] is Iterable
              ? List.unmodifiable(
                ((map['command_list'] as Iterable).whereType<Map>()).map(
                  CommandSerializer.fromMap,
                ),
              )
              : [],
      authUserEntity:
          map['auth_user_entity'] != null
              ? AuthUserSerializer.fromMap(map['auth_user_entity'] as Map)
              : null,
      notices:
          map['notices'] is Iterable
              ? List.unmodifiable(
                ((map['notices'] as Iterable).whereType<Map>()).map(
                  NoticeSerializer.fromMap,
                ),
              )
              : [],
      preferences:
          map['preferences'] is Iterable
              ? (map['preferences'] as Iterable).cast<String>().toList()
              : [],
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map) as UserEntity
              : {}  as UserEntity,
      drivingLicence:
          map['driving_licence'] != null
              ? DrivingLicenceSerializer.fromMap(map['driving_licence'] as Map)
              : null,
      vehicule:
          map['vehicule'] != null
              ? VehiculeSerializer.fromMap(map['vehicule'] as Map)
              : null,
    );
  }

  static Map<String, dynamic> toMap(DriverEntity? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
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
      'administrator': AdministratorSerializer.toMap(model.administrator),
      'employee': EmployeeSerializer.toMap(model.employee),
      'person': PersonSerializer.toMap(model.person),
      'driver': DriverSerializer.toMap(model.driver),
      'command_list':
          model.commandList?.map((m) => CommandSerializer.toMap(m)).toList(),
      'auth_user_entity': AuthUserSerializer.toMap(model.authUserEntity),
      'notices': model.notices?.map((m) => NoticeSerializer.toMap(m)).toList(),
      'preferences': model.preferences,
      'user': UserSerializer.toMap(model.user),
      'driving_licence': DrivingLicenceSerializer.toMap(model.drivingLicence),
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
    };
  }
}

abstract class DriverFields {
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
    administrator,
    employee,
    person,
    driver,
    commandList,
    authUserEntity,
    notices,
    preferences,
    user,
    drivingLicence,
    vehicule,
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

  static const String administrator = 'administrator';

  static const String employee = 'employee';

  static const String person = 'person';

  static const String driver = 'driver';

  static const String commandList = 'command_list';

  static const String authUserEntity = 'auth_user_entity';

  static const String notices = 'notices';

  static const String preferences = 'preferences';

  static const String user = 'user';

  static const String drivingLicence = 'driving_licence';

  static const String vehicule = 'vehicule';
}
