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
      table.integer('id_int');
      table.integer('identification_number');
      table.declareColumn(
        'document_pdf',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.varChar('title', length: 64);
      table.declare('driver_id', ColumnType('int')).references('people', 'id');
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
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = DrivingLicenceQueryWhere(this);
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
  final DrivingLicenceQueryValues values = DrivingLicenceQueryValues();

  List<String> _selectedFields = [];

  DrivingLicenceQueryWhere? _where;

  late PersonQuery _driver;

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
      'id_int',
      'driver_id',
      'identification_number',
      'document_pdf',
      'title',
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
      id_Int: fields.contains('id_int') ? mapToInt(row[3]) : null,
      identificationNumber:
          fields.contains('identification_number') ? mapToInt(row[5]) : 0,
      documentPdf:
          fields.contains('document_pdf') ? (row[6] as Uint8List?) : null,
      title: fields.contains('title') ? (row[7] as String) : '',
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
      id_Int = NumericSqlExpressionBuilder<int>(query, 'id_int'),
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id'),
      identificationNumber = NumericSqlExpressionBuilder<int>(
        query,
        'identification_number',
      ),
      documentPdf = ListSqlExpressionBuilder(query, 'document_pdf'),
      title = StringSqlExpressionBuilder(query, 'title');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> id_Int;

  final NumericSqlExpressionBuilder<int> driverId;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final ListSqlExpressionBuilder documentPdf;

  final StringSqlExpressionBuilder title;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      id_Int,
      driverId,
      identificationNumber,
      documentPdf,
      title,
    ];
  }
}

class DrivingLicenceQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'document_pdf': 'jsonb'};
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

  int? get id_Int {
    return (values['id_int'] as int?);
  }

  set id_Int(int? value) => values['id_int'] = value;

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
    return json.decode((values['document_pdf'] as String)).cast();
  }

  set documentPdf(Uint8List? value) =>
      values['document_pdf'] = json.encode(value);

  String get title {
    return (values['title'] as String);
  }

  set title(String value) => values['title'] = value;

  void copyFrom(DrivingLicence model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    id_Int = model.id_Int;
    identificationNumber = model.identificationNumber;
    documentPdf = model.documentPdf;
    title = model.title;
    if (model.driver != null) {
      values['driver_id'] = model.driver?.id;
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
    this.id_Int,
    this.driver,
    required this.identificationNumber,
    this.documentPdf,
    this.photo,
    required this.title,
  });

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
  int? id_Int;

  @override
  DriverEntity? driver;

  @override
  int identificationNumber;

  @override
  Uint8List? documentPdf;

  @override
  PhotoEntity? photo;

  @override
  String title;

  DrivingLicence copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? id_Int,
    DriverEntity? driver,
    int? identificationNumber,
    Uint8List? documentPdf,
    PhotoEntity? photo,
    String? title,
  }) {
    return DrivingLicence(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      id_Int: id_Int ?? this.id_Int,
      driver: driver ?? this.driver,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      title: title ?? this.title,
    );
  }

  @override
  bool operator ==(other) {
    return other is DrivingLicenceEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.driver == driver &&
        other.identificationNumber == identificationNumber &&
        ListEquality().equals(other.documentPdf, documentPdf) &&
        other.photo == photo &&
        other.title == title;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      id_Int,
      driver,
      identificationNumber,
      documentPdf,
      photo,
      title,
    ]);
  }

  @override
  String toString() {
    return 'DrivingLicence(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, id_Int=$id_Int, driver=$driver, identificationNumber=$identificationNumber, documentPdf=$documentPdf, photo=$photo, title=$title)';
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
      id_Int: map['id_int'] as int?,
      driver:
          map['driver'] != null
              ? DriverSerializer.fromMap(map['driver'] as Map)
              : null,
      identificationNumber: map['identification_number'] as int,
      documentPdf:
          map['document_pdf'] is Uint8List
              ? (map['document_pdf'] as Uint8List)
              : (map['document_pdf'] is Iterable<int>
                  ? Uint8List.fromList(
                    (map['document_pdf'] as Iterable<int>).toList(),
                  )
                  : (map['document_pdf'] is String
                      ? Uint8List.fromList(
                        base64.decode(map['document_pdf'] as String),
                      )
                      : null)),
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      title: map['title'] as String,
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
      'identification_number': model.identificationNumber,
      'document_pdf':
          model.documentPdf != null ? base64.encode(model.documentPdf!) : null,
      'photo': PhotoSerializer.toMap(model.photo),
      'title': model.title,
    };
  }
}

abstract class DrivingLicenceFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    id_Int,
    driver,
    identificationNumber,
    documentPdf,
    photo,
    title,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String id_Int = 'id_int';

  static const String driver = 'driver';

  static const String identificationNumber = 'identification_number';

  static const String documentPdf = 'document_pdf';

  static const String photo = 'photo';

  static const String title = 'title';
}
