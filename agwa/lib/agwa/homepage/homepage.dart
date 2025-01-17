// import 'package:agwa/agwa/addSensor/addSensorPage.dart';
// import 'package:agwa/screens/home/home.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../inventory/inventory_options.dart';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
// import 'package:flutter/material.dart';

// class homePage extends StatefulWidget {
//   const homePage({super.key});

//   @override
//   State<homePage> createState() => _homePageState();
// }

// class _homePageState extends State<homePage> {
//   Query dbRef = FirebaseDatabase.instance.ref();
//   DatabaseReference reference = FirebaseDatabase.instance.ref();

//   Widget listItem({required Map phVal}) {
//     return Container(
//         margin: const EdgeInsets.all(10),
//         padding: const EdgeInsets.all(10),
//         height: 110,
//         color: Colors.amberAccent,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Current pH Level: 7",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
//             ),
//           ],
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           SizedBox(height: 24),
//           Center(
//             child: Stack(children: [
//               Container(
//                 // child: FirebaseAnimatedList(
//                 //   query: dbRef,
//                 //   itemBuilder: (BuildContext context, DataSnapshot snapshot,
//                 //       Animation<double> animation, int index) {
//                 //     Map phVal = snapshot.value as Map;
//                 //     phVal['key'] = snapshot.key;
//                 //     //return listItem(phVal: phVal);
//                 //     return Text("Current pH Level: 7");
//                 //   },
//                 // ),
//                 child: StreamBuilder(
//                   stream: dbRef.onValue,
//                   builder:
//                       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                     if (snapshot.hasData) {
//                       // Process the retrieved data
//                       DataSnapshot data = snapshot.data!.snapshot;
//                       Map<dynamic, dynamic>? dataMap = data.value as Map?;
//                       // Use the data to populate your UI
//                       return Text(dataMap!['phValue']);
//                     } else if (snapshot.hasError) {
//                       return Text('Error: ${snapshot.error}');
//                     } else {
//                       return CircularProgressIndicator();
//                     }
//                   },
//                 ),
//                 //

//                 color: Colors.cyan,
//                 width: 320,
//                 padding: EdgeInsets.symmetric(vertical: 100.0),
//               ),
//             ]),
//           ),
//           SizedBox(height: 24),
//           Container(child: Text("Reminders"), width: 360),
//           SizedBox(height: 24),
//           Center(
//             child: Stack(children: [
//               Container(
//                 child: Text(
//                   "Reminders...",
//                   textAlign: TextAlign.center,
//                 ),
//                 color: Colors.cyan,
//                 width: 320,
//                 padding: EdgeInsets.symmetric(vertical: 150.0),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//     // bottomNavigationBar: BottomNavigationBar(
//     //   currentIndex: currentIndex,
//     //   onTap: (index) => setState(() => currentIndex = index),
//     //   items: const [
//     //     BottomNavigationBarItem(
//     //         label: "Sensor",
//     //         icon: Icon(Icons.signal_cellular_0_bar_outlined)),
//     //     BottomNavigationBarItem(
//     //       label: "Home",
//     //       icon: Icon(Icons.home),
//     //     ),
//     //     BottomNavigationBarItem(
//     //       label: 'Settings',
//     //       icon: Icon(Icons.settings),
//     //     )
//     //   ],
//     // ));
//   }
// }

// ***********************************

