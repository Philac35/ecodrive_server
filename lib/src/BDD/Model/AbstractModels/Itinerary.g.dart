// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Itinerary.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class ItineraryMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('itineraries', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('updated_at');
      table.integer('id_int');
      table.double('price');

      // Adding foreign keys for addressDeparture and addressArrival
      var addressDepartureRef = table.integer('addressDeparture_id').references('addresses', 'id');
      addressDepartureRef.onDeleteCascade();

      var addressArrivalRef = table.integer('addressArrival_id').references('addresses', 'id');
      addressArrivalRef.onDeleteCascade();

      // Adding GeoPointList as a JSON field
      table.declareColumn(
        'GeoPointList',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.boolean('eco');
      table.timeStamp('duration');
      // Adding travel_id as a foreign key
      var travelRef = table.integer('travel_id').references('travels', 'id');
      travelRef.onDeleteCascade();
      table.timeStamp('created_at');


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
  ItineraryQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = ItineraryQueryWhere(this);
    leftJoin(
      _addressDeparture = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'itinerary_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _addressArrival = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'itinerary_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final ItineraryQueryValues values = ItineraryQueryValues();

  List<String> _selectedFields = [];

  ItineraryQueryWhere? _where;

  late FAngelModelQuery _addressDeparture;

  late FAngelModelQuery _addressArrival;

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
    const _fields = [
      'id',
      'updated_at',
      'id_int',
      'price',
      'eco',
      'duration',
      'created_at',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
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
    ItineraryModel? model = ItineraryModel(
      id: fields.contains('id') ? row[0].toString() : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[1]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[2]) : null,
      price: fields.contains('price') ? mapToDouble(row[3]) : null,
      eco: fields.contains('eco') ? mapToBool(row[4]) : null,
      duration:
          fields.contains('duration') ? mapToNullableDateTime(row[5]) : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[6]) : null,
    );
    if (row.length > 7) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(7).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(addressDeparture: m) as ItineraryModel?;
      });
    }
    if (row.length > 10) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(10).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(addressArrival: m) as ItineraryModel?;
      });
    }
    return Optional.of(model as Itinerary);
  }

  @override
  Optional<Itinerary> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get addressDeparture {
    return _addressDeparture;
  }

  FAngelModelQuery get addressArrival {
    return _addressArrival;
  }
}

class ItineraryQueryWhere extends QueryWhere {
  ItineraryQueryWhere(ItineraryQuery query)
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
        price = NumericSqlExpressionBuilder<double>(
          query,
          'price',
        ),
        eco = BooleanSqlExpressionBuilder(
          query,
          'eco',
        ),
        duration = DateTimeSqlExpressionBuilder(
          query,
          'duration',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final NumericSqlExpressionBuilder<double> price;

  final BooleanSqlExpressionBuilder eco;

  final DateTimeSqlExpressionBuilder duration;

  final DateTimeSqlExpressionBuilder createdAt;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      updatedAt,
      idInt,
      price,
      eco,
      duration,
      createdAt,
    ];
  }
}

class ItineraryQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
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

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  void copyFrom(Itinerary model) {
    updatedAt = model.updatedAt;
    idInt = model.idInt;
    price = model.price;
    eco = model.eco;
    duration = model.duration;
    createdAt = model.createdAt;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class ItineraryModel extends Itinerary {
  ItineraryModel(
 {
    this.id,
    this.updatedAt,
    this.idInt,
    this.price,
    this.addressDeparture,
    this.addressArrival,
    this.eco,
    this.duration,
    this.createdAt,
    this.travel,
    this.travelId
  }) : super(idInt: idInt,price: price,addressDeparture:  addressDeparture,addressArrival:  addressArrival, eco: eco, duration: duration,
createdAt: createdAt, travel: travel);

  @override
  String? id;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  int? idInt;

  @override
  double? price;

  @override
  a.Address? addressDeparture;

  @override
  a.Address? addressArrival;

  @override
  bool? eco;

  @override
  DateTime? duration;

  @override
  DateTime? createdAt;

   int?  travelId;

   @override
   Travel? travel;

  Itinerary copyWith(
    {
    String? id,
    DateTime? updatedAt,
    int? idInt,
    double? price,
    a.Address? addressDeparture,
    a.Address? addressArrival,
    bool? eco,
    DateTime? duration,
    DateTime? createdAt,
  }) {
    return ItineraryModel(
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        price: price ?? this.price,
        addressDeparture: addressDeparture ?? this.addressDeparture,
        addressArrival: addressArrival ?? this.addressArrival,
        eco: eco ?? this.eco,
        duration: duration ?? this.duration,
        createdAt: createdAt ?? this.createdAt);
  }

  @override
  bool operator ==(other) {
    return other is Itinerary &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.price == price &&
        other.addressDeparture == addressDeparture &&
        other.addressArrival == addressArrival &&
        other.eco == eco &&
        other.duration == duration &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      updatedAt,
      idInt,
      price,
      addressDeparture,
      addressArrival,
      eco,
      duration,
      createdAt,
    ]);
  }

  @override
  String toString() {
    return 'Itinerary(id=$id, updatedAt=$updatedAt, idInt=$idInt, price=$price, addressDeparture=$addressDeparture, addressArrival=$addressArrival, eco=$eco, duration=$duration, createdAt=$createdAt)';
  }

  Map<String, dynamic> toJson() {
    return ItinerarySerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class ItinerarySerializer {
  static Itinerary fromMap( Map map

  ) {
    return ItineraryModel( id: map['id'] as String?,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        idInt: map['id_int'] as int?,
        price: map['price'] as double?,
        addressDeparture: map['address_departure'] != null
            ? AddressSerializer.fromMap(map['address_departure'] as Map)
            : null,
        addressArrival: map['address_arrival'] != null
            ? AddressSerializer.fromMap(map['address_arrival'] as Map)
            : null,
        eco: map['eco'] as bool?,
        duration: map['duration'] != null
            ? (map['duration'] is DateTime
                ? (map['duration'] as DateTime)
                : DateTime.parse(map['duration'].toString()))
            : null,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        travelId: map['travel_id'] as int?);
  }

  static Map<String, dynamic> toMap(Itinerary? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'price': model.price,
      'address_departure': AddressSerializer.toMap(model.addressDeparture),
      'address_arrival': AddressSerializer.toMap(model.addressArrival),
      'eco': model.eco,
      'duration': model.duration?.toIso8601String(),
      'created_at': model.createdAt?.toIso8601String(),
      'travel_id': model.travel?.idInt
    };
  }
}

abstract class ItineraryFields {
  static const List<String> allFields = <String>[
    id,
    updatedAt,
    idInt,
    price,
    addressDeparture,
    addressArrival,
    eco,
    duration,
    createdAt,
    travel_id,
  ];

  static const String id = 'id';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String price = 'price';

  static const String addressDeparture = 'address_departure';

  static const String addressArrival = 'address_arrival';

  static const String eco = 'eco';

  static const String duration = 'duration';

  static const String createdAt = 'created_at';

  static const String travel_id = 'travel_id';
}
