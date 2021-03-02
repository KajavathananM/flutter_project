import 'package:cloud_firestore/cloud_firestore.dart';


import 'RoomData.dart';
import 'PropertyOverviewData.dart';
class Property {
  String name;
  String propertyType;
  String purchaseType;
  int price;
  int area;
  List imgList=new List();
  //roomDetails is a table of roomType,quantity and roomArea
  List<RoomData> roomDetails;
  //overViewData consists of configuration,number of floors and possesion date
  PropertyOverviewData overviewData;
  List<dynamic> specialHighlights;
  //Latitude and Longitude required to show the position of the property
  double latitude;
  double longitude;
  String owner;
  String address;
  String city;
  String region;
  //url need to retrieve the relevant Property image either using AssetImage or NetworkImage
  String imgUrl='';
  //Reference for the document of properties Collection
  DocumentReference reference;

  Property.fromMap(Map<String,dynamic> map,{this.reference}){
    name=map["name"];
    propertyType=map["propertyType"];
    purchaseType=map["purchaseType"];
    price=map["price"];
    area=map["area"];
    imgList=map["imgList"];
    //This is to retrieve to an array of mapped objects from the firebase Database
    roomDetails= map["roomDetails"].map<RoomData>((item) {
      return RoomData.fromMap(item);
    }).toList();
    //This is to retrieve a mapped object from the firebase database
    overviewData= PropertyOverviewData.fromMap(map['overviewData']);

    specialHighlights=map["specialHighlights"];
    latitude=map["latitude"];
    longitude=map["longitude"];
    owner=map["owner"];
    address=map["address"];
    city=map["city"];
    region=map["region"];
    imgUrl=map["imgUrl"];
  }
}