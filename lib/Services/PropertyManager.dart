import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/Models/FilterModel.dart';

class PropertyManager
{
    Firestore _db = Firestore.instance;
    String collectionName="Properties";

    /*This is the method used in FilterPage that 
     allows us to filter our list of documents from the Properties Collection based on filter parameters
     in filter page.*/
    Future getSelectedProperties(FilterModel model)async{
        //Note that Region parameter is optional
		    //Method chaining "where" acts like "and" clause in SQL
		    //In Firestore there is a constraint where you can perform comparison only on one field
        if(model.region=='')
        {
          QuerySnapshot snapshot=await _db.collection(collectionName)
         .where('city',isEqualTo:model.city)
         .where('purchaseType',isEqualTo:model.purchaseType)
         .where('propertyType',whereIn:model.propertyType)
         .where('price',isGreaterThanOrEqualTo:model.budgetRange[0]).where('price',isLessThanOrEqualTo:model.budgetRange[1])
         .getDocuments();
          return snapshot.documents;
        }else if(model.region!='')
        {
          QuerySnapshot snapshot=await _db.collection(collectionName)
         .where('city',isEqualTo:model.city)
         .where('region',isEqualTo:model.region)
         .where('purchaseType',isEqualTo:model.purchaseType)
         .where('propertyType',whereIn:model.propertyType)
         .where('price',isGreaterThanOrEqualTo:model.budgetRange[0]).where('price',isLessThanOrEqualTo:model.budgetRange[1])
         .getDocuments();
          return snapshot.documents;
        }
    }
}