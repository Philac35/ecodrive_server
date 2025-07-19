// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommandEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class CommandMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('commands', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('reference', length: 64);
      table.double('credits');
      table.double('unitary_price');
      table.double('total_h_t');
      table.double('total_t_t_c');
      table.varChar('status', length: 16);
      table.declare('user_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('commands');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class CommandQuery extends Query<Command, CommandQueryWhere> {
  CommandQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = CommandQueryWhere(this);
    leftJoin(
      _user = PersonQuery(trampoline: trampoline, parent: this),
      'user_id',
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
  final CommandQueryValues values = CommandQueryValues();

  List<String> _selectedFields = [];

  CommandQueryWhere? _where;

  late PersonQuery _user;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'commands';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'reference',
      'credits',
      'unitary_price',
      'total_h_t',
      'total_t_t_c',
      'status',
      'user_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  CommandQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  CommandQueryWhere? get where {
    return _where;
  }

  @override
  CommandQueryWhere newWhereClause() {
    return CommandQueryWhere(this);
  }

  Optional<Command> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = Command(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      reference: fields.contains('reference') ? (row[3] as String) : '',
      credits: fields.contains('credits') ? mapToDouble(row[4]) : 0.0,
      unitaryPrice:
          fields.contains('unitary_price') ? mapToDouble(row[5]) : 0.0,
      totalHT: fields.contains('total_h_t') ? mapToDouble(row[6]) : 0.0,
      totalTTC: fields.contains('total_t_t_c') ? mapToDouble(row[7]) : 0.0,
      status: fields.contains('status') ? (row[8] as String) : '',
      user: {} as UserEntity,
    );
    if (row.length > 10) {
      var modelOpt = PersonQuery().parseRow(row.skip(10).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(user: m as UserEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<Command> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get user {
    return _user;
  }
}

class CommandQueryWhere extends QueryWhere {
  CommandQueryWhere(CommandQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      reference = StringSqlExpressionBuilder(query, 'reference'),
      credits = NumericSqlExpressionBuilder<double>(query, 'credits'),
      unitaryPrice = NumericSqlExpressionBuilder<double>(
        query,
        'unitary_price',
      ),
      totalHT = NumericSqlExpressionBuilder<double>(query, 'total_h_t'),
      totalTTC = NumericSqlExpressionBuilder<double>(query, 'total_t_t_c'),
      status = StringSqlExpressionBuilder(query, 'status'),
      userId = NumericSqlExpressionBuilder<int>(query, 'user_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder reference;

  final NumericSqlExpressionBuilder<double> credits;

  final NumericSqlExpressionBuilder<double> unitaryPrice;

  final NumericSqlExpressionBuilder<double> totalHT;

  final NumericSqlExpressionBuilder<double> totalTTC;

  final StringSqlExpressionBuilder status;

  final NumericSqlExpressionBuilder<int> userId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      reference,
      credits,
      unitaryPrice,
      totalHT,
      totalTTC,
      status,
      userId,
    ];
  }
}

class CommandQueryValues extends MapQueryValues {
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

  String get reference {
    return (values['reference'] as String);
  }

  set reference(String value) => values['reference'] = value;

  double get credits {
    return (values['credits'] as double?) ?? 0.0;
  }

  set credits(double value) => values['credits'] = value;

  double get unitaryPrice {
    return (values['unitary_price'] as double?) ?? 0.0;
  }

  set unitaryPrice(double value) => values['unitary_price'] = value;

  double get totalHT {
    return (values['total_h_t'] as double?) ?? 0.0;
  }

  set totalHT(double value) => values['total_h_t'] = value;

  double get totalTTC {
    return (values['total_t_t_c'] as double?) ?? 0.0;
  }

  set totalTTC(double value) => values['total_t_t_c'] = value;

  String get status {
    return (values['status'] as String);
  }

  set status(String value) => values['status'] = value;

  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;

  void copyFrom(Command model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    reference = model.reference;
    credits = model.credits;
    unitaryPrice = model.unitaryPrice;
    totalHT = model.totalHT;
    totalTTC = model.totalTTC;
    status = model.status;
    if (model.user != null) {
      values['user_id'] = model.user?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Command extends CommandEntity {
  Command({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.reference,
    required this.credits,
    required this.unitaryPrice,
    required this.totalHT,
    required this.totalTTC,
    required this.status,
    required this.user,
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
  String reference;

  @override
  double credits;

  @override
  double unitaryPrice;

  @override
  double totalHT;

  @override
  double totalTTC;

  @override
  String status;

  @override
  UserEntity user;

  Command copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? reference,
    double? credits,
    double? unitaryPrice,
    double? totalHT,
    double? totalTTC,
    String? status,
    UserEntity? user,
  }) {
    return Command(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      reference: reference ?? this.reference,
      credits: credits ?? this.credits,
      unitaryPrice: unitaryPrice ?? this.unitaryPrice,
      totalHT: totalHT ?? this.totalHT,
      totalTTC: totalTTC ?? this.totalTTC,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(other) {
    return other is CommandEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.reference == reference &&
        other.credits == credits &&
        other.unitaryPrice == unitaryPrice &&
        other.totalHT == totalHT &&
        other.totalTTC == totalTTC &&
        other.status == status &&
        other.user == user;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      reference,
      credits,
      unitaryPrice,
      totalHT,
      totalTTC,
      status,
      user,
    ]);
  }

  @override
  String toString() {
    return 'Command(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, reference=$reference, credits=$credits, unitaryPrice=$unitaryPrice, totalHT=$totalHT, totalTTC=$totalTTC, status=$status, user=$user)';
  }

  Map<String, dynamic> toJson() {
    return CommandSerializer.toMap(this)!;
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const CommandSerializer commandSerializer = CommandSerializer();

class CommandEncoder extends Converter<Command, Map> {
  const CommandEncoder();

  @override
  Map convert(Command model) => CommandSerializer.toMap(model)!;
}

class CommandDecoder extends Converter<Map, Command> {
  const CommandDecoder();

  @override
  Command convert(Map map) => CommandSerializer.fromMap(map);
}

class CommandSerializer extends Codec<Command, Map> {
  const CommandSerializer();

  @override
  CommandEncoder get encoder => const CommandEncoder();

  @override
  CommandDecoder get decoder => const CommandDecoder();

  static Command fromMap(Map map) {
    return Command(
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
      reference: map['reference'] as String,
      credits: map['credits'] as double,
      unitaryPrice: map['unitary_price'] as double,
      totalHT: map['total_h_t'] as double,
      totalTTC: map['total_t_t_c'] as double,
      status: map['status'] as String,
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map) as UserEntity
              : {} as UserEntity,
    );
  }

  static Map<String, dynamic>? toMap(CommandEntity? model) {
    if (model == null) {
      return null;
      throw FormatException("Command L465, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'reference': model.reference,
      'credits': model.credits,
      'unitary_price': model.unitaryPrice,
      'total_h_t': model.totalHT,
      'total_t_t_c': model.totalTTC,
      'status': model.status,
      'user': UserSerializer.toMap(model.user),
    };
  }
}

abstract class CommandFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    reference,
    credits,
    unitaryPrice,
    totalHT,
    totalTTC,
    status,
    user,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String reference = 'reference';

  static const String credits = 'credits';

  static const String unitaryPrice = 'unitary_price';

  static const String totalHT = 'total_h_t';

  static const String totalTTC = 'total_t_t_c';

  static const String status = 'status';

  static const String user = 'user';
}
