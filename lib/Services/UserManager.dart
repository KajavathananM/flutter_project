import 'package:cloud_firestore/cloud_firestore.dart';
import '../Models/UserData.dart';
class UserManager
{
  Firestore _db = Firestore.instance;
  String collectionName="Users";

   //We are inserting User data into Users Collection in the Firestore database
   void  registerUser(UserData user){
    try{
        _db.runTransaction((Transaction transaction) async{
            await Firestore.instance.collection(collectionName).document().setData(user.toJson());
        }); 
    }catch(e){
       print(e.toString());
    }
  }
 //Get Current User data according to his/her email username
  Future getUserByUsername(String username)async{
         QuerySnapshot snapshot=await _db.collection(collectionName).where('userName',isEqualTo:username).getDocuments();
          return snapshot.documents;
    }
    //Updating properties of userData except his/her email username 
    void editProfile(UserData user,String fullName,String contactNumber,String address){
    try{
      /* Here we are accessing document reference of the collection Users and update the JSON data. */     
      _db.runTransaction((transaction)async{
        await transaction.update(_db.document(user.reference.path.toString()),{'fullName':fullName,'userName':user.userName,'contactNumber':contactNumber,'address':address});
      });
    }catch(e){
      print(e.toString());
    }
  }
}