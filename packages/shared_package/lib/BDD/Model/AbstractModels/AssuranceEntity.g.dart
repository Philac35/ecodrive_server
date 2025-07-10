// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AssuranceEntity.dart';

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
      table.integer('id_int');
      table.varChar('driver', length: 255);
      table.integer('identification_number');
      table.declareColumn(
        'document_pdf',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.varChar('title', length: 64);
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
  AssuranceQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AssuranceQueryWhere(this);
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
  }

  @override
  final AssuranceQueryValues values = AssuranceQueryValues();

  List<String> _selectedFields = [];

  AssuranceQueryWhere? _where;

  late VehiculeQuery _vehicule;

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
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'id_int',
      'driver',
      'identification_number',
      'document_pdf',
      'title',
      'vehicule_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
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
    var model = Assurance(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      driver: fields.contains('driver') ? (row[3] as DriverEntity?) : null,
      identificationNumber:
          fields.contains('identification_number') ? mapToInt(row[4]) : 0,
      documentPdf:
          fields.contains('document_pdf') ? (row[5] as Uint8List?) : null,
      title: fields.contains('title') ? (row[6] as String) : '',
      vehicule: {} as VehiculeEntity,
    );
    if (row.length > 8) {
      var modelOpt = VehiculeQuery().parseRow(row.skip(8).take(11).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(vehicule: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Assurance> deserialize(List row) {
    return parseRow(row);
  }

  VehiculeQuery get vehicule {
    return _vehicule;
  }
}

class AssuranceQueryWhere extends QueryWhere {
  AssuranceQueryWhere(AssuranceQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
         identificationNumber = NumericSqlExpressionBuilder<int>(
        query,
        'identification_number',
      ),
      documentPdf = ListSqlExpressionBuilder(query, 'document_pdf'),
      title = StringSqlExpressionBuilder(query, 'title'),
      vehiculeId = NumericSqlExpressionBuilder<int>(query, 'vehicule_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final ListSqlExpressionBuilder documentPdf;

  final StringSqlExpressionBuilder title;

  final NumericSqlExpressionBuilder<int> vehiculeId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    var driver;
    return [
      id,
      createdAt,
      updatedAt,
      driver,
      identificationNumber,
      documentPdf,
      title,
      vehiculeId,
    ];
  }
}

class AssuranceQueryValues extends MapQueryValues {
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

  DriverEntity? get driver {
    return (values['driver'] as DriverEntity?);
  }

  set driver(DriverEntity? value) => values['driver'] = value;

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

  int get vehiculeId {
    return (values['vehicule_id'] as int);
  }

  set vehiculeId(int value) => values['vehicule_id'] = value;

  void copyFrom(Assurance model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    driver = model.driver;
    identificationNumber = model.identificationNumber;
    documentPdf = model.documentPdf;
    title = model.title;
    if (model.vehicule != null) {
      values['vehicule_id'] = model.vehicule?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Assurance extends AssuranceEntity {
  Assurance({
    this.id,
    this.createdAt,
    this.updatedAt,

    this.driver,
    required this.identificationNumber,
    this.documentPdf,
    this.photo,
    required this.title,
    required this.vehicule,
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
  DriverEntity? driver;

  @override
  int identificationNumber;

  @override
  Uint8List? documentPdf;

  @override
  PhotoEntity? photo;

  @override
  String title;

  @override
  VehiculeEntity vehicule;

  Assurance copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DriverEntity? driver,
    int? identificationNumber,
    Uint8List? documentPdf,
    PhotoEntity? photo,
    String? title,
    VehiculeEntity? vehicule,
  }) {
    return Assurance(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driver: driver ?? this.driver,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      title: title ?? this.title,
      vehicule: vehicule ?? this.vehicule,
    );
  }

  @override
  bool operator ==(other) {
    return other is AssuranceEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.driver == driver &&
        other.identificationNumber == identificationNumber &&
        ListEquality().equals(other.documentPdf, documentPdf) &&
        other.photo == photo &&
        other.title == title &&
        other.vehicule == vehicule;
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
      vehicule,
    ]);
  }

  @override
  String toString() {
    return 'Assurance(id=$id, createdAt=$createdAt, updatedAt=$updatedAt,  driver=$driver, identificationNumber=$identificationNumber, documentPdf=$documentPdf, photo=$photo, title=$title, vehicule=$vehicule)';
  }

  Map<String, dynamic> toJson() {
    return AssuranceSerializer.toMap(this);
  }

  @override
  void set(int idInt) {
    // TODO: implement set
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const AssuranceSerializer assuranceSerializer = AssuranceSerializer();

class AssuranceEncoder extends Converter<Assurance, Map> {
  const AssuranceEncoder();

  @override
  Map convert(Assurance model) => AssuranceSerializer.toMap(model);
}

class AssuranceDecoder extends Converter<Map, Assurance> {
  const AssuranceDecoder();

  @override
  Assurance convert(Map map) => AssuranceSerializer.fromMap(map);
}

class AssuranceSerializer extends Codec<Assurance, Map> {
  const AssuranceSerializer();

  @override
  AssuranceEncoder get encoder => const AssuranceEncoder();

  @override
  AssuranceDecoder get decoder => const AssuranceDecoder();

  static Assurance fromMap(Map map) {
    return Assurance(
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
      vehicule:
          map['vehicule'] != null
              ? VehiculeSerializer.fromMap(map['vehicule'] as Map) as VehiculeEntity
              : {} as VehiculeEntity,
    );
  }

  static Map<String, dynamic> toMap(AssuranceEntity? model) {
    if (model == null) {
      throw FormatException("Assurance L470, Required field [model] cannot be null");
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
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
    };
  }
}

abstract class AssuranceFields {
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
    vehicule,
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

  static const String vehicule = 'vehicule';
}
