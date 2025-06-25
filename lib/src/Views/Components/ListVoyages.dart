
import 'dart:typed_data';

import 'package:angel3_framework/angel3_framework.dart';
import 'package:auto_route/auto_route.dart';

import 'package:ecodrive_server/src/Repository/Repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecodrive_server/src/Controller/Controller.dart';

import 'package:http/http.dart';

import '../../BDD/Model/Abstract/PersonEntity.dart';
import '../../BDD/Model/AbstractModels/ItineraryEntity.dart';
import '../../BDD/Model/AbstractModels/TravelEntity.dart';
import '../../BDD/Model/AbstractModels/UserEntity.dart';
import '../../BDD/Model/AbstractModels/VehiculeEntity.dart';
import '../../BDD/Model/AbstractModels/DriverEntity.dart' as driver;
import '../../Router/AppRouter.gr.dart' show VoyageDetails;

import '../../BDD/Model/AbstractModels/AddressEntity.dart' as a;
//import 'package:ecodrive_server/src/Services/HTMLService/HTMLFetchEntityService.dart'; TODO this must manager intern


class ListVoyages extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListVoyagesState();
  }
}



class ListVoyagesState extends State<ListVoyages> {
  late Repository<Travel> rep;
  List<Travel> travels = [];

  @override
  void initState() {
    super.initState();
    //rep = Repository<Travel>(query:"/api/travels")), fromJsonFactory:(Map<String, dynamic> json) => Travel.fromJson(json)),fromJson: (json) => Travel.fromJson(json));
    fetchTravels();
  }

  Future<void> fetchTravels() async {
    Map<String, dynamic> query = {'queryAddress': a.Address};
    List<Travel>  fetchedTravels = await rep.findBy(query) ;
   //dynamic fetchedTravels = (await rep.findBy(query) )as  List<Travel> ;
  Travel example=Travel(
      departureTime:  DateTime(2025,5,10,9,0),
        itinerary: Itinerary(
        addressDeparture: a.Address(city: "Paris", address: 'Rue Saint Augustin', postCode: '75000',  createdAt: DateTime(2025,5,9)),
    addressArrival: a.Address(city: "Lyon", address: 'Rue Saint Pancras', postCode: '69000', createdAt: DateTime(2025,5,9)),
    duration: DateTime(0, 0, 0, 2,0),
    ), driver: driver.Driver(firstname: 'Sam', lastname: 'Auburn', authUser: null, credits: 100, person: {} as Person, user: {} as User),
      createdAt: DateTime(2025,5,9));
    setState(() {
      travels=[example];
      if(fetchedTravels!=null){
      travels .addAll(fetchedTravels);}
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView(
        children:  travels!=null? travels.map((travel) {
          return ListTile(
            title: Text(
              'Heure de départ : ${travel.departureTime}, '
                  'Départ: ${travel.itinerary.addressDeparture?.city} - '
                  'Arrivée : ${travel.itinerary.addressArrival?.city}, '
                  'Durée estimée : ${travel.itinerary.duration}',
            ),
            onTap: () {
              try {
              //  AutoRouter.of(context).push(VoyageDetails());
              } catch (e, stackTrace) {
                debugPrint('Error navigating to VoyageDetails: $e');
                debugPrint('Stack trace: $stackTrace');
              }
            },
          );
        }).toList(): [],
      ),
    );
  }
}
