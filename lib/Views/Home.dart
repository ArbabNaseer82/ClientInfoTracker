import 'package:applicant_info/Views/ListPage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();

  TextEditingController cnicController = TextEditingController();

  TextEditingController contactController = TextEditingController();

  TextEditingController totalFeeController = TextEditingController();

  TextEditingController payFeeController = TextEditingController();

  TextEditingController unpayFeeController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  final String birth = "Birth";

  final String death = "Death";

  final String marriage = "Marriage";

  final String divorce = "Divorce";

  // Database variable
  late Database _database;

  // button function for event selection

  String? selectedEvent;

  Widget buildEventButton(String event) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedEvent = event;
          });
        },
        child: Container(
          height: 45,
          decoration: BoxDecoration(
            color: selectedEvent == event
                ? const Color(0xff0b7f7e)
                : const Color.fromARGB(255, 212, 210, 210),
            border: Border.all(
              color: Colors.white,
            ),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              event,
              style: TextStyle(
                color: selectedEvent == event ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
// end of button function

// function for get today date

  String getTodayDate() {
    // Get the current date and time
    DateTime now = DateTime.now();

    // Extract the current date
    int day = now.day;
    int month = now.month;
    int year = now.year;
    return '$day-$month-$year';
  }
  // end of function

  // Function for create database and table
  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'applicants.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE applicants (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            cnic TEXT,
            contactNo TEXT,
            totalFee REAL,
            payFee REAL,
            unpayFee REAL,
            address TEXT,
            date TEXT,
            selectedEvent TEXT
          )
        ''');
      },
      version: 1,
    );
    print("database created successfully:: $_database");
  }

  Future<void> _saveApplicantData() async {
    await _database.insert(
      'applicants',
      {
        'name': nameController.text,
        'cnic': cnicController.text,
        'contactNo': contactController.text,
        'totalFee': double.parse(totalFeeController.text),
        'payFee': double.parse(payFeeController.text),
        'unpayFee': double.parse(unpayFeeController.text),
        'address': addressController.text,
        'date': getTodayDate(),
        'selectedEvent': selectedEvent,
      },
    );

    // Clear the text controllers after saving data
    nameController.clear();
    cnicController.clear();
    contactController.clear();
    totalFeeController.clear();
    payFeeController.clear();
    unpayFeeController.clear();
    addressController.clear();

    // Update the UI after saving data
    setState(() {});

    print("data saved successfully");
  }

  // Function for get back data from database
  Future<void> _retrieveApplicants() async {
    final List<Map<String, dynamic>> applicants = await _database.query(
      'applicants',
    );
    print(applicants);
  }

  // init function
  @override
  void initState() {
    super.initState();
    getTodayDate();
    _initializeDatabase();
  }
  // end of init function

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Applicant Information",
            style: TextStyle(
              color: Color(0xff0b7f7e),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 168, 168)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Applicant Name',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 168, 168)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: cnicController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Applicant CNIC',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 168, 168)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: contactController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Applicant Contact No #',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 153, 168, 168)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: totalFeeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Total Fee',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 153, 168, 168)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: payFeeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Pay Fee',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromARGB(255, 153, 168, 168)
                                            .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: unpayFeeController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Unpay Fee',
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 168, 168)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Applicant Address',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 153, 168, 168)
                                  .withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: TextEditingController(
                            text: getTodayDate(),
                          ),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildEventButton('Birth'),
                          const SizedBox(width: 5),
                          buildEventButton('Death'),
                          const SizedBox(width: 5),
                          buildEventButton('Marriage'),
                          const SizedBox(width: 5),
                          buildEventButton('Divorce'),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff0b7f7e),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 50.0),
                                ),
                                elevation: MaterialStateProperty.all(10),
                                overlayColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 100, 109, 109),
                                ),
                              ),
                              onPressed: () {
                                if (selectedEvent == null ||
                                    selectedEvent == "" ||
                                    nameController.text == "" ||
                                    cnicController.text == "" ||
                                    contactController.text == "" ||
                                    totalFeeController.text == "" ||
                                    payFeeController.text == "" ||
                                    unpayFeeController.text == "") {
                                  // Alert dialog for show error
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text(
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                            "Error"),
                                        content: const Text(
                                          "Please fill all fields",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              height: 30,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                color: const Color(0xff0b7f7e),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    "Ok"),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  return;
                                } else {
                                  _saveApplicantData();
                                  // SnackBar for show success message at top of screen
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Center(
                                        child: Text(
                                          "Data saved successfully",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      backgroundColor: Colors.green,
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 50,
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xff0b7f7e),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                  const Size(double.infinity, 50.0),
                                ),
                                elevation: MaterialStateProperty.all(10),
                                overlayColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 100, 109, 109),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: const ListPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Check List",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
