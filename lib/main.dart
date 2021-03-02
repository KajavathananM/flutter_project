import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutterproject/Models/FilterModel.dart';
import 'package:flutterproject/Models/RoomData.dart';

//import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'Models/GroupModel.dart';
import 'Models/Property.dart';
import 'Models/UserData.dart';

import 'package:flutterproject/Services/Authentication.dart';
import 'package:flutterproject/Services/UserManager.dart';
import 'package:flutterproject/Services/PropertyManager.dart';

//FireBase Crud Services 
Authentication authService=new Authentication();
UserManager userService=new UserManager();
PropertyManager propertyService=new PropertyManager();

void main() => runApp(MyApp());

/*
 glob_username: Username of the person login
status: Status when Logging in or Logging out
*/
String glob_username="";
String status="";
 class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) { return
    MaterialApp(
      title: 'GoldenKeyHomes',
      home: HomePage(title: 'Home page'),
    );
  }
}
/*DrawDivider and DrawBigline draws a Horizontal lines with respect to its x and y coordinates.*/
class DrawBigline extends CustomPainter {
  Paint _paint;
  DrawBigline() {
    _paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
     //Passing  cartesian coordinates  and customerPainter draws for the respective distance
      canvas.drawLine(Offset(-150, 0.0), Offset(150, 0.0), _paint);
  }
   @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
class DrawDivider extends CustomPainter {
  Paint _paint;
  DrawDivider() {
    _paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
     //Passing  cartesian coordinates  and customerPainter draws for the respective distance
      canvas.drawLine(Offset(0, 0.0), Offset(500, 0.0), _paint);
  }
   @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

//Generate Bezier curve shape for Tool Window
class MenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
   Path path = new Path();
  path.lineTo(0, size.height*0.85); //vertical line
  path.quadraticBezierTo(size.width/2, size.height, size.width, size.height*0.85); //quadratic curve
  path.lineTo(size.width, 0); //vertical line
  return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return null;
  }
}


//This generates an AppBar for the User Interface
Widget generateAppBar(BuildContext context,Function _updateFlg){
  final topAppBar = AppBar(
      elevation: 0.0,
      leading:Column(
        children: <Widget>[
          SizedBox(height:8),
          IconButton(
                              icon: new Icon(Icons.arrow_back),
                              color: Colors.black,
                              alignment:Alignment.topLeft,
                              onPressed: (){_navigateToLandingPage(context);},
                          )
        ],
      ),
    actions: <Widget>[
      IconButton(
                              icon: new Icon(Icons.settings),
                              color: Colors.black,
                              // alignment:Alignment(0,0.2),
                               onPressed: (){
                                 _updateFlg();
                               },
      ),
    ],
    flexibleSpace:Container(  decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
      ),child:Stack(
         children: <Widget>[
           Positioned(
         left:60,
         top:40,
        child:Container(
        child:Row(children: <Widget>[
               Column(children: <Widget>[CircleAvatar(
                radius: 20.0,
                backgroundImage:ExactAssetImage('assets/images/GoldenKeyHomesLogo.png'),
                backgroundColor: Colors.transparent,
              )],),
               Column(children: <Widget>[Text('   GoldenKeyHomes',style:TextStyle(fontSize:25.0,color:Colors.white,fontWeight:FontWeight.bold))],),
             ],))
      )

         ],
      ))
  );
  return topAppBar;
}
//ToolWindow that shows features of the mobile app that we can navigate to instead of going to the home page
Widget generateToolWindow(BuildContext context){
  Widget toolWindow=Container(
    width:430,
    height:200,
    child:ClipPath(
      clipper:MenuClipper(),
      child:Container(child:Stack(children: <Widget>[Positioned(
        top:50,
        left:30,
        child:FloatingActionButton(
                         child:CircleAvatar(
                            radius: 20.0,
                            backgroundImage:ExactAssetImage('assets/images/HomeIcon.png'),
                            backgroundColor: Colors.transparent,
              ),
                       backgroundColor: Colors.white,
                       onPressed:(){_navigateToFilterPage(context);},
      )	),
      Positioned(
        top:110,
        left:20,
        child:Container(child:Text("Find New Home/\nAppartment",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.white)),),
      )
       	],),decoration:BoxDecoration(gradient: LinearGradient(colors: [Colors.amber[600], Colors.brown],
          )))
      ),
    );
    return Align(alignment:Alignment(0,-1),child:toolWindow);
}
class LoginPartialView extends StatefulWidget {
  @override
  _LoginPartialViewState  createState() => _LoginPartialViewState();
}
class _LoginPartialViewState extends State<LoginPartialView>{

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState>  _formLogin = new GlobalKey<FormState>(debugLabel:'_LoginPartialViewState');
   @override
  Widget build(BuildContext context) {
        var _LoginView=Container(
           color:Colors.blueGrey[100],height:310,width:350,
           padding:EdgeInsets.all(15),
            //TextFormField Widget is used inorder to use property validator to perform validation
           child:Form(
                key:_formLogin,
            child:Column(
            children : <Widget>[
              Text("Login",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.black)),
              SizedBox(height:8),
              TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                  hintText: "Your Email",
                   border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
          ),
               keyboardType: TextInputType.text,
                validator: (String username) {
                   if(username.isEmpty){
                        return 'Please Enter Username';
                    }
                    //Regular Expression for Email Username
                    Pattern pattern =r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp usernameExp = new RegExp(pattern);
                      if (!usernameExp.hasMatch(username))
                         return 'Username should be a an email';
                      else
                        return null;

                }

              ) ,
                SizedBox(height:8),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                  hintText: "MaxSize of the password is 8 characters",
                ),
               keyboardType: TextInputType.text,
               //Encrypting the password
               obscureText:true,
                validator: (String password) {
                    if(password.isEmpty){
                        return 'Please Enter Password';
                    }
                    if(password.length<8){
                        return 'Password should be atleast 8 characters';
                    }
                }
              ) ,
    SizedBox(height:17),//textfield
    Container(
        width:360.0,
        height:50.0,
        child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)),
          onPressed:(){
              //Here Form Validation is performed based on formState.
              final formState=_formLogin.currentState;
              if(formState.validate()){
                formState.save();
                     authService.signIn(usernameController, passwordController).then (
                    (res)=>{
                       glob_username=usernameController.text,
                       usernameController.text="",
                       passwordController.text="",
                      _navigateToLandingPage(context)
                    }
                  );

              }
            },
	      textColor: Colors.white,
           child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0)
      ),
        child: Container(
        alignment: Alignment.center,
        child: Text(
          "Login",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white
          ),
        )))))]), //column
    )
          );
 return Align(
         alignment:Alignment(0,-0.8),
         child:ClipRRect(
           borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0),
                  bottomLeft: Radius.circular(25.0),
            ),
            child: _LoginView
     )
 );

  }
}
class SignUpPartialView extends StatefulWidget {
  @override
  _SignUpPartialViewState  createState() => _SignUpPartialViewState();
}
class _SignUpPartialViewState extends State<SignUpPartialView>{

