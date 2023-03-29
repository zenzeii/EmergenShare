import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/screens/main_screens/inventory/add_inventory_item_screen.dart';
import 'package:emergenshare/screens/main_screens/inventory/update_inventory_item_screen.dart';
import 'package:emergenshare/services/helperfunctions.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

final inventoryRef = FirebaseFirestore.instance
    .collection('users')
    .doc(HelperFunctions.getUserIdSharedPreference())
    .collection('inventory');

class InventoryListScreen extends StatefulWidget {
  InventoryListScreen({Key? key}) : super(key: key);
  List<String> courseNames = [];

  @override
  _InventoryListScreenState createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  late int captureNumberOfCourses;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconTheme:
            IconThemeData(color: Theme.of(context).textTheme.bodyText1?.color),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'MY INVENTORY',
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1?.color),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              /*
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => SearchCoursesScreen2()),
                (route) => true,
              );

               */
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddInventoryItemScreen()),
          );
        },
        tooltip: 'Add Item to inventory',
        icon: const Icon(Icons.add),
        label: const Text('Add item to donate'),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Theme.of(context).dividerColor.withOpacity(0.05),
          ],
        )),
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: inventoryRef.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text("Something went wrong :("),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.requireData.size == 0) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text("What do want to donate?"),
                ),
              );
            }

            final data = snapshot.requireData;
            captureNumberOfCourses = data.size;
            for (var i = 0; i < captureNumberOfCourses; i++) {
              InventoryListScreen()
                  .courseNames
                  .add((data.docs[i].data())["itemName"]);
            }

            return GridView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: data.size,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UpdateInventoryItemScreen(
                                itemName: (data.docs[index].data())["itemName"],
                                itemImageUrl:
                                    (data.docs[index].data())["itemImageUrl"],
                                itemImageName:
                                    (data.docs[index].data())["itemImageName"],
                                inventoryId: data.docs[index].id,
                              )),
                    );
                  },
                  child: CourseBox().courseBox(
                    MediaQuery.of(context).size.width,
                    (data.docs[index].data())["itemName"],
                    (data.docs[index].data())["itemImageUrl"],
                  ),
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
            );
          },
        ),
      ),
    );
  }
}

class CourseBox {
  Widget courseBox(double width, String name, String imageUrl) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
              opacity: 0.8,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue, Colors.blueAccent],
              tileMode: TileMode.mirror,
            ),
          ),
          padding: const EdgeInsets.all(18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InventoryTile {
  Widget inventoryTile(double width, String name, String imageUrl) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          placeholder: (context, url) => CardLoading(
            height: double.infinity,
          ),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          imageBuilder: (context, imageProvider) => Container(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
                opacity: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
