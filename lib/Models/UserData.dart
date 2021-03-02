import 'package:cloud_firestore/cloud_firestore.dart';

class UserData
{
  String fullName;
  String userName;
  String address;
  String contactNumber;
  DocumentReference reference;
  UserData({this.fullName,this.userName,this.address,this.contactNumber});
  UserData.fromMap(Map<String,dynamic> map,{this.reference}){
    fullName=map["fullName"];
    userName=map["userName"];
    address=map["address"];
    contactNumber=map["contactNumber"];
  }
  UserData.fromSnapshot(DocumentSnapshot snapshot):this.fromMap(snapshot.data,reference:snapshot.reference);
  
  toJson(){
     var userData={
        'fullName':fullName,
        'userName':userName,
        'address':address,
        'contactNumber':contactNumber
     };
     return userData;
  }
}