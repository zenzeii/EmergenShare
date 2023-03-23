import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emergenshare/screens/main_screens/inventory/add_inventory_item_screen.dart';
import 'package:flutter/material.dart';

final coursesRef = FirebaseFirestore.instance.collection('courses');

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
              'INVENTORY',
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddInventoryItemScreen()),
          );
        },
        tooltip: 'Add Item to inventory',
        child: const Icon(Icons.add),
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
          stream: coursesRef
              .where('numberOfReviewers', isNotEqualTo: 0)
              .orderBy('numberOfReviewers', descending: true)
              .limit(40)
              .snapshots(),
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
                  .add((data.docs[i].data())["name"]);
            }

            return ListView.builder(
              itemCount: data.size + 1,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    /*
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoursePageScreen2(
                          data.docs[index],
                        ),
                      ),
                    );

                     */
                  },
                  child: CourseBox().courseBox(
                      MediaQuery.of(context).size.width,
                      (data.docs[index].data())["name"]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class CourseBox {
  Widget courseBox(double width, String name) {
    return Container(
      width: width,
      margin: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.redAccent, Colors.redAccent],
              tileMode: TileMode.mirror,
            ),
          ),
          padding: const EdgeInsets.all(18.0),
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
