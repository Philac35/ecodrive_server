
import 'package:angel3_migration/angel3_migration.dart';
class AddItineraryFKMigration extends Migration {


  @override
  Future<void> up(Schema schema) async {

    schema.alter('itineraries', (table) {
      // Adding foreign keys for addressDeparture and addressArrival
      var addressDepartureRef = table.integer('addressDeparture_id').references('addresses', 'id');
      addressDepartureRef.onDeleteCascade();

      var addressArrivalRef = table.integer('addressArrival_id').references('addresses', 'id');
      addressArrivalRef.onDeleteCascade();

      var travelRef = table.integer('travel_id').references('travels', 'id');
      travelRef.onDeleteCascade();

    });
  }

  @override
  Future<void> down(Schema schema) async {
    // If supported, drop foreign keys here or ignore.
  }
}
