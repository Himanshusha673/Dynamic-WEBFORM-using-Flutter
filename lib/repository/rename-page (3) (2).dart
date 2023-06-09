import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class RenamePage extends StatelessWidget {
  const RenamePage({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Request to Rename table';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  String? schema;
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String bearerToken = globals.token;
  final schemaController = TextEditingController();
  final tableController = TextEditingController();
  final newname = TextEditingController();
  final List<String> schemaName = [
    'consumers',
    'service',
    'product',
    'customer_bill',
    'marketing_and_sales',
    'business_partner_and_supplier',
    'common_business_support',
    'colleague_data',
  ];
  String dropDownValue = 'consumers';

  // for table name dropdwn
  List<String> tableName = [''];
  String dropDownValueTbaleName = '';

  void RenameSubmitData(String json_body) {
    http
        .patch(
            Uri.parse(
                "https://mrd-service2-53tlfuoihq-nw.a.run.app/renameTable"),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $bearerToken'
            },
            body: json_body)
        .then((response) {
      if (response.statusCode == 200) {
        print('Registration successful!');
      } else {
        print('An error occurred: ${response.body}');
      }
    }).catchError((error) {
      print('Request failed: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final double size = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(left: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20, 20, size / 2, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Data set Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: dropDownValue,
                              items: schemaName.map((String item) {
                                return DropdownMenuItem(
                                  child: Text(item),
                                  value: item,
                                );
                              }).toList(),
                              onChanged: (String? newValue) async {
                                setState(() {
                                  dropDownValue = newValue!;
                                });
                                // Call the Flask API to get values for the second drop-down
                                await http.get(
                                  Uri.parse(
                                      'https://mrd-service2-53tlfuoihq-nw.a.run.app/listTables?dataset_name=$newValue'),
                                  headers: {
                                    'Content-Type': 'application/json',
                                    'Authorization': 'Bearer $bearerToken',
                                  },
                                ).then((response) {
                                  setState(() {
                                    tableName = json
                                        .decode(response.body)['result']
                                        .cast<String>();
                                    print(json
                                        .decode(response.body)['result']
                                        .cast<String>());
                                  });
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: const Text('Table Name',
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownButton(
                              isExpanded: true,
                              value: dropDownValueTbaleName.isNotEmpty
                                  ? dropDownValueTbaleName
                                  : null,
                              items: tableName.map((value) {
                                return DropdownMenuItem<String>(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  dropDownValueTbaleName = value!;
                                });
                              }),
                        ),
                        SizedBox(width: size / 10),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter New table name ',
                      ),

                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'new name  cannot be empty';
                        }
                        return null;
                      },
                      controller: newname,
                    ),
                    // Add some space between the text field and button
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Check if the table name already exists in the dropdown items
                            bool tableExists = tableName.contains(newname.text);

                            final scaffoldMessenger =
                                ScaffoldMessenger.of(context);
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  // title: const Text('NOT SUBMITED'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      tableExists
                                          ? Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 40.0,
                                            )
                                          : Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 40.0,
                                            ),
                                      const SizedBox(height: 16.0),
                                      Text(tableExists
                                          ? 'Table name already exists'
                                          : 'Table name does not exist'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text('OK'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            // scaffoldMessenger.showSnackBar(
                            //   SnackBar(
                            //     content: Text(tableExists
                            //         ? 'Table name already exists'
                            //         : 'Table name does not exist'),
                            //   ),
                            // );
                          }
                        },
                        child: Text('Check if table name already exists'),
                      ),
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final scaffoldMessenger = ScaffoldMessenger.of(context);
                        final bool? shouldDelete = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                'Are you sure you want to rename the table?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // create a map with the text field values
                                    final data = {
                                      "table_ref":
                                          "$dropDownValue.$dropDownValueTbaleName",
                                      "new_table_name": newname.text,
                                    };
                                    // convert the map to a JSON object
                                    final jsonData = jsonEncode(data);
                                    RenameSubmitData(jsonData);
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: const Text('Rename'),
                              ),
                            ],
                          ),
                        );

                        if (shouldDelete == true) {
                          scaffoldMessenger.showSnackBar(
                            SnackBar(
                              content:
                                  const Text('Table successfully renamed!'),
                            ),
                          );
                        }
                      },
                      child: const Text('Rename'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
