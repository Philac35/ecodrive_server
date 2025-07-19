// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VehiculeEntity.dart';

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
      table.varChar('brand', length: 64);
      table.varChar('modele', length: 64);
      table.varChar('color', length: 64);
      table.varChar('energy', length: 64);
      table.varChar('immatriculation', length: 64);
      table.timeStamp('first_immatriculation');
      table.integer('nb_places');
      table.declareColumn(
        'preferences',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.declare('driver_id', ColumnType('int')).references('people', 'id');
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
  VehiculeQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    if (trampoline.contains(tableName)) return; // Modification E.H 2/07/2025 17h56 Prevent recursion!
    trampoline.add(tableName);
    _where = VehiculeQueryWhere(this);
    leftJoin(
      _photoList = PhotoQuery(trampoline: trampoline, parent: this),
      'id',
      'vehicule_id',
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
    );
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
  final VehiculeQueryValues values = VehiculeQueryValues();

  List<String> _selectedFields = [];

  VehiculeQueryWhere? _where;

  late PhotoQuery _photoList;

  late PersonQuery _driver;

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
    const localFields = [
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
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
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
    var model = Vehicule(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      brand: fields.contains('brand') ? (row[3] as String?) : null,
      modele: fields.contains('modele') ? (row[4] as String?) : null,
      color: fields.contains('color') ? (row[5] as String?) : null,
      energy: fields.contains('energy') ? (row[6] as String?) : null,
      immatriculation:
          fields.contains('immatriculation') ? (row[7] as String?) : null,
      firstImmatriculation:
          fields.contains('first_immatriculation')
              ? mapToNullableDateTime(row[8])
              : null,
      nbPlaces: fields.contains('nb_places') ? mapToInt(row[9]) : null,
      preferences:
          fields.contains('preferences') ? (row[11] as List<String>?) : null,
      driver: {} as DriverEntity,
    );
    if (row.length > 12) {
      var modelOpt = PhotoQuery().parseRow(row.skip(12).take(10).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(photoList: [m]);
      });
    }
    if (row.length > 22) {
      var modelOpt = PersonQuery().parseRow(row.skip(22).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(driver: m as DriverEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Vehicule> deserialize(List row) {
    return parseRow(row);
  }

  PhotoQuery get photoList {
    return _photoList;
  }

  PersonQuery get driver {
    return _driver;
  }

  @override
  Future<List<Vehicule>> get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Vehicule>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              photoList: List<PhotoEntity>.from(l.photoList as Iterable)
                ..addAll(model.photoList as Iterable<PhotoEntity>),
            );
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
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              photoList: List<PhotoEntity>.from(l.photoList as Iterable)
                ..addAll(model.photoList as Iterable<PhotoEntity>),
            );
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
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
              photoList: List<PhotoEntity>.from(l.photoList as Iterable)
                ..addAll(model.photoList as Iterable<PhotoEntity>),
            );
        }
      });
    });
  }
}

class VehiculeQueryWhere extends QueryWhere {
  VehiculeQueryWhere(VehiculeQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      brand = StringSqlExpressionBuilder(query, 'brand'),
      modele = StringSqlExpressionBuilder(query, 'modele'),
      color = StringSqlExpressionBuilder(query, 'color'),
      energy = StringSqlExpressionBuilder(query, 'energy'),
      immatriculation = StringSqlExpressionBuilder(query, 'immatriculation'),
      firstImmatriculation = DateTimeSqlExpressionBuilder(
        query,
        'first_immatriculation',
      ),
      nbPlaces = NumericSqlExpressionBuilder<int>(query, 'nb_places'),
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id'),
      preferences = ListSqlExpressionBuilder(query, 'preferences');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

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
class Vehicule extends VehiculeEntity {
  Vehicule({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.brand,
    this.modele,
    this.color,
    this.energy,
    this.immatriculation,
    this.firstImmatriculation,
    this.nbPlaces,
    List<PhotoEntity>? photoList = const [],
    required this.driver,
    List<String>? preferences = const [],
    this.assurance,
  }) : photoList = List.unmodifiable(photoList ?? []),
       preferences = List.unmodifiable(preferences ?? []);

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
  List<PhotoEntity>? photoList;

  @override
  DriverEntity driver;

  @override
  List<String>? preferences;

  @override
  AssuranceEntity? assurance;

  Vehicule copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? brand,
    String? modele,
    String? color,
    String? energy,
    String? immatriculation,
    DateTime? firstImmatriculation,
    int? nbPlaces,
    List<PhotoEntity>? photoList,
    DriverEntity? driver,
    List<String>? preferences,
    AssuranceEntity? assurance,
  }) {
    return Vehicule(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
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
      assurance: assurance ?? this.assurance,
    );
  }

