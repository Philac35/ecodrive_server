// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Driver.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class DriverMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('drivers', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('updated_at');
      table.integer('id_int');
      table.varChar('firstname', length: 255);
      table.varChar('lastname', length: 255);
      table.integer('age');
      table.varChar('gender', length: 255);
      table.varChar('address', length: 255);
      table.varChar('email', length: 255);
      table.timeStamp('created_at');
      table.declareColumn(
        'preferences',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.varChar('drivinglicense', length: 255);
      table.varChar('driving_licence', length: 255);
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
  DriverQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    //shoud be : DriverQueryWhere DriverQueryWhere(DriverQuery query, StringSqlExpressionBuilder address
    // It was DriverQueryWhere( this) //Modified 20/05/2025 18h02
    _where = DriverQueryWhere( this);
    leftJoin(
      _photo = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'driver_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _notice = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'driver_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _vehicule = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'driver_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final DriverQueryValues values = DriverQueryValues();

  List<String> _selectedFields = [];

  DriverQueryWhere? _where;

  late FAngelModelQuery _photo;

  late FAngelModelQuery _notice;

  late FAngelModelQuery _vehicule;

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
    const _fields = [
      'id',
      'updated_at',
      'id_int',
      'firstname',
      'lastname',
      'age',
      'gender',
      'address',
      'email',
      'created_at',
      'preferences',
      'drivinglicense',
      'driving_licence',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
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
    DriverModel? model = DriverModel(
      id: fields.contains('id') ? row[0].toString() : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[1]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[2]) : null,
      firstname: fields.contains('firstname') ? (row[3] as String?) : null,
      lastname: fields.contains('lastname') ? (row[4] as String?) : null,
      age: fields.contains('age') ? mapToInt(row[5]) : null,
      gender: fields.contains('gender') ? (row[6] as String?) : null,
      address: fields.contains('address') ? (row[7] as Address?) : null,
      email: fields.contains('email') ? (row[8] as String?) : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[9]) : null,
      preferences:
          fields.contains('preferences') ? (row[10] as List<dynamic>?) : null,
      drivingLicence: fields.contains('driving_licence')
          ? (row[12] as DrivingLicence?)
          : null,
    );
    if (row.length > 13) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(13).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(photo: m) as DriverModel?;
      });
    }
    if (row.length > 16) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(16).take(3).toList());
      modelOpt.ifPresent((m) {
       model = model?.copyWith(notices: [m]) as DriverModel?; //Driver could have a list of Notice, arg m is right
    });
    }
    if (row.length > 19) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(19).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(vehicule: m) as DriverModel?;
      });
    }
    return Optional.of(model as Driver);
  }

  @override
  Optional<Driver> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get photo {
    return _photo;
  }

  FAngelModelQuery get notice {
    return _notice;
  }

  FAngelModelQuery get vehicule {
    return _vehicule;
  }

  @override
  Future<List<Driver>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Driver>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx] as DriverModel;
          return out
            ..[idx] =
                l.copyWith(notices:  [...?l.notices, ...?model.notices]);
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
          var l = out[idx] as DriverModel;
          return out
            ..[idx] =
                l.copyWith(notices:  [...?l.notices, ...?model.notices]);
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
          var l = out[idx] as DriverModel;
          return out
            ..[idx] =
                l.copyWith(notices: [...?l.notices, ...?model.notices]); //I am not sure of the cast. We work with list of notices.
        }
      });
    });
  }
}

