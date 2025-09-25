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
        'preferences',
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
    print('User L151 parseRow : length: ${row.length}');
    print("User L150, debug parseRow $row");
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
      //addressId:fields.contains('address_id') && row[10]!=null? row[10] is String ? int.parse(row[10]):row[10] as int: null,
     // photoId:fields.contains('photo_id') && row[9]!=null? row[9] is String ? int.parse(row[9]):row[9] as int: null,

      //personId:fields.contains('person_id')  && row[10]!=null? row[10] is String ? int.parse(row[10]):row[10] as int: null,
      //driverId:fields.contains('driver_id') && row[11]!=null? row[11] is String ? int.parse(row[11]):row[11] as int: null,
      //commandIdList: fields.contains('command_id_list')  && row[12]!=null? List<int>.of(jsonDecode(row[12]) as List<int>): null,
      //userId:fields.contains('user_id') && row[13]!=null? row[13] is String ? int.parse(row[13]):row[13] as int: null,
    );
    if (row.length > 14) {
      var modelOpt = PersonQuery().parseRow(row.skip(14).take(15).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });

    }
    if (row.length > 29) {
      var modelOpt = DriverQuery().parseRow(row.skip(29).take(9).toList());
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
      if(model.person!.id != null)   values['person_id'] = int.parse( model.person!.id! );

    }

    if (model.driver != null) {
      values['driver_id'] = int.parse(model.driver!.id!);

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
    this.authUserId,
    this.person,
    this.personId,
    this.driver,
    this.driverId,
    List<CommandEntity>? commandList = const [],
    this. commandIdList,
    this.userId
  //  this.authUserEntity,
  }) : commandList = List.unmodifiable(commandList ?? []);

 //static final empty= User(credits: 0.0, person: Person.empty, driver: Driver.dummy);
  static final empty = User(credits: 0.0);
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

  @override
  int? addressId;

  @override
  PhotoEntity? photo;

  int? photoId;

  @override
  AuthUserEntity? authUser;

  @override
  int? authUserId;

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

  @override
  int? userId;

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
    PhotoEntity? photo,
    int? photoId,
    PersonEntity? person,
    int? personId,
    DriverEntity? driver,
    int? driverId,
    List<CommandEntity>? commandList,
    List<int>? commandIdList,
    int? userId

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
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
      person: person ?? this.person,
      personId: personId ?? this.personId,
      driver: driver ?? this.driver,
      driverId: driverId ?? this.driverId,
      commandList: commandList ?? this.commandList,
      commandIdList: commandIdList ?? this.commandIdList,
      userId: userId ?? this.userId,
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
        other.photoId == photoId &&
        other.personId == personId &&
        other.driverId == driverId &&
        ListEquality<CommandEntity>(
          DefaultEquality<CommandEntity>(),
        ).equals(other.commandList, commandList)&&
        ListEquality<int?>(
          DefaultEquality<int?>(),
        ).equals(other.commandIdList, commandIdList)&&
         other.userId== userId
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
      photoId,
      userId,
      personId,
      driverId,
      commandIdList,

    //  authUserEntity,
    ]);
  }

  @override
  String toString() {
    return 'User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email,person=$person,personId=$personId, driverId=$driverId)';
  }

  static User fromJson(Map userData){
    return UserSerializer.fromMap(userData);
  }
  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this)!;
  }

