// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ItineraryEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class ItineraryMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('itineraries', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.double('price');
      table.boolean('eco').defaultsTo(false);
      table.timeStamp('duration');
      table.declareColumn(
        'geo_point_list',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.declare('travel_id', ColumnType('int')).references('travels', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('itineraries', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class ItineraryQuery extends Query<Itinerary, ItineraryQueryWhere> {
  ItineraryQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = ItineraryQueryWhere(this);
    leftJoin(
      _travel = TravelQuery(trampoline: trampoline, parent: this),
      'travel_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'driver_id',
        'validate',
        'departure_time',
        'arrival_time',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final ItineraryQueryValues values = ItineraryQueryValues();

  List<String> _selectedFields = [];

  ItineraryQueryWhere? _where;

  late TravelQuery _travel;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'itineraries';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'price',
      'eco',
      'duration',
      'geo_point_list',
      'travel_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  ItineraryQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  ItineraryQueryWhere? get where {
    return _where;
  }

  @override
  ItineraryQueryWhere newWhereClause() {
    return ItineraryQueryWhere(this);
  }

  Optional<Itinerary> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Itinerary(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      price: fields.contains('price') ? mapToDouble(row[3]) : null,
      eco: fields.contains('eco') ? mapToBool(row[4]) : null,
      duration:
          fields.contains('duration') ? mapToNullableDateTime(row[5]) : null,
      geoPointList:
          fields.contains('geo_point_list')
              ? (row[6] as List<Uint8List>?)
              : null,
    );
    if (row.length > 8) {
      var modelOpt = TravelQuery().parseRow(row.skip(8).take(7).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(travel: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Itinerary> deserialize(List row) {
    return parseRow(row);
  }

  TravelQuery get travel {
    return _travel;
  }
}

class ItineraryQueryWhere extends QueryWhere {
  ItineraryQueryWhere(ItineraryQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      price = NumericSqlExpressionBuilder<double>(query, 'price'),
      eco = BooleanSqlExpressionBuilder(query, 'eco'),
      duration = DateTimeSqlExpressionBuilder(query, 'duration'),
      geoPointList = ListSqlExpressionBuilder(query, 'geo_point_list'),
      travelId = NumericSqlExpressionBuilder<int>(query, 'travel_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<double> price;

  final BooleanSqlExpressionBuilder eco;

  final DateTimeSqlExpressionBuilder duration;

  final ListSqlExpressionBuilder geoPointList;

  final NumericSqlExpressionBuilder<int> travelId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      price,
      eco,
      duration,
      geoPointList,
      travelId,
    ];
  }
}

class ItineraryQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'geo_point_list': 'jsonb'};
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

  double? get price {
    return (values['price'] as double?) ?? 0.0;
  }

  set price(double? value) => values['price'] = value;

  bool? get eco {
    return (values['eco'] as bool?);
  }

  set eco(bool? value) => values['eco'] = value;

  DateTime? get duration {
    return (values['duration'] as DateTime?);
  }

  set duration(DateTime? value) => values['duration'] = value;

  List<Uint8List>? get geoPointList {
    return json.decode((values['geo_point_list'] as String)).cast();
  }

  set geoPointList(List<Uint8List>? value) =>
      values['geo_point_list'] = json.encode(value);

  int get travelId {
    return (values['travel_id'] as int);
  }

  set travelId(int value) => values['travel_id'] = value;

  void copyFrom(Itinerary model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    price = model.price;
    eco = model.eco;
    duration = model.duration;
    geoPointList = model.geoPointList;
    if (model.travel != null) {
      values['travel_id'] = model.travel?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Itinerary extends ItineraryEntity {
  Itinerary({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.price,
    this.addressDeparture,
    this.addressArrival,
    this.eco = false,
    this.duration,
    List<Uint8List>? geoPointList = const [],
    this.travel,
  }) : geoPointList = List.unmodifiable(geoPointList ?? []);

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
  double? price;

  @override
  AddressEntity? addressDeparture;

  @override
  AddressEntity? addressArrival;

  @override
  bool? eco;

  @override
  DateTime? duration;

  @override
  List<Uint8List>? geoPointList;

  @override
  TravelEntity? travel;

  Itinerary copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? price,
    AddressEntity? addressDeparture,
    AddressEntity? addressArrival,
    bool? eco,
    DateTime? duration,
    List<Uint8List>? geoPointList,
    TravelEntity? travel,
  }) {
    return Itinerary(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      price: price ?? this.price,
      addressDeparture: addressDeparture ?? this.addressDeparture,
      addressArrival: addressArrival ?? this.addressArrival,
      eco: eco ?? this.eco,
      duration: duration ?? this.duration,
      geoPointList: geoPointList ?? this.geoPointList,
      travel: travel ?? this.travel,
    );
  }

  @override
  bool operator ==(other) {
    return other is ItineraryEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.price == price &&
        other.addressDeparture == addressDeparture &&
        other.addressArrival == addressArrival &&
        other.eco == eco &&
        other.duration == duration &&
        ListEquality<Uint8List>(
          ListEquality() as Equality<Uint8List>,
        ).equals(other.geoPointList, geoPointList) &&
        other.travel == travel;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      price,
      addressDeparture,
      addressArrival,
      eco,
      duration,
      geoPointList,
      travel,
    ]);
  }

  @override
  String toString() {
    return 'Itinerary(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, price=$price, addressDeparture=$addressDeparture, addressArrival=$addressArrival, eco=$eco, duration=$duration, geoPointList=$geoPointList, travel=$travel)';
  }

  Map<String, dynamic> toJson() {
    return ItinerarySerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const ItinerarySerializer itinerarySerializer = ItinerarySerializer();

class ItineraryEncoder extends Converter<Itinerary, Map> {
  const ItineraryEncoder();

  @override
  Map convert(Itinerary model) => ItinerarySerializer.toMap(model);
}

class ItineraryDecoder extends Converter<Map, Itinerary> {
  const ItineraryDecoder();

  @override
  Itinerary convert(Map map) => ItinerarySerializer.fromMap(map);
}

class ItinerarySerializer extends Codec<Itinerary, Map> {
  const ItinerarySerializer();

  @override
  ItineraryEncoder get encoder => const ItineraryEncoder();

  @override
  ItineraryDecoder get decoder => const ItineraryDecoder();

  static Itinerary fromMap(Map map) {
    return Itinerary(
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
      price: map['price'] as double?,
      addressDeparture:
          map['address_departure'] != null
              ? AddressSerializer.fromMap(map['address_departure'] as Map)
              : null,
      addressArrival:
          map['address_arrival'] != null
              ? AddressSerializer.fromMap(map['address_arrival'] as Map)
              : null,
      eco: map['eco'] as bool? ?? false,
      duration:
          map['duration'] != null
              ? (map['duration'] is DateTime
                  ? (map['duration'] as DateTime)
                  : DateTime.parse(map['duration'].toString()))
              : null,
      geoPointList:
          map['geo_point_list'] is Iterable
              ? (map['geo_point_list'] as Iterable).cast<Uint8List>().toList()
              : [],
      travel:
          map['travel'] != null
              ? TravelSerializer.fromMap(map['travel'] as Map)
              : null,
    );
  }

  static Map<String, dynamic> toMap(ItineraryEntity? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'price': model.price,
      'address_departure': AddressSerializer.toMap(model.addressDeparture),
      'address_arrival': AddressSerializer.toMap(model.addressArrival),
      'eco': model.eco,
      'duration': model.duration?.toIso8601String(),
      'geo_point_list': model.geoPointList,
      'travel': TravelSerializer.toMap(model.travel),
    };
  }
}

abstract class ItineraryFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    price,
    addressDeparture,
    addressArrival,
    eco,
    duration,
    geoPointList,
    travel,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String price = 'price';

  static const String addressDeparture = 'address_departure';

  static const String addressArrival = 'address_arrival';

  static const String eco = 'eco';

  static const String duration = 'duration';

  static const String geoPointList = 'geo_point_list';

  static const String travel = 'travel';
}
