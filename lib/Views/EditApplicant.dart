import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class EditData extends StatefulWidget {
  EditData({super.key});

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  // Variables for store data
  late BuildContext _context;
  late Map<String, dynamic> originalData;
  late Map<String, dynamic> editedData;
  late TextEditingController nameController;
  late TextEditingController cnicController;
  late TextEditingController contactController;
  late TextEditingController addressController;
  late TextEditingController dateController;
  late TextEditingController totalFeeController;
  late TextEditingController payFeeController;
  late TextEditingController unpayFeeController;
  bool isEditMode = false;
  // Database variable
  late Database _database;
  // Function to convert the first letter of a string to lowercase
  String firstLetterToLowerCase(String input) {
    if (input.isEmpty) return input;
    return input[0].toLowerCase() + input.substring(1);
  }

// Function for Update applicant details in database and show in list page
  Future<void> _updateApplicant(BuildContext context) async {
    await _database.update(
      'applicants',
      {
        'name': editedData['name'],
        'cnic': editedData['cnic'],
        'contactNo': editedData['contactNo'],
        'address': editedData['address'],
        'date': editedData['date'],
        'totalFee': editedData['totalFee'],
        'payFee': editedData['payFee'],
        'unpayFee': editedData['unpayFee'],
      },
      where: 'id = ?',
      whereArgs: [originalData['id']],
    );
    Navigator.pop(context);
    // snackBar for show message after update data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(
          child: Text(
            "Data Updated Successfully!",
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

  // Function for delete applicant details in database and show in list page
  Future<void> _deleteApplicant() async {
    await _database.delete(
      'applicants',
      where: 'id = ?',
      whereArgs: [originalData['id']],
    );
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

  // Function for show alert dialog for delete applicant details
  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Applicant'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this applicant?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                _deleteApplicant();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

// This snippet shows the implementation of the didChangeDependencies method:

  // get data which is pass from list page
  @override
  Widget build(BuildContext context) {
    _context = context;

    originalData =
        ModalRoute.of(_context)!.settings.arguments as Map<String, dynamic>;
    editedData = Map.from(originalData);
    nameController = TextEditingController(text: originalData['name']);
    cnicController = TextEditingController(text: originalData['cnic']);
    contactController = TextEditingController(text: originalData['contactNo']);
    addressController = TextEditingController(text: originalData['address']);
    dateController = TextEditingController(text: originalData['date']);
    totalFeeController =
        TextEditingController(text: originalData['totalFee'].toString());
    payFeeController =
        TextEditingController(text: originalData['payFee'].toString());
    unpayFeeController =
        TextEditingController(text: originalData['unpayFee'].toString());

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Edit Detalis',
            style: TextStyle(
              color: Color(0xff0b7f7e),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              print(originalData);
              _showDeleteDialog(context);
            },
            icon: const Icon(Icons.delete, color: Colors.red),
          ),
        ],
      ),
      // Button for edit data
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isEditMode) {
            editedData['name'] = nameController.text;
            editedData['cnic'] = cnicController.text;
            editedData['contactNo'] = contactController.text;
            editedData['address'] = addressController.text;
            editedData['date'] = dateController.text;
            editedData['totalFee'] = totalFeeController.text;
            editedData['payFee'] = payFeeController.text;
            editedData['unpayFee'] = unpayFeeController.text;

            _updateApplicant(context);
          }
          setState(() {
            isEditMode = !isEditMode;
          });
        },
        child: Icon(isEditMode ? Icons.check_rounded : Icons.edit),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // show all data of applicant in saprate text field
              const SizedBox(height: 10),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xff0b7f7e),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Text(
                      '${originalData['selectedEvent']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              buildTextField('Name', nameController),
              buildTextField('Cnic', cnicController),
              buildTextField('ContactNo', contactController),
              buildTextField('Address', addressController),
              buildTextField('Date', dateController),
              buildTextField('TotalFee', totalFeeController),
              buildTextField('PayFee', payFeeController),
              buildTextField('UnpayFee', unpayFeeController),
            ],
          ),
        ),
      ),
    );
  }

// This snippet shows the implementation of the buildTextField method:
  Widget buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          '$label:',
          style: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        isEditMode
            ? TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              )
            : Text(
                '${editedData[firstLetterToLowerCase(label)]}',
                style: const TextStyle(
                  color: Color(0xff0b7f7e),
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
        const Divider(),
      ],
    );
  }
}
