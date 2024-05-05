// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, dead_code, avoid_types_as_parameter_names
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/db_services/database.dart';
import 'package:random_string/random_string.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool Personal = true, College = false, Office = false;
  bool suggest = false;
  TextEditingController todoController = TextEditingController();
  Stream? todoStream;

  getonTheLoad() async {
    todoStream = await DatabseService().getTask(Personal
        ? "Personal"
        : College
            ? "College"
            : Office
                ? "Office"
                : "Default");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }

  Widget getWork() {
    return StreamBuilder(
        stream: todoStream,
        builder: (context, AsyncSnapshot Snapshot) {
          return Snapshot.hasData
              ? Expanded(
                  child: ListView.builder(
                      itemCount: Snapshot.data.docs.length,
                      itemBuilder: (context, Index) {
                        DocumentSnapshot docSnap = Snapshot.data.docs[Index];
                        return CheckboxListTile(
                          activeColor: Colors.greenAccent.shade400,
                          title: Text(docSnap["work"]),
                          value: docSnap["Yes"],
                          onChanged: (NewValue) async {
                            await DatabseService().tickMethod(
                                docSnap["Id"],
                                Personal
                                    ? "Personal"
                                    : College
                                        ? "College"
                                        : Office
                                            ? "Office"
                                            : "Default");
                            setState(() {
                              Future.delayed(Duration(seconds: 2), () {
                                DatabseService().removeMethod(
                                    docSnap["Id"],
                                    Personal
                                        ? "Personal"
                                        : College
                                            ? "College"
                                            : Office
                                                ? "Office"
                                                : "Default");
                              });
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                )
              : Center(child: CircularProgressIndicator());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent.shade400,
        onPressed: () {
          openBox();
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 50, left: 10),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyanAccent,
              Colors.lightBlueAccent,
              Colors.lightBlueAccent,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                'Hii',
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                'AR',
                style: TextStyle(fontSize: 54, color: Colors.black),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              child: Text(
                "Let's the work begins! ",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Personal
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Personal",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = true;
                          College = false;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text(
                          "Personal",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                College
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "College",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = true;
                          Office = false;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text(
                          "College",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                Office
                    ? Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade200,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Office",
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () async {
                          Personal = false;
                          College = false;
                          Office = true;
                          await getonTheLoad();
                          setState(() {});
                        },
                        child: Text(
                          "Office",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            getWork(),
          ],
        ),
      ),
    );
  }

  Future openBox() {
    return showDialog(
        context: context,
        builder: (Context) => AlertDialog(
              content: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          Text(
                            "Add Todo Task ~",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.greenAccent.shade400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Text("Add Text"),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2.0),
                        ),
                        child: TextField(
                          controller: todoController,
                          decoration: InputDecoration(
                            hintText: "Enter the task",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              String id = randomAlphaNumeric(10);
                              Map<String, dynamic> userTodo = {
                                "work": todoController.text,
                                "Id": id,
                                "Yes": false,
                              };
                              Personal
                                  ? DatabseService()
                                      .addPersonalTask(userTodo, id)
                                  : College
                                      ? DatabseService()
                                          .addCollegeTask(userTodo, id)
                                      : DatabseService()
                                          .addOfficeTask(userTodo, id);
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                "Add",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ));
  }
}