    TextEditingController fullNameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController contactNumberController = TextEditingController();
    TextEditingController addressController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    final GlobalKey<FormState>  _formSignup = new GlobalKey<FormState>(debugLabel:'_SignUpPartialViewState');
   @override
  Widget build(BuildContext context) {
    var _form=Form(key:_formSignup,child:Column(
      children: <Widget>[
        //TextFormField Widget is used in order to use property validator to perform validation
        TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                  hintText: "Your Entire name",
                   border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
          ),
               keyboardType: TextInputType.text,
               validator:(String fName){
                  if(fName.isEmpty)
                    return 'Please Enter FullName';
               },
              ) ,
                SizedBox(height:8),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                  hintText: "Username is your Email",
                ),
               keyboardType: TextInputType.text,
               validator: (String username) {
                   if(username.isEmpty){
                        return 'Please Enter Username';
                    }
                    //Regular Expression for Email Username
                    Pattern pattern =r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                    RegExp usernameExp = new RegExp(pattern);
                      if (!usernameExp.hasMatch(username))
                         return 'Username should be a an email';
                      else
                        return null;
                },
      ) ,
     SizedBox(height:8),
     TextFormField(
                controller: contactNumberController,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
           hintText: "10 Digits",
         ),
              keyboardType: TextInputType.text,
              validator:(String contactNumber){
                  //Regular Expression for Phone Number
                  Pattern pattern =r'(^(?:[+0]9)?[0-9]{10,12}$)';
                   RegExp regex = new RegExp(pattern);
                    if (!regex.hasMatch(contactNumber))
                              return 'Enter Valid Phone Number';
                    else
                      return null;
           }

      ) ,

           SizedBox(height:8),
     TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                ),
              keyboardType: TextInputType.text,
              ) ,
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                ),

                keyboardType: TextInputType.text,
                //Encrypting the password
                obscureText:true,
                validator: (String password) {
                    if(password.isEmpty){
                        return 'Please Enter Password';
                    }
                    if(password.length<8){
                        return 'Password should be atleast 8 characters';
                    }
                }

              ) ,
              TextFormField(
                controller: newPasswordController,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                ),
                keyboardType: TextInputType.text,
                //Encrypting the password
                obscureText:true,
                validator: (String password) {
                    if(password.isEmpty){
                        return 'Please confirm your Password';
                    }
                    if(password.length<8){
                        return 'Password should be atleast 8 characters';
                    }
                    //Comparing the values in password and Confirm Password fields
                    if(password!=passwordController.text){
                        return 'Confirm password does not match with password';
                    }
                }
              ) ,
      ],)
    );
    final _SignUpView=Container(
      color:Colors.blueGrey[100],height:380,width:350,
          padding:EdgeInsets.all(15),
          child:Column(
            children : <Widget>[
              Text("Sign up",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.black)),
              SizedBox(height:8),
              //Create a scroll view for textboxes inside Sign up Window
              Expanded(child: SingleChildScrollView(child:_form),),
              SizedBox(height:8),
              Container(
        width:360.0,
        height:50.0,
        child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)),
        onPressed: (){
          //Here Form Validation is performed based on formState.
          final formState=_formSignup.currentState;
              if(formState.validate()){
                formState.save();
                      UserData data=new UserData(fullName:fullNameController.text,userName:emailController.text,address:addressController.text,
                              contactNumber:contactNumberController.text);
                       authService.signUp(emailController.text,passwordController.text).then((res)=>{
                                userService.registerUser(data),
                                _RefreshHomePage(context)               
                        });
              }
        },
	      textColor: Colors.white,
           child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0)
      ),
        child: Container(
        alignment: Alignment.center,
        child: Text(
          "Sign Up",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white
          ),
        )))))]), //column
    );
 return Align(
         alignment:Alignment(0,-2),
         child:ClipRRect(
           borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(35.0),
                 topRight: Radius.circular(35.0),
                 bottomRight: Radius.circular(35.0),
                 bottomLeft: Radius.circular(35.0),
            ),
            child: _SignUpView
     )
 );

  }
}
//Front end Routing methods

//Navigate to HomePage with Sign Up and Login tabs
void _RefreshHomePage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );

}
//Navigating to Landing Page once you Login
 void _navigateToLandingPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>LandingPage()),
    );
}
//Navigating to Filter page when you press feature Buy House/Appartment
 void _navigateToFilterPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>FilterPage()),
    );
  }
  //Here we are passing property of FilterModel from Filter Page to HouseListPage
  void _navigateToHouseListPage(BuildContext context,var filterMethod,FilterModel model) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HouseListPage(filterMethod:filterMethod,model:model)),
    );
  }
  /*
      Navigating to Detail Page
      Here property object is passed so we can access in DetailPage interface
 */
 void _navigateToDetailPage(BuildContext context,Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailPage(property:property)),
    );
  }
  //Here map view is rendered when you press ViewMap button for the property object
  void _navigateToMapPage(BuildContext context,Property property) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage(property:property)),
    );
  }
  
