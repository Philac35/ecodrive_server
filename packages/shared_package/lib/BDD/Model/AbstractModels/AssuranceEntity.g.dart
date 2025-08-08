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
      table.integer('identification_number');
      table.declareColumn(
        'document_pdf',
        Column(type: ColumnType('json'), length: 255),
      );
      table.varChar('title', length: 64);
      table.varChar("path", length:256);
      table
          .declare('vehicule_id', ColumnType('int'))
          .references('vehicules', 'id');
      table
          .declare('photo_id', ColumnType('int'))
          .references('photos', 'id');
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

    bool isActive = !(trampoline?.contains(tableName) ?? false);
    trampoline ??= <String>{};

    trampoline.add(tableName);

    _where = AssuranceQueryWhere(this);

    if(isActive){

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
        'preferences',
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
          'person_id',
          'vehicule_id',
          'driving_licence_id',
         ],
       trampoline: trampoline,
    );}

  }

  @override
  final AssuranceQueryValues values = AssuranceQueryValues();




  List<String> _selectedFields = [];

  AssuranceQueryWhere? _where;

  late VehiculeQuery _vehicule;
  late PhotoQuery _photo;
  /*
  @override
  Map<String, String>? get casts {
    return {"documentPdf":"json"};

  }*/

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
      'identification_number',
      'document_pdf',
      'title',
      'path',
      'vehicule_id',
      'photo_id'
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


    print('L151 row : $row');
    var   model = Assurance(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      identificationNumber:
          fields.contains('identification_number') ? mapToInt(row[3]) : null,
      documentPdf:
          fields.contains('document_pdf') && row[4] != null ?
            row[4] is String?  Uint8ListJsonConverter().jsonStrToUint(row[4])
            :CompressionLib().decompressBlob(row[4])
          : null,
      title: fields.contains('title') ? row[5] is String? //Caution to order
                                        ?(row[5] as String?) :null
                                      : null,
      path: fields.contains('path') ? row[6] is String
                                        ?(row[6] as String?) :null
                                     : null,
      vehiculeId: fields.contains('vehicule_id') ? row[7] is String ?
                                                     int.parse(row[7]) : null
                                                 :null,
      photoId: fields.contains('photo_id') ? row[8] is String ?
                                                    int.parse(row[8]) : null
                                                :null,
      );
    if (row.length > 9) {
      var modelOpt = VehiculeQuery().parseRow(row.skip(9).take(12).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(vehicule: m);
      });
    };
    if (row.length > 22) {
      var modelOpt = PhotoQuery().parseRow(row.skip(22).take(10).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(photo: m);
      });
    };

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
      identificationNumber = NumericSqlExpressionBuilder<int>(query,'identification_number'),
      documentPdf = ListSqlExpressionBuilder(query, 'document_pdf'),
      title = StringSqlExpressionBuilder(query, 'title'),
      path = StringSqlExpressionBuilder(query, 'path'),
      vehiculeId = NumericSqlExpressionBuilder<int>(query, 'vehicule_id'),
      photoId = NumericSqlExpressionBuilder<int>(query, 'photo_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> identificationNumber;

  final ListSqlExpressionBuilder documentPdf;

  final StringSqlExpressionBuilder title;

  final StringSqlExpressionBuilder path;

  final NumericSqlExpressionBuilder<int> vehiculeId;

  final NumericSqlExpressionBuilder<int> photoId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {

    return [
      id,
      createdAt,
      updatedAt,
      identificationNumber,
      documentPdf,
      title,
      path,
      vehiculeId,
      photoId
    ];
  }
}

class AssuranceQueryValues extends MapQueryValues {


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


  int get identificationNumber {
    return (values['identification_number'] as int);
  }

  set identificationNumber(int? value) =>
      values['identification_number'] = value;

  Uint8List? get documentPdf {

    return json.decode((values['document_pdf'] ));//.casts() if needed
  }

  set documentPdf(Uint8List? value) =>
      values['document_pdf'] = json.encode(value);

  String? get title {
    return (values['title'] as String);
  }

  set title(String? value) => values['title'] = value;

  String? get path {
    return (values['path'] as String);
  }

  set path(String? value) => values['path'] = value;

  int get vehiculeId {
    return (values['vehicule_id'] as int);
  }

  set vehiculeId(int value) => values['vehicule_id'] = value;

  int get photoId {
    return (values['photo_id'] as int);
  }

  set photoId(int value) => values['photo_id'] = value;

