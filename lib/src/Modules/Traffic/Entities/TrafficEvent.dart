import 'package:xml/xml.dart';

class TrafficEvent {
  final String id;
  late  String type;
  final String description;
  final double latitude;
  final double longitude;
  final double latitudeFrom;
  final double longitudeFrom;
  final double latitudeTo;
  final double longitudeTo;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime situationVersionTime;
  final String overallSeverity;
  final DateTime situationRecordCreationTime;
  final DateTime situationRecordObservationTime;
  final DateTime situationRecordVersionTime;
  final String probabilityOfOccurrence;
  final String sourceIdentification;
  final String sourceName;
  final String reliable;
  final String tpegDirection;
  final String tpegLinearLocationType;
  final String toName;
  final String fromName;
  final String operatingMode;
  final DateTime subscriptionStartTime;
  final String subscriptionState;
  final DateTime subscriptionStopTime;
  final String updateMethod;

  TrafficEvent({
    required this.id,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.latitudeFrom,
    required this.longitudeFrom,
    required this.latitudeTo,
    required this.longitudeTo,
    required this.startDate,
    required this.endDate,
    required this.situationVersionTime,
    required this.overallSeverity,
    required this.situationRecordCreationTime,
    required this.situationRecordObservationTime,
    required this.situationRecordVersionTime,
    required this.probabilityOfOccurrence,
    required this.sourceIdentification,
    required this.sourceName,
    required this.reliable,
    required this.tpegDirection,
    required this.tpegLinearLocationType,
    required this.toName,
    required this.fromName,
    required this.operatingMode,
    required this.subscriptionStartTime,
    required this.subscriptionState,
    required this.subscriptionStopTime,
    required this.updateMethod,
  });

  @override
  String toString() {
    return 'TrafficEvent('
        'id: ${id}, '
        'type: ${type}, '
        'description: ${description}, '
        'latitude: ${latitude}, '
        'longitude: ${longitude}, '
        'latitudeFrom: ${latitudeFrom}, '
        'longitudeFrom: ${longitudeFrom}, '
        'latitudeTo: ${latitudeTo}, '
        'longitudeTo: ${longitudeTo}, '
        'startDate: ${startDate}, '
        'endDate: ${endDate}, '
        'situationVersionTime: ${situationVersionTime}, '
        'overallSeverity: ${overallSeverity}, '
        'situationRecordCreationTime: ${situationRecordCreationTime}, '
        'situationRecordObservationTime: ${situationRecordObservationTime}, '
        'situationRecordVersionTime: ${situationRecordVersionTime}, '
        'probabilityOfOccurrence: ${probabilityOfOccurrence}, '
        'sourceIdentification: ${sourceIdentification}, '
        'sourceName: ${sourceName}, '
        'reliable: ${reliable}, '
        'tpegDirection: ${tpegDirection}, '
        'tpegLinearLocationType: ${tpegLinearLocationType}, '
        'toName: ${toName}, '
        'fromName: ${fromName}, '
        'operatingMode: ${operatingMode}, '
        'subscriptionStartTime: ${subscriptionStartTime}, '
        'subscriptionState: ${subscriptionState}, '
        'subscriptionStopTime: ${subscriptionStopTime}, '
        'updateMethod: ${updateMethod}'
        ')';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'latitudeFrom': latitudeFrom,
      'longitudeFrom': longitudeFrom,
      'latitudeTo': latitudeTo,
      'longitudeTo': longitudeTo,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'situationVersionTime': situationVersionTime.toIso8601String(),
      'overallSeverity': overallSeverity,
      'situationRecordCreationTime': situationRecordCreationTime.toIso8601String(),
      'situationRecordObservationTime': situationRecordObservationTime.toIso8601String(),
      'situationRecordVersionTime': situationRecordVersionTime.toIso8601String(),
      'probabilityOfOccurrence': probabilityOfOccurrence,
      'sourceIdentification': sourceIdentification,
      'sourceName': sourceName,
      'reliable': reliable,
      'tpegDirection': tpegDirection,
      'tpegLinearLocationType': tpegLinearLocationType,
      'toName': toName,
      'fromName': fromName,
      'operatingMode': operatingMode,
      'subscriptionStartTime': subscriptionStartTime.toIso8601String(),
      'subscriptionState': subscriptionState,
      'subscriptionStopTime': subscriptionStopTime.toIso8601String(),
      'updateMethod': updateMethod,
    };
  }


  static TrafficEvent _TrafficEventFromJson(Map<String, dynamic> json) {
    return TrafficEvent(
      id: json['id'] as String, // Cast as String
      type: json['type'] as String, // Cast as String
      description: json['description'] as String, // Cast as String
      latitude: (json['latitude'] as num).toDouble(), // Cast as double
      longitude: (json['longitude'] as num).toDouble(), // Cast as double
      latitudeFrom: (json['latitudeFrom'] as num).toDouble(), // Cast as double
      longitudeFrom: (json['longitudeFrom'] as num).toDouble(), // Cast as double
      latitudeTo: (json['latitudeTo'] as num).toDouble(), // Cast as double
      longitudeTo: (json['longitudeTo'] as num).toDouble(), // Cast as double
      startDate: DateTime.parse(json['startDate']), // Parse ISO8601 string to DateTime
      endDate: DateTime.parse(json['endDate']), // Parse ISO8601 string to DateTime
      situationVersionTime:
      DateTime.parse(json['situationVersionTime']), // Parse DateTime
      overallSeverity: json['overallSeverity'] as String, // Cast as String
      situationRecordCreationTime:
      DateTime.parse(json['situationRecordCreationTime']), // Parse DateTime
      situationRecordObservationTime:
      DateTime.parse(json['situationRecordObservationTime']), // Parse DateTime
      situationRecordVersionTime:
      DateTime.parse(json['situationRecordVersionTime']), // Parse DateTime
      probabilityOfOccurrence:
      json['probabilityOfOccurrence'] as String, // Cast as String
      sourceIdentification: json['sourceIdentification'] as String, // Cast as String
      sourceName: json['sourceName'] as String, // Cast as String
      reliable: json['reliable']!! as String, // Cast as bool
      tpegDirection: json['tpegDirection'] as String, // Cast as String
      tpegLinearLocationType:
      json['tpegLinearLocationType'] as String, // Cast as String
      toName: json['toName'] as String, // Cast as String
      fromName: json['fromName'] as String, // Cast as String
      operatingMode: json['operatingMode'] as String, // Cast as String
      subscriptionStartTime: 
      DateTime.parse(json['subscriptionStartTime']), // Parse DateTime
      subscriptionState: json['subscriptionState'] as String, // Cast as String
      subscriptionStopTime:
      DateTime.parse(json['subscriptionStopTime']), // Parse DateTIme
      updateMethod: json['updateMethod'] as String, // Cast as string
    );
  }

  factory TrafficEvent.fromJson(Map<String, dynamic> json) =>  _TrafficEventFromJson(json);

}


extension XmlUtils on Iterable<XmlElement> {
  XmlElement? get firstOrNull => isEmpty ? null : first;
}

extension StringToDouble on String {
  double toDouble() => double.tryParse(this) ?? 0.0;
}
