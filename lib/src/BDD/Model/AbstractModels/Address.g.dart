// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Address.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class AddressMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('addresses', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('updated_at');
      table.integer('id_int');
      table.integer('number');
      table.varChar('type', length: 255);
      table.varChar('address', length: 255);
      table.varChar('complement_address', length: 255);
      table.varChar('post_code', length: 255);
      table.varChar('city', length: 255);
      table.varChar('country', length: 255);
      table.timeStamp('created_at');
      table
          .declare('person_id', ColumnType('int'))
          .references('f_angel_models', 'id');
      table
          .declare('itinerary_id', ColumnType('int'))
          .references('f_angel_models', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('addresses');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class AddressQuery extends Query<Address, AddressQueryWhere> {
  AddressQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AddressQueryWhere(this);
    leftJoin(
      _person = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'person_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _itinerary = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'itinerary_id',
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
  final AddressQueryValues values = AddressQueryValues();

  List<String> _selectedFields = [];

  AddressQueryWhere? _where;

  late FAngelModelQuery _person;

  late FAngelModelQuery _itinerary;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'addresses';
  }

  @override
  List<String> get fields {
    const _fields = [
      'id',
      'updated_at',
      'id_int',
      'number',
      'type',
      'address',
      'complement_address',
      'post_code',
      'city',
      'country',
      'created_at',
      'person_id',
      'itinerary_id',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
  }

  AddressQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  AddressQueryWhere? get where {
    return _where;
  }

  @override
  AddressQueryWhere newWhereClause() {
    return AddressQueryWhere(this);
  }

  Optional<Address> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    AddressModel model = AddressModel(
      id: fields.contains('id') ? row[0].toString() : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[1]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[2]) : null,
      number: fields.contains('number') ? mapToInt(row[3]) : null,
      type: fields.contains('type') ? (row[4] as String?) : null,
      address: fields.contains('address') ? (row[5] as String) : '',
      complementAddress:
          fields.contains('complement_address') ? (row[6] as String?) : null,
      postCode: fields.contains('post_code') ? (row[7] as String?) : null,
      city: fields.contains('city') ? (row[8] as String?) : null,
      country: fields.contains('country') ? (row[9] as String?) : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[10]) : null,
    );
    if (row.length > 13) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(13).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    if (row.length > 16) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(16).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(itinerary: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Address> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get person {
    return _person;
  }

  FAngelModelQuery get itinerary {
    return _itinerary;
  }
}

class AddressQueryWhere extends QueryWhere {
  AddressQueryWhere(AddressQuery query)
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
        number = NumericSqlExpressionBuilder<int>(
          query,
          'number',
        ),
        type = StringSqlExpressionBuilder(
          query,
          'type',
        ),
        address = StringSqlExpressionBuilder(
          query,
          'address',
        ),
        complementAddress = StringSqlExpressionBuilder(
          query,
          'complement_address',
        ),
        postCode = StringSqlExpressionBuilder(
          query,
          'post_code',
        ),
        city = StringSqlExpressionBuilder(
          query,
          'city',
        ),
        country = StringSqlExpressionBuilder(
          query,
          'country',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        ),
        personId = NumericSqlExpressionBuilder<int>(
          query,
          'person_id',
        ),
        itineraryId = NumericSqlExpressionBuilder<int>(
          query,
          'itinerary_id',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final NumericSqlExpressionBuilder<int> number;

  final StringSqlExpressionBuilder type;

  final StringSqlExpressionBuilder address;

  final StringSqlExpressionBuilder complementAddress;

  final StringSqlExpressionBuilder postCode;

  final StringSqlExpressionBuilder city;

  final StringSqlExpressionBuilder country;

  final DateTimeSqlExpressionBuilder createdAt;

  final NumericSqlExpressionBuilder<int> personId;

  final NumericSqlExpressionBuilder<int> itineraryId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      updatedAt,
      idInt,
      number,
      type,
      address,
      complementAddress,
      postCode,
      city,
      country,
      createdAt,
      personId,
      itineraryId,
    ];
  }
}

class AddressQueryValues extends MapQueryValues {
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

  int? get number {
    return (values['number'] as int?);
  }

  set number(int? value) => values['number'] = value;

  String? get type {
    return (values['type'] as String?);
  }

  set type(String? value) => values['type'] = value;

  String get address {
    return (values['address'] as String);
  }

  set address(String value) => values['address'] = value;

  String? get complementAddress {
    return (values['complement_address'] as String?);
  }

  set complementAddress(String? value) => values['complement_address'] = value;

  String? get postCode {
    return (values['post_code'] as String?);
  }

  set postCode(String? value) => values['post_code'] = value;

  String? get city {
    return (values['city'] as String?);
  }

  set city(String? value) => values['city'] = value;

  String? get country {
    return (values['country'] as String?);
  }

  set country(String? value) => values['country'] = value;

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  int get personId {
    return (values['person_id'] as int);
  }