class DriverQueryWhere extends QueryWhere {
  DriverQueryWhere(DriverQuery query)
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
        address = StringSqlExpressionBuilder(query, 'address'),
        email = StringSqlExpressionBuilder(
          query,
          'email',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        ),
        preferences = ListSqlExpressionBuilder(
          query,
          'preferences',
        ),
        drivingLicence = StringSqlExpressionBuilder(
          query,
          'drivinglicense',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final StringSqlExpressionBuilder firstname;

  final StringSqlExpressionBuilder lastname;

  final NumericSqlExpressionBuilder<int> age;

  final StringSqlExpressionBuilder gender;

  final StringSqlExpressionBuilder address;

  final StringSqlExpressionBuilder email;

  final DateTimeSqlExpressionBuilder createdAt;

  final ListSqlExpressionBuilder preferences;

  final StringSqlExpressionBuilder drivingLicence;

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
      address,
      email,
      createdAt,
      preferences,
      drivingLicence,
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

  Address? get address {
    return (values['address'] as Address?);
  }

  set address(Address? value) => values['address'] = value;

  String? get email {
    return (values['email'] as String?);
  }

  set email(String? value) => values['email'] = value;

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  List<dynamic>? get preferences {
    return json.decode((values['preferences'] as String)).cast();
  }

  set preferences(List<dynamic>? value) =>
      values['preferences'] = json.encode(value);

  String? get drivinglicense {
    return (values['drivinglicense'] as String?);
  }

  set drivinglicense(String? value) => values['drivinglicense'] = value;

  DrivingLicence? get drivingLicence {
    return (values['driving_licence'] as DrivingLicence?);
  }

  set drivingLicence(DrivingLicence? value) =>
      values['driving_licence'] = value;

  void copyFrom(DriverModel model) {
    updatedAt = model.updatedAt;
    idInt = model.idInt;
    firstname = model.firstname;
    lastname = model.lastname;
    age = model.age;
    gender = model.gender;
    address = model.address;
    email = model.email;
    createdAt = model.createdAt;
    preferences = model.preferences;
    drivinglicense = model.drivinglicense;
    drivingLicence = model.drivingLicence;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class DriverModel extends Driver {


  DriverModel( {
    this.id,
    this.updatedAt,
    this.idInt,
    this.firstname,
    this.lastname,
    this.age,
    this.gender,
    this.address,
    this.email,
    this.createdAt,
    this.photo,
    List<Notice>? this.notices,
    List<dynamic>? preferences = const [],
   this.vehicule_id,
    this.vehicule,
    this.drivingLicence,
    this.authUser,
  })  : preferences = List.unmodifiable(preferences ?? []),
        super(idInt:idInt, firstname: firstname, lastname: lastname, age:age, gender:gender, address: address, email:email, photo:photo,
           authUser:authUser,createdAt:  createdAt, notices:notices, preferences:preferences, drivingLicence: drivingLicence, vehicule: vehicule!, vehicule_id:vehicule_id);

  @override
  String? id;

  /// The last time at which this item was updated.
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
  DateTime? createdAt;

  @override
  Photo? photo;

  @override
  List<Notice>?  notices;

  @override
  List<dynamic>? preferences;

  @override
  Vehicule? vehicule;

  @override
  DrivingLicence? drivingLicence;

  var vehicule_id;

  @override
  AuthUser? authUser;

  Driver copyWith(  {
    String? id,
    DateTime? updatedAt,
    int? idInt,
    String? firstname,
    String? lastname,
    int? age,
    String? gender,
    Address? address,
    String? email,
    DateTime? createdAt,
    Photo? photo,
    List<Notice>?  notices,
    List<dynamic>? preferences,
    Vehicule? vehicule,
    DrivingLicence? drivingLicence,
  }) {
    return DriverModel(
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        firstname: firstname ?? this.firstname,
        lastname: lastname ?? this.lastname,
        age: age ?? this.age,
        gender: gender ?? this.gender,
        address: address ?? this.address,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
        photo: photo ?? this.photo,
        notices: notices ?? this.notices,
        preferences: preferences ?? this.preferences,
        vehicule: vehicule ?? this.vehicule,
        drivingLicence: drivingLicence ?? this.drivingLicence);
  }

  @override
  bool operator ==(other) {
    return other is Driver &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.firstname == firstname &&
        other.lastname == lastname &&
        other.age == age &&
        other.gender == gender &&
        other.address == address &&
        other.email == email &&
        other.createdAt == createdAt &&
        other.photo == photo &&
        other.notices == notices &&
        ListEquality<dynamic>(DefaultEquality())
            .equals(other.preferences, preferences) &&
        other.vehicule == vehicule &&
        other.drivingLicence == drivingLicence;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      updatedAt,
      idInt,
      firstname,
      lastname,
      age,
      gender,
      address,
      email,
      createdAt,
      photo,
      notices,
      preferences,
      vehicule,
      drivingLicence,
    ]);
  }

  @override
  String toString() {
    return 'Driver(id=$id, updatedAt=$updatedAt, idInt=$idInt, firstname=$firstname, lastname=$lastname, age=$age, gender=$gender, address=$address, email=$email, createdAt=$createdAt, photo=$photo, notices=$notices, preferences=$preferences, vehicule=$vehicule, drivingLicence=$drivingLicence)';
  }

  Map<String, dynamic> toJson() {
    return DriverSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class DriverSerializer {
  static Driver fromMap(
    Map map,

  ) {    
    return DriverModel(
        id: map['id'] as String?,
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
        address: map['address'] != null
            ? AddressSerializer.fromMap(map['address'] as Map)
            : null,
        email: map['email'] as String?,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        photo: map['photo'] != null
            ? PhotoSerializer.fromMap(map['photo'] as Map) as Photo?
            : null,
        notices: map['notices'] != null
            ? NoticeSerializer.fromMap(map['notices'] as Map)  as List<Notice>? // List of Notice
            : null,
        preferences: map['preferences'] is Iterable
            ? (map['preferences'] as Iterable).cast<dynamic>().toList()
            : [],
        vehicule_id: map['vehicule_id'] != null
            ? VehiculeSerializer.fromMap(map['vehicule_id'] as Map)
            : null,
        vehicule: map['vehicule'] != null ? VehiculeSerializer.fromMap(map['vehicule'] as Map) : null,
        drivingLicence: map['drivingLicence'] != null ? DrivingLicenceSerializer.fromMap(map['drivingLicence'] as Map) as DrivingLicence : null,
        authUser: map['authUser'] != null  ? AuthUserSerializer.fromMap(map['authUser'] as Map)  : null);

  }

  static Map<String, dynamic> toMap(Driver? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'firstname': model.firstname,
      'lastname': model.lastname,
      'age': model.age,
      'gender': model.gender,
      'address': AddressSerializer.toMap(model.address as abAdr.Address?),
      'email': model.email,
      'created_at': model.createdAt?.toIso8601String(),
      'photo': PhotoSerializer.toMap(model.photo as Photo?),
      'notices': NoticeSerializer.toMap(model.notices as Notice?),  // /!\ It is a list of Notice
      'preferences': model.preferences,
      'drivinglicense': model.drivinglicense,
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
      'driving_licence': DrivingLicenceSerializer.toMap(model.drivingLicence as DrivingLicence? )
    };
  }
}

abstract class DriverFields {
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
    createdAt,
    photo,
    notices,
    preferences,
    drivinglicense,
    vehicule,
    drivingLicence,
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

  static const String createdAt = 'created_at';

  static const String photo = 'photo';

  static const String notices = 'notices';

  static const String preferences = 'preferences';

  static const String drivinglicense = 'drivinglicense';

  static const String vehicule = 'vehicule';

  static const String drivingLicence = 'driving_licence';
}
