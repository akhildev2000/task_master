import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key}) : super(key: key);

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String type = "";
  String category = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff1d1e26),
          Color(0xff252041),
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Create",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "New Todo",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    label("Task Title"),
                    const SizedBox(
                      height: 12,
                    ),
                    title(),
                    const SizedBox(
                      height: 10,
                    ),
                    label("Task Type"),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        taskSelect("Important", 0xff2664fa),
                        const SizedBox(
                          width: 15,
                        ),
                        taskSelect("Planned", 0xff2bc8d9),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    label("Description"),
                    const SizedBox(
                      height: 10,
                    ),
                    description(),
                    const SizedBox(
                      height: 15,
                    ),
                    label("Category"),
                    const SizedBox(
                      height: 5,
                    ),
                    Wrap(
                      children: [
                        categorySelect("Errands", 0xffff6d6e),
                        const SizedBox(
                          width: 15,
                        ),
                        categorySelect("Housework", 0xfff29732),
                        const SizedBox(
                          width: 15,
                        ),
                        categorySelect("Grocery", 0xff6557ff),
                        const SizedBox(
                          width: 15,
                        ),
                        categorySelect("GYM", 0xff2bc8d9),
                        const SizedBox(
                          width: 15,
                        ),
                        categorySelect("Work", 0xff663300),
                        const SizedBox(
                          width: 15,
                        ),
                        categorySelect("School", 0xff009900),
                        const SizedBox(
                          width: 15,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    createButton()
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  Widget taskSelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: type == label ? Colors.white : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.black : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        labelPadding: const EdgeInsets.symmetric(vertical: 3.8, horizontal: 13),
      ),
    );
  }

  Widget categorySelect(String label, int color) {
    return InkWell(
      onTap: () {
        setState(() {
          category = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: category == label ? Colors.black : Color(color),
        label: Text(
          label,
          style: TextStyle(
              color: type == label ? Colors.white : Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold),
        ),
        labelPadding: const EdgeInsets.symmetric(vertical: 3.8, horizontal: 13),
      ),
    );
  }

  Widget createButton() {
    return InkWell(
      onTap: () {
        final title = _titleController.text;
        final description = _descriptionController.text;

        if (title.isNotEmpty) {
          // Define the task data
          final taskData = {
            'title': title,
            'description': description,
            'type': type,
            'category': category,
          };

          // Add the task to Firestore
          firestore.collection('Todo').add(taskData).then((value) {
            // The task has been added to Firestore
          
            Navigator.pop(context);
          }).catchError((error) {
            // Handle any Firestore errors here
          //  print('Error adding task to Firestore: $error');
          });
        }
      },
      child: Container(
          height: 55,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [
              Color(0xffff9999),
              Color(0xffff5050),
              Color(0xffff4500),
            ]),
          ),
          child: const Center(
            child: Text(
              'Add Todo',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 15),
            ),
          )),
    );
  }

  Widget description() {
    return Container(
      height: 120,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        maxLines: null,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
            hintText: "Description",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, top: 8)),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: const InputDecoration(
            hintText: "Task Title",
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: EdgeInsets.only(left: 20, right: 20, bottom: 5)),
      ),
    );
  }

  Widget label(String text) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.white,
          fontSize: 16.5,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2),
    );
  }
}
