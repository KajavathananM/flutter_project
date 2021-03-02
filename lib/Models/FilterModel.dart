
class FilterModel{
  String city='';
  String region='';
  List propertyType=new List();
  String purchaseType;
  List budgetRange=new List();
  List areaRange=new List();
  FilterModel(String city,String region,List propertyType,String purchaseType,List budgetRange,List areaRange){
    this.city=city;
    this.region=region;
    this.propertyType=propertyType;
    this.purchaseType=purchaseType;
    this.budgetRange=budgetRange;
    this.areaRange=areaRange;
  }
}