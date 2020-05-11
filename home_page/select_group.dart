import 'direct_select_container.dart';
import 'direct_select_item.dart';
import 'direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'package:ourwonderfullapp/classes/Groupe.dart';

class MyGroup extends StatefulWidget {
  MyGroup({Key key, this.title}) : super(key: key);

  final String title;
  @override
  _MyGroupState createState() => _MyGroupState();
}

List<String> Groups = [
  "Family",
  "Project",
  "Sisters",
  "Friends",
  "Groupe5",
  "Cousins",
];

class _MyGroupState extends State<MyGroup> {

  int selectedgroup = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Container(
      child: DirectSelectContainer(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      GroupSelector(data: Groups),
                      SizedBox(height: 20.0),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

class GroupSelector extends StatelessWidget {
  final buttonPadding = const EdgeInsets.fromLTRB(35, 20, 35, 0);

  final List<String> data;

  GroupSelector({@required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: buttonPadding,
          child: Container(
            decoration: _getShadowDecoration(),
            child: Card(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                            child: DirectSelectList<String>(
                              values: data,
                              defaultItemIndex: 0,
                              itemBuilder: (String value) =>
                                  getDropDownMenuItem(value),
                              focusedItemDecoration: _getDslDecoration(),
                            ),
                            padding: EdgeInsets.only(left: 12))
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: _getDropdownIcon(),
                    )
                  ],
                )),
          ),
        ),
      ],
    );
  }

  DirectSelectItem<String> getDropDownMenuItem(String value) {
    return DirectSelectItem<String>(
        itemHeight: 45,
        value: value,
        itemBuilder: (context, value) {
          return Text(value,
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
            ),
          );
        });
  }

  _getDslDecoration() {
    return BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(width: 1, color: Colors.orangeAccent),
          top: BorderSide(width: 1, color: Colors.orangeAccent),
        ));
  }

  BoxDecoration _getShadowDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      boxShadow: <BoxShadow>[
        new BoxShadow(
          color: Colors.black45.withOpacity(0.06),
          spreadRadius: 4,
          offset: new Offset(0.0, 0.0),
          blurRadius: 10.0,
        ),
      ],
    );
  }

  Icon _getDropdownIcon() {
    return Icon(
      Icons.unfold_more,
      color: Colors.orangeAccent,
    );
  }
}