//User Interfaces of our Mobile App
/*
  HomePage
  MainPage
  1)Buy House/Appartment Feature(IT17079532)
      FilterPage
      HouseListPage
      DetailPage
      MapPage
  2)Edit User Profile(IT17079532)
       EditProfileView
*/

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}
  class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin{
  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = new TabController(length: 3,vsync: this, initialIndex: 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
        Container(
         width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //Using decoration property for inserting background image for the User Interface
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/BackgroundProject.jpg",),
              ),
              color: Color(0xff0d89ff).withOpacity(0.9)
            ),

             ),
          Positioned(
             top:80,
             right:60,
             left:60,
             child:new GestureDetector(
                onTap:(){_RefreshHomePage(context);},
                child:Row(
               children: <Widget>[
                 Row(children: <Widget>[
               Column(children: <Widget>[CircleAvatar(
                radius: 20.0,
                backgroundImage:ExactAssetImage('assets/images/GoldenKeyHomesLogo.png'),
                backgroundColor: Colors.transparent,
              )],),
           Column(children: <Widget>[Text('   GoldenKeyHomes',style:TextStyle(fontSize:25.0,color:Colors.white,fontWeight:FontWeight.bold)
  )],),
             ],),
               ],
             )
             )
          ),
          Positioned(
             top:140,
             right:200,
             left:200,
            child:Row(children: <Widget>[CustomPaint(painter: DrawBigline())  ],)
          ),
     Align(
       alignment: Alignment(2.0,-0.4),
         child:Container(
      child: new TabBar(
    controller: _controller,
    indicatorColor:Colors.transparent,
    tabs: [
      new Tab(
        child:Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red]),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Sign Up"),
                    ),
                  ),
      ),
      new Opacity(opacity: 0.0,

              child: new Tab(
        child:Align(alignment:Alignment(0,-0.8),child:Container(
                    width:10,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red]),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child:Container(width:10,child:Text("")),

                  )
          ),
    )
        )
            ),
      new Tab(
          child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red]),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.redAccent, width: 1)),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text("Login"),
                    ),
                  ),
      ),
    ],
  ),
)
     ),
   Align(
    alignment:Alignment(0,0.6),
     child:Container(
     height:400,
            child:TabBarView(
            children: [
            SignUpPartialView(),
            Container(child:Text("")),
            LoginPartialView()
        ],
      controller: _controller,)
    )
   ),


      ],),

    );
  }
}
/*Here we are checking the Login Status of the user using FireBaseAuth and return the relevant page 
if the user is found, the Main Page is rendered,otherwise the HomePage is rendered and asked to type username
 and password.
*/
class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          FirebaseUser user = snapshot.data;
          if (user==null) {
            if(status=="signout"){
              status="";
              return HomePage();
            }
             return Stack(children: <Widget>[
               HomePage(),
               AlertDialog(
                title: Text("Invalid Account"),
               backgroundColor: Colors.blueGrey[100],
                content: Text("Please enter username and password again or create new account."),
                actions: [
                  RaisedButton(padding: const EdgeInsets.all(0.0),
                  child:Container(
                    width:60,
                    height:40,
                    padding: const EdgeInsets.all(10.0),
                    child:Align(alignment:Alignment.center,child:Text("Ok")),
                  decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  Colors.orange,
                  Colors.red,
                ],
              ),
            )),onPressed:(){Navigator.pop(context);}),
               ],)
             ],);

          }
       
          else if(user!=null){
              return MainPage(username:glob_username);
          }
        
         
       }
       else return Container(child:Text(""));
      },
    );
  }
}
class MainPage extends StatefulWidget {
  String username;
  MainPage({Key key,this.username}) : super(key: key);
    @override
  _MainPageState createState() => _MainPageState();
}
  class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin{
  @override
  void initState() {
     super.initState();
  }
  bool isEditViewOpened=false;
  TextEditingController edit_fullNameController;
  TextEditingController edit_contactNumberController;
  TextEditingController edit_addressController;

  
  @override
  Widget build(BuildContext context) {
/*Create Interface for Edit User Profile Window where one can edit his/her full name, contact Number 
and address.*/
Widget generateEditProfile(UserData user){
         //Initializing Edit User Profile UI's textboxes with the values from Logged In User's UserData
         edit_fullNameController=TextEditingController(text:user.fullName);
         edit_addressController=TextEditingController(text:user.address);
         edit_contactNumberController=TextEditingController(text:user.contactNumber);
      final _form=Column(
      children: <Widget>[
        SizedBox(height:3),
        TextField(
                  controller: edit_fullNameController,
                  decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                  hintText: "Your Entire name",
                   border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
          ),
               keyboardType: TextInputType.text,
              ) ,
                SizedBox(height:8),
     SizedBox(height:8),
     TextField(
                controller: edit_contactNumberController,
                decoration: InputDecoration(
                labelText: "Contact Number",
                labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
           hintText: "10 Digits",
         ),
              keyboardType: TextInputType.text,
      ) ,
     SizedBox(height:8),
     TextField(
                controller: edit_addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  labelStyle:TextStyle(fontWeight: FontWeight.w300, color: Colors.black),
                     border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      ),
                ),
              keyboardType: TextInputType.text,
              ) ,
             
      ],);