import 'package:agwa/agwa/addSensor/addSensorPage.dart';
import 'package:agwa/screens/home/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../inventory/inventory_options.dart';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:agwa/agwa/inventory/ponddata.dart';
import 'package:agwa/agwa/inventory/pondtile.dart';
import 'package:agwa/agwa/inventory/pondsList.dart';
import 'package:flutter/src/rendering/box.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:agwa/agwa/inventory/ponddata.dart';
import 'package:agwa/agwa/inventory/final_pond_dependencies/moodel_pondsData.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  // final CollectionReference _ponds =
  // FirebaseFirestore.instance.collection("ponds");

  final CollectionReference _reminders =
      FirebaseFirestore.instance.collection("activities");

  final reference = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL:
              'https://agwa-trial-space-v1-default-rtdb.asia-southeast1.firebasedatabase.app/')
      .ref('pHValue');

  // Get pH threshold from the database
  double threshold = 7.0; // Set your pH threshold
  double minimumPH = 0.0;
  double maximumPH = 0.0;
  String pHStatus = "";

  bool isSensorConnected = false; // Track the sensor connection status
  bool toShowDialog = true;

  void showDialog() {
    setState(() {
      toShowDialog = false;
    });
  }

  void connectToSensor() {
    setState(() {
      isSensorConnected = true;
    });
  }

  void disconnectFromSensor() {
    setState(() {
      isSensorConnected = false;
      toShowDialog = true;
    });
  }

  void showAlertDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: 'pH Level Alert',
      desc: 'The pH level is critical! Fix your water immediately.',
      btnOkOnPress: () {},
      btnOkColor: Colors.cyan,
    ).show();
  }

  Widget buildConnectedUI(BuildContext context, double pHValue,
      double minimumPH, double maximumPH) {
    // if (pHValue > threshold){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     showAlertDialog(context);
    //   });
    // }
    // Compare the pH value with the retrieved threshold values
    if (pHValue < minimumPH && toShowDialog) {
      pHStatus = "Below Normal pH Range";
      toShowDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlertDialog(context);
      });
    } else if (pHValue > maximumPH && toShowDialog) {
      pHStatus = "Above Normal pH Range";
      toShowDialog = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAlertDialog(context);
      });
    } else {
      if (pHValue < minimumPH) {
        pHStatus = "Below Normal pH Range";
      } else if (pHValue > maximumPH) {
        pHStatus = "Above Normal pH Range";
      } else {
        pHStatus = "Normal";
      }
    }
    //Retrieve the minimum and maximum pH values from Firestore

    return Column(
      children: [
        Text(
          "Current pH Level:",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "$pHValue",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Text(
          "Status: $pHStatus",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: disconnectFromSensor,
          child: Text('Disconnect Sensor'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(16),
          ),
        )
      ],
    );
  }

  Widget buildDisconnectedUI(BuildContext context) {
    return Column(
      children: [
        Text(
          'Connect to Sensor to see the pH readings',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: connectToSensor,
          child: Text('Connect Sensor'),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget listItem({required Map phVal}) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(10),
        height: 110,
        color: Colors.amberAccent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Current pH Level: 7",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 24),
          Center(
            child: Stack(children: [
              Container(
                width: 320,
                child: Card(
                  color: Colors.cyan,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 50.0),
                    child: isSensorConnected
                        ? StreamBuilder(
                            stream: reference.onValue,
                            builder: (BuildContext context,
                                AsyncSnapshot<DatabaseEvent> snapshot) {
                              if (snapshot.hasData) {
                                // Process the retrieved data
                                DataSnapshot data = snapshot.data!.snapshot;

                                // Retrieve the pH value from the database
                                double pHValue =
                                    double.parse(data.value.toString());

                                // // Compare the pH value with the threshold
                                // if (pHValue > threshold){
                                //   WidgetsBinding.instance.addPostFrameCallback((_) {
                                //     showAlertDialog(context);
                                //   });
                                // }
                                FirebaseFirestore.instance
                                    .collection(
                                        "pond-species_inventory") // Replace with your actual collection name
                                    .doc(
                                        "HGzRDo3Eoga441QQuIdK") // Replace with your actual document ID
                                    .get()
                                    .then((DocumentSnapshot documentSnapshot) {
                                  if (documentSnapshot.exists) {
                                    // Retrieve the minimum and maximum pH values from the document snapshot
                                    minimumPH = documentSnapshot
                                        .get("Minimum pH Level")
                                        .toDouble();
                                    maximumPH = documentSnapshot
                                        .get("Maximum pH Level")
                                        .toDouble();
                                    // double pHValue = double.parse(data.value.toString());
                                    // setState(() {
                                    //   // Update the UI with the retrieved values
                                    // });
                                  }
                                });
                                // Use the data to populate your UI
                                return buildConnectedUI(
                                    context, pHValue, minimumPH, maximumPH);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return CircularProgressIndicator();
                              }
                              // return Text('some text');
                            },
                          )
                        : buildDisconnectedUI(context),
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(height: 24),

          Container(
            width: 360,
            padding: EdgeInsets.fromLTRB(
                16, 0, 0, 8), // Adjust the bottom padding value
            child: Text(
              "Reminders",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // SizedBox(height: 24),
          Expanded(
            child: Stack(children: [
              SingleChildScrollView(
                child: Container(
                  height: 250,
                  padding: EdgeInsets.fromLTRB(
                      15, 0, 15, 8), // Adjust the bottom padding value

                  child: StreamBuilder(
                    stream: _reminders.snapshots(),
                    builder: (context, AsyncSnapshot snapshots) {
                      if (snapshots.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.cyan),
                        );
                      }
                      if (snapshots.hasData) {
                        final tasks = snapshots.data!.docs.toList();
                        final notDoneTasks = tasks
                            .where((task) => task['Status'] == false)
                            .toList();

                        // Sort the tasks based on the nearest deadline
                        notDoneTasks.sort((a, b) {
                          final DateTime deadlineA = a['Deadline'].toDate();
                          final DateTime deadlineB = b['Deadline'].toDate();
                          return deadlineA.compareTo(deadlineB);
                        });

                        return ListView.builder(
                          // itemCount: snapshots.data!.docs.length,
                          itemCount: notDoneTasks.length,
                          itemBuilder: (context, index) {
                            // final DocumentSnapshot records =
                            //     snapshots.data!.docs[index];
                            final DocumentSnapshot task = notDoneTasks[index];
                            // bool isTaskDone = task["Status"];

                            return Slidable(
                              child: Card(
                                child: ListTile(
                                  leading: Checkbox(
                                    // value: isTaskDone,
                                    value: false,
                                    onChanged: (value) {
                                      if (value == true) {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.question,
                                          animType: AnimType.bottomSlide,
                                          title: 'Confirmation',
                                          desc:
                                              'Are you sure you want to mark this as done?',
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            // Update the task status
                                            _reminders
                                                .doc(task.id)
                                                .update({'Status': value});
                                            Fluttertoast.showToast(
                                                msg: 'Activity marked as done');
                                          },
                                          btnOkColor: Colors.cyan,
                                        ).show();
                                      } else {
                                        // Update the status to not done
                                        _reminders
                                            .doc(task.id)
                                            .update({'Status': false});
                                      }
                                    },
                                  ),
                                  title: Text(task["Task Description"]),
                                  subtitle: Text("Deadline: " +
                                      task["Deadline"].toDate().toString()),
                                ),
                              ),
                            );
                          },
                          //     ),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(color: Colors.cyan),
                      );
                    },
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
