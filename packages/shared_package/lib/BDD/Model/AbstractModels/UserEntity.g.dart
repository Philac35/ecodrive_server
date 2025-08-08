// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UserMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('users', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('firstname', length: 64);
      table.varChar('lastname', length: 64);
      table.integer('age');
      table.varChar('gender', length: 8);
      table.double('credits');
      table.varChar('email', length: 128);
      table.declare('photo_id', ColumnType('int')).references('photo', 'id');
      table.declare('person_id', ColumnType('int')).references('people', 'id');
      table.declare('driver_id', ColumnType('int')).references('drivers', 'id');
      table.declare('command_id_list', ColumnType('json')).references('commands', 'id'); //cf if fonctionnal
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('users', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UserQuery extends Query<User, UserQueryWhere> {
  UserQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    if (trampoline.contains(tableName)) return; // Modification E.H 6/08/2025 17h56 Prevent recursion!
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
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
    leftJoin(
      _driver = DriverQuery(trampoline: trampoline, parent: this),
      'driver_id',
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
  final UserQueryValues values = UserQueryValues();

  List<String> _selectedFields = [];

  UserQueryWhere? _where;

  late PersonQuery _person;
  late DriverQuery _driver;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'users';
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
      'photo_id',
      'person_id',
      'driver_id',
      'command_id_list',
      'user_id'            // /!\
    ];

    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  UserQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  UserQueryWhere? get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return UserQueryWhere(this);
  }

  Optional<User> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }

    var model = User(
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
      photoId:fields.contains('photo_id')  && row[9]!=null? row[9] is String ?  int.parse(row[9]):row[9] as int: null,
      personId:fields.contains('person_id')  && row[10]!=null? row[10] is String ? int.parse(row[10]):row[10] as int: null,
      driverId:fields.contains('driver_id')  && row[11]!=null? row[11] is String ? int.parse(row[11]):row[11] as int: null,
      commandIdList: fields.contains('command_id_list')  && row[12]!=null? List<int>.of(jsonDecode(row[12])): null,
    );
    if (row.length > 11) {
      var modelOpt = PersonQuery().parseRow(row.skip(11).take(15).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });

    }
    if (row.length > 27) {
      var modelOpt = DriverQuery().parseRow(row.skip(27).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(driver: m);
      });
    }

    return Optional.of(model);
  }

  @override
  Optional<User> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }

  @override
  Future<List<User>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
            );
        }
      });
    });
  }

  @override
  Future<List<User>> update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
            );
        }
      });
    });
  }

  @override
  Future<List<User>> delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<User>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              commandList: List<CommandEntity>.from(l.commandList as Iterable)
                ..addAll(model.commandList as Iterable<CommandEntity>),
            );
        }
      });
    });
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query, )
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
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id'),
      commandIdList=ListSqlExpressionBuilder(query,'command_id_list');
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

  final NumericSqlExpressionBuilder<int> driverId;

  final ListSqlExpressionBuilder commandIdList;

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
      driverId,
      commandIdList
    ];
  }
}

class UserQueryValues extends MapQueryValues {
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

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

  void copyFrom(User model) {
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
      values['person_id'] = int.parse(model.person!.id!);
      values['person'] = model.person ;
    }
    if (model.driver != null) {
      values['driver_id'] = int.parse(model.driver!.id!);
      values['driver']= model.driver ;
    }

    if (model.driverId != null) {
      values['driver_id'] = model.driverId;
    }
    if (model.commandIdList != null) {
      values['command_id_list'] = model.commandIdList;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class User extends UserEntity {
  User({
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
    this.authUser,
    this.person,
    this.personId,
    this.driver,
    this.driverId,
    List<CommandEntity>? commandList = const [],
    this. commandIdList
  //  this.authUserEntity,
  }) : commandList = List.unmodifiable(commandList ?? []);

 //static final empty= User(credits: 0.0, person: Person.empty, driver: Driver.dummy);
  static final empty = User(credits: 0.0);
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
  AddressEntity? address;

  @override
  int? addressId;

  @override
  PhotoEntity? photo;

  int? photoId;

  @override
  AuthUserEntity? authUser;

  @override
  PersonEntity? person;

  @override
  int? personId;

  @override
  DriverEntity? driver;

  @override
  int? driverId;

  @override
  List<CommandEntity>? commandList;

  @override
  List<int>? commandIdList;

  /*@override
  AuthUserEntity? authUserEntity;
 */
  User copyWith({
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
    PersonEntity? person,
    int? personId,
    DriverEntity? driver,
    int? driverId,
    List<CommandEntity>? commandList,
    List<int>? commandIdList,
   // AuthUserEntity? authUserEntity,
  }) {
    return User(
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
      addressId: addressId ?? this.addressId,
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
      authUser: authUser ?? this.authUser,
      person: person ?? this.person,
      personId: personId ?? this.personId,
      driver: driver ?? this.driver,
      driverId: driverId ?? this.driverId,
      commandList: commandList ?? this.commandList,
      commandIdList: commandIdList ?? this.commandIdList,
   //   authUserEntity: authUserEntity ?? this.authUserEntity,
    );
  }

  @override
  bool operator ==(other) {
    return other is UserEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.age == age &&
        other.gender == gender &&
        other.credits == credits &&
        other.email == email &&
        other.address== address &&
        other.addressId == addressId &&
        other.photo == photo &&
        other.authUser == authUser &&
        other.person == person &&
        other.driver == driver &&
        ListEquality<CommandEntity>(
          DefaultEquality<CommandEntity>(),
        ).equals(other.commandList, commandList)&&
        ListEquality<int?>(
          DefaultEquality<int?>(),
        ).equals(other.commandIdList, commandIdList)

    ;
    //    other.authUserEntity == authUserEntity;
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
      person,
      driver,
      commandList,
    //  authUserEntity,
    ]);
  }