  set personId(int value) => values['person_id'] = value;

  int get itineraryId {
    return (values['itinerary_id'] as int);
  }

  set itineraryId(int value) => values['itinerary_id'] = value;

  void copyFrom(Address model) {
    updatedAt = model.updatedAt;
    idInt = model.idInt;
    number = model.number;
    type = model.type;
    address = model.address;
    complementAddress = model.complementAddress;
    postCode = model.postCode;
    city = model.city;
    country = model.country;
    createdAt = model.createdAt;
    if (model.person != null) {
      values['person_id'] = model.person?.id;
    }
    if (model.itinerary != null) {
      values['itinerary_id'] = model.itinerary?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class AddressModel  extends Address {
  AddressModel (
    {
    this.id,
    this.updatedAt,
    this.idInt,
    this.number,
    this.type,
    required this.address,
    this.complementAddress,
    this.postCode,
    this.city,
    this.country,
    this.createdAt,
    this.person,
    this.itinerary,
  }) : super(idInt: idInt,
      type: type,
      address: address,
      complementAddress:  complementAddress,
      postCode:  postCode,
      city:city,
      country: country,
      person:  person,
      itinerary: itinerary,
      createdAt: createdAt);

  @override
  String? id;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  int? idInt;

  @override
  int? number;

  @override
  String? type;

  @override
  String address;

  @override
  String? complementAddress;

  @override
  String? postCode;

  @override
  String? city;

  @override
  String? country;

  @override
  DateTime? createdAt;

  @override
  Person? person;

  @override
  Itinerary? itinerary;

  AddressModel copyWith(
     {
    String? id,
    DateTime? updatedAt,
    int? idInt,
    int? number,
    String? type,
    String? address,
    String? complementAddress,
    String? postCode,
    String? city,
    String? country,
    DateTime? createdAt,
    Person? person,
    Itinerary? itinerary,
  }) {
    return AddressModel(
        id: id ?? this.id,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        number: number ?? this.number,
        type: type ?? this.type,
        address: address ?? this.address,
        complementAddress: complementAddress ?? this.complementAddress,
        postCode: postCode ?? this.postCode,
        city: city ?? this.city,
        country: country ?? this.country,
        createdAt: createdAt ?? this.createdAt,
        person: person ?? this.person,
        itinerary: itinerary ?? this.itinerary);
  }

  @override
  bool operator ==(other) {
    return other is Address &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.number == number &&
        other.type == type &&
        other.address == address &&
        other.complementAddress == complementAddress &&
        other.postCode == postCode &&
        other.city == city &&
        other.country == country &&
        other.createdAt == createdAt &&
        other.person == person &&
        other.itinerary == itinerary;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      updatedAt,
      idInt,
      number,
      type,
      address,
      complementAddress,
      postCode,
      city,
      country,
      createdAt,
      person,
      itinerary,
    ]);
  }

  @override
  String toString() {
    return 'Address(id=$id, updatedAt=$updatedAt, idInt=$idInt, number=$number, type=$type, address=$address, complementAddress=$complementAddress, postCode=$postCode, city=$city, country=$country, createdAt=$createdAt, person=$person, itinerary=$itinerary)';
  }

  Map<String, dynamic> toJson() {
    return AddressSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class AddressSerializer {
  static Address fromMap(
    Map map

  ) {
    return AddressModel(id: map['id'] as String?,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        idInt: map['id_int'] as int?,
        number: map['number'] as int?,
        type: map['type'] as String?,
        address: map['address'] as String,
        complementAddress: map['complement_address'] as String?,
        postCode: map['post_code'] as String?,
        city: map['city'] as String?,
        country: map['country'] as String?,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        person: map['person'] != null
            ? PersonSerializer.fromMap(map['person'] as Map)
            : null,
        itinerary: map['itinerary'] != null ? ItinerarySerializer.fromMap(map['itinerary'] as Map) as Itinerary
            : null);
  }

  static Map<String, dynamic> toMap(Address? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'number': model.number,
      'type': model.type,
      'address': model.address,
      'complement_address': model.complementAddress,
      'post_code': model.postCode,
      'city': model.city,
      'country': model.country,
      'created_at': model.createdAt?.toIso8601String(),
      'person': PersonSerializer.toMap(model.person),
      'itinerary': ItinerarySerializer.toMap(model.itinerary)
    };
  }
}

abstract class AddressFields {
  static const List<String> allFields = <String>[
    id,
    updatedAt,
    idInt,
    number,
    type,
    address,
    complementAddress,
    postCode,
    city,
    country,
    createdAt,
    person,
    itinerary,
  ];

  static const String id = 'id';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String number = 'number';

  static const String type = 'type';

  static const String address = 'address';

  static const String complementAddress = 'complement_address';

  static const String postCode = 'post_code';

  static const String city = 'city';

  static const String country = 'country';

  static const String createdAt = 'created_at';

  static const String person = 'person';

  static const String itinerary = 'itinerary';
}
