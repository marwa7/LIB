import 'package:ourwonderfullapp/classes/Groupe.dart';
import 'package:ourwonderfullapp/classes/Request.dart';
import 'package:ourwonderfullapp/classes/SharableUserInfo.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'package:ourwonderfullapp/classes/transport.dart';
import 'package:ourwonderfullapp/servises/firestore.dart';
import 'package:ourwonderfullapp/servises/auth.dart';

class App {
  final FirestoreService _firestoreService = FirestoreService ();
  final ServicesAuth _servicesAuth = ServicesAuth();
  Utilisateur _utilisateur ; //utilisateur connecté à l'application
  List<Utilisateur> _list_utilisateur ;
  List<Group> _list_groupes;

  App (Utilisateur utilisateur){
    _utilisateur = utilisateur;
  }

  Future<Group> test () async
  {
    try {
      //u.setDateOfBirth();
      /*_utilisateur.setDisplayName('Yasmina');
      _utilisateur.setPhone('+213 676370021');
      _utilisateur.removePhone();
      _utilisateur.setPhone('phone');
      _utilisateur.changeActiveStatus();
      _utilisateur.setPhoto();
      _utilisateur.deletePhoto();
      _utilisateur.setTransport(Transport.Voiture);
      _utilisateur.addVehicule(new Vehicle('matricule', 'model', 'color'));
      _utilisateur.setLocation();*/

      /*await add()
          .then((_) async => _utilisateur.getUsersGroupsHeaders() )
          .then((_) => print('finishedddddddddddddddddddddddddddddddddddddddddddddddddddddddd'));*/
      return await ajouterGroupe('groupe1',false, List<String>());
    }
    catch (e){

    }
  }
  Future<void> add () async {
    ajouterGroupe('groupe1',false, List<String>()).then((_) async {
      ajouterGroupe('groupe2',false, List<String>()).then((_) async {
        ajouterGroupe('groupe3',false, List<String>()).then((_) async {
          ajouterGroupe('groupe4',false, List<String>()).then((_) {
            print('Groupeeees addeeeed');
          });
        });
      });
    });
  }

  Future<Group> ajouterGroupe (String nom,bool photo, List<String> membres) async {
    if(_utilisateur!=null){
      Group groupe = await _firestoreService.createGroupDoc(nom, this._utilisateur.sharableUserInfo.id,photo);
      print('Grouuupe $groupe');
      this._utilisateur.addGroupe(groupe.gid);
        //groupe.setPhoto();
      membres.forEach((member) async {
        await addMemberToGroup(groupe, member);
      });
      return groupe ;
    }
    else {
      print('No user signned in or up \n This should\'nt happen ?!!');
      return null ;
    }
  }
  Future<void> addMemberToGroup (Group groupe,String member) async {
    if(_utilisateur!=null){
      String text = this._utilisateur.sharableUserInfo.displayName+' invites you to join the groupe '+groupe.nom;
      //TODO await _firestoreService.sendInvitationFromGroup(member,_utilisateur.sharableUserInfo.id, groupe.gid,text);
    }
    else {
      print('Could\'nt send request : No user : this shouldn=\'t happen');
    }
  }
  void joinGroupe (String groupeID){
    if(_utilisateur!=null){
      String text = this._utilisateur.sharableUserInfo.displayName+' asks join this groupe';
      _firestoreService.sendInvitationFromUser(groupeID, this._utilisateur.sharableUserInfo.id, groupeID, text);
    }
    else {
      print('No user signned in or up \n This should\'nt happen ?!!');
    }
  }

  /*void refuseInvitation (Request request){
    request.setAccepted(false);
  }
  void acceptInvitation (Request request){
    request.setAccepted(true);
  }*/
}