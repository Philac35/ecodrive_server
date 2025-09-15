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
    if (trampoline.contains(tableName)) return; // Modification E.H 6/08/2025 17h56 Prevent recursion!
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
        'address_id',
        'photo_id',
        'auth_user_id',
        'user_id',
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
      personId:fields.contains('person_id')
           ? row[9] is String
             ? int.parse(row[9]):row[9]
            :null
    );
    if (row.length > 10) {  // We could have a solution based on EntityQuery().fields.length. here administrator
      var modelOpt = PersonQuery().parseRow(row.skip(10).take(15).toList());
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

  int get addressId {
    return (values['address_id'] as int);
  }

  set addressId(int? value) => values['address_id'] = value;

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
    if (model.personId != null) {
      values['person_id'] = model.personId;
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
    this.photoId,
    this.address,
    this.addressId,
    this.authUser,
    this.authUserId,
    this.user,
    this.userId,
    this.administrator,
    this.administratorId,
    this.employee,
    this.employeeId,
    this.person,
    this.personId,
    this.authUserEntity,
    this.authUserEntityId,
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

  @override
  int? addressId;

  @override
  PhotoEntity? photo;

  @override
  int? photoId;

  @override
  AuthUserEntity? authUser;

  @override
  int? authUserId;

  @override
  UserEntity? user;

  @override
  int? userId;

  @override
  AdministratorEntity? administrator;

  @override
  int? administratorId;

  @override
  EmployeeEntity? employee;
  int? employeeId;

  @override
  PersonEntity? person;

  @override
  int? personId;

  @override
  AuthUserEntity? authUserEntity;

  @override
  int? authUserEntityId;

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
    AddressEntity? address,
    int? addressId,
    PhotoEntity? photo,
    int? photoId,
    AuthUserEntity? authUser,
    int? authUserId,
    UserEntity? user,
    int? userId,
    AdministratorEntity? administrator,
    int? administratorId,
    EmployeeEntity? employee,
    int? employeeId,
    PersonEntity? person,
    int? personId,
    AuthUserEntity? authUserEntity,
    int? authUserEntityId,
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
      address: address?? this.address,
      addressId: addressId?? this.addressId,
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
      person: person ?? this.person,
      personId: personId ?? this.personId,
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
        other.employeeId == employeeId &&
        other.person == person &&
        other.personId == personId &&
        other.authUserEntity == authUserEntity &&
        other.authUserEntityId == authUserEntityId;
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
      addressId,
      photoId,
      authUser,
      authUserId,
      userId,
      administratorId,
      employeeId,
      personId,
      authUserEntityId,
    ]);
  }

  @override
  String toString() {
    return 'Administrator(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email, address=$address,addressId=$addressId,photoId=$photoId, authUserId=$authUserId, userId=$userId, administratorId=$administratorId, employeeId=$employeeId, personId=$personId, authUserEntityId=$authUserEntityId)';
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
'user': {"get":user,"set":(val) => user = val}, 
'userId': {"get":userId,"set":(val) => userId = val}, 
'administrator': {"get":administrator,"set":(val) => administrator = val}, 
'administratorId': {"get":administratorId,"set":(val) => administratorId = val}, 
'employee': {"get":employee,"set":(val) => employee = val}, 
'employeeId': {"get":employeeId,"set":(val) => employeeId = val}, 
'person': {"get":person,"set":(val) => person = val}, 
'personId': {"get":personId,"set":(val) => personId = val}, 
'authUserEntity': {"get":authUserEntity,"set":(val) => authUserEntity = val}, 
'authUserEntityId': {"get":authUserEntityId,"set":(val) => authUserEntityId = val}, 
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
    map=StringLib().camelToSnakeKeyFromMap(map);

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
      age: map['age'] !=null?
                map['age'] is String
                    ?int.parse(map['age'])
                    : map['age'] as int?
             :null,
      gender: map['gender'] as String?,
      credits: map['credits'] != null ?
                double.parse(map['credits'].toString())
              :0.0,
      email: map['email'] as String?,
      address:
           map['address'] != null
              ? AddressSerializer.fromMap(map['address'] as Map)
              : null,
      addressId: map['address_id'] != null
              ?  map['address_id'] as int?
              :null,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      photoId: map['photo_id'] != null
          ?  map['photo_id'] as int?
          :null,
      authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
              : null,
      authUserId: map['authUser_id'] != null
          ?  map['authUser_id'] as int?
          :null,
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map)
              : null,
      userId: map['user_id'] != null
          ?  map['user_id'] as int?
          :null,
      administrator:
          map['administrator'] != null
              ? AdministratorSerializer.fromMap(map['administrator'] as Map)
              : null,
      administratorId: map['administrator_id'] != null
          ?  map['administrator_id'] as int?
          :null,
      employee:
          map['employee'] != null
              ? EmployeeSerializer.fromMap(map['employee'] as Map)
              : null,
      employeeId: map['employee_id'] != null
          ?  map['employee_id'] as int?
          :null,
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] as Map) as PersonEntity
              : null,
      personId: map['person_id'] != null
          ?   map['person_id'] is String
               ? int.parse( map['person_id']):
               map['person_id'] as int?
          :null,

      authUserEntity:
          map['auth_user_entity'] != null
              ? AuthUserSerializer.fromMap(map['auth_user_entity'] as Map)
              : null,
      authUserEntityId: map['authUserEntity_id'] != null
          ?  map['authUserEntity_id'] as int?
          :null,
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
      'address':model.address,
      'addressId':model.addressId,
      'photo': PhotoSerializer.toMap(model.photo),
      'photoId': model.photoId,
      'authUser': AuthUserSerializer.toMap(model.authUser),
      'authUserId': model.authUserId,
      'user': UserSerializer.toMap(model.user),
      'userId':model.userId,
      'administrator': AdministratorSerializer.toMap(model.administrator),
      'administratorId':model.administratorId,
      'employee': EmployeeSerializer.toMap(model.employee),
      'employeeId':model.employeeId,
      'person': PersonSerializer.toMap(model.person),
      'personId': model.personId,
      'authUserEntity': AuthUserSerializer.toMap(model.authUserEntity),
      'authUserEntityId':model.authUserEntityId

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
    address,
    addressId,
    photo,
    photoId,
    authUser,
    authUserId,
    user,
    userId,
    administrator,
    administratorId,
    employee,
    employeeId,
    person,
    personId,
    authUserEntity,
    authUserEntityId

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

  static const String address = 'address';

  static const String addressId = 'address_id';

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

  static const String person = 'person';

  static const String personId = 'person_id';

  static const String authUserEntity = 'auth_user_entity';

  static const String authUserEntityId = 'auth_user_entity_id';

}
