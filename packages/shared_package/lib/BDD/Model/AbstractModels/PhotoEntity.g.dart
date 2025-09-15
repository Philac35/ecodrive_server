// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PhotoEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class PhotoMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('photos', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('title', length: 64);
      table.varChar('uri', length: 128);
      table.varChar('description', length: 256);
      table.declareColumn(
        'photo',
        Column(type: ColumnType('json'), length: 255),
      );
      table.declare('person_id', ColumnType('int')).references('people', 'id');
      table
          .declare('vehicule_id', ColumnType('int'))
          .references('vehicules', 'id');
      table
          .declare('driving_licence_id', ColumnType('int'))
          .references('driving_licences', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('photos');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************
 
class PhotoQuery extends Query<Photo, PhotoQueryWhere> {
  PhotoQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};

    bool isActive = !(trampoline?.contains(tableName) ?? false);//Prevent recurion


    trampoline.add(tableName);
    _where = PhotoQueryWhere(this);
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
        'address_id',
        'photo_id',
        'auth_user_id',
        'user_id',
      ],
      trampoline: trampoline,
    );

    leftJoin(
      _vehicule = VehiculeQuery(trampoline: trampoline, parent: this),
      'vehicule_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'brand',
        'modele',
        'color',
        'energy',
        'immatriculation',
        'first_immatriculation',
        'nb_places',
        'driver_id',
        'preferences',
      ],
      trampoline: trampoline,
    );

    leftJoin(
      _drivingLicence = DrivingLicenceQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'driving_licence_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
        'driver_id',
        'identification_number',
        'document_pdf',
        'title',
      ],
      trampoline: trampoline,
    );}
  }

  @override
  final PhotoQueryValues values = PhotoQueryValues();

  List<String> _selectedFields = [];

  PhotoQueryWhere? _where;

  late PersonQuery _person;

  late VehiculeQuery _vehicule;

  late DrivingLicenceQuery _drivingLicence;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'photos';
  }

  @override
  List<String> get fields {
    const localFields = [
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
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  PhotoQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  PhotoQueryWhere? get where {
    return _where;
  }

  @override
  PhotoQueryWhere newWhereClause() {
    return PhotoQueryWhere(this);
  }

  Optional<Photo> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Photo(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      title: fields.contains('title') ? (row[3] as String?) : null,
      uri: fields.contains('uri') ? (row[4] as String?) : null,
      description: fields.contains('description') ? (row[5] as String?) : null,
      photo: fields.contains('photo')
          ? Uint8ListJsonConverter().jsonStrToUint(row[6])
          : null,
    );
    if (row.length > 10) {
      var modelOpt = PersonQuery().parseRow(row.skip(10).take(15).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    if (row.length > 26) {
      var modelOpt = VehiculeQuery().parseRow(row.skip(26).take(12).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(vehicule: m);
      });
    }
    if (row.length > 39) {
      var modelOpt = DrivingLicenceQuery().parseRow(
        row.skip(39).take(8).toList(),
      );
      modelOpt.ifPresent((m) {
        model = model.copyWith(drivingLicence: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Photo> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }

  VehiculeQuery get vehicule {
    return _vehicule;
  }

  DrivingLicenceQuery get drivingLicence {
    return _drivingLicence;
  }
}

class PhotoQueryWhere extends QueryWhere {
  PhotoQueryWhere(PhotoQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        title = StringSqlExpressionBuilder(query, 'title'),
        uri = StringSqlExpressionBuilder(query, 'uri'),
        description = StringSqlExpressionBuilder(query, 'description'),
        photo = ListSqlExpressionBuilder(query, 'photo'),
        personId = NumericSqlExpressionBuilder<int>(query, 'person_id'),
        vehiculeId = NumericSqlExpressionBuilder<int>(query, 'vehicule_id'),
        drivingLicenceId = NumericSqlExpressionBuilder<int>(
          query,
          'driving_licence_id',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder title;

  final StringSqlExpressionBuilder uri;

  final StringSqlExpressionBuilder description;

  final ListSqlExpressionBuilder photo;

  final NumericSqlExpressionBuilder<int> personId;

  final NumericSqlExpressionBuilder<int> vehiculeId;

  final NumericSqlExpressionBuilder<int> drivingLicenceId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      title,
      uri,
      description,
      photo,
      personId,
      vehiculeId,
      drivingLicenceId,
    ];
  }
}

class PhotoQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'photo': 'json'};
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

  String? get title {
    return (values['title'] as String?);
  }

  set title(String? value) => values['title'] = value;

  String? get uri {
    return (values['uri'] as String?);
  }

  set uri(String? value) => values['uri'] = value;

  String? get description {
    return (values['description'] as String?);
  }

  set description(String? value) => values['description'] = value;

  Uint8List? get photo {
    return json.decode((values['photo'] as String)).cast();
  }

  set photo(Uint8List? value) => values['photo'] = json.encode(value);

  int get personId {
    return (values['person_id'] as int);
  }

  set personId(int value) => values['person_id'] = value;

  int get vehiculeId {
    return (values['vehicule_id'] as int);
  }

  set vehiculeId(int value) => values['vehicule_id'] = value;

  int get drivingLicenceId {
    return (values['driving_licence_id'] as int);
  }

  set drivingLicenceId(int value) => values['driving_licence_id'] = value;

  void copyFrom(Photo model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    title = model.title;
    uri = model.uri;
    description = model.description;
    photo = model.photo;
    if (model.person != null) {
      values['person_id'] = model.person?.id;
    }
    if (model.vehicule != null) {
      values['vehicule_id'] = model.vehicule?.id;
    }
    if (model.drivingLicence != null) {
      values['driving_licence_id'] = model.drivingLicence?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Photo extends PhotoEntity {
  Photo(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.title,
      this.uri,
      this.description,
      this.photo,
      this.person,
      this.personId,
      this.vehicule,
      this.vehiculeId,
      this.drivingLicence,
      this.drivingLicenceId});

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
  String? title;

  @override
  String? uri;

  @override
  String? description;

  @override
  Uint8List? photo;

  @override
  PersonEntity? person;

  @override
  int? personId;

  @override
  VehiculeEntity? vehicule;

  @override
  int? vehiculeId;

  @override
  DrivingLicenceEntity? drivingLicence;

  @override
  int? drivingLicenceId;

  Photo copyWith(
      {String? id,
      DateTime? createdAt,
      DateTime? updatedAt,
      String? title,
      String? uri,
      String? description,
      Uint8List? photo,
      int? photoId,
      PersonEntity? person,
      int? personId,
      VehiculeEntity? vehicule,
      int? vehiculeId,
      DrivingLicenceEntity? drivingLicence,
      int? drivingLicenceId}) {
    return Photo(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      uri: uri ?? this.uri,
      description: description ?? this.description,
      photo: photo ?? this.photo,
      person: person ?? this.person,
      personId: personId ?? this.personId,
      vehicule: vehicule ?? this.vehicule,
      vehiculeId: vehiculeId ?? this.vehiculeId,
      drivingLicence: drivingLicence ?? this.drivingLicence,
      drivingLicenceId: drivingLicenceId ?? this.drivingLicenceId,
    );
  }

  @override
  bool operator ==(other) {
    return other is PhotoEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.title == title &&
        other.uri == uri &&
        other.description == description &&
        ListEquality().equals(other.photo, photo) &&
        other.person == person &&
        other.personId == personId &&
        other.vehicule == vehicule &&
        other.vehiculeId == vehiculeId &&
        other.drivingLicence == drivingLicence &&
        other.drivingLicenceId == drivingLicenceId;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      title,
      uri,
      description,
      photo,
      person,
      vehicule,
      drivingLicence,
    ]);
  }

  @override
  String toString() {
    return 'Photo(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, title=$title, uri=$uri, description=$description, photo=$photo, person=$person,personId=$personId, vehicule=$vehicule, vehiculeId=$vehiculeId,drivingLicence=$drivingLicence,drivingLicenceId=$drivingLicenceId)';
  }

  Map<String, dynamic> toJson() {
    return PhotoSerializer.toMap(this)!;
  }




Map<String, Map<String,dynamic>> get accessors => {
  'id': {"get":id,"set":(val) => id = val}, 
'cascadeTempKey': {"get":cascadeTempKey,"set":(val) => cascadeTempKey = val}, 
'createdAt': {"get":createdAt,"set":(val) => createdAt = val}, 
'updatedAt': {"get":updatedAt,"set":(val) => updatedAt = val}, 
'title': {"get":title,"set":(val) => title = val}, 
'uri': {"get":uri,"set":(val) => uri = val}, 
'description': {"get":description,"set":(val) => description = val}, 
'photo': {"get":photo,"set":(val) => photo = val}, 
'person': {"get":person,"set":(val) => person = val}, 
'personId': {"get":personId,"set":(val) => personId = val}, 
'vehicule': {"get":vehicule,"set":(val) => vehicule = val}, 
'vehiculeId': {"get":vehiculeId,"set":(val) => vehiculeId = val}, 
'drivingLicence': {"get":drivingLicence,"set":(val) => drivingLicence = val}, 
'drivingLicenceId': {"get":drivingLicenceId,"set":(val) => drivingLicenceId = val}, 
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

const PhotoSerializer photoSerializer = PhotoSerializer();

class PhotoEncoder extends Converter<Photo, Map> {
  const PhotoEncoder();

  @override
  Map convert(Photo model) => PhotoSerializer.toMap(model)!;
}

class PhotoDecoder extends Converter<Map, Photo> {
  const PhotoDecoder();

  @override
  Photo convert(Map map) => PhotoSerializer.fromMap(map);
}

class PhotoSerializer extends Codec<Photo, Map> {
  const PhotoSerializer();

  @override
  PhotoEncoder get encoder => const PhotoEncoder();

  @override
  PhotoDecoder get decoder => const PhotoDecoder();

  static Photo fromMap(Map map) {
    map = StringLib().camelToSnakeKeyFromMap(map);

    return Photo(
      id: map['id'] as String?,
      createdAt: map['created_at'] != null
          ? (map['created_at'] is DateTime
              ? (map['created_at'] as DateTime)
              : DateTime.parse(map['created_at'].toString()))
          : null,
      updatedAt: map['updated_at'] != null
          ? (map['updated_at'] is DateTime
              ? (map['updated_at'] as DateTime)
              : DateTime.parse(map['updated_at'].toString()))
          : null,
      title: map['title'] as String?,
      uri: map['uri'] as String?,
      description: map['description'] as String?,
      photo: map['photo'] is Uint8List
          ? (map['photo'] as Uint8List)
          : (map['photo'] is Iterable<int>
              ? Uint8List.fromList((map['photo'] as Iterable<int>).toList())
              : (map['photo'] is String
                  ? Uint8List.fromList(
                      base64.decode(map['photo'] as String),
                    )
                  : null)),
      person: map['person'] != null
          ? PersonSerializer.fromMap(map['person'] as Map)
          : null,
      personId: map['person_id'] != null
          ? map['person_id'] is String
              ? int.parse(map['person_id'])
              : map['person_id']
          : null,
      vehicule: map['vehicule'] != null
          ? VehiculeSerializer.fromMap(map['vehicule'] as Map)
          : null,
      vehiculeId: map['vehicule_id'] != null
          ? map['vehicule_id'] is String
              ? int.parse(map['vehicule_id'])
              : map['vehicule_id']
          : null,
      drivingLicence: map['driving_licence'] != null
          ? DrivingLicenceSerializer.fromMap(map['driving_licence'] as Map)
          : null,
      drivingLicenceId: map['driving_licence_id'] != null
          ? map['driving_licence_id'] is String
              ? int.parse(map['driving_licence_id'])
              : map['driving_Licence_id']
          : null,
    );
  }

  static Map<String, dynamic>? toMap(PhotoEntity? model) {
    if (model == null) {
      return null;
      throw FormatException(
          "PhotoEntity L553,Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'title': model.title,
      'uri': model.uri,
      'description': model.description,
      'photo': model.photo != null ? base64.encode(model.photo!) : null,
      'person': PersonSerializer.toMap(model.person),
      'personId': model.personId,
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
      'vehiculeId': model.vehiculeId,
      'drivingLicence': DrivingLicenceSerializer.toMap(model.drivingLicence),
      'drivingLicenceId': model.drivingLicenceId
    };
  }
}

abstract class PhotoFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    title,
    uri,
    description,
    photo,
    person,
    personId,
    vehicule,
    vehiculeId,
    drivingLicence,
    drivingLicenceId
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String title = 'title';

  static const String uri = 'uri';

  static const String description = 'description';

  static const String photo = 'photo';

  static const String person = 'person';

  static const String personId = 'person_id';

  static const String vehicule = 'vehicule';

  static const String vehiculeId = 'vehicule_id';

  static const String drivingLicence = 'driving_licence';

  static const String drivingLicenceId = 'driving_licence_id';
}
