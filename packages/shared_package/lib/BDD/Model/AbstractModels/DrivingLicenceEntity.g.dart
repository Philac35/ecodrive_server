// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DrivingLicenceEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class DrivingLicenceMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('driving_licences', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('identification_number');
      table.declareColumn(
        'document_pdf',
        Column(type: ColumnType('json'), length: 255),
      );
      table.varChar('title', length: 64);
      table.varChar("path", length:256);
      table.declare('driver_id', ColumnType('int')).references('people', 'id');
      table.declare('photo_id', ColumnType('int')).references('photos', 'id');

    });
  }

  @override
  void down(Schema schema) {
    schema.drop('driving_licences', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class DrivingLicenceQuery
    extends Query<DrivingLicence, DrivingLicenceQueryWhere> {
  DrivingLicenceQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};    bool isActive = !(trampoline?.contains(tableName) ?? false);

    trampoline ??= <String>{};

    trampoline.add(tableName);
    _where = DrivingLicenceQueryWhere(this);
if(isActive){
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
      ],
      trampoline: trampoline,
    );
  }
  }

  @override
  final DrivingLicenceQueryValues values = DrivingLicenceQueryValues();

  List<String> _selectedFields = [];

  DrivingLicenceQueryWhere? _where;

  late PersonQuery _driver;
  late PhotoQuery _photo;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'driving_licences';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'driver_id',
      'identification_number',
      'document_pdf',
      'photo_id',
      'title',
      'path'
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  DrivingLicenceQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  DrivingLicenceQueryWhere? get where {
    return _where;
  }

  @override
  DrivingLicenceQueryWhere newWhereClause() {
    return DrivingLicenceQueryWhere(this);
  }

  Optional<DrivingLicence> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = DrivingLicence(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      identificationNumber:
          fields.contains('identification_number') ? mapToInt(row[3]) : 0,
      documentPdf:
          fields.contains('document_pdf') ? Uint8ListJsonConverter().jsonStrToUint(row[4]) : null,
      photoId: fields.contains('photo_id')? int.parse(row[5]): null,
      title: fields.contains('title') ? (row[6] as String) : '',
      path: fields.contains('path') ? (row[7] as String) : '',

    );
    if (row.length > 8) {
      var modelOpt = PersonQuery().parseRow(row.skip(8).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(driver: m as DriverEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<DrivingLicence> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get driver {
    return _driver;
  }
}

class DrivingLicenceQueryWhere extends QueryWhere {
  DrivingLicenceQueryWhere(DrivingLicenceQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id'),
      identificationNumber = NumericSqlExpressionBuilder<int>(
        query,
        'identification_number',
      ),
      documentPdf = ListSqlExpressionBuilder(query, 'document_pdf'),
      photoId = NumericSqlExpressionBuilder<int>(query, 'photo_id'),
      title = StringSqlExpressionBuilder(query, 'title'),
      path = StringSqlExpressionBuilder(query, 'path');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> driverId;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final ListSqlExpressionBuilder documentPdf;

  final NumericSqlExpressionBuilder<int> photoId;

  final StringSqlExpressionBuilder title;

  final StringSqlExpressionBuilder path;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      driverId,
      identificationNumber,
      documentPdf,
      photoId,
      title,
      path
    ];
  }
}

class DrivingLicenceQueryValues extends MapQueryValues {
  /*@override
  Map<String, String> get casts {
    return {'document_pdf': 'json'};
  }*/

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

  Driver get driver {
    return values['driver_id'] ;
  }

  set driver(Driver value) => values['driver_id'] = value;

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

  int get identificationNumber {
    return (values['identification_number'] as int);
  }

  set identificationNumber(int value) =>
      values['identification_number'] = value;

  Uint8List? get documentPdf {
    return json.decode((values['document_pdf'] )).cast();
  }

  set documentPdf(Uint8List? value) =>
      values['document_pdf'] = json.encode(value);

  Photo? get photo {
    return values['photo'] ;
  }

  set photo(Photo? value) =>
      values['photo'] = value;


  int? get photoId {
    return values['photo_id'] ;
  }

  set photoId(int? value) =>
      values['photo_id'] = value;

  String get title {
    return (values['title'] as String);
  }

  set title(String? value) => values['title'] = value;

  String get path {
    return (values['path'] as String);
  }

  set path(String? value) => values['path'] = value;


  void copyFrom(DrivingLicence model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    identificationNumber = model.identificationNumber!;
    documentPdf = model.documentPdf;
    if (model.photoId != null) {
      values['photo_id'] = model.photo?.id;
    }
    if (model.photo != null) {
      values['photo'] = model.photo;
    }
    title = model.title;
    path = model.path;
    if (model.driverId != null) {
      values['driver_id'] = model.driver?.id;
    }
    if (model.driver != null) {
      values['driver'] = model.driver;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class DrivingLicence extends DrivingLicenceEntity {
  DrivingLicence({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.driverId,
    required this.identificationNumber,
    this.documentPdf,
    this.photo,
    this.photoId,
    required this.title,
    this.path
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
  DriverEntity? driver;
  int? driverId;

  @override
  int? identificationNumber;

  @override
  Uint8List? documentPdf;

  @override
  String? path;

  @override
  PhotoEntity? photo;
  int? photoId;

  @override
  String? title;

  DrivingLicence copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DriverEntity? driver,
    int? driverId,
    int? identificationNumber,
    Uint8List? documentPdf,
    PhotoEntity? photo,
    int? photoId,
    String? title,
    String? path

  }) {
    return DrivingLicence(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driver: driver ?? this.driver,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
      title: title ?? this.title,
      path: path ?? this.path,
    );
  }

  @override
  bool operator ==(other) {
    return other is DrivingLicenceEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.driver == driver &&
        other.driverId == driverId &&
        other.identificationNumber == identificationNumber &&
        ListEquality().equals(other.documentPdf, documentPdf) &&
        other.photo == photo &&
        other.photoId == photoId &&
        other.title == title &&
        other.path == path;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      driver,
      driverId,
      identificationNumber,
      documentPdf,
      photo,
      photoId,
      title,
      path
    ]);
  }

  @override
  String toString() {
    return 'DrivingLicence(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, driver=$driver, driverId=$driverId, identificationNumber=$identificationNumber, documentPdf=$documentPdf, photo=$photo,photoId=$photoId , title=$title, path=$path)';
  }

  Map<String, dynamic> toJson() {
    return DrivingLicenceSerializer.toMap(this)!;
  }



}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const DrivingLicenceSerializer drivingLicenceSerializer =
    DrivingLicenceSerializer();

class DrivingLicenceEncoder extends Converter<DrivingLicence, Map> {
  const DrivingLicenceEncoder();

  @override
  Map convert(DrivingLicence model) => DrivingLicenceSerializer.toMap(model)!;
}

class DrivingLicenceDecoder extends Converter<Map, DrivingLicence> {
  const DrivingLicenceDecoder();

  @override
  DrivingLicence convert(Map map) => DrivingLicenceSerializer.fromMap(map);
}

class DrivingLicenceSerializer extends Codec<DrivingLicence, Map> {
  const DrivingLicenceSerializer();

  @override
  DrivingLicenceEncoder get encoder => const DrivingLicenceEncoder();

  @override
  DrivingLicenceDecoder get decoder => const DrivingLicenceDecoder();

  static DrivingLicence fromMap(Map map) {

    map=StringLib().camelToSnakeKeyFromMap(map);

    //map['identification_number']=map['identification_number']??map['identificationNumber'];

    return DrivingLicence(
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
              ? DriverSerializer.fromMap(map['driver'] as Map)
              : null,
      identificationNumber: map['identification_number'] as int,
      documentPdf:  map['document_pdf'] !=null ? Uint8ListJsonConverter().jsonStrToUint(map['document_pdf']):null,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      title: map['title'] as String,
      path: map['path'] as String
    );
  }

  static Map<String, dynamic>? toMap(DrivingLicenceEntity? model) {
    if (model == null) {
      return null;
      throw FormatException("DrivingLicenceEntity L448, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'driver': DriverSerializer.toMap(model.driver),
      'driverId': model.driverId,
      'identification_number': model.identificationNumber,
      'document_pdf':
          model.documentPdf != null ? base64.encode(model.documentPdf!) : null,
      'photo': PhotoSerializer.toMap(model.photo),
      'photoId':model.photoId,
      'title': model.title,
      'path': model.path
    };
  }
}

abstract class DrivingLicenceFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    driver,
    driverId,
    identificationNumber,
    documentPdf,
    photo,
    photoId,
    title,
    path
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String driver = 'driver';
  static const String driverId = 'driver_id';

  static const String identificationNumber = 'identification_number';

  static const String documentPdf = 'document_pdf';

  static const String photo = 'photo';
  static const String photoId = 'photo_id';

  static const String title = 'title';

  static const String path = 'path';
}
