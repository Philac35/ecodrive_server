// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NoticeEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class NoticeMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('notices', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('updated_at');
      table.varChar('title', length: 64);
      table.varChar('description', length: 256);
      table.integer('note');
      table.timeStamp('created_at');
      table.declare('driver_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('notices');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class NoticeQuery extends Query<Notice, NoticeQueryWhere> {
  NoticeQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = NoticeQueryWhere(this);
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
  final NoticeQueryValues values = NoticeQueryValues();

  List<String> _selectedFields = [];

  NoticeQueryWhere? _where;

  late PersonQuery _driver;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'notices';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'updated_at',
      'title',
      'description',
      'note',
      'created_at',
      'driver_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  NoticeQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  NoticeQueryWhere? get where {
    return _where;
  }

  @override
  NoticeQueryWhere newWhereClause() {
    return NoticeQueryWhere(this);
  }

  Optional<Notice> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Notice(
      id: fields.contains('id') ? row[0].toString() : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[1]) : null,
      title: fields.contains('title') ? (row[2] as String) : '',
      description: fields.contains('description') ? (row[3] as String) : '',
      note: fields.contains('note') ? mapToInt(row[4]) : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[5]) : null,
    );
    if (row.length > 7) {
      var modelOpt = PersonQuery().parseRow(row.skip(7).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(driver: m as DriverEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Notice> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get driver {
    return _driver;
  }
}

class NoticeQueryWhere extends QueryWhere {
  NoticeQueryWhere(NoticeQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      title = StringSqlExpressionBuilder(query, 'title'),
      description = StringSqlExpressionBuilder(query, 'description'),
      note = NumericSqlExpressionBuilder<int>(query, 'note'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      driverId = NumericSqlExpressionBuilder<int>(query, 'driver_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder title;

  final StringSqlExpressionBuilder description;

  final NumericSqlExpressionBuilder<int> note;

  final DateTimeSqlExpressionBuilder createdAt;

  final NumericSqlExpressionBuilder<int> driverId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [id, updatedAt, title, description, note, createdAt, driverId];
  }
}

class NoticeQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
  }

  String? get id {
    return (values['id'] as String?);
  }

  set id(String? value) => values['id'] = value;

  DateTime? get updatedAt {
    return (values['updated_at'] as DateTime?);
  }

  set updatedAt(DateTime? value) => values['updated_at'] = value;

  String get title {
    return (values['title'] as String);
  }

  set title(String value) => values['title'] = value;

  String get description {
    return (values['description'] as String);
  }

  set description(String value) => values['description'] = value;

  int? get note {
    return (values['note'] as int?);
  }

  set note(int? value) => values['note'] = value;

  DateTime? get createdAt {
    return (values['created_at'] as DateTime?);
  }

  set createdAt(DateTime? value) => values['created_at'] = value;

  int get driverId {
    return (values['driver_id'] as int);
  }

  set driverId(int value) => values['driver_id'] = value;

  void copyFrom(Notice model) {
    updatedAt = model.updatedAt;
    title = model.title;
    description = model.description;
    note = model.note;
    createdAt = model.createdAt;
    if (model.driver != null) {
      values['driver_id'] = model.driver?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Notice extends NoticeEntity {
  Notice({
    this.id,
    this.updatedAt,
    required this.title,
    required this.description,
    this.note,
    this.createdAt,
    this.driver,
  });

  /// A unique identifier corresponding to this item.
  @override
  String? id;

  /// The last time at which this item was updated.
  @override
  DateTime? updatedAt;

  @override
  String title;

  @override
  String description;

  @override
  int? note;

  @override
  DateTime? createdAt;

  @override
  DriverEntity? driver;

  Notice copyWith({
    String? id,
    DateTime? updatedAt,
    String? title,
    String? description,
    int? note,
    DateTime? createdAt,
    DriverEntity? driver,
  }) {
    return Notice(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      title: title ?? this.title,
      description: description ?? this.description,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      driver: driver ?? this.driver,
    );
  }

  @override
  bool operator ==(other) {
    return other is NoticeEntity &&
        other.id == id &&
        other.updatedAt == updatedAt &&
        other.title == title &&
        other.description == description &&
        other.note == note &&
        other.createdAt == createdAt &&
        other.driver == driver;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      updatedAt,
      title,
      description,
      note,
      createdAt,
      driver,
    ]);
  }

  @override
  String toString() {
    return 'Notice(id=$id, updatedAt=$updatedAt, title=$title, description=$description, note=$note, createdAt=$createdAt, driver=$driver)';
  }

  Map<String, dynamic> toJson() {
    return NoticeSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const NoticeSerializer noticeSerializer = NoticeSerializer();

class NoticeEncoder extends Converter<Notice, Map> {
  const NoticeEncoder();

  @override
  Map convert(Notice model) => NoticeSerializer.toMap(model);
}

class NoticeDecoder extends Converter<Map, Notice> {
  const NoticeDecoder();

  @override
  Notice convert(Map map) => NoticeSerializer.fromMap(map);
}

class NoticeSerializer extends Codec<Notice, Map> {
  const NoticeSerializer();

  @override
  NoticeEncoder get encoder => const NoticeEncoder();

  @override
  NoticeDecoder get decoder => const NoticeDecoder();

  static Notice fromMap(Map map) {
    return Notice(
      id: map['id'] as String?,
      updatedAt:
          map['updated_at'] != null
              ? (map['updated_at'] is DateTime
                  ? (map['updated_at'] as DateTime)
                  : DateTime.parse(map['updated_at'].toString()))
              : null,
      title: map['title'] as String,
      description: map['description'] as String,
      note: map['note'] as int?,
      createdAt:
          map['created_at'] != null
              ? (map['created_at'] is DateTime
                  ? (map['created_at'] as DateTime)
                  : DateTime.parse(map['created_at'].toString()))
              : null,
      driver:
          map['driver'] != null
              ? DriverSerializer.fromMap(map['driver'] as Map)
              : null,
    );
  }

  static Map<String, dynamic> toMap(NoticeEntity? model) {
    if (model == null) {
      throw FormatException("NoticeEntity L382, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'updated_at': model.updatedAt?.toIso8601String(),
      'title': model.title,
      'description': model.description,
      'note': model.note,
      'created_at': model.createdAt?.toIso8601String(),
      'driver': DriverSerializer.toMap(model.driver),
    };
  }
}

abstract class NoticeFields {
  static const List<String> allFields = <String>[
    id,
    updatedAt,
    title,
    description,
    note,
    createdAt,
    driver,
  ];

  static const String id = 'id';

  static const String updatedAt = 'updated_at';

  static const String title = 'title';

  static const String description = 'description';

  static const String note = 'note';

  static const String createdAt = 'created_at';

  static const String driver = 'driver';
}
