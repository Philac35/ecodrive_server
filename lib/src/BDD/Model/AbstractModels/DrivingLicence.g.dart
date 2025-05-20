// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DrivingLicence.dart';

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
      table.varChar('title', length: 255);
      table.varChar('document_pdf', length: 255);
      table.varChar('photo', length: 255);
      table
          .declare('driver_id', ColumnType('int'))
          .references('f_angel_models', 'id');
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

class DrivingLicenceQuery extends Query<DrivingLicence, DrivingLicenceQueryWhere> {
  DrivingLicenceQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = DrivingLicenceQueryWhere(this);
  }

  @override
  final DrivingLicenceQueryValues values = DrivingLicenceQueryValues();

  List<String> _selectedFields = [];

  DrivingLicenceQueryWhere? _where;

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
    const _fields = [
      'id',
      'created_at',
      'updated_at',
      'identification_number',
      'title',
      'document_pdf',
      'photo',
      'driver_id',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
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
    var model = DrivingLicenceModel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
      fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
      fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      identificationNumber:
      fields.contains('identification_number') ? mapToInt(row[3]) : null,
      title: fields.contains('title') ? (row[4] as String?) : null,
      documentPdf: fields.contains('document_pdf') ? (row[5] as String?) : null,
      photo: fields.contains('photo') ? (row[6] as String?) : null,
      driverId: fields.contains('driver_id') ? mapToInt(row[7]) : null,
    );
    return Optional.of(model as DrivingLicence);
  }

  @override
  Optional<DrivingLicence> deserialize(List row) {
    return parseRow(row);
  }
}

class DrivingLicenceQueryWhere extends QueryWhere {
  DrivingLicenceQueryWhere(DrivingLicenceQuery query)
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
        identificationNumber = NumericSqlExpressionBuilder<int>(
          query,
          'identification_number',
        ),
        title = StringSqlExpressionBuilder(
          query,
          'title',
        ),
        documentPdf = StringSqlExpressionBuilder(
          query,
          'document_pdf',
        ),
        photo = StringSqlExpressionBuilder(
          query,
          'photo',
        ),
        driverId = NumericSqlExpressionBuilder<int>(
          query,
          'driver_id',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final StringSqlExpressionBuilder title;

  final StringSqlExpressionBuilder documentPdf;

  final StringSqlExpressionBuilder photo;

  final NumericSqlExpressionBuilder<int> driverId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      identificationNumber,
      title,
      documentPdf,
      photo,
      driverId,
    ];
  }
}

class DrivingLicenceQueryValues extends MapQueryValues {
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

  int? get identificationNumber {
    return (values['identification_number'] as int?);
  }

  set identificationNumber(int? value) =>
      values['identification_number'] = value;

  String? get title {
    return (values['title'] as String?);
  }

  set title(String? value) => values['title'] = value;

  String? get documentPdf {
    return (values['document_pdf'] as String?);
  }

  set documentPdf(String? value) => values['document_pdf'] = value;

  String? get photo {
    return (values['photo'] as String?);
  }

  set photo(String? value) => values['photo'] = value;

  int? get driverId {
    return (values['driver_id'] as int?);
  }

  set driverId(int? value) => values['driver_id'] = value;

  void copyFrom(DrivingLicenceModel model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    identificationNumber = model.identificationNumber;
    title = model.title;
    documentPdf = model.documentPdf;
    photo = model.photo;
    driverId = model.driverId;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class DrivingLicenceModel {


  DrivingLicenceModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.identificationNumber,
    this.title,
    this.documentPdf,
    this.photo,
    this.driverId,
  });

  final String? id;

  /// The time at which this item was created.
  final DateTime? createdAt;

  /// The last time at which this item was updated.
  final DateTime? updatedAt;

  final int? identificationNumber;

  final String? title;

  final String? documentPdf;

  final String? photo;

  final int? driverId;

  DrivingLicenceModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? identificationNumber,
    String? title,
    String? documentPdf,
    String? photo,
    int? driverId,
  }) {
    return DrivingLicenceModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      title: title ?? this.title,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      driverId: driverId ?? this.driverId,
    );
  }

  @override
  bool operator ==(other) {
    return other is DrivingLicenceModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.identificationNumber == identificationNumber &&
        other.title == title &&
        other.documentPdf == documentPdf &&
        other.photo == photo &&
        other.driverId== driverId;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      identificationNumber,
      title,
      documentPdf,
      photo,
      driverId,
    ]);
  }

  @override
  String toString() {
    return 'DrivingLicence(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, identificationNumber=$identificationNumber, title=$title, documentPdf=$documentPdf, photo=$photo, driverId=$driverId)';
  }

  Map<String, dynamic> toJson() {
    return DrivingLicenceSerializer.toMap(this as DrivingLicence?);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class DrivingLicenceSerializer {
  static DrivingLicenceModel fromMap(Map map) {
    return DrivingLicenceModel(
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
      identificationNumber: map['identification_number'] as int?,
      title: map['title'] as String?,
      documentPdf: map['document_pdf'] as String?,
      photo: map['photo'] as String?,
      driverId: map['driver_id'] as int?,
    );
  }

  static Map<String, dynamic> toMap(DrivingLicence? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'identification_number': model.identificationNumber,
      'title': model.title,
      'document_pdf': model.documentPdf,
      'photo': model.photo,
      'driver_id': model.driver?.idInt,
    };
  }
}

abstract class DrivingLicenceFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    identificationNumber,
    title,
    documentPdf,
    photo,
    driverId,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String identificationNumber = 'identification_number';

  static const String title = 'title';

  static const String documentPdf = 'document_pdf';

  static const String photo = 'photo';

  static const String driverId = 'driver_id';
}
