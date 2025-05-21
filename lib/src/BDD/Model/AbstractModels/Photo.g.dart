// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Photo.dart';

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
      table.integer('id_int');
      table.varChar('title', length: 255);
      table.varChar('uri', length: 255);
      table.varChar('description', length: 255);
      table.declareColumn(
        'photo',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table
          .declare('person_id', ColumnType('int'))
          .references('f_angel_models', 'id');
      table
          .declare('vehicule_id', ColumnType('int'))
          .references('f_angel_models', 'id');
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
  PhotoQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = PhotoQueryWhere(this);
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
      _vehicule = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'vehicule_id',
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
  final PhotoQueryValues values = PhotoQueryValues();

  List<String> _selectedFields = [];

  PhotoQueryWhere? _where;

  late FAngelModelQuery _person;

  late FAngelModelQuery _vehicule;

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
    const _fields = [
      'id',
      'created_at',
      'updated_at',
      'id_int',
      'title',
      'uri',
      'description',
      'photo',
      'person_id',
      'vehicule_id',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
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
    PhotoModel? model = PhotoModel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[3]) : null,
      title: fields.contains('title') ? (row[4] as String?) : null,
      uri: fields.contains('uri') ? (row[5] as String?) : null,
      description: fields.contains('description') ? (row[6] as String?) : null,
      photo: fields.contains('photo') ? (row[7] as Uint8List?) : null,
    );
    if (row.length > 10) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(10).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(person: m) as PhotoModel?;
      });
    }
    if (row.length > 13) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(13).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(vehicule: m) as PhotoModel?;
      });
    }
    return Optional.of(model as Photo);
  }

  @override
  Optional<Photo> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get person {
    return _person;
  }

  FAngelModelQuery get vehicule {
    return _vehicule;
  }
}

class PhotoQueryWhere extends QueryWhere {
  PhotoQueryWhere(PhotoQuery query)
      : id = NumericSqlExpressionBuilder<int>(
          query,
          'id',
        ),
        createdAt = DateTimeSqlExpressionBuilder(
          query,
          'created_at',
        ),
        updatedAt = DateTimeSqlExpressionBuilder(
          query,
          'updated_at',
        ),
        idInt = NumericSqlExpressionBuilder<int>(
          query,
          'id_int',
        ),
        title = StringSqlExpressionBuilder(
          query,
          'title',
        ),
        uri = StringSqlExpressionBuilder(
          query,
          'uri',
        ),
        description = StringSqlExpressionBuilder(
          query,
          'description',
        ),
        photo = ListSqlExpressionBuilder(
          query,
          'photo',
        ),
        personId = NumericSqlExpressionBuilder<int>(
          query,
          'person_id',
        ),
        vehiculeId = NumericSqlExpressionBuilder<int>(
          query,
          'vehicule_id',
        ),
        drivingLicenceId = NumericSqlExpressionBuilder<int>(
          query,
          'drivingLicence_id',
  )
  ;

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

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
      idInt,
      title,
      uri,
      description,
      photo,
      personId,
      vehiculeId,
      drivingLicenceId
    ];
  }
}

class PhotoQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'photo': 'jsonb'};
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

  int? get idInt {
    return (values['id_int'] as int?);
  }

  set idInt(int? value) => values['id_int'] = value;

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
    return (values['vehicule_id'] as int);
  }

  set drivingLicenceId(int value) => values['drivingLicence_id'] = value;

  void copyFrom(Photo model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    idInt = model.idInt;
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
      values['drivingLicence_id'] = model.drivingLicence?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class PhotoModel extends Photo {
  PhotoModel(
    {
    this.id,
    this.createdAt,
    this.updatedAt,
    this.idInt,
    this.title,
    this.uri,
    this.description,
    this.photo,
    this.person,
    this.vehicule,
    this.drivingLicence
  }) : super(idInt: idInt, title:title,uri:  uri,description:  description,photo: photo,person: person,vehicule: vehicule,drivingLicence:drivingLicence);

  @override
  String? id;

  /// The time at which this item was created.
  @override
  DateTime? createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  int? idInt;

  @override
  String? title;

  @override
  String? uri;

  @override
  String? description;

  @override
  Uint8List? photo;

  @override
  Person? person;

  @override
  Vehicule? vehicule;

  @override
  DrivingLicence? drivingLicence;

  Photo copyWith(
    {
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? idInt,
    String? title,
    String? uri,
    String? description,
    Uint8List? photo,
    Person? person,
    Vehicule? vehicule,
    DrivingLicence? drivingLicence
  }) {
    return PhotoModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        title: title ?? this.title,
        uri: uri ?? this.uri,
        description: description ?? this.description,
        photo: photo ?? this.photo,
        person: person ?? this.person,
        vehicule: vehicule ?? this.vehicule,
        drivingLicence : drivingLicence ?? this.drivingLicence );
  }

  @override
  bool operator ==(other) {
    return other is Photo &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.title == title &&
        other.uri == uri &&
        other.description == description &&
        ListEquality().equals(other.photo, photo) &&
        other.person == person &&
        other.vehicule == vehicule &&
        other.drivingLicence == drivingLicence
    ;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      idInt,
      title,
      uri,
      description,
      photo,
      person,
      vehicule,
      drivingLicence
    ]);
  }

  @override
  String toString() {
    return 'Photo(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, idInt=$idInt, title=$title, uri=$uri, description=$description, photo=$photo, person=$person, vehicule=$vehicule,drivingLicence=$drivingLicence)';
  }

  Map<String, dynamic> toJson() {
    return PhotoSerializer.toMap(this);
  }
}




// **************************************************************************
// SerializerGenerator
// **************************************************************************
abstract class PhotoSerializer {
  static Photo fromMap(Map map) {
    var drivingLicencevar;
    if (map['drivingLicence'] != null) {
      drivingLicencevar = DrivingLicenceSerializer.fromMap(map['drivingLicence'] as Map);
    } else {
      drivingLicencevar = null;
    }
    return PhotoModel(
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
      idInt: map['id_int'] as int?,
      title: map['title'] as String?,
      uri: map['uri'] as String?,
      description: map['description'] as String?,
      photo: map['photo'] is Uint8List
          ? (map['photo'] as Uint8List)
          : (map['photo'] is Iterable<int>
          ? Uint8List.fromList((map['photo'] as Iterable<int>).toList())
          : (map['photo'] is String
          ? Uint8List.fromList(base64.decode(map['photo'] as String))
          : null)),
      person: map['person'] != null
          ? PersonSerializer.fromMap(map['person'] as Map)
          : null,
      vehicule: map['vehicule'] != null
          ? VehiculeSerializer.fromMap(map['vehicule'] as Map)
          : null,
      drivingLicence: drivingLicencevar,
    );
  }

  static Map<String, dynamic> toMap(Photo? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'title': model.title,
      'uri': model.uri,
      'description': model.description,
      'photo': model.photo != null ? base64.encode(model.photo!) : null,
      'person': PersonSerializer.toMap(model.person),
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
      'drivingLicence': DrivingLicenceSerializer.toMap(model.drivingLicence)
    };
  }
}


abstract class PhotoFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    idInt,
    title,
    uri,
    description,
    photo,
    person,
    vehicule,
    drivingLicence
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String title = 'title';

  static const String uri = 'uri';

  static const String description = 'description';

  static const String photo = 'photo';

  static const String person = 'person';

  static const String vehicule = 'vehicule';

  static const String drivingLicence = 'drivingLicence';
}
