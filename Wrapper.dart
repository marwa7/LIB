import 'package:flutter/material.dart';
import 'package:ourwonderfullapp/authentication/Connection.dart';
import 'package:ourwonderfullapp/classes/Groupe.dart';
import 'package:ourwonderfullapp/classes/SharableUserInfo.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'package:ourwonderfullapp/groupe/groups.dart';
import 'package:ourwonderfullapp/home/home_page_2.dart';
import 'package:ourwonderfullapp/servises/auth.dart';
import 'package:ourwonderfullapp/servises/firestore.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  Group _group;
  @override
  Widget build(BuildContext context) {
    //return either Home or Authenticate depending on the Firebase.Auth instance
    if (Provider
        .of<User>(context)
        .utilisateur == null)
      return Connection();
    /*else {
      return CreatePage();
    }*/
    else
      return HomePages_2();
  }
}
class User  extends ChangeNotifier {
  Utilisateur _utilisateur;
  final ServicesAuth _servicesAuth = ServicesAuth();
  final FirestoreService _firestoreService = FirestoreService();

  void setUtilisateur (Utilisateur utilisateur){
    _utilisateur = utilisateur;
    notifyListeners();
  }
  void onUserModified (){
    notifyListeners();
  }
  void signOut (){
    if(_utilisateur!=null){
      _servicesAuth.signOut(_utilisateur.sharableUserInfo.id);
      _utilisateur = null ;
      notifyListeners();
    }
  }
  void delete () async {
    if(_utilisateur!=null){
      await _servicesAuth.delete();
      await _utilisateur.delete();
      _utilisateur = null;
      notifyListeners();
    }
  }
 Utilisateur get utilisateur => _utilisateur;
}

