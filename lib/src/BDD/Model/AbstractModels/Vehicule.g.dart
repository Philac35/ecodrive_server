// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Vehicule.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class VehiculeMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('vehicules', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('id_int');
      table.varChar('brand', length: 255);
      table.varChar('modele', length: 255);
      table.varChar('color', length: 255);
      table.varChar('energy', length: 255);
      table.varChar('immatriculation', length: 255);
      table.timeStamp('first_immatriculation');
      table.integer('nb_places');
      table.declareColumn(
        'preferences',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table
          .declare('driver_id', ColumnType('int'))
          .references('f_angel_models', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('vehicules', cascade: true);
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class VehiculeQuery extends Query<Vehicule, VehiculeQueryWhere> {
  VehiculeQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = VehiculeQueryWhere(this);
    leftJoin(
      _photoList = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'vehicule_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _driver = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'driver_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
    leftJoin(
      _assurance = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'id',
      'vehicule_id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final VehiculeQueryValues values = VehiculeQueryValues();

  List<String> _selectedFields = [];

  VehiculeQueryWhere? _where;

  late FAngelModelQuery _photoList;

  late FAngelModelQuery _driver;

  late FAngelModelQuery _assurance;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'vehicules';
  }

  @override
  List<String> get fields {
    const _fields = [
      'id',
      'created_at',
      'updated_at',
      'id_int',
      'brand',
      'modele',
      'color',
      'energy',
      'immatriculation',
      'first_immatriculation',
      'nb_places',
      'driver_id',
      'preferences',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
  }

  VehiculeQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  VehiculeQueryWhere? get where {
    return _where;
  }

  @override
  VehiculeQueryWhere newWhereClause() {
    return VehiculeQueryWhere(this);
  }

  Optional<Vehicule> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }

   var drivervar;
    if(fields.contains('driver')) { drivervar =row[12] as Driver;};
    VehiculeModel? model = VehiculeModel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[3]) : null,
      brand: fields.contains('brand') ? (row[4] as String?) : null,
      modele: fields.contains('modele') ? (row[5] as String?) : null,
      color: fields.contains('color') ? (row[6] as String?) : null,
      energy: fields.contains('energy') ? (row[7] as String?) : null,
      immatriculation:
          fields.contains('immatriculation') ? (row[8] as String?) : null,
      firstImmatriculation: fields.contains('first_immatriculation')
          ? mapToNullableDateTime(row[9])
          : null,
      nbPlaces: fields.contains('nb_places') ? mapToInt(row[10]) : null,
      preferences:
          fields.contains('preferences') ? (row[13] as List<String>?) : null,
      driver:drivervar);
    if (row.length > 13) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(14).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(photoList: [m]) as VehiculeModel?;
      });
    }
    if (row.length > 16) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(16).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(driver: m) as VehiculeModel?;
      });
    }
    if (row.length > 19) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(19).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(assurance: m) as VehiculeModel?;
      });
    }
    return Optional.of(model as Vehicule);
  }

  @override
  Optional<Vehicule> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get photoList {
    return _photoList;
  }

  FAngelModelQuery get driver {
    return _driver;
  }

  FAngelModelQuery get assurance {
    return _assurance;
  }

  @override
  Future<List<Vehicule>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Vehicule>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx]as VehiculeModel;   //Modified Cast 20/05/2025 15h55;
          return out
            ..[idx] = l.copyWith(
                photoList: List<Photo>.from(l.photoList as Iterable)  //Modified Cast
                  ..addAll(model.photoList as Iterable<Photo>)); //Modified Cast
        }
      });
    });
  }

  @override
  Future<List<Vehicule>> update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<Vehicule>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx] as VehiculeModel;   //Modified Cast 20/05/2025 15h55;
          return out
            ..[idx] = l.copyWith(
                photoList: List<Photo>.from(l.photoList as Iterable)  //Modified Cast
                  ..addAll(model.photoList as Iterable<Photo>)); //Modified Cast
        }
      });
    });
  }

  @override
  Future<List<Vehicule>> delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<Vehicule>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx] as VehiculeModel;   //Modified Cast 20/05/2025 15h54
          return out
            ..[idx] = l.copyWith(
                photoList: List<Photo>.from(l.photoList as Iterable)  //Modified Cast
                  ..addAll(model.photoList as Iterable<Photo>));  //Modified Cast
        }
      });
    });
  }
}

