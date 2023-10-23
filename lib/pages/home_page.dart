import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_master/pages/add_task_page.dart';
import 'package:task_master/pages/signin_page.dart';
import 'package:task_master/pages/view_data_page.dart';
import 'package:task_master/services/auth_class.dart';
import 'package:task_master/widgets/todo_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();
  String selectedCategory = "All";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          actions: [
            buildFilterButton(context),
            IconButton(
              icon: const Icon(
                color: Colors.white,
                Icons.logout,
              ),
              onPressed: () async {
                Provider.of<Authentication>(context, listen: false)
                    .signOutWithGoogle();
                Provider.of<Authentication>(context, listen: false)
                    .logoutViaEmail();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => const SignInPage()),
                    (route) => false);
              },
            ),
          ],
          backgroundColor: Colors.black87,
          title: const Text(
            "Today's schedule",
            style: TextStyle(
                color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(35),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 22.0),
                child: Text(
                  'Monday 21',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          items: [
            BottomNavigationBarItem(
                icon: Container(
                  height: 20,
                  width: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    size: 32,
                    Icons.home,
                    color: Colors.white,
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const AddTaskPage()));
                  },
                  child: Container(
                    height: 50,
                    width: 52,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffff9999),
                          Color(0xffff5050),
                          Color(0xffff4500),
                        ],
                      ),
                    ),
                    child: const Icon(
                      size: 32,
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Container(
                  height: 20,
                  width: 50,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: const Icon(
                    size: 32,
                    Icons.settings,
                    color: Colors.white,
                  ),
                ),
                label: '',
                backgroundColor: Colors.red),
          ],
        ),
        body: StreamBuilder<dynamic>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final filteredDocs = snapshot.data.docs
                .where((doc) =>
                    selectedCategory == "All" ||
                    doc.data()["category"] == selectedCategory)
                .toList();
            return ListView.builder(
              itemCount: filteredDocs.length,
              itemBuilder: ((context, index) {
                IconData iconData = Icons.question_mark;
                Color iconColor = Colors.black;
                Map<String, dynamic> document =
                    filteredDocs[index].data() as Map<String, dynamic>;
                switch (document["category"]) {
                  case "Work":
                    iconData = Icons.work;

                    break;
                  case "Errands":
                    iconData = Icons.directions_walk_outlined;

                    break;
                  case "Housework":
                    iconData = Icons.house;

                    break;
                  case "Grocery":
                    iconData = Icons.local_grocery_store;

                    break;
                  case "GYM":
                    iconData = Icons.fitness_center;

                    break;
                  case "School":
                    iconData = Icons.school;

                    break;
                  default:
                    iconData = Icons.question_mark;
                    iconColor = Colors.white;
                }
                switch (document["type"]) {
                  case "Important":
                    iconColor = Colors.red;
                    break;
                  case "Planned":
                    iconColor = Colors.black;
                    break;

                  default:
                    iconColor = Colors.white;
                }
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ViewDataPage(
                          document: document,
                          id: snapshot.data.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: TodoCard(
                    title: document["title"] ?? "Title is Empty",
                    check: true,
                    time: "11 PM",
                    iconBgColor: Colors.white,
                    iconColor: iconColor,
                    iconData: iconData,
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }

  PopupMenuItem<String> buildPopupMenuItem(String category, String text) {
    return PopupMenuItem<String>(
      value: category,
      child: Text(text),
    );
  }

  IconButton buildFilterButton(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.filter_list,
        color: Colors.white,
      ),
      onPressed: () {
        showMenu(
          context: context,
          position: const RelativeRect.fromLTRB(0, 60, 0, 0),
          items: [
            buildPopupMenuItem("All", "All Categories"),
            buildPopupMenuItem("Work", "Work"),
            buildPopupMenuItem("Errands", "Errands"),
            buildPopupMenuItem("Housework", "Housework"),
            buildPopupMenuItem("Grocery", "Grocery"),
            buildPopupMenuItem("GYM", "GYM"),
            buildPopupMenuItem("School", "School"),
          ],
          elevation: 8.0,
        ).then((selectedCategoryValue) {
          setState(() {
            selectedCategory = selectedCategoryValue!;
          });
        });
      },
    );
  }
}
