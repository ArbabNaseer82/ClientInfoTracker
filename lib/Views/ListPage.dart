import 'package:applicant_info/Views/EditApplicant.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  bool isSearching = false;
  // List for store data
  late List<Map<String, dynamic>> applicants = [];
  late List<Map<String, dynamic>> allApplicants = [];
  // Database variable
  late Database _database;
  // Loading variable
  bool isLoading = true;
  // Event filter variable
  late String selectedEventFilter = 'All';

  // Function for get back data from database
  Future<void> _retrieveApplicants() async {
    final List<Map<String, dynamic>> applicants = await _database.query(
      'applicants',
    );
    print(applicants);
    setState(() {
      this.applicants = applicants;
      allApplicants = applicants;
      isLoading = false;
    });
  }

  // Function for open database
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
  // end function

  // Function for search data from list
  void _searchApplicants(String query) async {
    if (query.isEmpty) {
      setState(() {
        isSearching = false;
        applicants = allApplicants;
      });
      return;
    }

    setState(() {
      isLoading = true;
    });

    final List<Map<String, dynamic>> searchResults = await _database.rawQuery(
      'SELECT * FROM applicants WHERE name LIKE ? OR cnic LIKE ?',
      ['%$query%', '%$query%'],
    );

    setState(() {
      isSearching = true;
      applicants = searchResults;
      isLoading = false;
    });
  }
  // end function

  // Init state function
  @override
  void initState() {
    super.initState();
    _initializeDatabase().then((_) {
      _retrieveApplicants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                autofocus: true,
                onChanged: (value) {
                  _searchApplicants(value);
                },
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: "Search...",
                  hintStyle:
                      TextStyle(color: Color.fromARGB(255, 128, 119, 119)),
                ),
              )
            : const Center(
                child: Text(
                  'Applicant List',
                  style: TextStyle(
                    color: Color(0xff0b7f7e),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
              });
            },
          ),
          // Event filter button for filter data
          PopupMenuButton<String>(
            onSelected: (String value) {
              // Handle the selection of the event filter
              setState(() {
                selectedEventFilter = value;
                if (selectedEventFilter == 'All') {
                  applicants = allApplicants;
                } else {
                  applicants = allApplicants
                      .where((applicant) =>
                          applicant['selectedEvent'] == selectedEventFilter)
                      .toList();
                }
              });
            },
            itemBuilder: (BuildContext context) {
              return ['All', 'Birth', 'Death', 'Marriage', 'Divorce']
                  .map((String event) {
                return PopupMenuItem<String>(
                  value: event,
                  child: Text(event),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : applicants.isEmpty
              ? const Center(
                  child: Text('Data not available'),
                )
              : ListView.builder(
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        title: Text(
                          applicant['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Text('${applicant['cnic']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Pending: ',
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              '${applicant['unpayFee']}',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          // moveon next screen and pass data of that applicant which is clicked
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: EditData(),
                              settings: RouteSettings(arguments: applicant),
                            ),
                          ).then((_) {
                            // after return from edit screen, refresh list
                            _retrieveApplicants();
                          });
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