class VehiculeQueryWhere extends QueryWhere {
  VehiculeQueryWhere(VehiculeQuery query)
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
        brand = StringSqlExpressionBuilder(
          query,
          'brand',
        ),
        modele = StringSqlExpressionBuilder(
          query,
          'modele',
        ),
        color = StringSqlExpressionBuilder(
          query,
          'color',
        ),
        energy = StringSqlExpressionBuilder(
          query,
          'energy',
        ),
        immatriculation = StringSqlExpressionBuilder(
          query,
          'immatriculation',
        ),
        firstImmatriculation = DateTimeSqlExpressionBuilder(
          query,
          'first_immatriculation',
        ),
        nbPlaces = NumericSqlExpressionBuilder<int>(
          query,
          'nb_places',
        ),
        driverId = NumericSqlExpressionBuilder<int>(
          query,
          'driver_id',
        ),
        preferences = ListSqlExpressionBuilder(
          query,
          'preferences',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final StringSqlExpressionBuilder brand;

  final StringSqlExpressionBuilder modele;

  final StringSqlExpressionBuilder color;

  final StringSqlExpressionBuilder energy;

  final StringSqlExpressionBuilder immatriculation;

  final DateTimeSqlExpressionBuilder firstImmatriculation;

  final NumericSqlExpressionBuilder<int> nbPlaces;

  final NumericSqlExpressionBuilder<int> driverId;

  final ListSqlExpressionBuilder preferences;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      idInt,
      brand,
      modele,
      color,
      energy,
      immatriculation,
      firstImmatriculation,
      nbPlaces,
      driverId,
      preferences,
    ];
  }
}

class VehiculeQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'preferences': 'jsonb'};
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

  String? get brand {
    return (values['brand'] as String?);
  }

  set brand(String? value) => values['brand'] = value;

  String? get modele {
    return (values['modele'] as String?);
  }

  set modele(String? value) => values['modele'] = value;

  String? get color {
    return (values['color'] as String?);
  }

  set color(String? value) => values['color'] = value;

  String? get energy {
    return (values['energy'] as String?);
  }

  set energy(String? value) => values['energy'] = value;

  String? get immatriculation {
    return (values['immatriculation'] as String?);
  }

  set immatriculation(String? value) => values['immatriculation'] = value;

  DateTime? get firstImmatriculation {
    return (values['first_immatriculation'] as DateTime?);
  }

  set firstImmatriculation(DateTime? value) =>
      values['first_immatriculation'] = value;

  int? get nbPlaces {
    return (values['nb_places'] as int?);
  }

  set nbPlaces(int? value) => values['nb_places'] = value;

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

  List<String>? get preferences {
    return json.decode((values['preferences'] as String)).cast();
  }

  set preferences(List<String>? value) =>
      values['preferences'] = json.encode(value);

  void copyFrom(Vehicule model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    idInt = model.idInt;
    brand = model.brand;
    modele = model.modele;
    color = model.color;
    energy = model.energy;
    immatriculation = model.immatriculation;
    firstImmatriculation = model.firstImmatriculation;
    nbPlaces = model.nbPlaces;
    preferences = model.preferences;
    if (model.driver != null) {
      values['driver_id'] = model.driver?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class VehiculeModel extends Vehicule {
  VehiculeModel( {
    this.id,
    this.createdAt,
    this.updatedAt,
    this.idInt,
    this.brand,
    this.modele,
    this.color,
    this.energy,
    this.immatriculation,
    this.firstImmatriculation,
    this.nbPlaces,
    List<Photo>? photoList = const [],
    required this.driver,
    List<String>? preferences = const [],
    this.assurance,
  })  : photoList = List.unmodifiable(photoList ?? []),
        preferences = List.unmodifiable(preferences ?? []),
        super(
            idInt: idInt,
            driver: driver,
            brand: brand,
            modele: modele,
            color: color,
            energy: energy,
            immatriculation: immatriculation,
            firstImmatriculation: firstImmatriculation,
            nbPlaces: nbPlaces,
            preferences: preferences,
            assurance: assurance,
            photoList: photoList,
            createdAt: createdAt,
            updatedAt: updatedAt,
            id:id);

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
  String? brand;

  @override
  String? modele;

  @override
  String? color;

  @override
  String? energy;

  @override
  String? immatriculation;

  @override
  DateTime? firstImmatriculation;

  @override
  int? nbPlaces;

  @override
  List<Photo>? photoList;

  @override
  Driver driver;

  @override
  List<String>? preferences;

  @override
  Assurance? assurance;

  Vehicule copyWith(
{
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? idInt,
    String? brand,
    String? modele,
    String? color,
    String? energy,
    String? immatriculation,
    DateTime? firstImmatriculation,
    int? nbPlaces,
    List<Photo>? photoList,
    Driver? driver,
    List<String>? preferences,
    Assurance? assurance,
  }) {
    return VehiculeModel(

        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        brand: brand ?? this.brand,
        modele: modele ?? this.modele,
        color: color ?? this.color,
        energy: energy ?? this.energy,
        immatriculation: immatriculation ?? this.immatriculation,
        firstImmatriculation: firstImmatriculation ?? this.firstImmatriculation,
        nbPlaces: nbPlaces ?? this.nbPlaces,
        photoList: photoList ?? this.photoList,
        driver: driver ?? this.driver,
        preferences: preferences ?? this.preferences,
        assurance: assurance ?? this.assurance);
  }

  @override
  bool operator ==(other) {
    return other is Vehicule &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.brand == brand &&
        other.modele == modele &&
        other.color == color &&
        other.energy == energy &&
        other.immatriculation == immatriculation &&
        other.firstImmatriculation == firstImmatriculation &&
        other.nbPlaces == nbPlaces &&
        ListEquality<Photo>(DefaultEquality<Photo>())
            .equals(other.photoList, photoList) &&
        other.driver == driver &&
        ListEquality<String>(DefaultEquality<String>())
            .equals(other.preferences, preferences) &&
        other.assurance == assurance;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      idInt,
      brand,
      modele,
      color,
      energy,
      immatriculation,
      firstImmatriculation,
      nbPlaces,
      photoList,
      driver,
      preferences,
      assurance,
    ]);
  }

  @override
  String toString() {
    return 'Vehicule(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, idInt=$idInt, brand=$brand, modele=$modele, color=$color, energy=$energy, immatriculation=$immatriculation, firstImmatriculation=$firstImmatriculation, nbPlaces=$nbPlaces, photoList=$photoList, driver=$driver, preferences=$preferences, assurance=$assurance)';
  }

  Map<String, dynamic> toJson() {
    return VehiculeSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class VehiculeSerializer {
  static Vehicule fromMap(
    Map map,
  ) {
   var  assurancevar,drivervar,photoListvar;

    if(map['driver'] != null){drivervar= DriverSerializer.fromMap(map['driver'] as Map);}
    if(map['assurance'] != null ){assurancevar= AssuranceSerializer.fromMap(map['assurance'] as Map) ;}
    if(map['photo_list']!=null && map['photo_list'] is Iterable ){
      List.unmodifiable(((map['photo_list'] as Iterable).whereType<Map>()).map((photo)=>Photo.fromJson));}


    //Photo? photo =PhotoHelper.fromMap(map['photo']) as Photo?;
    return VehiculeModel(
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
        brand: map['brand'] as String?,
        modele: map['modele'] as String?,
        color: map['color'] as String?,
        energy: map['energy'] as String?,
        immatriculation: map['immatriculation'] as String?,
        firstImmatriculation: map['first_immatriculation'] != null
            ? (map['first_immatriculation'] is DateTime
                ? (map['first_immatriculation'] as DateTime)
                : DateTime.parse(map['first_immatriculation'].toString()))
            : null,
        nbPlaces: map['nb_places'] as int?,
        photoList: photoListvar,
        driver:drivervar,
        preferences:
            map['preferences'] is Iterable ? (map['preferences'] as Iterable).cast<String>().toList() : [],
        assurance: assurancevar);

  }

  static Map<String, dynamic> toMap(Vehicule? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'brand': model.brand,
      'modele': model.modele,
      'color': model.color,
      'energy': model.energy,
      'immatriculation': model.immatriculation,
      'first_immatriculation': model.firstImmatriculation?.toIso8601String(),
      'nb_places': model.nbPlaces,
      'photo_list':
          model.photoList?.map((m) => PhotoSerializer.toMap(m)).toList(),
      'driver': DriverSerializer.toMap(model.driver),
      'preferences': model.preferences,
      'assurance': AssuranceSerializer.toMap(model.assurance as AssuranceModel?)
    };
  }
}

abstract class VehiculeFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    idInt,
    brand,
    modele,
    color,
    energy,
    immatriculation,
    firstImmatriculation,
    nbPlaces,
    photoList,
    driver,
    preferences,
    assurance,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String brand = 'brand';

  static const String modele = 'modele';

  static const String color = 'color';

  static const String energy = 'energy';

  static const String immatriculation = 'immatriculation';

  static const String firstImmatriculation = 'first_immatriculation';

  static const String nbPlaces = 'nb_places';

  static const String photoList = 'photo_list';

  static const String driver = 'driver';

  static const String preferences = 'preferences';

  static const String assurance = 'assurance';
}
