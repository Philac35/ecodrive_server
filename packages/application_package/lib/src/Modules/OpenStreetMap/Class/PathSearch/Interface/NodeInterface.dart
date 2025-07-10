abstract interface class NodeInterface{

   get id;
   get latitude;
   get longitude;

    get successors ;

   Map<String,dynamic> toJson();
  factory NodeInterface.fromJson(Map<String, dynamic> json){
    //TODO Implement the factory
    throw UnimplementedError();
  }


   String toString() ;










}