  @override
  String toString() {
    return 'User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email, address=$address, addressId=$addressId ,authUser=$authUser, personId=$personId, driverId=$driverId)';
  }

  static User fromJson(Map userData){
    return UserSerializer.fromMap(userData);
  }
  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this)!;
  }

  //Has person User entity inherit of these field
  //but there are not implemented
  @override
  //  Unimplemented administrator
  AdministratorEntity? get administrator => null; //throw UnimplementedError();

  @override
  // TODO: Unimplemented employee
  EmployeeEntity? get employee => null;// throw UnimplementedError();

  @override
  UserEntity? get user =>this;

}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const UserSerializer userSerializer = UserSerializer();

class UserEncoder extends Converter<User, Map> {
  const UserEncoder();

  @override
  Map convert(User model) => UserSerializer.toMap(model)!;
}

class UserDecoder extends Converter<Map, User> {
  const UserDecoder();

  @override
  User convert(Map map) => UserSerializer.fromMap(map);
}

class UserSerializer extends Codec<User, Map> {
  const UserSerializer();

  @override
  UserEncoder get encoder => const UserEncoder();

  @override
  UserDecoder get decoder => const UserDecoder();

  static User fromMap(Map map) {
    map=StringLib().camelToSnakeKeyFromMap(map);

    return User(
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

      credits: map['credits']!=null ?
              map['credits'] is String ? double.parse(map['credits']) as double :map['credits']
            : 0.0,
      email: map['email'] as String?,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
              : null,
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] )
              : null ,
      personId:
          map['person_id'] != null
             ? map['person_id'] is String ? int.tryParse(map['person_id']):map['person_id']
             : null ,
      driver:
          map['driver'] != null
              ? DriverSerializer.fromMap(map['driver'] as Map) as DriverEntity
              : null,
      driverId:
      map['driver_id'] != null
          ? map['driver_id'] is String ? int.tryParse(map['driver_id']):map['driver_id']
          : null ,
      commandList:
          map['command_list'] is Iterable
              ? List.unmodifiable(
                ((map['command_list'] as Iterable).whereType<Map>()).map(
                  CommandSerializer.fromMap,
                ),
              )
              : [],
    /*  authUserEntity:
          map['auth_user_entity'] != null
              ? AuthUserSerializer.fromMap(map['auth_user_entity'] as Map)
              : null,*/
    );
  }

  static Map<String, dynamic>? toMap(UserEntity? model) {
    if (model == null) {
      return null; // Modified 7/07/2025
      throw FormatException("UserEntity L636, Required field [model] cannot be null");
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
      'person': PersonSerializer.toMap(model.person),
      'person_id': model.personId ,
      'driver': DriverSerializer.toMap(model.driver),
      'driver_id': model.driverId ,
      'command_list':
          model.commandList?.map((m) => CommandSerializer.toMap(m)).toList(),
      'command_id_list': model.commandIdList,
    //  'auth_user_entity': AuthUserSerializer.toMap(model.authUserEntity),
    };
  }
}

abstract class UserFields {
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
    userId,
    person,
    personId,
    driver,
    driverId,
    commandList,
    commandIdList,
    //authUserEntity,
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

  static const String userId = 'user_id';

  static const String person = 'person';

  static const String personId = 'person_id';

  static const String driver = 'driver';

  static const String driverId = 'driver_id';

  static const String commandList = 'command_list';

  static const String commandIdList = 'command_id_list';
  //static const String authUserEntity = 'auth_user_entity';
}
