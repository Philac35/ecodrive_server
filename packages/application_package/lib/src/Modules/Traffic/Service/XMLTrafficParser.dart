import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../Entities/TrafficEvent.dart';
import 'package:xml/xml.dart';
import 'package:intl/intl.dart';
class XMLTrafficParser {
  final bool isEncrypted;
  String? result;
  final String ns2 = 'http://datex2.eu/schema/2/2_0';

  XMLTrafficParser({required this.isEncrypted});



  Future<List<TrafficEvent>?> fetchTrafficEvents(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        result = response.body;

        // Parse the result and return traffic events
        return parseResult();
      } else {
        debugPrint('XMLTrafficParser L24 ,Request failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      debugPrint('XMLTrafficParser L28 ,fetchTrafficEvents,Error occurred: $e');
      debugPrint('XMLTrafficParser L29 ,Stack trace: $stackTrace');
      return [];
    }
  }


  /*
  * Function parseResult
  */
  Future <List<TrafficEvent>> parseResult() async {
    List<TrafficEvent> listTraffic;
    String description = "";
    if (result == null) {
      return [];
    }

    //debugPrint("XMLTrafficParser, Document xml"+document.toString());
    // Find all situationRecord elements
    //compute create an isolate to fetch data in background and the map state fluid.
    return await (compute (this.parse,result!) ?? Future.value([]));


    }


  /*
   *   Function decodeUtf8
   */
  String decodeUtf8(String input) {
    return utf8.decode(input.codeUnits);
  }



