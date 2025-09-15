// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AddressEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class AddressMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('addresses', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('number');
      table.varChar('type', length: 255);
      table.varChar('address', length: 255);
      table.varChar('complement_address', length: 255);
      table.varChar('post_code', length: 8);
      table.varChar('city', length: 64);
      table.varChar('country', length: 64);
      table.declare('person_id', ColumnType('int')).references('people', 'id');
      table.declare('itinerary_id', ColumnType('int')).references('itineraries', 'id');
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
  AddressQuery({super.parent, Set<String>? trampoline}) {
    bool isActive = !(trampoline?.contains(tableName) ?? false) ;// Prevent recursion
    trampoline ??= <String>{};

    trampoline.add(tableName);
    _where = AddressQueryWhere(this);
    if(isActive){
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
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _itinerary = ItineraryQuery(trampoline: trampoline, parent: this),
      'itinerary_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'price',
        'eco',
        'duration',
        'geo_point_list',
        'travel_id',
      ],
      trampoline: trampoline,
    );}
  }

  @override
  final AddressQueryValues values = AddressQueryValues();

  List<String> _selectedFields = [];

  AddressQueryWhere? _where;

 PersonQuery? _person;

  ItineraryQuery? _itinerary;

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
    const localFields = [
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
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
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
    var model = Address(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      number: fields.contains('number') ? mapToInt(row[3]) : null,
      type: fields.contains('type') ? (row[4] as String?) : null,
      address: fields.contains('address') ? (row[5] as String?) : '',
      complementAddress:
          fields.contains('complement_address') ? (row[6] as String?) : null,
      postCode: fields.contains('post_code') ? (row[7] as String?) : null,
      city: fields.contains('city') ? (row[8] as String?) : null,
      country: fields.contains('country') ? (row[9] as String?) : null,
      personId: fields.contains('person_id') && row[10]!=null ? int.parse(row[10]) : null,
      itineraryId: fields.contains('itinerary_id')&& row[11]!=null ? int.parse(row[11]) : null,
    );
    if (row.length > 12) {
      var modelOpt = PersonQuery().parseRow(row.skip(12).take(15).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    if (row.length > 28) {
      var modelOpt = ItineraryQuery().parseRow(row.skip(28).take(8).toList());
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

  PersonQuery? get person {
    return _person;
  }

  ItineraryQuery? get itinerary {
    return _itinerary;
  }
}

class AddressQueryWhere extends QueryWhere {
  AddressQueryWhere(AddressQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      personId = NumericSqlExpressionBuilder<int>(query, 'person_id'),
      itineraryId = NumericSqlExpressionBuilder<int>(query, 'itinerary_id'),
      number = NumericSqlExpressionBuilder<int>(query, 'number'),
      type = StringSqlExpressionBuilder(query, 'type'),
      address = StringSqlExpressionBuilder(query, 'address'),
      complementAddress = StringSqlExpressionBuilder(query, 'complement_address'),
      postCode = StringSqlExpressionBuilder(query, 'post_code'),
      city = StringSqlExpressionBuilder(query, 'city'),
      country = StringSqlExpressionBuilder(query, 'country');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> personId;

  final NumericSqlExpressionBuilder<int> itineraryId;

  final NumericSqlExpressionBuilder<int> number;

  final StringSqlExpressionBuilder type;

  final StringSqlExpressionBuilder address;

  final StringSqlExpressionBuilder complementAddress;

  final StringSqlExpressionBuilder postCode;

  final StringSqlExpressionBuilder city;

  final StringSqlExpressionBuilder country;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      personId,
      itineraryId,
      number,
      type,
      address,
      complementAddress,
      postCode,
      city,
      country,
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

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;
/*
  Person? get person{
    return (values['person'] as Person?);
  }

  set person(Person? value) => values['person'] = value;
*/
  int get personId {
    return (values['person_id'] as int);
  }

  set personId(int value) => values['person_id'] = value;

  int get itineraryId {
    return (values['itinerary_id'] as int);
  }

  set itineraryId(int value) => values['itinerary_id'] = value;

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

  set address(String? value) => values['address'] = value;

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

  void copyFrom(Address model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    number = model.number;
    type = model.type;
    address = model.address;
    complementAddress = model.complementAddress;
    postCode = model.postCode;
    city = model.city;
    country = model.country;
   /* if (model.person != null) {
      values['person_id'] = model.person?.id;
    } */
    if (model.personId != null) {  //It should have both personId and person
      values['person_id'] = model.personId;
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
class Address extends AddressEntity {
  Address({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.person,
    this.personId,
    this.itinerary,
    this.itineraryId,
    this.number,
    this.type,
    this.address, // was required in original Model
    this.complementAddress,
    this.postCode,
    this.city,
    this.country,
  });


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
  PersonEntity? person;

  @override
  int? personId;

  @override
  ItineraryEntity? itinerary;

  @override
  int? itineraryId;

  @override
  int? number;

  @override
  String? type;

  @override
  String? address;

  @override
  String? complementAddress;

  @override
  String? postCode;

  @override
  String? city;

  @override
  String? country;

  Address copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    PersonEntity? person,
    ItineraryEntity? itinerary,
    int? number,
    String? type,
    String? address,
    String? complementAddress,
    String? postCode,
    String? city,
    String? country,
  }) {
    return Address(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      person: person ?? this.person,
      itinerary: itinerary ?? this.itinerary,
      number: number ?? this.number,
      type: type ?? this.type,
      address: address ?? this.address,
      complementAddress: complementAddress ?? this.complementAddress,
      postCode: postCode ?? this.postCode,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  @override
  bool operator ==(other) {
    return other is AddressEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.person == person &&
        other.itinerary == itinerary &&
        other.number == number &&
        other.type == type &&
        other.address == address &&
        other.complementAddress == complementAddress &&
        other.postCode == postCode &&
        other.city == city &&
        other.country == country;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      person,
      itinerary,
      number,
      type,
      address,
      complementAddress,
      postCode,
      city,
      country,
    ]);
  }

  @override
  String toString() {
    return 'Address(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, person=$person, itinerary=$itinerary, number=$number, type=$type, address=$address, complementAddress=$complementAddress, postCode=$postCode, city=$city, country=$country)';
  }

  Map<String, dynamic>? toJson() {
    var a=AddressSerializer.toMap(this);
    print("Address ${a}");
    return a;
  }


Map<String, Map<String,dynamic>> get accessors => {
  'id': {"get":id,"set":(val) => id = val}, 
'cascadeTempKey': {"get":cascadeTempKey,"set":(val) => cascadeTempKey = val}, 
'createdAt': {"get":createdAt,"set":(val) => createdAt = val}, 
'updatedAt': {"get":updatedAt,"set":(val) => updatedAt = val}, 
'person': {"get":person,"set":(val) => person = val}, 
'personId': {"get":personId,"set":(val) => personId = val}, 
'itinerary': {"get":itinerary,"set":(val) => itinerary = val}, 
'itineraryId': {"get":itineraryId,"set":(val) => itineraryId = val}, 
'number': {"get":number,"set":(val) => number = val}, 
'type': {"get":type,"set":(val) => type = val}, 
'address': {"get":address,"set":(val) => address = val}, 
'complementAddress': {"get":complementAddress,"set":(val) => complementAddress = val}, 
'postCode': {"get":postCode,"set":(val) => postCode = val}, 
'city': {"get":city,"set":(val) => city = val}, 
'country': {"get":country,"set":(val) => country = val}, 
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

const AddressSerializer addressSerializer = AddressSerializer();

class AddressEncoder extends Converter<Address, Map> {
  const AddressEncoder();

  @override
  Map convert(Address model) => AddressSerializer.toMap(model)!;
}

class AddressDecoder extends Converter<Map, Address> {
  const AddressDecoder();

  @override
  Address convert(Map map) => AddressSerializer.fromMap(map);
}

class AddressSerializer extends Codec<Address, Map> {
  const AddressSerializer();

  @override
  AddressEncoder get encoder => const AddressEncoder();

  @override
  AddressDecoder get decoder => const AddressDecoder();


  static Address fromMap(Map map) {

    map=StringLib().camelToSnakeKeyFromMap(map);

    return Address(
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
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] as Map)
              : null,
      personId:  map['person_id'] != null?
                    int.parse( map['person_id'])
              :null,
      itinerary:
          map['itinerary'] != null
              ? ItinerarySerializer.fromMap(map['itinerary'] as Map)
              : null,
      itineraryId: map['itinerary_id'] != null?
                      int.parse( map['itinerary_id'])
                  :null,
      number: map['number'] as int?,
      type: map['type'] as String?,
      address: map['address'] as String?,
      complementAddress: map['complement_address'] as String?,
      postCode: map['post_code']??map['postCode'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
    );
  }

  static Map<String, dynamic>? toMap(AddressEntity? model) {
    if (model == null) {
      return null;
      throw FormatException("AddressEntity L552, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'person': PersonSerializer.toMap(model.person),
      'personId':model.personId,
      'itinerary': ItinerarySerializer.toMap(model.itinerary),
      'itineraryId':model.itineraryId,
      'number': model.number,
      'type': model.type,
      'address': model.address,
      'complement_address': model.complementAddress,
      'post_code': model.postCode,
      'city': model.city,
      'country': model.country,
    };
  }
}

abstract class AddressFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
  //  person,
    personId,
    itinerary,
    itineraryId,
    number,
    type,
    address,
    complementAddress,
    postCode,
    city,
    country,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  //static const String person = 'person';

  static const String personId = 'person_id';

  static const String itinerary = 'itinerary';

  static const String itineraryId = 'itinerary_id';

  static const String number = 'number';

  static const String type = 'type';

  static const String address = 'address';

  static const String complementAddress = 'complement_address';

  static const String postCode = 'post_code';

  static const String city = 'city';

  static const String country = 'country';
}
