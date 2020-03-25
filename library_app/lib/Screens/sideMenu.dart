import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:libraryapp/Screens/Profile.dart';
import 'package:libraryapp/Services/menuItem.dart';
import 'package:libraryapp/constants/allConst.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
//        margin: EdgeInsets.only(right: 0.0),
        color: kThemeText,
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(
              'KSK',
              style: TextStyle(color: kThemeText),
            ),
            accountEmail: Text(
              'abc@gmail.com',
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
//          Container(
//            height: 150.0,
//            child: DrawerHeader(
//              margin: EdgeInsets.only(bottom: 0.0),
//              padding: EdgeInsets.fromLTRB(15.0, 70.0, 0.0, 0.0),
//              child: Text(
//                'Welcome! KSK',
//                style: TextStyle(color: kThemeText, fontSize: 25),
//              ),
//              decoration: BoxDecoration(
//                color: kThemeColor,
//              ),
//            ),
//          ),
          //TODO 2: Add navigator push for resp screens rn added same screen to all
          MenuItem(
            text: 'Profile',
            iconName: Icons.verified_user,
            screen: ProfileDetails(),
          ),
          MenuItem(
              text: 'History',
              iconName: Icons.history,
              screen: ProfileDetails()),
          MenuItem(
            text: 'Books Issued',
            iconName: Icons.book,
            screen: ProfileDetails(),
          ),
          MenuItem(
            text: 'Wishlist',
            iconName: Icons.list,
            screen: ProfileDetails(),
          ),
          MenuItem(
            text: 'Settings',
            iconName: Icons.settings,
            screen: ProfileDetails(),
          ),
          MenuItem(
            text: 'Feedback',
            iconName: Icons.border_color,
            screen: ProfileDetails(),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            //TODO 3 :after adding named routes everywhere change logout function
            onTap: () => {Navigator.pop(context)},
          ),
        ]),
      ),
    );
  }
}
