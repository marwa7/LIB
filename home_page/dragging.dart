import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'friend/friend.dart';




class Dragging extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Dragging> {

  List<Friend> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    http.Response response =
    await http.get('https://randomuser.me/api/?results=25');

    setState(() {
      _friends = Friend.allFromResponse(response.body);
    });
  }

  Widget _buildFriendListTile(BuildContext context, int index) {
    var friend = _friends[index];

    return new ListTile(
      leading: new Hero(
        tag: index,
        child: new CircleAvatar(
          backgroundImage: new NetworkImage(friend.avatar),
        ),
      ),
      title: new Text(friend.name),
      subtitle: new Text(friend.location),
     // trailing: BatteryLevelPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
          child: DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.8,
            builder: (BuildContext context, myscrollController) {
              return
                Stack(children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24.0),
                          topRight: Radius.circular(24.0)),
                    ),
                    margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0),
                    child:  ListView.builder(
                      controller: myscrollController,
                      itemCount: _friends.length,
                      itemBuilder: _buildFriendListTile,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 160,top: 5),
                    child:Container(
                      height: 6,
                      width: 36,
                      decoration: BoxDecoration(
                        color:Colors.black26,
                        borderRadius: BorderRadius.circular(20),
                      ),),),

                ]);
              },
          ),

      );
  }
  Widget button( IconData icon, Color color1 , Color color2) {
    return Container(
        height: 45,
        width: 45,
        child: FittedBox(
          child:
          FloatingActionButton(

            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: color1,
            child: Icon(
                icon,
                size: 30.0,
                color:color2
            ),
          ),
        )
    );
  }
}