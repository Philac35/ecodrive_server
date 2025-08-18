import 'dart:convert';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:test/test.dart';
import 'dart:typed_data';
import 'package:shared_package/BDD/Model/AbstractModels/AssuranceEntity.dart' ;
import 'package:shared_package/BDD/Model/AbstractModels/VehiculeEntity.dart' ;
import 'package:shared_package/BDD/Model/AbstractModels/PhotoEntity.dart' ;

// Assuming you import or have access to the classes like AssuranceQuery, Assurance, VehiculeQuery, PhotoQuery, Optional, etc.

final exampleBytes = Uint8List.fromList([1, 2, 3]);
// Convert as JSON string if jsonStrToUint expects JSON array string
final jsonString = jsonEncode(exampleBytes.toList());

late final dynamic Function() queryFactory ;


/**
 * Function getFieldNumber
 * Get field Number from queryEntity
 */
int getFieldNumber(queryFactory){
var field=queryFactory.fields;
print(" fields number: ${field.length} ");
return field.length;
}

addRowParameters(String entityName,List row,int start,int nbOfRow,Map exceptions ){
  int end= start+nbOfRow;
  for (int i = start; i < end; i++) {
    if( exceptions[i]!=null){row[i]=exceptions[i];}
    else{
      row[i] = '${entityName}_field_${i}';
    }
  }
}

void main() {
  group('AssuranceQuery parseRow', () {
    late AssuranceQuery query;
    late VehiculeQuery vehiculeQueryquery;
    Map rowCount={};

    setUp(() {
      query = AssuranceQuery();
      // Optionally configure fields if needed for your environment.
      // You might simulate fields present:
       final fields = query.fields;
      rowCount[ "assuranceFieldCount"] = getFieldNumber(query);
      rowCount[ "vehiculeFieldCount"] = getFieldNumber(VehiculeQuery());
      rowCount[ "photoFieldCount"] = getFieldNumber(PhotoQuery());

      final totalFieldCount =  rowCount[ "assuranceFieldCount"]  +    rowCount[ "vehiculeFieldCount"] +  rowCount[ "photoFieldCount"] ;
      print("totalFieldCount =$totalFieldCount");

      query.select([
        'id', 'created_at', 'updated_at', 'identification_number',
        'document_pdf', 'title', 'path', 'vehicule_id', 'photo_id'
      ]);
    });

    test('returns empty Optional for all-null row', () {
      final row = List.filled(51, null);
      final result = query.parseRow(row);
      expect(result.isPresent, isFalse);
    });

    test('parses base Assurance fields correctly', () {
      List? row = List.filled(51,null);

      // Populate only Assurance fields (first 9)
      row[0] = '42' ; // id as string
      row[1] = DateTime(2020, 1, 1).toIso8601String(); // created_at string for mapToNullableDateTime
      row[2] = DateTime(2020, 2, 1).toIso8601String(); // updated_at
      row[3] = 12345; // identification_number (int)

      // document_pdf: you may want to test both a null, String, and binary case.
      row[4] = jsonString; // Assign JSON string
      row[5] = 'Title example'; // title
      row[6] = 'some/path'; // path
      row[7] = '10'; // vehicule_id parsed as int
      row[8] = '20'; // photo_id parsed as int

      final result = query.parseRow(row);
      expect(result.isPresent, isTrue);

      final assurance = result.value;
      expect(assurance.id, '42');
      expect(assurance.createdAt, isNotNull);  // check nullable date
      expect(assurance.identificationNumber, 12345);
      expect(assurance.documentPdf, isNotNull); // decompression tested
      expect(assurance.title, 'Title example');
      expect(assurance.path, 'some/path');
      expect(assurance.vehiculeId, 10);
      expect(assurance.photoId, 20);
      expect(assurance.vehicule, isNull);  // no vehicule joined data here
      expect(assurance.photo, isNull);    // no photo joined data here
    });

    test('parses joined Vehicule and Photo entities', () {
      // Construct full row with dummy data for Assurance + Vehicule + Photo

      List? row = List.filled(51, null);

      // First 9 for Assurance
      // Add RowParameters for Assurance

        Map  firstAssuranceParameters= {0:'1',
                                  1:DateTime.now().toIso8601String(),
                                  2:DateTime(2020, 2, 1).toIso8601String(),
                                  3:12345,
                                  4:jsonString,
                                  7:10,
                                  8:20
                               };

      // ... fill rest similarly or leave as null
      addRowParameters("assurance",row,0,
          rowCount[ "assuranceFieldCount"],firstAssuranceParameters);

      // For simplification, fill strings or nulls as per Vehicule parseRow expects
      var preferences = jsonEncode(['verte', 'eco']);  //preferences
     // Add RowParameters for vehicule
      addRowParameters("vehicule",row,rowCount[ "assuranceFieldCount"],
          rowCount[ "vehiculeFieldCount"],{19:preferences});

      // Add RowParameters for photo
      addRowParameters("photo",row,rowCount[ "assuranceFieldCount"]+rowCount[ "vehiculeFieldCount"],
          rowCount[ "photoFieldCount"],{28:jsonString});


      final result = query.parseRow(row);
      expect(result.isPresent, isTrue);

      final assurance = result.value;
      expect(assurance.vehicule, isNotNull);
      expect(assurance.photo, isNotNull);

      // Further checks can be made by inspecting fields of vehicule and photo parsed models.
    });

    test('handles partial rows gracefully', () {
      // Row too short - no vehicule or photo data
      List? row = List.filled(9, null);
      row[0] = 'test';

      final result = query.parseRow(row);
      expect(result.isPresent, isTrue);
      final assurance = result.value;
      expect(assurance.vehicule, isNull);
      expect(assurance.photo, isNull);
    });
  });
}
