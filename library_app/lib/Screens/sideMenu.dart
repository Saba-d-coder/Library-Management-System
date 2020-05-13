import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:libraryapp/Screens/Profile.dart';
import 'package:libraryapp/Services/menuItem.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'history.dart';
import 'wishlist.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/Ratings.dart';

class SideMenu extends StatelessWidget {
  final Map<String, dynamic> profile;
  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();

  SideMenu({this.profile, this.bookDB, this.ratingDB});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
//        margin: EdgeInsets.only(right: 0.0),
        color: kThemeText,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              profile['name'],
              style: TextStyle(color: kThemeText),
            ),
            accountEmail: Text(
              profile['emailID'],
              style: TextStyle(color: kThemeText),
            ),
            currentAccountPicture: new CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            decoration: new BoxDecoration(color: kThemeColor),
          ),
          //TODO 2: Add navigator push for resp screens rn added same screen to all
          MenuItem(
            text: 'Profile',
            iconName: Icons.person_outline,
            screen: ProfileDetails(profile),
          ),
          MenuItem(
              text: 'History',
              iconName: Icons.history,
              screen: History()),
          MenuItem(
            text: 'Wishlist',
            iconName: Icons.list,
            screen: Wishlist(bookDB, profile['uid'], ratingDB),
          ),
          MenuItem(
            text: 'Settings',
            iconName: Icons.settings,
            screen: ProfileDetails(profile),
          ),
          MenuItem(
            text: 'Feedback',
            iconName: Icons.border_color,
            screen: ProfileDetails(profile),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {Navigator.pop(context)},
          ),
        ]),
      ),
    );
  }
}
