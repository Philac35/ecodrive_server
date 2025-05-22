// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Travel.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class TravelMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('travels', (table) {
      table.serial('id').primaryKey();
      table.integer('id_int');
      table
          .declare('itinerary_id', ColumnType('int'))
          .references('f_angel_models', 'id');
      table.declareColumn(
        'user_list',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.declareColumn(
        'validate',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.timeStamp('departure_time');
      table.timeStamp('arrival_time');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table
          .declare('driver_id', ColumnType('int'))
          .references('f_angel_models', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('travels');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class TravelQuery extends Query<Travel, TravelQueryWhere> {
  TravelQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = TravelQueryWhere(this);
    leftJoin(
      _driver = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'driver_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final TravelQueryValues values = TravelQueryValues();

  List<String> _selectedFields = [];

  TravelQueryWhere? _where;

  late FAngelModelQuery _driver;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'travels';
  }

  @override
  List<String> get fields {
    const _fields = [
      'id',
      'id_int',
      'driver_id',
      'itinerary',
      'user_list',
      'validate',
      'departure_time',
      'arrival_time',
      'created_at',
      'updated_at',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
  }

  TravelQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  TravelQueryWhere? get where {
    return _where;
  }

  @override
  TravelQueryWhere newWhereClause() {
    return TravelQueryWhere(this);
  }

  Optional<Travel> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }

    var itineraryvar,drivervar;

    if( fields.contains('itinerary') ){ itineraryvar=(row[3] as Itinerary);}
    if(fields.contains('driver') ){ drivervar =(row[2] as Driver);}
    TravelModel? model = TravelModel(
      id: fields.contains('id') ? row[0].toString() : null,
      idInt: fields.contains('id_int') ? mapToInt(row[1]) : null,
      itinerary:itineraryvar,
      userList:
          fields.contains('user_list') ? (row[4] as List<dynamic>?) : null,
      validate: fields.contains('validate') ? (row[5] as List<dynamic>?) : null,
      departureTime: fields.contains('departure_time')
          ? mapToNullableDateTime(row[6])
          : null,
      arrivalTime: fields.contains('arrival_time')
          ? mapToNullableDateTime(row[7])
          : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[8]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[9]) : null,
      driver:drivervar,
    );
    if (row.length > 10) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(10).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(driver: m) as TravelModel?;
      });
    }
    return Optional.of(model as Travel);
  }

  @override
  Optional<Travel> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get driver {
    return _driver;
  }
}

class TravelQueryWhere extends QueryWhere {
  TravelQueryWhere(TravelQuery query)
      : id = NumericSqlExpressionBuilder<int>(
          query,
          'id',
        ),
        idInt = NumericSqlExpressionBuilder<int>(
          query,
          'id_int',
        ),
        driverId = NumericSqlExpressionBuilder<int>(
          query,
          'driver_id',
        ),
        userList = ListSqlExpressionBuilder(
          query,
          'user_list',
        ),
        validate = ListSqlExpressionBuilder(
          query,
          'validate',
        ),
        departureTime = DateTimeSqlExpressionBuilder(
          query,
          'departure_time',
        ),
        arrivalTime = DateTimeSqlExpressionBuilder(
          query,
          'arrival_time',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        ),
        updatedAt = DateTimeSqlExpressionBuilder(
          query,
          'updated_at',
        ),
       itineraryId = NumericSqlExpressionBuilder<int>(
           query,
           'itinerary_id');

  final NumericSqlExpressionBuilder<int> id;

  final NumericSqlExpressionBuilder<int> idInt;

  final NumericSqlExpressionBuilder<int> driverId;

  final ListSqlExpressionBuilder userList;

  final ListSqlExpressionBuilder validate;

  final DateTimeSqlExpressionBuilder departureTime;

  final DateTimeSqlExpressionBuilder arrivalTime;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;
  final NumericSqlExpressionBuilder<int> itineraryId;
  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      idInt,
      driverId,
      itineraryId,
      userList,
      validate,
      departureTime,
      arrivalTime,
      createdAt,
      updatedAt,
    ];
  }
}

class TravelQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {
      'user_list': 'jsonb',
      'validate': 'jsonb',
    };
  }

  String? get id {
    return (values['id'] as String?);
  }

  set id(String? value) => values['id'] = value;

  int? get idInt {
    return (values['id_int'] as int?);
  }

  set idInt(int? value) => values['id_int'] = value;

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

  Itinerary get itinerary {
    return (values['itinerary'] as Itinerary);
  }

  set itinerary(Itinerary value) => values['itinerary'] = value;

  List<dynamic>? get userList {
    return json.decode((values['user_list'] as String)).cast();
  }

  set userList(List<dynamic>? value) =>
      values['user_list'] = json.encode(value);

  List<dynamic>? get validate {
    return json.decode((values['validate'] as String)).cast();
  }

  set validate(List<dynamic>? value) => values['validate'] = json.encode(value);

  DateTime? get departureTime {
    return (values['departure_time'] as DateTime?);
  }

  set departureTime(DateTime? value) => values['departure_time'] = value;

  DateTime? get arrivalTime {
    return (values['arrival_time'] as DateTime?);
  }

  set arrivalTime(DateTime? value) => values['arrival_time'] = value;

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;

  void copyFrom(Travel model) {
    idInt = model.idInt;
    itinerary = model.itinerary as Itinerary;
    userList = model.userList;
    validate = model.validate;
    departureTime = model.departureTime;
    arrivalTime = model.arrivalTime;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    if (model.driver != null) {
      values['driver_id'] = model.driver?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class TravelModel extends Travel {
  TravelModel(
     {
    this.id,
    this.idInt,
    required this.driver,
    required this.itinerary,
    List<dynamic>? userList = const [],
    List<dynamic>? validate = const [],
    this.departureTime,
    this.arrivalTime,
    this.createdAt,
    this.updatedAt,
  })  : userList = List.unmodifiable(userList ?? []),
        validate = List.unmodifiable(validate ?? []),
        super(idInt: idInt,driver:  driver,itinerary: itinerary! as Itinerary,departureTime:  departureTime,userList:  userList,validate:  validate,
 createdAt: createdAt, updatedAt: updatedAt);

  @override
  String? id;

  @override
  int? idInt;

  @override
  Driver driver;

  @override
  Itinerary itinerary;

  @override
  List<dynamic>? userList;

  @override
  List<dynamic>? validate;

  @override
  DateTime? departureTime;

  @override
  DateTime? arrivalTime;

  @override
  DateTime? createdAt;

  @override
  DateTime? updatedAt;

  Travel copyWith(
     {
    String? id,
    int? idInt,
    Driver? driver,
    Itinerary? itinerary,
    List<dynamic>? userList,
    List<dynamic>? validate,
    DateTime? departureTime,
    DateTime? arrivalTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TravelModel(
        id: id ?? this.id,
        idInt: idInt ?? this.idInt,
        driver: driver ?? this.driver,
        itinerary: itinerary ?? this.itinerary,
        userList: userList ?? this.userList,
        validate: validate ?? this.validate,
        departureTime: departureTime ?? this.departureTime,
        arrivalTime: arrivalTime ?? this.arrivalTime,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  @override
  bool operator ==(other) {
    return other is Travel &&
        other.id == id &&
        other.idInt == idInt &&
        other.driver == driver &&
        other.itinerary == itinerary &&
        ListEquality<dynamic>(DefaultEquality())
            .equals(other.userList, userList) &&
        ListEquality<dynamic>(DefaultEquality())
            .equals(other.validate, validate) &&
        other.departureTime == departureTime &&
        other.arrivalTime == arrivalTime &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      idInt,
      driver,
      itinerary,
      userList,
      validate,
      departureTime,
      arrivalTime,
      createdAt,
      updatedAt,
    ]);
  }

  @override
  String toString() {
    return 'Travel(id=$id, idInt=$idInt, driver=$driver, itinerary=$itinerary, userList=$userList, validate=$validate, departureTime=$departureTime, arrivalTime=$arrivalTime, createdAt=$createdAt, updatedAt=$updatedAt)';
  }

  Map<String, dynamic> toJson() {
    return TravelSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class TravelSerializer {
  static Travel fromMap(
    Map map,
    int? idInt,
    Driver driver,
    Itinerary itinerary,
    DateTime? departureTime,
    List<dynamic>? userList,
    List<dynamic>? validate,
    DateTime? createdAt,
    DateTime? updatedAt,
  ) {

    var drivervar, itineraryvar;
    if(map['driver'] != null ){ drivervar=DriverSerializer.fromMap(map['driver'] as Map) ;};
    if( map['itinerary'] != null ){ itineraryvar=ItinerarySerializer.fromMap(map['itinerary'] as Map) as Itinerary ;}
    return TravelModel(
        id: map['id'] as String?,
        idInt: map['id_int'] as int?,
        driver: drivervar,
        itinerary: itineraryvar ,
        userList: map['user_list'] is Iterable
            ? (map['user_list'] as Iterable).cast<dynamic>().toList()
            : [],
        validate: map['validate'] is Iterable
            ? (map['validate'] as Iterable).cast<dynamic>().toList()
            : [],
        departureTime: map['departure_time'] != null
            ? (map['departure_time'] is DateTime
                ? (map['departure_time'] as DateTime)
                : DateTime.parse(map['departure_time'].toString()))
            : null,
        arrivalTime: map['arrival_time'] != null
            ? (map['arrival_time'] is DateTime
                ? (map['arrival_time'] as DateTime)
                : DateTime.parse(map['arrival_time'].toString()))
            : null,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(Travel? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'id_int': model.idInt,
      'driver': DriverSerializer.toMap(model.driver),
      'itinerary': ItinerarySerializer.toMap(model.itinerary),
      'user_list': model.userList,
      'validate': model.validate,
      'departure_time': model.departureTime?.toIso8601String(),
      'arrival_time': model.arrivalTime?.toIso8601String(),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class TravelFields {
  static const List<String> allFields = <String>[
    id,
    idInt,
    driver,
    itinerary,
    userList,
    validate,
    departureTime,
    arrivalTime,
    createdAt,
    updatedAt,
  ];

  static const String id = 'id';

  static const String idInt = 'id_int';

  static const String driver = 'driver';

  static const String itinerary = 'itinerary';

  static const String userList = 'user_list';

  static const String validate = 'validate';

  static const String departureTime = 'departure_time';

  static const String arrivalTime = 'arrival_time';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
