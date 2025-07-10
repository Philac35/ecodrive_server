// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUserEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class AuthUserMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('auth_users', (table) {
      table.serial('id').primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('identifiant', length: 255);
      table.varChar('password', length: 255);
      table.declareColumn(
        'role',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table.declare('person_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('auth_users');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class AuthUserQuery extends Query<AuthUser, AuthUserQueryWhere> {
  AuthUserQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AuthUserQueryWhere(this);
    leftJoin(
      _person = PersonQuery(trampoline: trampoline, parent: this),
      'person_id',
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
  final AuthUserQueryValues values = AuthUserQueryValues();

  List<String> _selectedFields = [];

  AuthUserQueryWhere? _where;

  late PersonQuery _person;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'auth_users';
  }

  @override
  List<String> get fields {
    const localFields = [
      'id',
      'created_at',
      'updated_at',
      'identifiant',
      'password',
      'role',
      'person_id',
    ];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  AuthUserQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  AuthUserQueryWhere? get where {
    return _where;
  }

  @override
  AuthUserQueryWhere newWhereClause() {
    return AuthUserQueryWhere(this);
  }

  Optional<AuthUser> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = AuthUser(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      identifiant: fields.contains('identifiant') ? (row[3] as String?) : null,
      password: fields.contains('password') ? (row[4] as String?) : null,
      role: fields.contains('role') ? (row[5] as List<String>?) : null,
    );
    if (row.length > 7) {
      var modelOpt = PersonQuery().parseRow(row.skip(7).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(person: m);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<AuthUser> deserialize(List row) {
    return parseRow(row);
  }

  PersonQuery get person {
    return _person;
  }
}

class AuthUserQueryWhere extends QueryWhere {
  AuthUserQueryWhere(AuthUserQuery query)
    : id = NumericSqlExpressionBuilder<int>(query, 'id'),
      createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
      updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
      identifiant = StringSqlExpressionBuilder(query, 'identifiant'),
      password = StringSqlExpressionBuilder(query, 'password'),
      role = ListSqlExpressionBuilder(query, 'role'),
      personId = NumericSqlExpressionBuilder<int>(query, 'person_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder identifiant;

  final StringSqlExpressionBuilder password;

  final ListSqlExpressionBuilder role;

  final NumericSqlExpressionBuilder<int> personId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [id, createdAt, updatedAt, identifiant, password, role, personId];
  }
}

class AuthUserQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {'role': 'jsonb'};
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

  String? get identifiant {
    return (values['identifiant'] as String?);
  }

  set identifiant(String? value) => values['identifiant'] = value;

  String? get password {
    return (values['password'] as String?);
  }

  set password(String? value) => values['password'] = value;

  List<String>? get role {
    return json.decode((values['role'] as String)).cast();
  }

  set role(List<String>? value) => values['role'] = json.encode(value);

  int get personId {
    return (values['person_id'] as int);
  }

  set personId(int value) => values['person_id'] = value;

  void copyFrom(AuthUser model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    identifiant = model.identifiant;
    password = model.password;
    role = model.role;
    if (model.person != null) {
      values['person_id'] = model.person?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class AuthUser extends AuthUserEntity {
  AuthUser({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.identifiant,
    this.password,
    List<String>? role = const [],
    this.person,
  }) : role = List.unmodifiable(role ?? []);

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
  String? identifiant;

  @override
  String? password;

  @override
  List<String>? role;

  @override
  PersonEntity? person;

  AuthUser copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? identifiant,
    String? password,
    List<String>? role,
    PersonEntity? person,
  }) {
    return AuthUser(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      identifiant: identifiant ?? this.identifiant,
      password: password ?? this.password,
      role: role ?? this.role,
      person: person ?? this.person,
    );
  }

  @override
  bool operator ==(other) {
    return other is AuthUserEntity &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.identifiant == identifiant &&
        other.password == password &&
        ListEquality<String>(
          DefaultEquality<String>(),
        ).equals(other.role, role) &&
        other.person == person;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      identifiant,
      password,
      role,
      person,
    ]);
  }

  @override
  String toString() {
    return 'AuthUser(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, identifiant=$identifiant, password=$password, role=$role, person=$person)';
  }

  Map<String, dynamic> toJson() {
    return AuthUserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const AuthUserSerializer authUserSerializer = AuthUserSerializer();

class AuthUserEncoder extends Converter<AuthUser, Map> {
  const AuthUserEncoder();

  @override
  Map convert(AuthUser model) => AuthUserSerializer.toMap(model);
}

class AuthUserDecoder extends Converter<Map, AuthUser> {
  const AuthUserDecoder();

  @override
  AuthUser convert(Map map) => AuthUserSerializer.fromMap(map);
}

class AuthUserSerializer extends Codec<AuthUser, Map> {
  const AuthUserSerializer();

  @override
  AuthUserEncoder get encoder => const AuthUserEncoder();

  @override
  AuthUserDecoder get decoder => const AuthUserDecoder();

  static AuthUser fromMap(Map map) {
    return AuthUser(
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
      identifiant: map['identifiant'] as String?,
      password: map['password'] as String?,
      role:
          map['role'] is Iterable
              ? (map['role'] as Iterable).cast<String>().toList()
              : [],
      person:
          map['person'] != null
              ? PersonSerializer.fromMap(map['person'] as Map)
              : null,
    );
  }

  static Map<String, dynamic> toMap(AuthUserEntity? model) {
    if (model == null) {
      return {}; //Modified 7/07/2025 17h56
      throw FormatException("AuthUserEntity L391, Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'identifiant': model.identifiant,
      'password': model.password,
      'role': model.role,
      'person': PersonSerializer.toMap(model.person),
    };
  }
}

abstract class AuthUserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    identifiant,
    password,
    role,
    person,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String identifiant = 'identifiant';

  static const String password = 'password';

  static const String role = 'role';

  static const String person = 'person';
}