final _EditView=Container(
      color:Colors.blueGrey[100],height:380,width:350,
          padding:EdgeInsets.all(15),
          child:Column(
            children : <Widget>[
              Row(children: <Widget>[
                Column(children: <Widget>[Text("Edit User Profile",style:TextStyle(fontSize:20,fontWeight:FontWeight.bold,color:Colors.black))],),
                SizedBox(width:80),
                Column(children: <Widget>[   IconButton(
             icon: Icon(Icons.close, color:Colors.black),
             onPressed:(){
               setState(() {
               isEditViewOpened=false;
             });
             },
             iconSize:30,
               )],)
              ],),
              SizedBox(height:10),
              //Create a scroll view for textboxes inside Sign up Window
              Expanded(child: SingleChildScrollView(child:_form),),
              SizedBox(height:8),//textfield
              Container(
        width:360.0,
        height:50.0,
        child: RaisedButton(
        padding: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)),
        onPressed: (){
          userService.editProfile(user,edit_fullNameController.text,
              edit_contactNumberController.text,edit_addressController.text);
          setState(() {
            isEditViewOpened=false;
          });
        },
	      textColor: Colors.white,
           child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0)
      ),
        child: Container(
        alignment: Alignment.center,
        child: Text(
          "Save",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white
          ),
        )))))]), //column
    );
 return Align(
         alignment:Alignment(0,-2),
         child:ClipRRect(
           borderRadius: BorderRadius.only(
                 topLeft: Radius.circular(35.0),
                 topRight: Radius.circular(35.0),
                 bottomRight: Radius.circular(35.0),
                 bottomLeft: Radius.circular(35.0),
            ),
            child: _EditView
     )
 );
}
    return Scaffold(
        body:FutureBuilder(
          //Retrieve the exact user data according to username
          future:userService.getUserByUsername(widget.username),
           builder:(context,snapshot){
             if(snapshot.hasData){
               var user=UserData.fromSnapshot(snapshot.data[0]);
               return Stack(children: <Widget>[
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //Using decoration property for inserting background image for the User Interface
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                //Color filter makes the picture darker so white text can be seen
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                image: AssetImage("assets/images/BackgroundProject.jpg",),
              ),
            ),

             ),
          Positioned(
            top:15,
            child:FlatButton(onPressed:(){
              status="signout";
              authService.signOut();
            },child:Text("Sign Out",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.white))),
          ),
          Positioned(
             top:80,
             right:60,
             left:60,
             child:Row(
               children: <Widget>[
                 Row(children: <Widget>[
               Column(children: <Widget>[CircleAvatar(
                radius: 20.0,
                backgroundImage:ExactAssetImage('assets/images/GoldenKeyHomesLogo.png'),
                backgroundColor: Colors.transparent,
              )],),
           Column(children: <Widget>[Text('   GoldenKeyHomes',style:TextStyle(fontSize:25.0,color:Colors.white,fontWeight:FontWeight.bold)
  )],),
             ],),
               ],
             )
          ),
          Positioned(
             top:140,
             right:200,
             left:200,
            child:Row(children: <Widget>[CustomPaint(painter: DrawBigline())  ],)
          ),
          Positioned(
             top:160,
             left:50,
            child:SingleChildScrollView(
              child:Container(
                width:300,
                child:Text("This is a Mobile Application that would provide the best property for a person to live in Srilanka without the need of a broker so we can minimize customer's expenditure and his/her time is used efficiently.Registering a House under buyer's name is made as easy and there is a payment service for monthly rental charge.",style:TextStyle(fontSize:14,color:Colors.white,fontWeight:FontWeight.bold)),
            )
            ),
         ),
         Positioned(
             top:330,
             right:200,
             left:200,
            child:Row(children: <Widget>[CustomPaint(painter: DrawBigline())  ],)
          ),
           Positioned(
             top:370,
             left:80,
            child:FloatingActionButton(
                         heroTag:1,
                         child:CircleAvatar(
                            radius: 50.0,
                            backgroundImage:ExactAssetImage('assets/images/HomeIcon.png'),
                            backgroundColor: Colors.transparent,
              ),
                       backgroundColor: Colors.white,
                       onPressed:(){_navigateToFilterPage(context);},
            )
          ),
          Positioned(
             top:370,
             left:140,
            child:Text("Find New Home/\nAppartment",style:TextStyle(fontSize:14,color:Colors.white,fontWeight:FontWeight.bold))
          ),
             Positioned(
             top:450,
             left:80,
            child:FloatingActionButton(
                         heroTag:2,
                         child:CircleAvatar(
                            radius: 50.0,
                            backgroundImage:ExactAssetImage('assets/images/UserIcon.png'),
                            backgroundColor: Colors.transparent,
              ),
                       backgroundColor: Colors.white,
                       onPressed:(){setState(() {
                         isEditViewOpened=true;
                       });},
            )
          ),
          Positioned(
             top:460,
             left:140,
            child:Text("Edit User Profile",style:TextStyle(fontSize:14,color:Colors.white,fontWeight:FontWeight.bold))
          ),
        //Visibility widget to open and close Edit User Profile window
         Visibility(
           visible:isEditViewOpened,
           child: Positioned(
             top:430,
             left:20,
            child:generateEditProfile(user)
          )
         )
      ],);
      
             }
              return Container(
                       width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            //Using decoration property for inserting background image for the User Interface
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                //Color filter makes the picture darker so white text can be seen
                colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.darken),
                image: AssetImage("assets/images/BackgroundProject.jpg",),
              ),
            ),
                      child:Row(children: <Widget>[
                      Column(children: <Widget>[
                        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
         ),
                      ],),SizedBox(width:10),
                        Column(children: <Widget>[
                          Text("Loading.......",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.white))
                        ],)
                    ],
                    )
                    );
              
           },
      
        )
    );
  }
}
class FilterPage extends StatefulWidget
{
  @override
  _FilterPageState createState() => _FilterPageState();
}
class _FilterPageState extends State<FilterPage>
{
  TextEditingController RegionController = TextEditingController(text:"");
 //----Configuring Drop Down List--------
  final _cities=['Select City','Colombo','Gampaha','Malabe','Kalutura','Jaffna','Matara','Galle','Kelaniya','Ja Ela','Trincomalee'];
     String  _cityValue='Select City';
    _onDropdownChanged (String value){
         setState((){
            this._cityValue=value;
            if(_cityValue=='Select City')
              this._isCitySelected=false;
            else{
              this._isCitySelected=true;
            }
        });
    }
//---------------------------------------------
//---Settings for Radio button--------------
  int _purchaseTypeIndex = 1;
  String _purchaseTypeText = 'Buy';
//----------------------------------
 //-------Configuring Radio Button-------
  List<GroupModel> _group = [
    GroupModel(
      text: "Buy",
      index: 1,
    ),
    GroupModel(
      text: "Rent",
      index: 2,
    ),
   ];
   String getText(GroupModel m){
     return m.text;
   }
   int getIndex(GroupModel m){
     return m.index;
   }
//---------------------------------------
 //-------Configuring Radio Slider-------
 RangeValues budgetCostRange=RangeValues(0,990000.0);
 RangeLabels budgetCostLabels=RangeLabels('LKR 0','LKR 990000');
 RangeValues areaRange=RangeValues(0,6000.0);
 RangeLabels areaLabels=RangeLabels('0 sqft','6000 sqft');

//Boolean Condition to enable show and hide for Tool WIndow
bool _openFlg=false;

//Boolean Condition to show and hide View Properties button after selecting City
bool _isCitySelected=false;

//Boolean Condition to enable show and hide labels for RangeSlider in FilterPage
bool showBudgetStartLabel=true;
bool showBudgetEndLabel=true;
bool showAreaStartLabel=true;
bool showAreaEndLabel=true;
//----------------------------------------------

//Method that updates boolean variable _openFlg
 void _updateFlg(){
   if(_openFlg==false){
      setState((){_openFlg=true;});
   }else{
      setState((){_openFlg=false;});
   }
}
//------------------------------------------
//--Color settings for buttons in Filter Page---
Color colorHome=Colors.blueGrey[100];
Color textHomeColor=Colors.black;
Color colorAppartment=Colors.blueGrey[100];
Color textAppartmentColor=Colors.black;
bool isAppartmentTapped=false;
bool isHouseTapped=false;
//-----------------------------------------------
//Adding property Types parameters to the array in filter page
List propertyTypes=[];

