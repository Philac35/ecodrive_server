abstract interface class EntityInterface{




  static T create<T extends EntityInterface>(Map<String, dynamic> parameters) {
    // TODO: implement create
    throw UnimplementedError();
  }


     dynamic get id; //String or int


  /// Returns the [id], parsed as an [int].
     int get idAsInt => id != null ? int.tryParse(id ?? "-1") ?? -1 : -1;

   /// Returns the [id] or "" if null.
  String get idAsString => id ?? "";

  String? get cascadeTempKey;

  void set cascadeTempKey(String? key);

  void setField(String key, dynamic value);

  dynamic getField(String key);

  // We can't use a factory constructor in an abstract class
  // Instead, we'll define an abstract fromJson method
  static EntityInterface fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
  Map<String, dynamic>? toJson();

}

