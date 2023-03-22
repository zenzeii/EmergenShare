import 'package:flutter/material.dart';

//TODO Dark Theme

// main colors
const primaryColor = Colors.blue;
const backgroundColor = Colors.white;

// for screen
const listViewBackgroundColor = Color(0xffEBEBEB);

// for input
const inputBackground = Color(0xffEBEBEB);
const inputBackgroundDark = Colors.white10;
const inputInside = Color(0xFF6C6C6C);
const inputInsideActive = Colors.black;

// for AppBar (Top)
const appBarColor = Colors.black87;
const appBarBackgroundColor = Colors.white;

// for NavigationBar (Bottom)
const navBarColorSelected = Colors.black87;
const navBarColorUnselected = Color(0xFF6F6F6F);
const navBarBackgroundColor = Colors.white;

List<Color> groupMemberColor = [
  const Color(0xFF6FB1E4),
  const Color(0xFFE57979),
  const Color(0xFFECD074),
  const Color(0xFF80D066),
  const Color(0xFFFBA76F),
  const Color(0xFF73CDD0),
  const Color(0xFFF98BAE),
  const Color(0xFFCC90E2),
];

Color getGroupMemberColor(int i) {
  return groupMemberColor[i % groupMemberColor.length];
}

int getIndexOfGroupMember(List users, String user) {
  if (!users.contains(user)) {
    return 0;
  }
  return users.indexOf(user);
}
