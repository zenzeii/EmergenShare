import 'package:emergenshare/components/colors.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Color backgroundColor = appBarBackgroundColor;
  final Color textColor = appBarColor;
  final String? title;
  AppBar? appBar = AppBar();
  final Icon? icon;
  final Function? press;
  final List<Widget>? widgets;
  final Container? space;
  final Image? image;

  ChatAppBar({
    Key? key,
    this.title,
    this.appBar,
    this.icon,
    this.press,
    this.widgets,
    this.space,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Row(
        children: [
          /*
          Container(
            padding: const EdgeInsets.only(right: 10),
            height: 42,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: Image.network(
                  "https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png"),
            ),
          ),

           */
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Theme.of(context).dividerColor,
              radius: 21.0,
            ),
          ),
          Text(title!.toUpperCase(),
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color,
                  fontSize: 18,
                  fontWeight: FontWeight.normal)),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      iconTheme:
          IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
      actions: widgets,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(AppBar().preferredSize.height);
}