/*
  void setField(String key, dynamic value) {
    key=StringLib.snakeToCamel(key);
    var index= Entity_Index[this.runtimeType.toString()];
    var toMap=index!['toMap'] as Function;
    final map = toMap(this);
    var fields= index!['fields']; //is immutable come from class EntityFields
    var  fields2=fields.map((value)=>StringLib.snakeToCamel(value));

    if (!fields2.contains(key)) {
      throw ArgumentError('Unknown field: $key');  }

    map![key] = value;
    var ret= index!['fromMap']!(map!);

    print('UserEntity L648 ${ret}');
    print('AuthUserEntity L649 ${this.toString()}');

    UserSerializer.fromMap(map);
    print('AuthUserEntity L652 ${this.toString()}');

    print("");

  }
*/

  void setFields(Map<String, dynamic> updates) {
    var index= Entity_Index[this.runtimeType.toString()];
    var toMap=index!['toMap'] as Function;
    final map = toMap(this);

    for (final entry in updates.entries) {
      if (!index!['fields'].contains(entry.key)) {
        throw ArgumentError('Unknown field: ${entry.key}');
      }
      map![entry.key] = entry.value;
    }

    index!['fromMap']!(map!);
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


Map<String, Map<String,dynamic>> get accessors => {
'id': {"get":id,"set":(val) => id = val},
'cascadeTempKey': {"get":cascadeTempKey,"set":(val) => cascadeTempKey = val}, 
'createdAt': {"get":createdAt,"set":(val) => createdAt = val}, 
'updatedAt': {"get":updatedAt,"set":(val) => updatedAt = val}, 
'firstname': {"get":firstname,"set":(val) => firstname = val}, 
'lastname': {"get":lastname,"set":(val) => lastname = val}, 
'age': {"get":age,"set":(val) => age = val}, 
'gender': {"get":gender,"set":(val) => gender = val}, 
'credits': {"get":credits,"set":(val) => credits = val}, 
'email': {"get":email,"set":(val) => email = val}, 
'address': {"get":address,"set":(val) => address = val}, 
'addressId': {"get":addressId,"set":(val) => addressId = val}, 
'photo': {"get":photo,"set":(val) => photo = val}, 
'photoId': {"get":photoId,"set":(val) => photoId = val}, 
'authUser': {"get":authUser,"set":(val) => authUser = val}, 
'authUserId': {"get":authUserId,"set":(val) => authUserId = val}, 
'person': {"get":person,"set":(val) => person = val}, 
'personId': {"get":personId,"set":(val) => personId = val}, 
'driver': {"get":driver,"set":(val) => driver = val}, 
'driverId': {"get":driverId,"set":(val) => driverId = val}, 
'commandList': {"get":commandList,"set":(val) => commandList = val}, 
'commandIdList': {"get":commandIdList,"set":(val) => commandIdList = val}, 
'userId': {"get":userId,"set":(val) => userId = val}, 
 };

void setField(String key, dynamic value) {
  key=StringLib.snakeToCamel(key);
     accessors[key]!['set'](value);  

     // Optional: update a backing field if your entity has typed fields
     if (this is dynamic) {
       try {
         (this as dynamic).noSuchMethod(Invocation.setter(Symbol(key + '='), [value]));
       } catch (_) {}
     }
   }
    

dynamic getField(String key){
  try{
    key=StringLib.snakeToCamel(key);
    return accessors[key]!['get'];
  }catch(e,s){print("Error to fetch field $key , error:$e, \n stack:$s");}
}

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
              map['credits'] is String ? double.parse(map['credits'])  :map['credits'] as double
            : 0.0,
      email: map['email'] as String?,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
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
      'createdAt': model.createdAt?.toIso8601String(),
      'updatedAt': model.updatedAt?.toIso8601String(),
      'firstname': model.firstname,
      'lastname': model.lastname,
      'age': model.age,
      'gender': model.gender,
      'credits': model.credits,
      'email': model.email,
      'photo': PhotoSerializer.toMap(model.photo),

      'person': PersonSerializer.toMap(model.person),
      'personId': model.personId ,
      'driver': DriverSerializer.toMap(model.driver),
      'driverId': model.driverId ,
      'commandList':
          model.commandList?.map((m) => CommandSerializer.toMap(m)).toList(),
      'commandIdList': model.commandIdList,
      //'auth_user_entity': AuthUserSerializer.toMap(model.authUserEntity),
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