  @override
  void initState() {
    super.initState();
  } 
   @override
  Widget build(BuildContext context) {
    final filterView=Stack(
        children: <Widget>[
          Positioned(top:0,child:Container(width:420,color:Colors.brown,child:ClipRect(child: Container(height:40,width:384,decoration: new BoxDecoration(
      color: Colors.brown,
      border: Border(
            top: BorderSide(width: 2.0, color: Colors.blueGrey[100]),
            bottom: BorderSide(width: 2.0, color: Colors.blueGrey[100]),
          ),
    ),child: Align(alignment:Alignment(0,0.2),child:Text("Filters",style:TextStyle(fontSize:19.4, fontWeight: FontWeight.bold,color:Colors.white))))))),
          Positioned(top:50,left:5,child: Row(children: <Widget>[
             Column(children: <Widget>[
               Text("Choose City",style:TextStyle(fontWeight:FontWeight.bold))
             ],),
             SizedBox(width:30),

             Column(children: <Widget>[
                 Container(
                   alignment:Alignment(0,-0.5),
                  width:160,
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                  iconSize: 25,
                   underline: Container(
                      color: Colors.transparent,
                   ),
                  items : _cities.map((String value){
                    return DropdownMenuItem<String>(
                        value :value,
                        child:Container(child:Text (value,style:TextStyle(fontSize:14.0)))
                    );

                  }).toList(),
                  value:_cityValue,
                  onChanged:(String value) {
                    _onDropdownChanged(value);
                  }
              ),
            ),
        ),

                 )
             ],)
          ],)),
          Positioned(top:100,left:5,child: Row(children: <Widget>[
             Column(children: <Widget>[
               Text("Select Localities",style:TextStyle(fontWeight:FontWeight.bold))
             ],),
             SizedBox(width:10),
             Column(children: <Widget>[
                 Container(
                   width:140,
                   height:30,
                   child:  TextField(
                controller: RegionController,
                decoration: InputDecoration(
                       border: new OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          const Radius.circular(10.0),
        ),
      )
                ),
                keyboardType: TextInputType.text,
              ) ,
                 )
             ],)
          ],)),
          Positioned(
            child:Stack(
              children: <Widget>[
                Positioned(top:160,left:5,child:Text("I am looking to",style:TextStyle(fontWeight:FontWeight.bold))),
                Positioned(top:170,left:-8,child:Container(
                  width:400,
                  child: Row(children: _group
                  .map((t) => Row(children: <Widget>[
                     Radio(
                        activeColor:Colors.purple,
                        value: t.index,
                        groupValue:_purchaseTypeIndex,
                        onChanged: (val) {
                          setState(() {
                            _purchaseTypeIndex =getIndex(t);
                            _purchaseTypeText = getText(t);
                          });
                        },
                      ),Text(t.text,style:TextStyle(fontWeight:FontWeight.bold))
                  ],)
                 ,).toList(),
                )))
              ],
            ),
          ),
          Positioned(
            top:215,
            left:5,
            child:Text("Property Type",style:TextStyle(fontWeight:FontWeight.bold)),
          ),
          Positioned(
            top:233,
            left:5,
            child:Row(children: <Widget>[Column(children: <Widget>[RaisedButton(color:colorHome,onPressed:(){
                 if(isHouseTapped==false){
                  setState(() {
                    isHouseTapped=true;
                    propertyTypes.add("Independent House");
                    textHomeColor=Colors.white;
                    colorHome=Colors.purple;
                });
                }else if(isHouseTapped==true){
                  setState(() {
                    isHouseTapped=false;
                    propertyTypes.remove("Independent House");
                    textHomeColor=Colors.black;
                    colorHome=Colors.blueGrey[100];
                  });

                }
                 //print(isHouseTapped);
                 //print(propertyTypes);
            },child:Container(alignment:Alignment(0,-0.1),height:30,width:150,child:Text("Independent House",textAlign:TextAlign.center,style:TextStyle(color:textHomeColor)),decoration:new BoxDecoration(
    )),),]),SizedBox(width:30),Column(children: <Widget>[RaisedButton(color:colorAppartment,onPressed:(){
          if(isAppartmentTapped==false){
            setState(() {
              isAppartmentTapped=true;
              propertyTypes.add("Appartment");
              textAppartmentColor=Colors.white;
              colorAppartment=Colors.purple;
            });
          }else if(isAppartmentTapped==true){
            setState(() {
              isAppartmentTapped=false;
              propertyTypes.remove("Appartment");
              textAppartmentColor=Colors.black;
              colorAppartment=Colors.blueGrey[100];
            });
          }
            //print(isAppartmentTapped);
            //print(propertyTypes);
    },child:Container(alignment:Alignment(0,-0.1),height:30,width:120,child:Text("Appartment",textAlign:TextAlign.center,style:TextStyle(color:textAppartmentColor),),decoration:new BoxDecoration(
     )))])]),
          ),
          Positioned(
              top:300,
              left:5,
              child:Text("Estimated Budget",style:TextStyle(fontWeight:FontWeight.bold))
          ),
           Positioned(
              top:330,
              left:10,
              child:Visibility(
                visible:showBudgetStartLabel,
                child:Text("LKR 0",style:TextStyle(fontWeight:FontWeight.bold)),
              )
          ),
          Positioned(
              top:330,
              left:190,
              child:Visibility(
                visible:showBudgetEndLabel,
                child:Text("LKR 9.9 Crores",style:TextStyle(fontWeight:FontWeight.bold)),
              )
          ),
          Positioned(
            top:340,
            left:-5,
            child:Container(
              width:250,
              child: RangeSlider(
              min:0,
              max:990000,
              divisions:990000,
              activeColor:Colors.purple,
              inactiveColor:Colors.black,
              labels:budgetCostLabels,
              values:budgetCostRange,
              onChanged:(value){
                 setState((){
                    budgetCostRange=value;
                    budgetCostLabels=RangeLabels('LKR '+budgetCostRange.start.toString(),'LKR '+budgetCostRange.end.toString());
                     if(budgetCostRange.start !=0){
                        showBudgetStartLabel=false;
                    }else if(budgetCostRange.start ==0){
                       showBudgetStartLabel=true;
                    }
                    if(budgetCostRange.end !=990000){
                        showBudgetEndLabel=false;
                    }else if(budgetCostRange.end ==990000){
                       showBudgetEndLabel=true;
                    }
                 });
              }

            ),
            )
          ),
          Positioned(
              top:400,
              left:5,
              child:Text("Built Up Area",style:TextStyle(fontWeight:FontWeight.bold))
          ),
           Positioned(
              top:430,
              left:10,
              child:Visibility(
                visible:showAreaStartLabel,
                child:Text("0 sqft",style:TextStyle(fontWeight:FontWeight.bold)),
              )
          ),
          Positioned(
              top:430,
              left:195,
              child:Visibility(
                visible:showAreaEndLabel,
                child:Text("6000 sqft",style:TextStyle(fontWeight:FontWeight.bold)),
              )
          ),
          Positioned(
            top:440,
            left:-5,
            child:Container(
              width:250,
              child: RangeSlider(
              min:0,
              max:6000,
              divisions:6000,
              activeColor:Colors.purple,
              inactiveColor:Colors.black,
              labels:areaLabels,
              values:areaRange,
              onChanged:(value){
                 setState((){
                    areaRange=value;
                    areaLabels=RangeLabels(areaRange.start.toString()+' sqft',areaRange.end.toString()+' sqft');
                    if(areaRange.start !=0){
                        showAreaStartLabel=false;
                    }else if(areaRange.start ==0){
                       showAreaStartLabel=true;
                    }
                    if(areaRange.end !=6000){
                        showAreaEndLabel=false;
                    }else if(areaRange.end ==6000){
                       showAreaEndLabel=true;
                    }
                 });
              }

            ),
            )
          ),
         Visibility(
           visible:_isCitySelected,
           child: Positioned(
            top:520,left:120,
            child:Container(
                width:160.0,
               height:50.0,
              child:RaisedButton(
                padding: EdgeInsets.all(0.0),
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blue)),
          onPressed:() async {
             /*To achieve filtering HouseList page, 
             FilterModel is created with user parameters and Firebase Filter method is invoked*/
            var filterMethod;
             FilterModel model=new FilterModel(
               _cityValue,
               RegionController.text,
               propertyTypes,
               _purchaseTypeText,
               [budgetCostRange.start.toInt(),budgetCostRange.end.toInt()],
               [areaRange.start.toInt(),areaRange.end.toInt()],
             );
             filterMethod=propertyService.getSelectedProperties(model);            
            _navigateToHouseListPage(context,filterMethod,model);},
	      textColor: Colors.white,
           child: Ink(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.brown[600], Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30.0)
      ),
        child: Container(
        alignment: Alignment.center,
        child: Text("View Properties",textAlign: TextAlign.center,style: TextStyle(color: Colors.white),)))
              ),
            )
          )
         ),

        ],
      ) ;
     return Scaffold(
       appBar:generateAppBar(context, _updateFlg),
       body:Stack(children: <Widget>[
         Container(child:filterView,decoration:BoxDecoration(color:Colors.yellow[300])),
        Visibility (
                  visible: _openFlg,
                  child:generateToolWindow(context)
            ),

       ],)

     ) ;
  }
}

