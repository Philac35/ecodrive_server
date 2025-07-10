abstract interface class EntityInterface{




  static T create<T extends EntityInterface>(Map<String, dynamic> parameters) {
    // TODO: implement create
    throw UnimplementedError();
  }

  // We can't use a factory constructor in an abstract class
  // Instead, we'll define an abstract fromJson method
  static EntityInterface fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }
  Map<String, dynamic> toJson();

}

