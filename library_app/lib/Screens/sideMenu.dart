import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:libraryapp/Screens/Profile.dart';
import 'package:libraryapp/Services/menuItem.dart';
import 'package:libraryapp/constants/allConst.dart';
import 'history.dart';
import 'wishlist.dart';
import 'package:libraryapp/Services/Book.dart';
import 'package:libraryapp/Services/Ratings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:libraryapp/Screens/loginPage.dart';
import 'package:libraryapp/Screens/SettingsPage.dart';

class SideMenu extends StatelessWidget {
  final Map<String, dynamic> profile;
  List<Book> bookDB = List();
  List<Ratings> ratingDB = List();

  SideMenu({this.profile, this.bookDB, this.ratingDB, getTheme()});

  void sendEmail(String email) => launch("mailto:$email?subject=Feedback"); //to open mail app on your phone

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
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
              backgroundColor: kThemeText,
              child: Icon(
                Icons.person,
                color: kCircleAvatarIconColor,
              ),
            ),
            decoration: new BoxDecoration(color: kThemeColor),
          ),
          MenuItem(
            text: 'Profile',
            iconName: Icons.person_outline,
            screen: ProfileDetails(profile), //to call profile details page
          ),
          MenuItem(
              text: 'History',
              iconName: Icons.history,
              screen: History(bookDB, profile['uid'], ratingDB) //to display library transaction history of the user
          ),
          MenuItem(
            text: 'Wishlist',
            iconName: Icons.list,
            screen: Wishlist(bookDB, profile['uid'], ratingDB), //to display wishlist of the user
          ),
          MenuItem(
            text: 'Settings',
            iconName: Icons.settings,
            screen: SettingsPage(profile['uid']), //opens profile itself(as of now)
          ),
          ListTile(
            title: Text('Feedback', style: TextStyle(color: kMenuItemTextColor)),
            leading: Icon(Icons.border_color),
            onTap: () => {sendEmail("libraryapp.proj@gmail.com")}, //to send a feedback via email
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout', style: TextStyle(color: kMenuItemTextColor)),
            onTap: () => {Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                return LoginPage();
              }),
             (Route<dynamic> route) => false) //to logout by popping out every screen and push login screen
            },
          ),
        ]),
      ),
    );
  }
}
