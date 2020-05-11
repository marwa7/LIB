import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ourwonderfullapp/classes/Request.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'package:ourwonderfullapp/groupe/join.dart';
import 'package:provider/provider.dart';
import 'package:ourwonderfullapp/Wrapper.dart';

class code extends StatefulWidget {
  @override
  _codeState createState() => _codeState();
}

class _codeState extends State<code> {

  CollectionReference collectionReference ;
  Utilisateur utilisateur ;
  @override
  Widget build(BuildContext context) {
    setState(() {
      utilisateur = Provider
          .of<User>(context)
          .utilisateur;
      collectionReference = utilisateur.usersInfoDoc.collection('invitationsFromGroup');
    });
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Color(0xffF2E9DB)),
        backgroundColor: Color(0xff739D84),
        title : Text (
          'Invitations',
          style: TextStyle(
              color: Color(0xffF2E9DB),
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => moveToLastSeen (),
        ),
      ),
      backgroundColor: Color(0xffF2E9DB),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 70,
            ),
            invitations(),
          ],
        ),
      ),
    );
  }
  moveToLastSeen() {
    Navigator.pop(context);
  }
  Widget invitationBuilder (){
    return null;
  }
  StreamBuilder invitations(){
    return StreamBuilder<List<RequestFromGroupe>>(
      stream : utilisateur.usersInfoDoc.collection('invitationsFromGroup').where('ToUID',isEqualTo: utilisateur.sharableUserInfo.id).snapshots().map((querySnapshot){
        List<RequestFromGroupe> invitations = List<RequestFromGroupe> ();
        for ( DocumentSnapshot documentSnapshot in  querySnapshot.documents) {
          RequestFromGroupe requestFromGroupe = RequestFromGroupe.fromMap(documentSnapshot.documentID, documentSnapshot.data);
          invitations.add(requestFromGroupe);
        }
        print(invitations.length);
        return invitations;
      }),
      builder: (BuildContext context,asyncSnapshot) {
        if (asyncSnapshot.hasError){
          print(asyncSnapshot.error);
          return Center(child: Text('Something went wrong'));
        }
        else if (!asyncSnapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          if (asyncSnapshot.data.length == 0){
            return Column (
              children: <Widget>[
                Text('There are no invitations for you at the moment'),
              ],
            );
          }
          else {
            return Expanded(
                child: ListView.builder(
                  itemCount: asyncSnapshot.data.length,
                  itemBuilder: (BuildContext context,int index){
                    RequestFromGroupe requestFromGroup  = asyncSnapshot.data[index];
                    return ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Invitation (requestFromGroupe: requestFromGroup,)));
                      },
                      title: Row(
                        children: <Widget>[
                          Text(requestFromGroup.text),
                        ],
                      ),
                      onLongPress: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> deleteInvitation(requestFromGroup.requestID)));
                        },
                    );
                  },
                ),
            );
          }

        }
      },
    );
  }
  AlertDialog deleteInvitation(String invitationID){
      return AlertDialog(
        title: Text("Delete Invitaion",
            style: TextStyle(
              color: Color(0xff739D84),
            )),
        content: Text(
            "Do you want to delete this invitation ?"),
        actions: <Widget>[
          FlatButton(
              child: Text('Yes',
                  style: TextStyle(
                    color: Color(0xffE8652D),
                  )),
              onPressed: () async {
                await collectionReference.document(invitationID).delete();
                Navigator.pop(context);
              }),
          FlatButton(
              child: Text('No',
                  style: TextStyle(
                    color: Color(0xffE8652D),
                  )),
              onPressed: () {
                Navigator.pop(context);
              }),
        ],
      );
  }
}

class Invitation extends StatefulWidget {
  final RequestFromGroupe requestFromGroupe;
  Invitation({this.requestFromGroupe});
  @override
  _InvitationState createState() => _InvitationState();
}

class _InvitationState extends State<Invitation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Color(0xffF2E9DB)),
        backgroundColor: Color(0xff739D84),
        title: Text(
          'Invitation',
          style: TextStyle(
              color: Color(0xffF2E9DB),
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xffF2E9DB),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(
              height: 70,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 25.0),
              width: 250.0,
              child: RaisedButton(
                elevation: 5.0,
                onPressed: () async {
                  DocumentSnapshot groupsInfo = await Firestore.instance.collection('groups').document(widget.requestFromGroupe.gid).get();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> JoinConfirme(groupInfo: groupsInfo,)) );
                },
                padding: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0)),
                color: Color(0xffE8652D),
                child: Text(
                  '  Accept  ',
                  style: TextStyle(
                      color: Color(0xffF1B97A),
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}























































































































































































































































