  void copyFrom(Assurance model) {

    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    identificationNumber = model.identificationNumber ;
    documentPdf = model.documentPdf;
    title = model.title;
    path =  model.path;
    if (model.vehiculeId != null) {
      values['vehicule_id'] = model.vehiculeId;
    }
    if (model.vehicule != null) {
      values['vehicule'] = VehiculeSerializer.toMap(model.vehicule);
    }

    if (model.photoId != null) {
      values['photo_id'] =model.photoId;
      //values['photo_id'] = model.photo!.id;
    }
    if (model.photo != null) {
      values['photo'] = PhotoSerializer.toMap(model.photo);
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
    this.identificationNumber,  //was required
    this.documentPdf,
    this.photo,
    this.photoId,
    required this.title,
    this.path,
    this.vehicule, //was required
    this.vehiculeId
  }){
}

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
  int? identificationNumber;


  @override
  Uint8List?  documentPdf ;

  @override
  PhotoEntity? photo;

  @override
  int? photoId;

  @override
  String? title;

  @override
  String? path;

  @override
  VehiculeEntity? vehicule;

  @override
  int? vehiculeId;





  Assurance copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? identificationNumber,
    Uint8List? documentPdf,
    PhotoEntity? photo,
    int? photoId,
    String? title,
    String? path,
    VehiculeEntity? vehicule,
    int? vehiculeId,

  }) {


    return Assurance(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      identificationNumber: identificationNumber ?? this.identificationNumber,
      documentPdf: documentPdf ?? this.documentPdf,
      photo: photo ?? this.photo,
      photoId: photoId ?? this.photoId,
      title: title ?? this.title,
      path: path ?? this.path,
      vehicule: vehicule ?? this.vehicule,
      vehiculeId: vehiculeId?? this.vehiculeId
    );
  }

  @override
  bool operator ==(other) {

    return other is AssuranceEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.identificationNumber == identificationNumber &&
        other.documentPdf == documentPdf &&
        other.photo == photo &&
        other.photoId == photoId &&
        other.title == title &&
        other.path == path &&
        other.vehicule == vehicule&&
        other.vehiculeId== vehiculeId;
  }

  @override
  int get hashCode {


    return hashObjects([
      id,
      createdAt,
      updatedAt,
      identificationNumber,
      documentPdf,
      photo,
      photoId,
      title,
      path,
      vehicule,
      vehiculeId
    ]);
  }

  @override
  String toString() {
    return 'Assurance(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, identificationNumber=$identificationNumber, documentPdf=$documentPdf, photo=$photo, title=$title, path=$path,vehicule=$vehicule, vehiculeId=$vehiculeId)';
  }

  Map<String, dynamic> toJson() {
    return AssuranceSerializer.toMap(this)!;
  }



}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const AssuranceSerializer assuranceSerializer = AssuranceSerializer();

class AssuranceEncoder extends Converter<Assurance, Map> {
  const AssuranceEncoder();

  @override
  Map convert(Assurance model) => AssuranceSerializer.toMap(model)!;
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

    print("AssuranceEntity L420 : ${map.keys.first.runtimeType}");
    map=StringLib().camelToSnakeKeyFromMap(map);

    print("AssuranceEntity L475 : $map");




  var ret=Assurance(
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
      identificationNumber: map['identification_number'] as int?,
      documentPdf:  map['document_pdf'] !=null ? CompressionLib().compressBlob(Uint8ListJsonConverter().jsonStrToUint(map['document_pdf'])!) :null,
      photo:
          map['photo'] != null
              ? PhotoSerializer.fromMap(map['photo'] as Map)
              : null,
      photoId:int.parse(map['photo_id'])??null,
      title: map['title'] as String?,
      path: map['path'] != null ? map['path'] as String :null,
      vehicule:
          map['vehicule'] != null
              ? VehiculeSerializer.fromMap(map['vehicule'] as Map) as VehiculeEntity
              : null,
      vehiculeId:map['vehicule_id']!=null?
        (map['vehicule_id'] is String) ? int.parse(map['vehicule_id']): map['vehicule_id']
               :null,
    );

    print("Assurances L524 fromMap ${ret}");
    return ret;
  }

  static Map<String, dynamic>? toMap(AssuranceEntity? model) {

    if (model == null) {
      return null;
      throw FormatException("Assurance L470, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'identification_number': model.identificationNumber!,
      'document_pdf':
          model.documentPdf != null ? model.documentPdf : null,
      'photo': PhotoSerializer.toMap(model.photo),
      'photoId':model.photoId,
      'title': model.title,
      'path' : model.path,
      'vehicule': VehiculeSerializer.toMap(model.vehicule),
      'vehiculeId': model.vehiculeId
    };
  }
}

abstract class AssuranceFields {

AssuranceFields(){

}

  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    identificationNumber,
    documentPdf,
    photo,
    photoId,
    title,
    path,
    vehicule,
    vehiculeId
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String identificationNumber = 'identification_number';

  static const String documentPdf = 'document_pdf';

  static const String photo = 'photo';

  static const String photoId = 'photo_id';

  static const String title = 'title';

  static const String path = 'path';

  static const String vehicule = 'vehicule';

  static const String vehiculeId = 'vehicule_id';
}