  /*
   * Function parse Asynchroniously
   */
  Future <List<TrafficEvent>>  parse(String xmlContent) async {
    List<TrafficEvent> listTraffic= [];
    try {
      // Simulate a delay to handle long operations
      await Future.delayed(Duration(seconds: 20));

      //debugPrint("XLMTraficParser L65 xmlContent: "+xmlContent);
      final document = XmlDocument.parse(xmlContent);
      final soapEnvelope = document.findAllElements('soap:Envelope').first;
      if (soapEnvelope == null) {
        print('soap:Envelope not found');
        return Future.value([]);
      }

      final soapBody = soapEnvelope.findAllElements('soap:Body').first;
      if (soapBody == null) {
        print('soap:Body not found');
        return Future.value([]);;
      }

      final d2LogicalModel = soapBody.findAllElements('d2LogicalModel').first;
      if (d2LogicalModel == null) {
        print('d2LogicalModel not found');
        return Future.value([]);;
      }

      final exchange = d2LogicalModel.findAllElements('exchange', namespace: ns2).firstOrNull;
      String operatingMode = 'Unknown';
      DateTime subscriptionStartTime = DateTime.now();
      String subscriptionState = 'Unknown';
      DateTime subscriptionStopTime = DateTime.now();
      String updateMethod = 'Unknown';
      String encodage='utf-8';
      if (exchange != null) {
        try {
          final supplierIdentification = exchange.findAllElements('supplierIdentification', namespace: ns2).first;
          if (supplierIdentification == null) {
            print('ns2:supplierIdentification not found');
          } else {

            final country = supplierIdentification.findAllElements('country', namespace: ns2).first?.text;
            final nationalIdentifier = supplierIdentification.findAllElements('nationalIdentifier', namespace: ns2).first?.text;

            if (country == null || nationalIdentifier == null) {
              print('Country or National Identifier not found');
            } else {
           //   debugPrint('Country: ${country}');
             // debugPrint('National Identifier: ${nationalIdentifier}');
            }
          }

          final subscription = exchange.findAllElements('subscription', namespace: ns2).first;
          if (subscription == null) {
            print('ns2:subscription not found');
          } else {
            operatingMode = subscription.findAllElements('operatingMode', namespace: ns2).first!.text ?? 'Unknown';
            final subscriptionStartTimeElement = subscription.findAllElements('subscriptionStartTime', namespace: ns2).first;
            subscriptionStartTime = subscriptionStartTimeElement != null ? DateTime.parse(subscriptionStartTimeElement.text) : DateTime.now();
            subscriptionState = subscription.findAllElements('subscriptionState', namespace: ns2).first?.text ?? 'Unknown';
            final subscriptionStopTimeElement = subscription.findAllElements('subscriptionStopTime', namespace: ns2).first;
            subscriptionStopTime = subscriptionStopTimeElement != null ? DateTime.parse(subscriptionStopTimeElement.text) : DateTime.now();
            updateMethod = subscription.findAllElements('updateMethod', namespace: ns2).first?.text ?? 'Unknown';
/*
            print('Operating Mode: ${operatingMode}');
            print('Subscription Start Time: ${subscriptionStartTime}');
            print('Subscription State: ${subscriptionState}');
            print('Subscription Stop Time: ${subscriptionStopTime}');
            print('Update Method: ${updateMethod}');
  */
          }
        } catch (e) {
          print('Error parsing exchange: ${e}');
        }
      }

      final payloadPublication = d2LogicalModel.findAllElements('payloadPublication', namespace: ns2).first;
      if (payloadPublication == null) {
        print('ns2:payloadPublication not found');
        return Future.value([]);;
      }

      try {
        final situations = payloadPublication.findAllElements('situation', namespace: ns2);
        var n = 0;
        for (final situation in situations) {
          n += 1;
          try {
            final situationId = situation.getAttribute('id') ?? 'Unknown';
            final overallSeverityElement = situation.findAllElements('overallSeverity', namespace: ns2).first;
            final overallSeverity = overallSeverityElement?.text;
            final situationVersionTimeElement = situation.findAllElements('situationVersionTime', namespace: ns2).first;
            final situationVersionTime = situationVersionTimeElement != null ? DateTime.parse(situationVersionTimeElement.text) : null;
            final situationRecord = situation.findAllElements('situationRecord', namespace: ns2).first;

            if (overallSeverity == null || situationVersionTime == null || situationRecord == null) {
              print('Overall Severity, Situation Version Time, or Situation Record not found');
              continue;
            }

            final situationRecordCreationTimeElement = situationRecord.findAllElements('situationRecordCreationTime', namespace: ns2).first;
            final situationRecordCreationTime = situationRecordCreationTimeElement != null ? DateTime.parse(situationRecordCreationTimeElement.text) : null;
            final situationRecordObservationTimeElement = situationRecord.findAllElements('situationRecordObservationTime', namespace: ns2).first;
            final situationRecordObservationTime = situationRecordObservationTimeElement != null ? DateTime.parse(situationRecordObservationTimeElement.text) : null;
            final situationRecordVersionTimeElement = situationRecord.findAllElements('situationRecordVersionTime', namespace: ns2).first;
            final situationRecordVersionTime = situationRecordVersionTimeElement != null ? DateTime.parse(situationRecordVersionTimeElement.text) : null;
            final probabilityOfOccurrenceElement = situationRecord.findAllElements('probabilityOfOccurrence', namespace: ns2).first;
            final probabilityOfOccurrence = probabilityOfOccurrenceElement?.text;
            final source = situationRecord.findAllElements('source', namespace: ns2).first;

            if (situationRecordCreationTime == null || situationRecordObservationTime == null || situationRecordVersionTime == null || probabilityOfOccurrence == null || source == null) {
              print('Situation Record details not found');
              continue;
            }

            final sourceIdentificationElement = source.findAllElements('sourceIdentification', namespace: ns2).first;
            final sourceIdentification = sourceIdentificationElement?.text;
            final sourceNameElement = source.findAllElements('sourceName', namespace: ns2).first?.findAllElements('value', namespace: ns2).first;
            final sourceName = sourceNameElement?.text;
            final reliableElement = source.findAllElements('reliable', namespace: ns2).first;
            final reliable = reliableElement?.text;

            if (sourceIdentification == null || sourceName == null || reliable == null) {
              print('Source details not found');
              continue;
            }

/*
            print("");
            print("Element ${n}");
            print('Situation ID: ${situationId}');
            print('Overall Severity: ${overallSeverity}');
            print('Situation Version Time: ${situationVersionTime}');
            print('Situation Record Creation Time: ${situationRecordCreationTime}');
            print('Situation Record Observation Time: ${situationRecordObservationTime}');
            print('Situation Record Version Time: ${situationRecordVersionTime}');
            print('Probability of Occurrence: ${probabilityOfOccurrence}');
            print('Source Identification: ${sourceIdentification}');
            print('Source Name: ${sourceName}');
            print('Reliable: ${reliable}');
*/
            final validity = situationRecord.findAllElements('validity', namespace: ns2).first;
            if (validity == null) {
              print('ns2:validity not found in situationRecord');
              continue;
            }

            final validityTimeSpecification = validity.findAllElements('validityTimeSpecification', namespace: ns2).first;
            if (validityTimeSpecification == null) {
              print('Validity Time Specification not found');
              continue;
            }

            final overallStartTimeElement = validityTimeSpecification.findAllElements('overallStartTime', namespace: ns2).first;
            final overallStartTime = overallStartTimeElement != null ? DateTime.parse(overallStartTimeElement.text) : null;
            final overallEndTimeElement = validityTimeSpecification.findAllElements('overallEndTime', namespace: ns2).first;
            final overallEndTime = overallEndTimeElement != null ? DateTime.parse(overallEndTimeElement.text) : null;

            if (overallStartTime == null) {
              print('Overall Start Time not found');
              continue;
            }

            final groupOfLocations = situationRecord.findAllElements('groupOfLocations', namespace: ns2).first;
            if (groupOfLocations == null) {
              print('ns2:groupOfLocations not found in situationRecord');
              continue;
            }

            final tpegLinearLocation = groupOfLocations.findAllElements('tpegLinearLocation', namespace: ns2).first;
            if (tpegLinearLocation == null) {
              print('ns2:tpegLinearLocation not found in groupOfLocations');
              continue;
            }

            final tpegDirectionElement = tpegLinearLocation.findAllElements('tpegDirection', namespace: ns2).first;
            final tpegDirection = tpegDirectionElement?.text;
            final tpegLinearLocationTypeElement = tpegLinearLocation.findAllElements('tpegLinearLocationType', namespace: ns2).first;
            final tpegLinearLocationType = tpegLinearLocationTypeElement?.text;
            final fromPoint = tpegLinearLocation.findAllElements('from', namespace: ns2).first;
            final toPoint = tpegLinearLocation.findAllElements('to', namespace: ns2).first;

            if (tpegDirection == null || tpegLinearLocationType == null || fromPoint == null || toPoint == null) {
              print('TPEG Linear Location details not found');
              continue;
            }

            final fromLatitudeElement = fromPoint.findAllElements('latitude', namespace: ns2).first;
            final fromLatitude = fromLatitudeElement != null ? double.tryParse(fromLatitudeElement.text) : null;
            final fromLongitudeElement = fromPoint.findAllElements('longitude', namespace: ns2).first;
            final fromLongitude = fromLongitudeElement != null ? double.tryParse(fromLongitudeElement.text) : null;
            final fromNameElement = fromPoint.findAllElements('name', namespace: ns2).first?.findAllElements('value', namespace: ns2).first;
            final fromName = fromNameElement?.text;

            final toLatitudeElement = toPoint.findAllElements('latitude', namespace: ns2).first;
            final toLatitude = toLatitudeElement != null ? double.tryParse(toLatitudeElement.text) : null;
            final toLongitudeElement = toPoint.findAllElements('longitude', namespace: ns2).first;
            final toLongitude = toLongitudeElement != null ? double.tryParse(toLongitudeElement.text) : null;
            final toNameElement = toPoint.findAllElements('name', namespace: ns2).first?.findAllElements('value', namespace: ns2).first;
            final toName = toNameElement?.text;

            if (fromLatitude == null || fromLongitude == null || toLatitude == null || toLongitude == null || fromName == null || toName == null) {
              print('Latitude, Longitude, or Name not found');
              continue;
            }
/*
            print('TPEG Direction: ${tpegDirection}');
            print('TPEG Linear Location Type: ${tpegLinearLocationType}');
            print('To Latitude: ${toLatitude}');
            print('To Longitude: ${toLongitude}');
            print('To Name: ${toName}');
            print('From Latitude: ${fromLatitude}');
            print('From Longitude: ${fromLongitude}');
            print('From Name: ${fromName}');
 */
            final generalPublicComments = situationRecord.findAllElements('generalPublicComment', namespace: ns2);
            String description = 'No description';
            for (final comment in generalPublicComments) {
              final commentValueElement = comment.findAllElements('value', namespace: ns2).first;
              final commentValue = commentValueElement?.text;
              if (commentValue != null) {
                description = commentValue;
                break;
              }
            }

            // Create a TrafficEvent object with the parsed data
            final event = TrafficEvent(
              id : decodeUtf8( situationId),
              type: decodeUtf8(overallSeverity) ?? 'Unknown',
              description : decodeUtf8( description),
              latitude : fromLatitude, // Assuming 'latitude' is the same as 'latitudeFrom'
              longitude: fromLongitude, // Assuming 'longitude' is the same as 'longitudeFrom'
              latitudeFrom: fromLatitude,
              longitudeFrom: fromLongitude,
              latitudeTo: toLatitude,
              longitudeTo: toLongitude,
              startDate: overallStartTime,
              endDate: overallEndTime ?? DateTime.now(),
              situationVersionTime: situationVersionTime,
              overallSeverity: overallSeverity ?? 'Unknown',
              situationRecordCreationTime: situationRecordCreationTime,
              situationRecordObservationTime: situationRecordObservationTime,
              situationRecordVersionTime: situationRecordVersionTime,
              probabilityOfOccurrence: probabilityOfOccurrence ?? 'Unknown',
              sourceIdentification : decodeUtf8( sourceIdentification )?? 'Unknown',
              sourceName : decodeUtf8( sourceName )?? 'Unknown',
              reliable: reliable ?? 'Unknown',
              tpegDirection: tpegDirection ?? 'Unknown',
              tpegLinearLocationType: tpegLinearLocationType ?? 'Unknown',
              toName : decodeUtf8( toName )?? 'Unknown',
              fromName : decodeUtf8( fromName )?? 'Unknown',
              operatingMode: operatingMode,
              subscriptionStartTime: subscriptionStartTime,
              subscriptionState: subscriptionState,
              subscriptionStopTime: subscriptionStopTime,
              updateMethod: updateMethod,
            );

            // Print the TrafficEvent object
            //   debugPrint(event);
            listTraffic.add(event);

          } catch (e) {
            print('Error parsing situation: ${e}');
          }
        }

      //  return listTraffic;
      } catch (e) {
        print('Error parsing payloadPublication: ${e}');
      }
    } catch (e, stack) {
      print('Error parsing XML: ${e}');
      print('Stacktrace: ${stack}');
    }
    return listTraffic;
  }


