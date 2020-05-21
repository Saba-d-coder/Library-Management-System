import 'package:flutter/material.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({this.text, this.iconName, this.screen});

  final String text;
  final IconData iconName;
  final screen;

  @override
  _MenuItemState createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> { //to display list items of side menu
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: ListTile(
        leading: Icon(widget.iconName),
        title: Text(widget.text),
        onTap: () => {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return widget.screen;
          }))
        },
      ),
    );
  }
}