class HouseListPage extends StatefulWidget {
  var filterMethod;
  FilterModel model;
  HouseListPage({Key key,this.filterMethod,this.model}) : super(key: key);
  @override
  _HouseListPageState createState() => _HouseListPageState();
  
}

class _HouseListPageState extends State<HouseListPage> {

bool _openFlg=false;
void _updateFlg(){
   if(_openFlg==false){
      setState((){_openFlg=true;});
   }else{
      setState((){_openFlg=false;});
   }
   //print(_openFlg);
}

  @override
  void initState() {
    super.initState();
  }
/*Builder and Template design pattern  is used to construct the body as list view for template method makeBody
through callback  makeCard  and its call back function ListTitle*/
  @override
  Widget build(BuildContext context) {
  //Creates Title for the card
   Stack makeListTitle(Property property)=>Stack(
          children: <Widget>[
                 Positioned(top:10,left:5,child:Text(property.name,style:TextStyle(fontSize:17.4,color:Colors.black,fontWeight:FontWeight.bold))),
                 Positioned(top:30,left:5,child:Text(property.owner,style:TextStyle(fontSize:13.2,color:Colors.black,fontWeight:FontWeight.w400))),
                 Positioned(top:100,right:6,child:Text(property.area.toString()+" sqft",style:TextStyle(fontSize:13.4,color:Colors.black,fontWeight:FontWeight.bold))),
                 Positioned(top:120,right:6,child:Text("LKR "+property.price.toString(),style:TextStyle(fontSize:16.4,color:Colors.black,fontWeight:FontWeight.bold))),
                 Positioned(top:140,right:6,child:Text(property.address,style:TextStyle(fontSize:13.4,color:Colors.black,fontWeight:FontWeight.bold)))
           ],
      );
    //Generate Card view
    Card makeCard(Property property) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
          child: GestureDetector(onTap:(){_navigateToDetailPage(context,property);},child:Container(
            //This attribute increases height for the card
            height:180,
            //This attribute increases width for the card
            width:80,
            decoration: BoxDecoration(image: DecorationImage(
               colorFilter: new ColorFilter.mode(Colors.blueGrey.withOpacity(0.5), BlendMode.dstATop),
                image: AssetImage(property.imgUrl), fit: BoxFit.cover)),
            child: makeListTitle(property),
          ),)
        );
    /*This method generates heading of the List View HouseListPage as Properties Avaible*/
    final makeHeading=Container( decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          )),child:Column(
      children: <Widget>[Row(children: <Widget>[ClipRect(child: Container(height:40,width:411,decoration: new BoxDecoration(
      color: Colors.brown,
      border: Border(
            top: BorderSide(width: 2.0, color: Colors.blueGrey[100]),
            bottom: BorderSide(width: 2.0, color: Colors.blueGrey[100]),
          ),
    ),child: Align(alignment:Alignment(0,0.2),child:Text("Properties Available",style:TextStyle(fontSize:19.4, fontWeight: FontWeight.bold,color:Colors.white)))))],
    )]));
    /*This method generates list View component of Homes returned by user's filtration*/
    final makeBody = Expanded(
      child:Container(
               decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.orangeAccent, Colors.red],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
      ),
                 child:FutureBuilder(
                 future:widget.filterMethod,
                  builder:(_,snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    //Loading Screen before the properties are loaded
                    return Container(
                      child:Row(children: <Widget>[
                      Column(children: <Widget>[
                        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
         ),
                      ],),SizedBox(width:10),
                        Column(children: <Widget>[
                          Text("Loading.......",style:TextStyle(fontWeight:FontWeight.bold,color:Colors.white))
                        ],)
                    ],
                    )
                    );
                  }else{
                    return ListView.builder(
                      //This is the location where  properties are loaded into HouseListPage
                      /*Note that snapshot.data is the array of properties snapshot.data[index].data 
                      is the single property from the array*/
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                           Property property=Property.fromMap(snapshot.data[index].data);
                           /*Note that one Filter Operation is done in the front end Flutter since in Firestore has a
                             constraint that only one range query can be performed
                           */
                           if(property.area>=widget.model.areaRange[0] && property.area<=widget.model.areaRange[1])
                              return makeCard(property);
                      },
                 );
                  }
                }
                 ,
      ),

    )
    );

  return Scaffold(
      backgroundColor: Colors.white,
      appBar: generateAppBar(context,_updateFlg),
      body:Stack(
        children: <Widget>[
          Column(
            children: <Widget>[makeHeading,makeBody],
         ),
         Visibility (
                  visible: _openFlg,
                  child:generateToolWindow(context)
            )
        ],
      )
     );
  }
}

