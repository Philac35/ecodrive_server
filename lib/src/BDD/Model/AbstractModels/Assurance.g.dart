// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Assurance.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class AssuranceMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('assurances', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('driver', length: 255);
      table.integer('identification_number');
      table.varChar('document_pdf', length: 255);
      table.varChar('photo', length: 255);
      table.varChar('title', length: 255);
      table
          .declare('vehicule_id', ColumnType('int'))
          .references('vehicules', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('assurances', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class AssuranceQuery extends Query<Assurance, AssuranceQueryWhere> {
  AssuranceQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AssuranceQueryWhere(this);
  }

  @override
  final AssuranceQueryValues values = AssuranceQueryValues();

  List<String> _selectedFields = [];

  AssuranceQueryWhere? _where;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'assurances';
  }

  @override
  List<String> get fields {
    const _fields = [
      'id',
      'created_at',
      'updated_at',
      'driver',
      'identification_number',
      'document_pdf',
      'photo',
      'title',
      'vehicule_id',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
  }

  AssuranceQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  AssuranceQueryWhere? get where {
    return _where;
  }

  @override
  AssuranceQueryWhere newWhereClause() {
    return AssuranceQueryWhere(this);
  }

  Optional<Assurance> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = AssuranceModel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
      fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
      fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      driver: fields.contains('driver') ? (row[3] as String?) : null,
      identificationNumber:
      fields.contains('identification_number') ? mapToInt(row[4]) : null,
      documentPdf: fields.contains('document_pdf') ? (row[5] as String?) : null,
      photo: fields.contains('photo') ? (row[6] as String?) : null,
      title: fields.contains('title') ? (row[7] as String?) : null,
      vehiculeId: fields.contains('vehicule_id') ? mapToInt(row[8]) : null,
    );
    return Optional.of(model as Assurance);
  }

  @override
  Optional<Assurance> deserialize(List row) {
    return parseRow(row);
  }
}

class AssuranceQueryWhere extends QueryWhere {
  AssuranceQueryWhere(AssuranceQuery query)
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
        driver = StringSqlExpressionBuilder(
          query,
          'driver',
        ),
        identificationNumber = NumericSqlExpressionBuilder<int>(
          query,
          'identification_number',
        ),
        documentPdf = StringSqlExpressionBuilder(
          query,
          'document_pdf',
        ),
        photo = StringSqlExpressionBuilder(
          query,
          'photo',
        ),
        title = StringSqlExpressionBuilder(
          query,
          'title',
        ),
        vehiculeId = NumericSqlExpressionBuilder<int>(
          query,
          'vehicule_id',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder driver;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final StringSqlExpressionBuilder documentPdf;

  final StringSqlExpressionBuilder photo;

  final StringSqlExpressionBuilder title;

  final NumericSqlExpressionBuilder<int> vehiculeId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      driver,
      identificationNumber,
      documentPdf,
      photo,
      title,
      vehiculeId,
    ];
  }
}

class AssuranceQueryValues extends MapQueryValues {
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

  String? get driver {
    return (values['driver'] as String?);
  }

  set driver(String? value) => values['driver'] = value;

  int? get identificationNumber {
    return (values['identification_number'] as int?);
  }

  set identificationNumber(int? value) =>
      values['identification_number'] = value;

  String? get documentPdf {
    return (values['document_pdf'] as String?);
  }

  set documentPdf(String? value) => values['document_pdf'] = value;

  String? get photo {
    return (values['photo'] as String?);
  }

  set photo(String? value) => values['photo'] = value;

  String? get title {
    return (values['title'] as String?);
  }

  set title(String? value) => values['title'] = value;

  int? get vehiculeId {
    return (values['vehicule_id'] as int?);
  }

  set vehiculeId(int? value) => values['vehicule_id'] = value;

  void copyFrom(AssuranceModel model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    driver = model.driver;
    identificationNumber = model.identificationNumber;
    documentPdf = model.documentPdf;
    photo = model.photo;
    title = model.title;
    vehiculeId = model.vehiculeId;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class AssuranceModel {
  AssuranceModel({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.driver,
    this.identificationNumber,
    this.documentPdf,
    this.photo,
    this.title,
    this.vehiculeId,
  });

  final String? id;

  /// The time at which this item was created.
  final DateTime? createdAt;

  /// The last time at which this item was updated.
  final DateTime? updatedAt;

  final String? driver;

  final int? identificationNumber;

  final String? documentPdf;

  final String? photo;

  final String? title;

  final int? vehiculeId;

  AssuranceModel copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? driver,
    int? identificationNumber,
    String? documentPdf,
    String? photo,
    String? title,
    int? vehiculeId,
  }) {
    return AssuranceModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driver: driver ?? this.driver,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      title: title ?? this.title,
      vehiculeId: vehiculeId ?? this.vehiculeId,
    );
  }

  @override
  bool operator ==(other) {
    return other is AssuranceModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.driver == driver &&
        other.identificationNumber == identificationNumber &&
        other.documentPdf == documentPdf &&
        other.photo == photo &&
        other.title == title &&
        other.vehiculeId == vehiculeId;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      driver,
      identificationNumber,
      documentPdf,
      photo,
      title,
      vehiculeId,
    ]);
  }

  @override
  String toString() {
    return 'Assurance(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, driver=$driver, identificationNumber=$identificationNumber, documentPdf=$documentPdf, photo=$photo, title=$title, vehiculeId=$vehiculeId)';
  }

  Map<String, dynamic> toJson() {
    return AssuranceSerializer.toMap(this as AssuranceModel?);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class AssuranceSerializer {
  static AssuranceModel fromMap(Map map) {
    return AssuranceModel(
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
      driver: map['driver'] as String?,
      identificationNumber: map['identification_number'] as int?,
      documentPdf: map['document_pdf'] as String?,
      photo: map['photo'] as String?,
      title: map['title'] as String?,
      vehiculeId: map['vehicule_id'] as int?,

    );
  }

  static Map<String, dynamic> toMap(AssuranceModel? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'driver': model.driver,
      'identification_number': model.identificationNumber,
      'document_pdf': model.documentPdf,
      'photo': model.photo,
      'title': model.title,
      'vehicule_id': model.vehiculeId,
    };
  }
}

abstract class AssuranceFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    driver,
    identificationNumber,
    documentPdf,
    photo,
    title,
    vehiculeId,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String driver = 'driver';

  static const String identificationNumber = 'identification_number';

  static const String documentPdf = 'document_pdf';

  static const String photo = 'photo';

  static const String title = 'title';

  static const String vehiculeId = 'vehicule_id';
}
