import 'package:flutter/material.dart';

class NotifPage extends StatefulWidget {
  @override
  _NotifPageState createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  Map <String , bool >values ={
    '50km/h': true ,
    '80km/h' :false ,
    '100km/h': true ,
    '120km/h':false ,

  };
  bool value1 = true;
  bool value2 = true;
  bool value3 = true;
  bool value4 = true;

  bool value5 = true;
  void onChangedValue1(bool value) {
    setState(() {
      value1 = value;
    });
  }

  void onChangedValue2(bool value) {
    setState(() {
      value2= value;
    });
  }
  void onChangedValue3(bool value) {
    setState(() {
      value3 = value;
    });
  }

  void onChangedValue4(bool value) {
    setState(() {
      value4 = value;
    });
  }


  void onChangedValue5(bool value) {
    setState(() {
      value5 = value;
    });
  }

  Widget _image() {
    return Positioned(
      top: 24,
      child: Image(
        image: AssetImage("bell.png"),
        height: 250,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _switch() {
    return Positioned(
      top: 270,
      child: Container(
        margin: EdgeInsets.all(20),
        height:432,
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                offset: new Offset(10.0, 10.0),
              )
            ]),
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new SwitchListTile(
                  value: value5,
                  onChanged: onChangedValue5,
                  activeColor: Colors.deepOrange,
                  secondary: new Icon(
                    Icons.battery_alert,
                    color: Color(0xFFF57C00),
                  ),
                  title: new Text('Batterie utilisateur faible',
                      style:
                      TextStyle(fontSize: 20.0, color: Color(0xff739D84))),
                  subtitle: new Text(
                      "Prévenez-moi lorsque la batterie de quelqu'un est sur le point de se vider")),
              SizedBox(
                height: 20,
              ),
              new Text(
                  " la vitesse maximale  " , style: TextStyle(fontSize: 20.0, color: Color(0xff739D84)) , textAlign : TextAlign.center),



              new SwitchListTile(
                value: value4,
                onChanged: onChangedValue4,
                activeColor: Colors.deepOrange,
                secondary: new Icon(
                  Icons.trending_up,
                  color: Color(0xFFF57C00),
                ),
                title: new Text('50km/h'),
              ),
              new SwitchListTile(
                value: value3,
                onChanged: onChangedValue3,
                activeColor: Colors.deepOrange,
                secondary: new Icon(
                  Icons.trending_up,
                  color: Color(0xFFF57C00),
                ),
                title: new Text('80km/h'),
              ),
              new SwitchListTile(
                value: value2,
                onChanged: onChangedValue2,
                activeColor: Colors.deepOrange,
                secondary: new Icon(
                  Icons.trending_up,
                  color: Color(0xFFF57C00),
                ),
                title: new Text('100km/h'),
              ),
              new SwitchListTile(
                value: value1,
                onChanged: onChangedValue1,
                activeColor: Colors.deepOrange,
                secondary: new Icon(
                  Icons.trending_up,
                  color: Color(0xFFF57C00),
                ),
                title: new Text('120km/h'),
              ),



            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Color(0xffF2E9DB)),
        backgroundColor: Color(0xff739D84),
        title: Text(
          'Notification',
          style: TextStyle(
              color: Color(0xffF2E9DB),
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(icon: Icon(Icons.arrow_back), onPressed: () {
          moveToLastSreen() ;
        }),
      ),
      backgroundColor: Color(0xffF2E9DB),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            _image(),
            _switch(),
          ],
        ),
      ),
    );
  }
  moveToLastSreen(){
    Navigator.pop(context) ;
  }
}
