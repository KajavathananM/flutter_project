class PropertyOverviewData
{
  String configuration;
  int floors;
  String possesionDate;

  PropertyOverviewData({this.configuration,this.floors,this.possesionDate});
  
 PropertyOverviewData.fromMap(Map<String, dynamic> data){
         configuration = data['configuration'];
         floors = data['floors'];
         possesionDate = data['possesionDate'];
  }
}
  