class DetailPage extends StatefulWidget {
  Property property;
  DetailPage({Key key,this.property}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}
class _DetailPageState extends State<DetailPage> {


  bool _openFlg=false;
   void _updateFlg(){
   if(_openFlg==false){
      setState((){_openFlg=true;});
   }else{
      setState((){_openFlg=false;});
   }
}
int _current=1;

//Configuring to navigate to previous House image for Carousel Image Slider
goPreviousImage(){
  cSlider.previousPage(
    duration:Duration(milliseconds:250),curve:Curves.ease
  );
}
//Configuring to navigate to next House image for Carousel Image Slider
goNextImage(){
  cSlider.nextPage(
    duration:Duration(milliseconds:250),curve:Curves.decelerate
  );
}
CarouselSlider cSlider;
  @override
  void initState() {
    super.initState();
  }
//This method returns Image object whether it is in the project(assets) or from the internet
 loadImages(imgUrl){
    if(imgUrl.startsWith("assets"))
       return ExactAssetImage(imgUrl);
    else if(imgUrl.startsWith("https"))
       return NetworkImage(imgUrl);
 }
//Stores a list of urls of House Images
List imgList=[];
//Populate image List using property object
loadImageList(Property p){
    imgList=p.imgList;
 }
//Generates rows of Room Details from Property class to the data table widget
generatRoomDetailsRow(Property p){
  List <RoomData> rDetails=p.roomDetails;
   //print(rDetails);
    List <DataRow>roomDetails =rDetails.map((roomData) {
      return new DataRow(cells:<DataCell>[
         DataCell(
             Text(roomData.roomType,style:TextStyle(fontSize:13.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
         ),
         DataCell(
             Text(roomData.quantity.toString(),style:TextStyle(fontSize:13,color:Colors.black),textAlign:TextAlign.center)
         ),
         DataCell(
             Text(roomData.roomArea,style:TextStyle(fontSize:13.0,color:Colors.black),textAlign:TextAlign.center)
         )
      ]);
    }).toList();
    return roomDetails;
}
//Generate a list of special features available in the appartment
generateSpecialHighlights(Property p){
  var items=p.specialHighlights.toList();
  return new ListView.builder
              (
                itemCount: items.length,
                itemBuilder: (BuildContext ctxt, int Index) {
                  return new Row(children: <Widget>[
                     Column(children: <Widget>[
                        IconButton(
             icon: Icon(Icons.arrow_right, color:Colors.black),
             iconSize:30,
               )
                     ],),
                     SizedBox(width:5),
                     Column(children: <Widget>[
                        Text(items[Index])
                     ],)
                  ],);
                }
    );
  }
  @override
  Widget build(BuildContext context) {
  Property property=widget.property;
  loadImageList(property);

  //Caraousel Image Slider that shows available photos of the property through Navigation
  final HouseSlider=Stack(
        children: <Widget>[
        cSlider=CarouselSlider(
          height:400,
          //Expanding the width of the image in Image Slider component
          viewportFraction: 1.0,
          initialPage:0,
          onPageChanged:(index){
              setState(() {
                _current=index+1;
              });
          },
          enlargeCenterPage: true,
          //This is where  Carousel Image slider is configured with the House Images
          items:imgList.map((imgUrl){
            return Builder(
              builder:(BuildContext context){
                return Align(
                  alignment:Alignment(0,-0.95),
                  child:Container(
                  width: MediaQuery.of(context).size.width,
                  margin:EdgeInsets.symmetric(horizontal:10.0),
                  child:Container(
                    height:180,
                    width:400,
                    decoration:BoxDecoration(
                      image: DecorationImage(
                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
                      image: loadImages(imgUrl),
                      fit: BoxFit.fitWidth
                    )),
                  )
                ),
                );
              }
            );
          }).toList()
        ),
       Positioned(
         top:140,
         left:270,
          child:Row(
          children:<Widget>[
            Container(child:IconButton(icon:Icon(Icons.panorama,color:Colors.white))),
            Container(child:Text(_current.toString()+"/"+imgList.length.toString(),style:TextStyle(color:Colors.white,fontWeight:FontWeight.bold,fontSize:12.0),))
          ]
        )
       ),
       Positioned(
         top:60,
         left:50,
         child:IconButton(
             icon: Icon(Icons.arrow_left, color:Colors.white),
             iconSize:30,
             onPressed:(){goPreviousImage();},
         )
       ),
       Positioned(
         top:60,
         left:290,
         child:IconButton(
             icon: Icon(Icons.arrow_right, color:Colors.white),
             iconSize:30,
            onPressed:(){
              goNextImage();
             // print("next");
            },
         )
       )

      ],
    
  );
  final detailView=Container(
    width:700,
    height:1100,
    child:Stack(children: <Widget>[
         Positioned(top:220,left:7,child:Text(property.name,style:TextStyle(fontSize:16,fontWeight:FontWeight.bold))),
         Positioned(top:220,left:230,child:RaisedButton.icon(
         icon:IconButton(
                              icon: new Icon(const IconData(0xe900, fontFamily: 'mapMarker'),color:Colors.purple)
                          ),
        shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
        side: BorderSide(color: Colors.blueGrey[300])),
        onPressed:(){_navigateToMapPage(context,property);},
	      color: Colors.white,
        label:
          Container(child:Text("View Map",
            style: TextStyle(fontSize: 14,color:Colors.purple)))),
        ),
        Positioned(top:250,left:7,child:Text('Owner: '+property.owner,style:TextStyle(fontSize:12))),
        Positioned(top:280,left:7,child:Text('Address: '+property.address,style:TextStyle(fontSize:14))),
        Positioned(top:310,left:7,child:Text('Price: LKR '+property.price.toString(),style:TextStyle(fontSize:14))),
        Visibility(
          visible:(property.purchaseType=='Rent'),
          child:Positioned(top:310,left:140,child:Text('per month',style:TextStyle(fontSize:14)))
        ),
        Positioned(top:310,left:220,child:Text("|  Area: "+property.area.toString()+' sqft',style:TextStyle(fontSize:14))),
        Positioned(top:350,child:CustomPaint(painter: DrawDivider())),
        Positioned(top:370,left:7,child:Text("Overview",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))),
        Positioned(top:410,left:20,child:Row(children:<Widget>[
           Column(
             children:<Widget>[
               Text('Number of Floors',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.right)
             ]
           ),
           SizedBox(width:5),
           Column(
             children:<Widget>[
                Row(children: <Widget>[
                  Column(children: <Widget>[
                     Text(property.overviewData.floors.toString()+" floor",style:TextStyle(fontSize:13.0),textAlign:TextAlign.right)
                  ],),
                  Visibility(
                    visible:(property.overviewData.floors!=1),
                    child:Column(children: <Widget>[
                         Text("s",style:TextStyle(fontSize:13.0),textAlign:TextAlign.right)
                    ],)
                  )
                ],)
             ]
           )
        ])),
         Positioned(top:440,left:-5,child:DataTable(
          columns:<DataColumn>[
              DataColumn(
                label:Text('Configuration',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
              ),
              DataColumn(
                label:Text('Possesion by',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
              )
          ],
          rows:<DataRow>[
              DataRow(
                cells:<DataCell>[
                  DataCell(
                    Text(property.overviewData.configuration,style:TextStyle(fontSize:13.0),textAlign:TextAlign.center)
                  ),
                   DataCell(
                    Text(property.overviewData.possesionDate,style:TextStyle(fontSize:13.0),textAlign:TextAlign.center)
                  )
                ]
              )
          ]
        )),
        Positioned(top:570,left:7,child:Text("Rooms",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold,color:Colors.black))),
        Positioned(top:600,left:-5,child:Container(
          height:200,
          child:SingleChildScrollView(
          scrollDirection:Axis.vertical,
        child:DataTable(
          columnSpacing:10,
          columns:[
              DataColumn(
                 label:Text('Room Type',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
              ),
              DataColumn(
                 label:Text('Quanity',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
              ),
              DataColumn(
                 label:Text('Area',style:TextStyle(fontSize:14.0,fontWeight:FontWeight.bold,color:Colors.black),textAlign:TextAlign.center)
              )
          ],
          rows:generatRoomDetailsRow(property)
        )
        ))),
        Visibility(
          visible:(property.propertyType=="Appartment"),
          child:Positioned(top:820,left:7,child:Text("Special Highlights",style:TextStyle(fontSize:14,fontWeight:FontWeight.bold))),
        ),
        Visibility
        (
          visible:(property.propertyType=="Appartment"),
          child:Positioned(top:840,left:7,child:Container(width:400,height:600,child:generateSpecialHighlights(property)))
        )
    ],),
  );
      return Scaffold(
          appBar:generateAppBar(context, _updateFlg),
          body:SingleChildScrollView(
             child:Container(
               decoration:BoxDecoration(color:Colors.yellow[300]),
               child:Stack(children: <Widget>[
                  Column(crossAxisAlignment: CrossAxisAlignment.stretch,children: <Widget>[HouseSlider],),
                  detailView,
                  Visibility (
                         visible: _openFlg,
                         child:generateToolWindow(context)
                  )
          ],))
          )
      );
  }
}

class MapPage extends StatefulWidget {
  Property property;
  MapPage({Key key,this.property}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
 bool _openFlg=false;
 void _updateFlg(){
   if(_openFlg==false){
      setState((){_openFlg=true;});
   }else{
      setState((){_openFlg=false;});
   }
   //print(_openFlg);
}
  //Variables initialized for Google Map
  Completer<GoogleMapController> _controller=Completer();
  //By default Latitude and Longitude is set to zero
  static   LatLng _center= LatLng(0,0);
  final Set<Marker>_markers={};
  //Current Position of the map is set with latitude as 0 and longitude as 0 initially
  LatLng _lastMapPosition=_center;
  //Setting map type as Normal Map View 
  MapType _currentMapType=MapType.normal;
  //Variable for custom House Indicator
  BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
  }
  //Create Map Icon for the chosen property with respect to its latitude and longitude
  _createMarker(){
      BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(50,50)), 'assets/images/HouseIndicator.png')
        .then((icon) {
      customIcon = icon;
      });
  }
  //Initializing properties to GooogleMap Controller
  _onMapCreated(GoogleMapController controller){
      _controller.complete(controller);
      setState((){
          _markers.add(
            Marker(
              markerId:MarkerId(_lastMapPosition.toString()),
              position:_lastMapPosition,
              infoWindow:InfoWindow(title:widget.property.name,snippet:widget.property.address),
              //icon:BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet)
              icon:customIcon
            )
          );
      }
     );
  }
  //As we scroll in the map view the current position gets updated
  _onCameraMove(CameraPosition position){
     _lastMapPosition=position.target;
  }
  //This method is assign property's latitude and longitude to _center and assign _center to _lastMapPosition
  _updatePosition(Property p){
    _center= LatLng(p.latitude,p.longitude);
    _lastMapPosition=_center;
  }
   /*Button generation method where UI function, unique id and Icon*/
   Widget  button(Function function,IconData iconData,int id)
  {
    return FloatingActionButton(
      onPressed:function,
      heroTag:id,
      backgroundColor:Colors.orangeAccent,
      child:Icon(iconData,size:36)
    );
  }
   //The method to change map view between Satellite and Normal view types.
  _onMapTypeChanged(){
    setState(() {
      _currentMapType=_currentMapType==MapType.normal?MapType.satellite:MapType.normal;
    });
  }
  @override
  Widget build(BuildContext context) {
     _updatePosition(widget.property);
     _createMarker();
      return Scaffold(
        appBar:generateAppBar(context, _updateFlg),
        body:Stack(
          children: <Widget>[
            GoogleMap(
              onMapCreated:_onMapCreated,
              initialCameraPosition:CameraPosition(target:_center,zoom:18.0),
              zoomGesturesEnabled: true,
              mapType:_currentMapType,
              markers:_markers ,
              onCameraMove:_onCameraMove,
            ),
            Positioned(
              left:10,
              top:20,
              child:button(_onMapTypeChanged,Icons.map,1)
            ),
            Visibility (
                         visible: _openFlg,
                         child:generateToolWindow(context)
            )
          ],
        )
      );
  }

}
