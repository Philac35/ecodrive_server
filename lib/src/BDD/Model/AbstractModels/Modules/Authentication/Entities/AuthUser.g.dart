// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthUser.dart';

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
      table.integer('id_int');
      table.varChar('identifiant', length: 255);
      table.varChar('password', length: 255);
      table.declareColumn(
        'role',
        Column(type: ColumnType('jsonb'), length: 255),
      );
      table
          .declare('person_id', ColumnType('int'))
          .references('f_angel_models', 'id');
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
  AuthUserQuery({
    Query? parent,
    Set<String>? trampoline,
  }) : super(parent: parent) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = AuthUserQueryWhere(this);
    leftJoin(
      _person = FAngelModelQuery(
        trampoline: trampoline,
        parent: this,
      ),
      'person_id',
      'id',
      additionalFields: const [
        'id',
        'created_at',
        'updated_at',
      ],
      trampoline: trampoline,
    );
  }

  @override
  final AuthUserQueryValues values = AuthUserQueryValues();

  List<String> _selectedFields = [];

  AuthUserQueryWhere? _where;

  late FAngelModelQuery _person;

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
    const _fields = [
      'id',
      'created_at',
      'updated_at',
      'id_int',
      'identifiant',
      'password',
      'role',
      'person_id',
    ];
    return _selectedFields.isEmpty
        ? _fields
        : _fields.where((field) => _selectedFields.contains(field)).toList();
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
    AuthUserModel? model = AuthUserModel(
      id: fields.contains('id') ? row[0].toString() : null,
      createdAt:
          fields.contains('created_at') ? mapToNullableDateTime(row[1]) : null,
      updatedAt:
          fields.contains('updated_at') ? mapToNullableDateTime(row[2]) : null,
      idInt: fields.contains('id_int') ? mapToInt(row[3]) : null,
      identifiant: fields.contains('identifiant') ? (row[4] as String?) : null,
      password: fields.contains('password') ? (row[5] as String?) : null,
      role: fields.contains('role') ? (row[6] as List<String>?) : null,
    );
    if (row.length > 8) {
      var modelOpt = FAngelModelQuery().parseRow(row.skip(8).take(3).toList());
      modelOpt.ifPresent((m) {
        model = model?.copyWith(person: m) as AuthUserModel?;
      });
    }
    return Optional.of(model as AuthUser);
  }

  @override
  Optional<AuthUser> deserialize(List row) {
    return parseRow(row);
  }

  FAngelModelQuery get person {
    return _person;
  }
}

class AuthUserQueryWhere extends QueryWhere {
  AuthUserQueryWhere(AuthUserQuery query)
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
        identifiant = StringSqlExpressionBuilder(
          query,
          'identifiant',
        ),
        password = StringSqlExpressionBuilder(
          query,
          'password',
        ),
        role = ListSqlExpressionBuilder(
          query,
          'role',
        ),
        personId = NumericSqlExpressionBuilder<int>(
          query,
          'person_id',
        );

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> idInt;

  final StringSqlExpressionBuilder identifiant;

  final StringSqlExpressionBuilder password;

  final ListSqlExpressionBuilder role;

  final NumericSqlExpressionBuilder<int> personId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      idInt,
      identifiant,
      password,
      role,
      personId,
    ];
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

  int? get idInt {
    return (values['id_int'] as int?);
  }

  set idInt(int? value) => values['id_int'] = value;

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
    idInt = model.idInt;
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
class AuthUserModel extends AuthUser {
  AuthUserModel( {
    this.id,
    this.createdAt,
    this.updatedAt,
    this.idInt,
    this.identifiant,
    this.password,
    List<String>? role = const [],
    this.person,
  })  : role = List.unmodifiable(role ?? []),
        super(idInt:idInt, identifiant:identifiant,password: password,role: role, person:person);

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
  String? identifiant;

  @override
  String? password;

  @override
  List<String>? role;

  @override
  Person? person;

  AuthUser copyWith(  {
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? idInt,
    String? identifiant,
    String? password,
    List<String>? role,
    Person? person,
  }) {
    return AuthUserModel(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        idInt: idInt ?? this.idInt,
        identifiant: identifiant ?? this.identifiant,
        password: password ?? this.password,
        role: role ?? this.role,
        person: person ?? this.person);
  }

  @override
  bool operator ==(other) {
    return other is AuthUser &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.idInt == idInt &&
        other.identifiant == identifiant &&
        other.password == password &&
        ListEquality<String>(DefaultEquality<String>())
            .equals(other.role, role) &&
        other.person == person;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      idInt,
      identifiant,
      password,
      role,
      person,
    ]);
  }

  @override
  String toString() {
    return 'AuthUser(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, idInt=$idInt, identifiant=$identifiant, password=$password, role=$role, person=$person)';
  }

  Map<String, dynamic> toJson() {
    return AuthUserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

abstract class AuthUserSerializer {

  static AuthUser fromMap(    Map map
  ) {
    return AuthUserModel(
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
        identifiant: map['identifiant'] as String?,
        password: map['password'] as String?,
        role: map['role'] is Iterable
            ? (map['role'] as Iterable).cast<String>().toList()
            : [],
        person: map['person'] != null
            ? PersonSerializer.fromMap(map['person'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(AuthUser? model) {
    if (model == null) {
      throw FormatException("Required field [model] cannot be null");
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'id_int': model.idInt,
      'identifiant': model.identifiant,
      'password': model.password,
      'role': model.role,
      'person': PersonSerializer.toMap(model.person)
    };
  }
}

abstract class AuthUserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    idInt,
    identifiant,
    password,
    role,
    person,
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String idInt = 'id_int';

  static const String identifiant = 'identifiant';

  static const String password = 'password';

  static const String role = 'role';

  static const String person = 'person';
}
