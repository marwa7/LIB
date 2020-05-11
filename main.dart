import 'package:flutter/material.dart';
import 'package:ourwonderfullapp/Wrapper.dart';
import 'package:ourwonderfullapp/classes/SharableUserInfo.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'package:ourwonderfullapp/servises/MessagesService.dart';
import 'package:provider/provider.dart';
import 'package:ourwonderfullapp/servises/auth.dart';
import 'package:ourwonderfullapp/servises/firestore.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  App () ;
  }
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final MessagingService messagingService = MessagingService();
  final ServicesAuth _servicesAuth = ServicesAuth();
  final FirestoreService _firestoreService = FirestoreService();
  User user = User ();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>(
      create: (context) => user,
      child: MaterialApp(
        home: /*FutureBuilder<Utilisateur>(
          future: getUser (),
          builder: (context, snapshot) {
            if (snapshot.hasError){
              return Text('Error');
            }else if(!snapshot.hasData){
                return Center(
                  child: Container(
                    color: Color(0xff739D84),
                    child: Image(
                        image: AssetImage('assets/images/logo.png' ),
                    ),
                  ),
                );
            }else{
              print('hiiiiiiiii');
              user.setUtilisateur(snapshot.data);
              return Wrapper();
            }
          }
        ),*/
        Wrapper(),
        debugShowCheckedModeBanner: false,
      ),
    ) ;
  }
  Future<Utilisateur> getUser () async {
    print('hiiiiiiiiiiiiiiiiiiiiiiiiiiii');
    if(await _servicesAuth.isSignedIn()){
        String uid = await _servicesAuth.userID();
        SharableUserInfo userInfo = await _firestoreService.getUserInfo(uid);
        return Utilisateur.old(uid, userInfo);
      }
      else
        return null ;
  }
}