  @override
  bool operator ==(other) {
    return other is VehiculeEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.brand == brand &&
        other.modele == modele &&
        other.color == color &&
        other.energy == energy &&
        other.immatriculation == immatriculation &&
        other.firstImmatriculation == firstImmatriculation &&
        other.nbPlaces == nbPlaces &&
        ListEquality<PhotoEntity>(
          DefaultEquality<PhotoEntity>(),
        ).equals(other.photoList, photoList) &&
        other.driver == driver &&
        ListEquality<String>(
          DefaultEquality<String>(),
        ).equals(other.preferences, preferences) &&
        other.assurance == assurance;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
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
    return 'Vehicule(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, brand=$brand, modele=$modele, color=$color, energy=$energy, immatriculation=$immatriculation, firstImmatriculation=$firstImmatriculation, nbPlaces=$nbPlaces, photoList=$photoList, driver=$driver, preferences=$preferences, assurance=$assurance)';
  }

  Map<String, dynamic>? toJson() {
    return VehiculeSerializer?.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const VehiculeSerializer vehiculeSerializer = VehiculeSerializer();

class VehiculeEncoder extends Converter<Vehicule, Map> {
  const VehiculeEncoder();

  @override
  Map convert(Vehicule model) => VehiculeSerializer.toMap(model)!;
}

class VehiculeDecoder extends Converter<Map, Vehicule> {
  const VehiculeDecoder();

  @override
  Vehicule convert(Map map) => VehiculeSerializer.fromMap(map);
}

class VehiculeSerializer extends Codec<Vehicule, Map> {
  const VehiculeSerializer();

  @override
  VehiculeEncoder get encoder => const VehiculeEncoder();

  @override
  VehiculeDecoder get decoder => const VehiculeDecoder();

  static Vehicule fromMap(Map map) {
    return Vehicule(
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
      brand: map['brand'] as String?,
      modele: map['modele'] as String?,
      color: map['color'] as String?,
      energy: map['energy'] as String?,
      immatriculation: map['immatriculation'] as String?,
      firstImmatriculation:
          map['first_immatriculation'] != null
              ? (map['first_immatriculation'] is DateTime
                  ? (map['first_immatriculation'] as DateTime)
                  : DateTime.parse(map['first_immatriculation'].toString()))
              : null,
      nbPlaces: map['nb_places'] as int?,
      photoList:
          map['photo_list'] is Iterable
              ? List.unmodifiable(
                ((map['photo_list'] as Iterable).whereType<Map>()).map(
                  PhotoSerializer.fromMap,
                ),
              )
              : [],
      driver:
          map['driver'] != null
              ? DriverSerializer.fromMap(map['driver'] as Map) as DriverEntity
              : {} as DriverEntity,
      preferences:
          map['preferences'] is Iterable
              ? (map['preferences'] as Iterable).cast<String>().toList()
              : [],
      assurance:
          map['assurance'] != null
              ? AssuranceSerializer.fromMap(map['assurance'] as Map)
              : null,
    );
  }

  static Map<String, dynamic>? toMap(VehiculeEntity? model) {
    if (model == null) {
      return null;
      throw FormatException("Vehicule L652, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
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
      'assurance': AssuranceSerializer.toMap(model.assurance),
    };
  }
}

abstract class VehiculeFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
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
