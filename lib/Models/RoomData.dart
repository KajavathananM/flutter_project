class RoomData
{
  String roomType;
  int quantity;
  String roomArea;
  RoomData({this.roomType,this.quantity,this.roomArea});

 RoomData.fromMap(Map<dynamic, dynamic> data)
       : roomType = data['roomType'],
         quantity = data['quantity'],
         roomArea = data['roomArea'];
}