  /*
   * Function parse synchronous (first step)
   */
  void parseSynchro(String xmlContent) {

  final document = XmlDocument.parse(xmlContent);
  final soapEnvelope = document
      .findAllElements('soap:Envelope')
      .first;
  final soapBody = soapEnvelope
      .findAllElements('soap:Body')
      .first;
  final d2LogicalModel = soapBody
      .findAllElements('d2LogicalModel')
      .first;
  final exchange = d2LogicalModel
      .findAllElements('exchange',namespace:ns2)
      .firstOrNull;
  final supplierIdentification = exchange
      ?.findAllElements('supplierIdentification', namespace: ns2)
      .first;
  final country = supplierIdentification
      ?.findAllElements('country',namespace: ns2)
      .first
      .text;
  final nationalIdentifier = supplierIdentification
      ?.findAllElements('nationalIdentifier',namespace: ns2)
      .first
      .text;
/*
  print('Country: ${country ?? "Not Fetched"}');
  print('National Identifier: ${nationalIdentifier?? "Not Fetched"}');
*/
  final subscription = exchange
      ?.findAllElements('subscription',namespace: ns2)
      .first;
  final operatingMode = subscription
      ?.findAllElements('operatingMode',namespace: ns2)
      .first
      .text;
  final subscriptionStartTime = DateTime.parse(subscription
      !.findAllElements('subscriptionStartTime',namespace: ns2)
      .first
      .text);
  final subscriptionState = subscription
      .findAllElements('subscriptionState',namespace: ns2)
      .first
      .text;
  final subscriptionStopTime = DateTime.parse(subscription
      .findAllElements('subscriptionStopTime',namespace: ns2)
      .first
      .text);
  final updateMethod = subscription
      .findAllElements('updateMethod',namespace: ns2)
      .first
      .text;
/*
  print('Operating Mode: ${operatingMode}');
  print('Subscription Start Time: ${subscriptionStartTime}');
  print('Subscription State: ${subscriptionState}');
  print('Subscription Stop Time: ${subscriptionStopTime}');
  print('Update Method: ${updateMethod}');
*/
  final payloadPublication = d2LogicalModel
      .findAllElements('payloadPublication',namespace: ns2)
      .first;
  final feedType = payloadPublication
      .findAllElements('feedType',namespace: ns2)
      .first
      .text;
  final publicationTime = DateTime.parse(payloadPublication
      .findAllElements('publicationTime' ,namespace: ns2)
      .first
      .text);
  final publicationCreator = payloadPublication
      .findAllElements('publicationCreator' ,namespace: ns2)
      .first;
  final creatorCountry = publicationCreator
      .findAllElements('country',namespace: ns2)
      .first
      .text;
  final creatorNationalIdentifier = publicationCreator
      .findAllElements('nationalIdentifier',namespace: ns2)
      .first
      .text;
/*
  print('Feed Type: ${feedType}');
  print('Publication Time: ${publicationTime}');
  print('Creator Country: ${creatorCountry}');
  print('Creator National Identifier: ${creatorNationalIdentifier}');
*/
  final situations = payloadPublication.findAllElements('situation');
  for (final situation in situations) {
    final situationId = situation.getAttribute('id') ?? 'Unknown';
    final overallSeverity = situation
        .findAllElements('overallSeverity',namespace: ns2)
        .first
        .text;
    final situationVersionTime = DateTime.parse(situation
        .findAllElements('situationVersionTime',namespace: ns2)
        .first
        .text);
    final situationRecord = situation
        .findAllElements('situationRecord',namespace: ns2)
        .first;
    final situationRecordCreationTime = DateTime.parse(situationRecord
        .findAllElements('situationRecordCreationTime',namespace: ns2)
        .first
        .text);
    final situationRecordObservationTime = DateTime.parse(situationRecord
        .findAllElements('situationRecordObservationTime',namespace: ns2)
        .first
        .text);
    final situationRecordVersionTime = DateTime.parse(situationRecord
        .findAllElements('situationRecordVersionTime',namespace: ns2)
        .first
        .text);
    final probabilityOfOccurrence = situationRecord
        .findAllElements('probabilityOfOccurrence',namespace: ns2)
        .first
        .text;
    final source = situationRecord
        .findAllElements('source',namespace: ns2)
        .first;
    final sourceIdentification = source
        .findAllElements('sourceIdentification',namespace: ns2)
        .first
        .text;
    final sourceName = source
        .findAllElements('sourceName',namespace: ns2)
        .first
        .findAllElements('value')
        .first
        .text;
    final reliable = source
        .findAllElements('reliable')
        .first
        .text;
/*
    print('Situation ID: ${situationId}');
    print('Overall Severity: ${overallSeverity}');
    print('Situation Version Time: ${situationVersionTime}');
    print(
        'Situation Record Creation Time: ${situationRecordCreationTime}');
    print(
        'Situation Record Observation Time: ${situationRecordObservationTime}');
    print('Situation Record Version Time: ${situationRecordVersionTime}');
    print('Probability of Occurrence: ${probabilityOfOccurrence}');
    print('Source Identification: ${sourceIdentification}');
    print('Source Name: ${sourceName}');
    print('Reliable: ${reliable}');
*/
    final validity = situationRecord
        .findAllElements('validity',namespace: ns2)
        .first;
    final validityStatus = validity
        .findAllElements('validityStatus',namespace: ns2)
        .first
        .text;
    final validityTimeSpecification = validity
        .findAllElements('validityTimeSpecification',namespace: ns2)
        .first;
    final overallStartTime = DateTime.parse(validityTimeSpecification
        .findAllElements('overallStartTime',namespace: ns2)
        .first
        .text);
    final overallEndTime = validityTimeSpecification
        .findAllElements('overallEndTime',namespace: ns2)
        .isNotEmpty
        ? DateTime.parse(validityTimeSpecification
        .findAllElements('overallEndTime',namespace: ns2)
        .first
        .text)
        : null;
/*
    print('Validity Status: ${validityStatus}');
    print('Overall Start Time: ${overallStartTime}');

 */
    if (overallEndTime != null) {
      print('Overall End Time: ${overallEndTime}');
    }

    final generalPublicComments = situationRecord.findAllElements(
        'generalPublicComment',namespace: ns2);
    for (final comment in generalPublicComments) {
      final commentValue = comment
          .findAllElements('value',namespace: ns2)
          .first
          .text;
      final commentType = comment
          .findAllElements('commentType',namespace: ns2)
          .first
          .text;
      print('Comment: ${commentValue}');
      print('Comment Type: ${commentType}');
    }

    final groupOfLocations = situationRecord
        .findAllElements('groupOfLocations',namespace: ns2)
        .first;
    final tpegLinearLocation = groupOfLocations
        .findAllElements('tpegLinearLocation',namespace: ns2)
        .first;
    final tpegDirection = tpegLinearLocation
        .findAllElements('tpegDirection',namespace: ns2)
        .first
        .text;
    final tpegLinearLocationType = tpegLinearLocation
        .findAllElements('tpegLinearLocationType',namespace: ns2)
        .first
        .text;
    final toPoint = tpegLinearLocation
        .findAllElements('to',namespace: ns2)
        .first;
    final toLatitude = double.parse(toPoint
        .findAllElements('latitude',namespace: ns2)
        .first
        .text);
    final toLongitude = double.parse(toPoint
        .findAllElements('longitude',namespace: ns2)
        .first
        .text);
    final toName = toPoint
        .findAllElements('name',namespace: ns2)
        .first
        .findAllElements('value',namespace: ns2)
        .first
        .text;
    final fromPoint = tpegLinearLocation
        .findAllElements('from',namespace: ns2)
        .first;
    final fromLatitude = double.parse(fromPoint
        .findAllElements('latitude',namespace: ns2)
        .first
        .text);
    final fromLongitude = double.parse(fromPoint
        .findAllElements('longitude',namespace: ns2)
        .first
        .text);
    final fromName = fromPoint
        .findAllElements('name',namespace: ns2)
        .first
        .findAllElements('value',namespace: ns2)
        .first
        .text;
/*
    print('TPEG Direction: ${tpegDirection}');
    print('TPEG Linear Location Type: ${tpegLinearLocationType}');
    print('To Latitude: ${toLatitude}');
    print('To Longitude: ${toLongitude}');
    print('To Name: ${toName}');
    print('From Latitude: ${fromLatitude}');
    print('From Longitude: ${fromLongitude}');
    print('From Name: ${fromName}');
    */

  }}
  }
