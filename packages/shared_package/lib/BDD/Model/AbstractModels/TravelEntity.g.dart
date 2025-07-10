// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TravelEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class TravelMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('travels', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.declareColumn(
        'validate',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.timeStamp('departure_time');
      table.timeStamp('arrival_time');
      table.declare('driver_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('travels', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class TravelQuery extends Query<Travel, TravelQueryWhere> {
  TravelQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = TravelQueryWhere(this);
    leftJoin(
      _driver = PersonQuery(trampoline: trampoline, parent: this),
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
  final TravelQueryValues values = TravelQueryValues();

  List<String> _selectedFields = [];

  TravelQueryWhere? _where;

  late PersonQuery _driver;

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
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'driver_id',
      'validate',
      'departure_time',
      'arrival_time',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
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
    // Parse itinerary if present
    ItineraryEntity? itinerary;
    if (fields.contains('itinerary') && row.length > 15) {
      var itineraryOpt = ItineraryQuery().parseRow(row.skip(15).take(8).toList());
      if (itineraryOpt.isPresent) {
        itinerary = itineraryOpt.value as ItineraryEntity;
      }
    }
    var model = Travel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      validate: fields.contains('validate') ? (row[4] as List<dynamic>?) : null,
      departureTime:
          fields.contains('departure_time')
              ? mapToNullableDateTime(row[5])
              : null,
      arrivalTime:
          fields.contains('arrival_time')
              ? mapToNullableDateTime(row[6])
              : null,
      driver: {} as DriverEntity,
      itinerary: itinerary!,
    );
    if (row.length > 7) {
      var modelOpt = PersonQuery().parseRow(row.skip(7).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(driver: m as DriverEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Travel> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get driver {
    return _driver;
  }

  @override
  Future<List<Travel>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Travel>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              user: List<dynamic>.from(l.user as Iterable)..addAll(model.user as Iterable),
            );
        }
      });
    });
  }

  @override
  Future<List<Travel>> update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<Travel>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              user: List<dynamic>.from(l.user as Iterable)..addAll(model.user as Iterable),
            );
        }
      });
    });
  }

  @override
  Future<List<Travel>> delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<Travel>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              user: List<dynamic>.from(l.user as Iterable)..addAll(model.user as Iterable),
            );
        }
      });
    });
  }
}

class TravelQueryWhere extends QueryWhere {
  TravelQueryWhere(TravelQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id'),
      validate = ListSqlExpressionBuilder(query, 'validate'),
      departureTime = DateTimeSqlExpressionBuilder(query, 'departure_time'),
      arrivalTime = DateTimeSqlExpressionBuilder(query, 'arrival_time');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> driverId;

  final ListSqlExpressionBuilder validate;

  final DateTimeSqlExpressionBuilder departureTime;

  final DateTimeSqlExpressionBuilder arrivalTime;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      driverId,
      validate,
      departureTime,
      arrivalTime,
    ];
  }
}

class TravelQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'validate': 'jsonb'};
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

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

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

  void copyFrom(Travel model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    validate = model.validate;
    departureTime = model.departureTime;
    arrivalTime = model.arrivalTime;
    if (model.driver != null) {
      values['driver_id'] = model.driver?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Travel extends TravelEntity {
  Travel({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.driver,
    required this.itinerary,
    List<dynamic>? user = const [],
    List<dynamic>? validate = const [],
    this.departureTime,
    this.arrivalTime,
  }) : user = List.unmodifiable(user ?? []),
       validate = List.unmodifiable(validate ?? []), super.empty();

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
  DriverEntity driver;

  @override
  ItineraryEntity itinerary;

  @override
  List<dynamic>? user;

  @override
  List<dynamic>? validate;

  @override
  DateTime? departureTime;

  @override
  DateTime? arrivalTime;

  Travel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DriverEntity? driver,
    ItineraryEntity? itinerary,
    List<dynamic>? user,
    List<dynamic>? validate,
    DateTime? departureTime,
    DateTime? arrivalTime,
  }) {
    return Travel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driver: driver ?? this.driver,
      itinerary: itinerary ?? this.itinerary,
      user: user ?? this.user,
      validate: validate ?? this.validate,
      departureTime: departureTime ?? this.departureTime,
      arrivalTime: arrivalTime ?? this.arrivalTime,
    );
  }

  @override
  bool operator ==(other) {
    return other is TravelEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.driver == driver &&
        other.itinerary == itinerary &&
        ListEquality<dynamic>(DefaultEquality()).equals(other.user, user) &&
        ListEquality<dynamic>(
          DefaultEquality(),
        ).equals(other.validate, validate) &&
        other.departureTime == departureTime &&
        other.arrivalTime == arrivalTime;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      driver,
      itinerary,
      user,
      validate,
      departureTime,
      arrivalTime,
    ]);
  }

  @override
  String toString() {
    return 'Travel(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, driver=$driver, itinerary=$itinerary, user=$user, validate=$validate, departureTime=$departureTime, arrivalTime=$arrivalTime)';
  }

  Map<String, dynamic> toJson() {
    return TravelSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const TravelSerializer travelSerializer = TravelSerializer();

class TravelEncoder extends Converter<Travel, Map> {
  const TravelEncoder();

  @override
  Map convert(Travel model) => TravelSerializer.toMap(model);
}

class TravelDecoder extends Converter<Map, Travel> {
  const TravelDecoder();

  @override
  Travel convert(Map map) => TravelSerializer.fromMap(map);
}

class TravelSerializer extends Codec<Travel, Map> {
  const TravelSerializer();

  @override
  TravelEncoder get encoder => const TravelEncoder();

  @override
  TravelDecoder get decoder => const TravelDecoder();

  static Travel fromMap(Map map) {
    return Travel(
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
      driver:
          map['driver'] != null
              ? DriverSerializer.fromMap(map['driver'] as Map) as DriverEntity
              : {}  as DriverEntity,
      itinerary:
          map['itinerary'] != null
              ? ItinerarySerializer.fromMap(map['itinerary'] as Map) as Itinerary
              : {}  as Itinerary,
      user:
          map['user'] is Iterable
              ? (map['user'] as Iterable).cast<dynamic>().toList()
              : [],
      validate:
          map['validate'] is Iterable
              ? (map['validate'] as Iterable).cast<dynamic>().toList()
              : [],
      departureTime:
          map['departure_time'] != null
              ? (map['departure_time'] is DateTime
                  ? (map['departure_time'] as DateTime)
                  : DateTime.parse(map['departure_time'].toString()))
              : null,
      arrivalTime:
          map['arrival_time'] != null
              ? (map['arrival_time'] is DateTime
                  ? (map['arrival_time'] as DateTime)
                  : DateTime.parse(map['arrival_time'].toString()))
              : null,
    );
  }

  static Map<String, dynamic> toMap(TravelEntity? model) {
    if (model == null) {
      throw FormatException("Travel L507,Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'driver': DriverSerializer.toMap(model.driver),
      'itinerary': ItinerarySerializer.toMap(model.itinerary),
      'user': model.user,
      'validate': model.validate,
      'departure_time': model.departureTime?.toIso8601String(),
      'arrival_time': model.arrivalTime?.toIso8601String(),
    };
  }
}

abstract class TravelFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    driver,
    itinerary,
    user,
    validate,
    departureTime,
    arrivalTime,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String driver = 'driver';

  static const String itinerary = 'itinerary';

  static const String user = 'user';

  static const String validate = 'validate';

  static const String departureTime = 'departure_time';

  static const String arrivalTime = 'arrival_time';
}
