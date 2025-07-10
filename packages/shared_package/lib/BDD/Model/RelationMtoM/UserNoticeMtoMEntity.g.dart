// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserNoticeMtoMEntity.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class UserNoticeMtoMMigration extends Migration {
  @override
  void up(Schema schema) {
    schema.create('user_notice_mto_ms', (table) {
      table.declare('notice_id', ColumnType('int')).references('notices', 'id');
      table.declare('user_id', ColumnType('int')).references('people', 'id');
    });
  }

  @override
  void down(Schema schema) {
    schema.drop('user_notice_mto_ms');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class UserNoticeMtoMQuery
    extends Query<UserNoticeMtoM, UserNoticeMtoMQueryWhere> {
  UserNoticeMtoMQuery({super.parent, Set<String>? trampoline}) {
    trampoline ??= <String>{};
    trampoline.add(tableName);
    _where = UserNoticeMtoMQueryWhere(this);
    leftJoin(
      _notice = NoticeQuery(trampoline: trampoline, parent: this),
      'notice_id',
      'id',
      additionalFields: const [
        'id',
        'updated_at',
        'title',
        'description',
        'note',
        'created_at',
        'driver_id',
      ],
      trampoline: trampoline,
    );
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
  final UserNoticeMtoMQueryValues values = UserNoticeMtoMQueryValues();

  List<String> _selectedFields = [];

  UserNoticeMtoMQueryWhere? _where;

  late NoticeQuery _notice;

  late PersonQuery _user;

  @override
  Map<String, String> get casts {
    return {};
  }

  @override
  String get tableName {
    return 'user_notice_mto_ms';
  }

  @override
  List<String> get fields {
    const localFields = ['notice_id', 'user_id'];
    return _selectedFields.isEmpty
        ? localFields
        : localFields
            .where((field) => _selectedFields.contains(field))
            .toList();
  }

  UserNoticeMtoMQuery select(List<String> selectedFields) {
    _selectedFields = selectedFields;
    return this;
  }

  @override
  UserNoticeMtoMQueryWhere? get where {
    return _where;
  }

  @override
  UserNoticeMtoMQueryWhere newWhereClause() {
    return UserNoticeMtoMQueryWhere(this);
  }

  Optional<UserNoticeMtoM> parseRow(List row) {
    if (row.every((x) => x == null)) {
      return Optional.empty();
    }
    var model = UserNoticeMtoM();
    if (row.length > 2) {
      var modelOpt = NoticeQuery().parseRow(row.skip(2).take(7).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(notice: m);
      });
    }
    if (row.length > 9) {
      var modelOpt = PersonQuery().parseRow(row.skip(9).take(9).toList());
      modelOpt.ifPresent((m) {
        model = model.copyWith(user: m as UserEntity);
      });
    }
    return Optional.of(model);
  }

  @override
  Optional<UserNoticeMtoM> deserialize(List row) {
    return parseRow(row);
  }

  NoticeQuery get notice {
    return _notice;
  }

  PersonQuery get user {
    return _user;
  }
}

class UserNoticeMtoMQueryWhere extends QueryWhere {
  UserNoticeMtoMQueryWhere(UserNoticeMtoMQuery query)
    : noticeId = NumericSqlExpressionBuilder<int>(query, 'notice_id'),
      userId = NumericSqlExpressionBuilder<int>(query, 'user_id');

  final NumericSqlExpressionBuilder<int> noticeId;

  final NumericSqlExpressionBuilder<int> userId;

  @override
  List<SqlExpressionBuilder> get expressionBuilders {
    return [noticeId, userId];
  }
}

class UserNoticeMtoMQueryValues extends MapQueryValues {
  @override
  Map<String, String> get casts {
    return {};
  }

  int get noticeId {
    return (values['notice_id'] as int);
  }

  set noticeId(int value) => values['notice_id'] = value;

  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;

  void copyFrom(UserNoticeMtoM model) {
    if (model.notice != null) {
      values['notice_id'] = model.notice?.id;
    }
    if (model.user != null) {
      values['user_id'] = model.user?.id;
    }
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class UserNoticeMtoM implements UserNoticeMtoMEntity {
  UserNoticeMtoM({this.notice, this.user});

  @override
  NoticeEntity? notice;

  @override
  UserEntity? user;

  UserNoticeMtoM copyWith({NoticeEntity? notice, UserEntity? user}) {
    return UserNoticeMtoM(
      notice: notice ?? this.notice,
      user: user ?? this.user,
    );
  }

  @override
  bool operator ==(other) {
    return other is UserNoticeMtoMEntity &&
        other.notice == notice &&
        other.user == user;
  }

  @override
  int get hashCode {
    return hashObjects([notice, user]);
  }

  @override
  String toString() {
    return 'UserNoticeMtoM(notice=$notice, user=$user)';
  }

  Map<String, dynamic> toJson() {
    return UserNoticeMtoMSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const UserNoticeMtoMSerializer userNoticeMtoMSerializer =
    UserNoticeMtoMSerializer();

class UserNoticeMtoMEncoder extends Converter<UserNoticeMtoM, Map> {
  const UserNoticeMtoMEncoder();

  @override
  Map convert(UserNoticeMtoM model) => UserNoticeMtoMSerializer.toMap(model);
}

class UserNoticeMtoMDecoder extends Converter<Map, UserNoticeMtoM> {
  const UserNoticeMtoMDecoder();

  @override
  UserNoticeMtoM convert(Map map) => UserNoticeMtoMSerializer.fromMap(map);
}

class UserNoticeMtoMSerializer extends Codec<UserNoticeMtoM, Map> {
  const UserNoticeMtoMSerializer();

  @override
  UserNoticeMtoMEncoder get encoder => const UserNoticeMtoMEncoder();

  @override
  UserNoticeMtoMDecoder get decoder => const UserNoticeMtoMDecoder();

  static UserNoticeMtoM fromMap(Map map) {
    return UserNoticeMtoM(
      notice:
          map['notice'] != null
              ? NoticeSerializer.fromMap(map['notice'] as Map)
              : null,
      user:
          map['user'] != null
              ? UserSerializer.fromMap(map['user'] as Map)
              : null,
    );
  }

  static Map<String, dynamic> toMap(UserNoticeMtoMEntity? model) {
    if (model == null) {
      throw FormatException("UserNoticeMtoMEntity L279, Required field [model] cannot be null");
    }
    return {
      'notice': NoticeSerializer.toMap(model.notice),
      'user': UserSerializer.toMap(model.user),
    };
  }
}

abstract class UserNoticeMtoMFields {
  static const List<String> allFields = <String>[notice, user];

  static const String notice = 'notice';

  static const String user = 'user';
}
