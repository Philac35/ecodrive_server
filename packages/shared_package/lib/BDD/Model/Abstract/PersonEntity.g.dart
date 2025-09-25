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

    print(" parseRow L235 : $row");

    if (row.every((x) => x == null)) {
      return Optional.empty();
    }

    var model = Person(
      id: fields.contains('id') ? row[0] : null,
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
      addressId: fields.contains('address_id') ? row[9] is String ?  (int.parse(row[9]) as int?):row[9]: null,
      photoId: fields.contains('photo_id') ?row[10] is String ?   (int.parse(row[10]) as int?):row[10]: null,
      authUserId:fields.contains('auth_user_id') ? row[11] is String ?  (int.parse(row[11]) as int?):row[11]: null,
      userId:  fields.contains('user_id') ? row[12] is String ?  (int.parse(row[12]) as int?):row[12]: null,
      administratorId:fields.contains('administrator_id') ?  row[13] is String ? (int.parse(row[13]) as int?): row[13]:null,
      employeeId:   fields.contains('employee_id') ? row[14] is String ?  (int.parse(row[14]) as int?): row[14]:null,


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
      addressId = NumericSqlExpressionBuilder<int>(query, 'address_id'),
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

  final NumericSqlExpressionBuilder<int> addressId;

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
      addressId,
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

  set credits(double? value) => values['credits'] = value;

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
    credits = model.credits;
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
    this .createdAt,
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
  });

 // Not sure this field is necessary
 // static final empty = Person(credits: 0.0);


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
  double? credits;

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


  @override
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
      addressId: addressId ?? this.addressId,
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
      addressId,
      photoId,
      authUserId,
      userId,
      administratorId,
      employeeId,
    ]);
  }

  @override
  String toString() {
    return 'Person(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, credits=$credits, email=$email,address=$address, photoId=$photoId,authUser=$authUser,authUserId=$authUserId, userId=$userId, administratorId=$administratorId, employeeId=$employeeId)';
  }

  Map<String, dynamic>? toJson() {
    return PersonSerializer?.toMap(this);
  }


  late Map<String, dynamic> setters ={
  'id': (val) => id = val,
  'createdAt': (val) => this.createdAt = val,
  'updatedAt': (val) => this.updatedAt = val,
  'firstname': (val) => this.firstname = val,
  'lastname': (val) => this.lastname = val,
  'age': (val) => this.age = val,
  'gender': (val) => this.gender = val,
  'credits': (val) => this.credits = val,
  'email': (val) => this.email = val,
  'photo': (val) => this.photo = val,
  'photoId': (val) => this.photoId = val,
  'authUser': (val) => this.authUser = val,
  'authUserId': (val) => this.authUserId = val,
  'user': (val) => this.user = val,
  'userId': (val) => this.userId = val,
  'administrator': (val) => this.administrator = val,
  'administratorId': (val) => this.administratorId = val,
  'employee': (val) => this.employee = val,
  'employeeId': (val) => this.employeeId = val
  };
/*
  void setField(String fieldName, dynamic value) {
    fieldName = StringLib.snakeToCamel(fieldName);
    if (setters.containsKey(fieldName)) {
      setters[fieldName]!(value);
    } else {
      throw ArgumentError('Unknown field: $fieldName');
    }
  }




  //This function shoud be better but create a new entity
  //It does not update original. It creates new instance
  void setField2(String key, dynamic value) {
    key = StringLib.snakeToCamel(key);
    var index = Entity_Index[this.runtimeType.toString()];
    var toMap = index!['toMap'] as Function;
    final map = toMap(this);
    var fields = index!['fields']; //is immutable come from class EntityFields
    var fields2 = fields.map((value) => StringLib.snakeToCamel(value));

    if (!fields2.contains(key)) {
      throw ArgumentError('Unknown field: $key');
    }
    map![key] = value;
    var ret = index!['fromMap']!(map!);
    PersonSerializer.fromMap(map!);

    print('PersonEntity ${ret}');
    print('PersonEntity ${this.toString()}');
    print("");
  }


  void setField3(String key, dynamic value){
    key = StringLib.snakeToCamel(key);
    var index = Entity_Index[this.runtimeType.toString()];

    List<String>  fields= index!['fields'];
      Map<String,dynamic> setters={};
    for (var field in fields){
         setters.addAll({field: (val) => this.['field'] = val});  /!\ Don't Work

     }
    if (setters.containsKey(key)) {
      setters[key]!(value);
    } else {
      throw ArgumentError('Unknown field: $key');
    }
  }*/

  void setFields(Map<String, dynamic> updates) {
    var index= Entity_Index[this.runtimeType.toString()];
    var serializer=index!['serializerClass'] ;
    final map = serializer().toMap(this);

    for (final entry in updates.entries) {
      String key=StringLib.snakeToCamel(entry.key);
      if (!index!['fields'].contains(key)) {
        throw ArgumentError('Unknown field: ${key}');
      }
      map![key] = entry.value;
    }

    serializer().fromMap(map!);
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
  var field=accessors[key];
    if(field!=null) return accessors[key]!['get'];
    throw("$key doesn't exist in accessors Map of ${this.runtimeType.toString()}");
  }catch(e,s){print("Error to fetch field $key , error:$e, \n stack:$s");}
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

    map=StringLib().camelToSnakeKeyFromMap(map);
    print('PersonEntity L892: fromMap , Person map (in snake case)  : $map');

     var a=Person(
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
      photoId: map['photo_id'] != null
          ? map['photo_id'] is String
          ? int.parse(map['photo_id'])
          :map['photo_id']
          :null ,
      authUser:
          map['auth_user'] != null
              ? AuthUserSerializer.fromMap(map['auth_user'] as Map)
              : null,
      authUserId: map['auth_user_id'] != null
          ? map['auth_user_id'] is String
          ? int.parse(map['auth_user_id'])
          :map['auth_user_id']
          :null ,
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map)
              : null,
      userId: map['user_id'] != null
          ? map['user_id'] is String
          ? int.parse(map['user_id'])
          :map['user_id']
          :null ,
      administrator:
          map['administrator'] != null
              ? AdministratorSerializer.fromMap(map['administrator'] as Map)
              : null,
      administratorId: map['administrator_id'] != null
          ? map['administrator_id'] is String
          ? int.parse(map['administrator_id'])
          :map['administrator_id']
          :null ,
      employee:
          map['employee'] != null
              ? EmployeeSerializer.fromMap(map['employee'] as Map)
              : null,
      employeeId: map['employee_id'] != null
          ? map['employee_id'] is String
          ? int.parse(map['employee_id'])
          :map['employee_id']
          :null ,
    );
    print('PersonEntity L823: fromMap , Person entity : $a');
     return a;
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
      'authUser': AuthUserSerializer.toMap(model.authUser),
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
