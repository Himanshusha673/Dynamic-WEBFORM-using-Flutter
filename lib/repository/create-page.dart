import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../models/create_model.dart';

// default rows that will be displayed
List<User> allUser = <User>[
  User(
      columnName: 'create_date',
      description: 'Contains Desc',
      datatype: 'DateTime',
      partition: false,
      pk: false,
      isNotNUll: false),
  User(
      columnName: 'update_date',
      description: 'Contains Desc',
      datatype: 'DateTime',
      partition: false,
      pk: false,
      isNotNUll: false),
  User(
      columnName: 'ein',
      description: 'Contains Desc',
      datatype: 'INT64',
      partition: false,
      pk: false,
      isNotNUll: false),
];

// User Class with some fields that is to be added into the list
class User {
  late String columnName;
  late String datatype;
  late String description;
  late dynamic partition;
  late dynamic isNotNUll;
  late dynamic pk;

  User(
      {required this.columnName,
      required this.description,
      required this.datatype,
      required this.partition,
      required this.isNotNUll,
      required this.pk});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      columnName: json["columnName"],
      datatype: json["datatype"],
      description: json["description"],
      isNotNUll: json["isNotNUll"],
      pk: json["pk"],
      partition: json["partition"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'columnName': columnName,
      'datatype': datatype,
      'description': description,
      'isNotNUll': isNotNUll,
      'pk': pk,
      'partition': partition
    };
  }

  User copy({
    String? columnName,
    String? datatype,
    String? description,
    bool? partition,
    bool? isNotNUll,
    bool? pk,
  }) =>
      User(
        columnName: columnName ?? this.columnName,
        datatype: datatype ?? this.datatype,
        description: description ?? this.description,
        isNotNUll: isNotNUll ?? this.isNotNUll,
        pk: pk ?? this.pk,
        partition: partition ?? this.partition,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          columnName == other.columnName &&
          datatype == other.datatype &&
          partition == other.partition &&
          isNotNUll == other.isNotNUll &&
          pk == other.pk;

//  factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       columnName: json["columnName"],
//       datatype: json["datatype"],
//       description: json["description"],
//        isNotNUll: json["isNotNUll"],
//         pk: json["pk"],
//         partition: json["partition"],
//     );
//   }

  // @override
  // int get hashcode =>
  //     columnName.hashCode ^
  //     datatype.hashCode ^
  //     partition.hashCode ^
  //     isNotNUll.hashCode ^
  //     pk.hashCode;

  // create a function to convert user to json mapping
}

class CreateTable extends StatelessWidget {
  const CreateTable({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const appTitle = 'Request to create table';

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
  /// all variables are defined here with the qsequence of their ui
  /// ////////////Schema Name/////////////
  String dataSetNameValue = 'consumers';
  final List<String> dataSetName = [
    'consumers',
    'service',
    'product',
    'customer_bill',
    'marketing_and_sales',
    'business_partner_and_supplier',
    'common_business_support',
    'colleague_data',
  ];

  // for Table Name///
  final TextEditingController _tableNameController = TextEditingController();

  ////Table Description//////////
  final TextEditingController _tableDescriptionController =
      TextEditingController();

  /// /// ////////////domainCategory/////////////
  String domainCategoryValue = 'billing';
  final List<String> domainCategory = ['billing', 'reimbursement'];

  /// /// ////////////consumptionCfu/////////////
  String consumptionCfuValue = 'consumer';
  final List<String> consumptionCfu = ['consumer', 'global', 'enterprise'];

  ////// /// ////////////consumptionCfu/////////////
  String lineOfBusinessValue = 'consumer';
  final List<String> lineOfBusiness = ['consumer', 'global', 'enterprise'];

  /// Business Justification
  final TextEditingController _BusinessJustController = TextEditingController();

  //requestorEmailController/////////////
  final TextEditingController _requestorEmailController =
      TextEditingController();

  //// for purge Date//////////
  bool issDateSelected = false;
  String selectedDate = " ";
  DateTime _date = DateTime.now();

  //critical data
  bool containsCriticalData = false;
  //////////////////////////////
  /////critical Tii data
  bool containsPTIData = false;

  /// ////EIN User who want to update////
  final TextEditingController _EinTableownController = TextEditingController();

  ////EIN User who want to update////
  final TextEditingController _tableOwnerNameController =
      TextEditingController();

  ///Requestors Comment/////
  final TextEditingController _requestorCommentController =
      TextEditingController();
  //////////////
  @override
  void dispose() {
    _tableNameController.dispose();
    _BusinessJustController.dispose();
    _tableDescriptionController.dispose();
    _requestorEmailController.dispose();
    _EinTableownController.dispose();
    _requestorEmailController.dispose();
    _tableOwnerNameController.dispose();
    _requestorCommentController.dispose();

    super.dispose();
  }

  ///Schmea variable////////////
  String? schema;
  bool defineYourSchema = true;

  final _formKey = GlobalKey<FormState>();

  bool isBrowse = false;
  // for schemaname dropdown

  Future<Null> _selectDate(BuildContext context) async {
    DateTime? _datePicker = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: DateTime(1947),
        lastDate: DateTime(2050));

    if (_datePicker != null && _datePicker != _date) {
      setState(() {
        _date = _datePicker;
        selectedDate = _date.toString().replaceRange(10, 23, "");
        print(selectedDate);

        issDateSelected = true;
      });
    }
  }

//To make Datatype editable
  Future editDataType(User editUser) async {
    String? selectedDataType;

    // Create a list of options for the dropdown menu
    List<DropdownMenuItem<String>> dataTypes = [
      const DropdownMenuItem(child: Text("INT64"), value: "INT64"),
      const DropdownMenuItem(child: Text("FLOAT64"), value: "FLOAT64"),
      const DropdownMenuItem(child: Text("STRING"), value: "STRING"),
    ];

    // Create a dialog box that displays the dropdown menu
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change DataType"),
          content: DropdownButton(
            value: selectedDataType,
            /*  items: dataTypes,
            onChanged: (value) {
              selectedDataType = value as String?;
            }, */
            items: selectedDataType == "STRING"
                ? dataTypes.where((data) => data.value != "DATETIME").toList()
                : dataTypes,
            onChanged: (value) {
              selectedDataType = value as String?;
            },
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() => allUser = allUser.map((user) {
                      final isEditorUser = user == editUser;
                      return isEditorUser
                          ? user.copy(datatype: selectedDataType)
                          : user;
                    }).toList());
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    //users = allUser;
    super.initState();
  }

  List<User> selectedUsers = [];

  onSelectedRow(bool selected, User user) {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

//to make columnname editable
  Future editColumnName(User editUser) async {
    final editedName = await showTextDialog(
      context,
      title: 'Change Column Name',
      value: editUser.columnName,
    );

    setState(
      () => allUser = allUser.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(columnName: editedName) : user;
      }).toList(),
    );
  }

//to make description editable
  Future editdesc(User editUser) async {
    final editedName = await showTextDialog(
      context,
      title: 'Give description',
      value: editUser.description,
    );

    setState(
      () => allUser = allUser.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(description: editedName) : user;
      }).toList(),
    );
  }

  Future<T?> showTextDialog<T>(BuildContext contex,
          {required String title, required String value}) =>
      showDialog<T>(
          context: context,
          builder: (context) => TextDialogWidget(
                title: title,
                value: value,
              ));

  //dataTable Body
  DataTable databody() {
    return DataTable(
      border: TableBorder.all(color: Colors.black),
      columns: [
        const DataColumn(
            label: Text('COLUMN_NAME'),
            numeric: false,
            tooltip: 'This is column Name'),
        const DataColumn(
            label: Text('DataType'),
            numeric: false,
            tooltip: 'This is DataType '),
        const DataColumn(
            label: Text('Partition'),
            numeric: true,
            tooltip: 'This is partion'),
        const DataColumn(
            label: Text('NotNull'), numeric: false, tooltip: 'This is NotNull'),
        const DataColumn(
            label: Text('Unique Values '),
            numeric: false,
            tooltip: 'This is Unique vlaues'),
        // DataColumn(
        //     label: Text('Index'), numeric: true, tooltip: 'This is  Index'),
        const DataColumn(
            label: Text('Description'),
            numeric: true,
            tooltip: 'This is  Description'),
      ],
      rows: allUser
          .map((user) => DataRow(
                  selected: user == allUser[0] || user == allUser[1]
                      ? false
                      : selectedUsers.contains(user),
                  onSelectChanged: (value) {
                    if (user == allUser[0] || user == allUser[1]) {
                      print("nothing happened");
                    } else {
                      onSelectedRow(value!, user);
                    }
                  },
                  cells: [
                    DataCell(
                      Text(user.columnName),
                      showEditIcon: user == allUser[0] || user == allUser[1]
                          ? false
                          : true,
                      onTap: () {
                        if (user == allUser[0] || user == allUser[1]) {
                          print("nothing happened");
                        } else {
                          editColumnName(user);
                        }
                      },
                    ),
                    DataCell(Text(user.datatype),
                        showEditIcon: user == allUser[0] || user == allUser[1]
                            ? false
                            : true, onTap: () {
                      if (user == allUser[0] || user == allUser[1]) {
                        print("nothing happened");
                      } else {
                        editDataType(user);
                      }
                    }),
                    DataCell(
                      Checkbox(
                        value: user.partition,
                        onChanged: (value) {
                          setState(() {
                            user.partition = value!;
                          });
                        },
                        checkColor: Colors.black,
                        focusColor: Colors.red,
                        hoverColor: Colors.green,
                        activeColor: Colors.white,
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: user.isNotNUll,
                        onChanged: (value) {
                          setState(() {
                            user.isNotNUll = value!;
                          });
                        },
                        checkColor: Colors.black,
                        focusColor: Colors.red,
                        hoverColor: Colors.green,
                        activeColor: Colors.white,
                      ),
                    ),
                    DataCell(
                      Checkbox(
                        value: user.pk,
                        onChanged: (value) {
                          setState(() {
                            user.pk = value!;
                          });
                        },
                        checkColor: Colors.black,
                        focusColor: Colors.red,
                        hoverColor: Colors.green,
                        activeColor: Colors.white,
                      ),
                    ),
                    DataCell(
                      Text(user.description),
                      showEditIcon: true,
                      onTap: () {
                        editdesc(user);
                      },
                    )
                  ]))
          .toList(),
    );
  }

  Future doSubmit(
    String tableName,
    String tableDesc,
    String businessJust,
    String dataSetName,
    String lineOfbusiness,
    String domainCategory,
    String consumptionCfu,
    String selectedDate,
    bool containsCriticalData,
    bool containsPiiData,
    String requestrPerEmail,
    String tableOwnerein,
    String tableOwnername,
    String requestComment,
    List<User> allUser,
  ) async {
    // final CreatePage createPage = CreatePage(
    //     table_name: tableName,
    //     table_description: tableDesc,
    //     business_justification: businessJust,
    //     dataset_name: dataSetNameValue,
    //     line_of_business: lineOfBusinessValue,
    //     domain_category: domainCategoryValue,
    //     consumption_cfu: consumptionCfuValue,
    //     expiration_date: selectedDate,
    //     critical_data: containsCriticalData,
    //     pii_data: containsPiiData,
    //     requestor_performed_email: requestrPerEmail,
    //     table_owner_ein: tableOwnerein,
    //     table_owner_name: tableOwnername,
    //     requestor_comment: requestComment,
    //     schema: allUser);
    // //to check value just printing
    // debugPrint(createPage.business_justification);
    // debugPrint(createPage.consumption_cfu);
    // debugPrint(createPage.dataset_name);
    // debugPrint(createPage.domain_category);
    // debugPrint(createPage.expiration_date);
    // debugPrint(createPage.line_of_business);
    // debugPrint(createPage.requestor_comment);
    // debugPrint(createPage.requestor_performed_email);
    // debugPrint(createPage.table_description);
    // debugPrint(createPage.table_name);
    // debugPrint(createPage.table_owner_ein);
    // debugPrint(createPage.table_owner_name);
    // debugPrint(createPage.critical_data.toString());
    // debugPrint(createPage.pii_data.toString());
    // debugPrint(createPage.schema[0].columnName);
    // debugPrint(createPage.schema[1].columnName);
    // debugPrint(createPage.schema[2].columnName);

    // try {
    //   await ApiServices().apiPost(createPage);
    // } catch (e) {}
  }

  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<User> temp = [];
        temp.addAll(selectedUsers);
        for (User user in temp) {
          allUser.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    final double size = MediaQuery.of(context).size.width * 0.2;
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
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
                      child: Text('Data Set Name',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                              selectedItem: dataSetNameValue,
                              searchFieldProps: const TextFieldProps(
                                  cursorColor: Colors.blue),
                              items: dataSetName,
                              showSearchBox: true,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Select Dataset",
                                hintText: "Select Dataset",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dataSetNameValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Table Name',
                          textAlign: TextAlign.left,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tableNameController,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Enter Table name',
                            ),
                            // The validator receives the text that the user has entered.
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Empty Text!!!Please fill';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _tableDescriptionController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Enter Table Description',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _BusinessJustController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Business Justification',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Domain Category',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                              selectedItem: domainCategoryValue,
                              searchFieldProps: const TextFieldProps(
                                  cursorColor: Colors.blue),
                              items: domainCategory,
                              showSearchBox: true,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Select DomainCategory",
                                hintText: "Schema DomainValue",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  domainCategoryValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Consumption CFU',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                              selectedItem: consumptionCfuValue,
                              searchFieldProps: const TextFieldProps(
                                  cursorColor: Colors.blue),
                              items: consumptionCfu,
                              showSearchBox: true,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Select CFU Value",
                                hintText: "Schema cfu",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  consumptionCfuValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text('Line Of Business [CFU]',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: DropdownSearch<String>(
                              selectedItem: lineOfBusinessValue,
                              searchFieldProps: const TextFieldProps(
                                  cursorColor: Colors.blue),
                              items: lineOfBusiness,
                              showSearchBox: true,
                              dropdownSearchDecoration: const InputDecoration(
                                labelText: "Select LineOfBusiness Value",
                                hintText: "Schema Line of Business",
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  lineOfBusinessValue = newValue!;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(children: [
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                              border: const UnderlineInputBorder(),
                              hintText: selectedDate,
                              labelText: issDateSelected
                                  ? selectedDate
                                  : 'Select a Purge Date [ Expiration Date ] '),
                          onTap: () {
                            setState(() {
                              _selectDate(context);
                            });
                          },
                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Empty Text!!!Please fill';
                            }
                            return null;
                          },
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _EinTableownController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'EIN of table owner',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Contains Critical Data'),
                        const SizedBox(
                          width: 20,
                        ),
                        Tooltip(
                          message:
                              "Business Critical Data Cannot be loaded and altered",
                          child: ToggleSwitch(
                            minWidth: 90.0,
                            cornerRadius: 20.0,
                            borderWidth: 2.0,
                            activeBgColor: containsCriticalData
                                ? [Colors.blue]
                                : [Colors.grey],
                            activeFgColor: Colors.white,
                            inactiveBgColor: containsCriticalData
                                ? Colors.grey
                                : Colors.blue,
                            inactiveFgColor: Colors.white,
                            initialLabelIndex: 0,
                            totalSwitches: 2,
                            animate: false,
                            labels: [
                              'Yes',
                              'No',
                            ],
                            onToggle: (index) {
                              setState(() {
                                containsCriticalData = !containsCriticalData;
                                print(containsCriticalData);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text('Contains PII Data'),
                        const SizedBox(
                          width: 20,
                        ),
                        ToggleSwitch(
                          minWidth: 90.0,
                          cornerRadius: 20.0,
                          borderWidth: 2.0,
                          activeBgColor:
                              containsPTIData ? [Colors.blue] : [Colors.grey],
                          activeFgColor: Colors.white,
                          inactiveBgColor:
                              containsPTIData ? Colors.grey : Colors.blue,
                          inactiveFgColor: Colors.white,
                          initialLabelIndex: 0,
                          totalSwitches: 2,
                          animate: false,
                          labels: [
                            'Yes',
                            'No',
                          ],
                          onToggle: (index) {
                            setState(() {
                              containsPTIData = !containsPTIData;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _requestorEmailController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Requestor Performed email',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _tableOwnerNameController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Table owner name',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      maxLines: 6,
                      controller: _requestorCommentController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        labelText: 'Requestors Comment',
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty Text!!!Please fill';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
              const Divider(),
              const Text("Define your schema",
                  style: const TextStyle(fontSize: 18)),
              const Divider(),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Expanded(
                  child: RadioListTile(
                    toggleable: true,
                    selected: defineYourSchema,
                    title: const Text("Define your Own Schema"),
                    value: defineYourSchema ? defineYourSchema : "own",
                    groupValue: defineYourSchema,
                    onChanged: (value) {
                      setState(() {
                        defineYourSchema = true;
                        schema = value.toString();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    toggleable: defineYourSchema,
                    selected: !defineYourSchema,
                    title: const Text("Load Schema using File"),
                    value: defineYourSchema ? "Load" : defineYourSchema,
                    groupValue: defineYourSchema,
                    onChanged: (value) {
                      setState(() {
                        defineYourSchema = false;
                        schema = value.toString();
                      });
                    },
                  ),
                ),
              ]),
              const SizedBox(
                height: 20,
              ),
              defineYourSchema ? databody() : const LoadSchemaFile(),
              //databody(),
              defineYourSchema
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: OutlinedButton(
                                child: const Text('Add Column'),
                                onPressed: () {
                                  setState(() {
                                    allUser.add(User(
                                        columnName: " ",
                                        description: "",
                                        datatype: "null",
                                        partition: false,
                                        isNotNUll: false,
                                        pk: false));
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: OutlinedButton(
                                child: Text(
                                    'DELETE SELECTED ${selectedUsers.length}'),
                                onPressed: () {
                                  deleteSelected();
                                },
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ElevatedButton(
                              child: const Text('Submit'),
                              onPressed: () {
                                doSubmit(
                                  _tableNameController.text,
                                  _tableDescriptionController.text,
                                  _BusinessJustController.text,
                                  dataSetNameValue,
                                  lineOfBusinessValue,
                                  domainCategoryValue,
                                  consumptionCfuValue,
                                  selectedDate,
                                  containsCriticalData,
                                  containsPTIData,
                                  _requestorEmailController.text,
                                  _EinTableownController.text,
                                  _tableOwnerNameController.text,
                                  _requestorCommentController.text,
                                  allUser,
                                );
                                if (_formKey.currentState!.validate()) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text('Successfully Created'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 40.0,
                                            ),
                                            const SizedBox(height: 16.0),
                                            const Text(
                                                'Your submission was successful.'),
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
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('NOT SUBMITED'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.error,
                                              color: Colors.red,
                                              size: 40.0,
                                            ),
                                            const SizedBox(height: 16.0),
                                            const Text(
                                                'Please fill all parameters'),
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
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          child: const Text('Submit'),
                          onPressed: () {
                            doSubmit(
                                _tableNameController.text,
                                _tableDescriptionController.text,
                                _BusinessJustController.text,
                                dataSetNameValue,
                                lineOfBusinessValue,
                                domainCategoryValue,
                                consumptionCfuValue,
                                selectedDate,
                                containsCriticalData,
                                containsPTIData,
                                _requestorEmailController.text,
                                _EinTableownController.text,
                                _tableOwnerNameController.text,
                                _requestorCommentController.text,
                                allUser);
                          },
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}

// To Browse file
class LoadSchemaFile extends StatefulWidget {
  const LoadSchemaFile({Key? key}) : super(key: key);

  @override
  State<LoadSchemaFile> createState() => _LoadSchemaFileState();
}

class _LoadSchemaFileState extends State<LoadSchemaFile> {
  final List<String> fileType = ['csv', 'xlsx', 'parquet'];
  String dropDownValue = 'csv';
  bool isBrowse = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Browse the file to Upload ',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    border: Border.all(), color: Colors.black.withOpacity(0.2)),
                height: 25,
                child: isBrowse
                    ? const Text('Select a file To Upload')
                    : const Text('addres or file name which user can select'),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isBrowse = !isBrowse;
                    });
                  },
                  child: const Text('Browse')),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Text("Please Select The file type "),
              const SizedBox(
                width: 10,
              ),
              DropdownButton(
                  value: dropDownValue,
                  items: fileType.map((String item) {
                    return DropdownMenuItem(
                      child: Text(item),
                      value: item,
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      dropDownValue = newValue!;
                    });
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

// for tables
class DefineSchema extends StatefulWidget {
  const DefineSchema({Key? key}) : super(key: key);

  @override
  State<DefineSchema> createState() => _DefineSchemaState();
}

class _DefineSchemaState extends State<DefineSchema> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Table(border: TableBorder.all(), children: [
        buildRow([
          'COLUMN NAME',
          'DATA TYPE',
          'Size',
          'NotNull',
          'Pk',
          'Index',
          'Description'
        ], isHeader: true),
        buildRow(['1', 'int', '20', 'yes', 'no', '0', 'this is first row']),
        buildRow(['1', 'int', '20', 'yes', 'no', '0', 'this is first row']),
        buildRow(['1', 'int', '20', 'yes', 'no', '0', 'this is first row']),
        buildRow(['1', 'int', '20', 'yes', 'no', '0', 'this is first row']),
        buildRow(['1', 'int', '20', 'yes', 'no', '0', 'this is first row']),
      ]),
    );
  }

  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
        children: cells.map((cells) {
          final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 10);

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Center(
                child: Text(
              cells,
              style: style,
            )),
          );
        }).toList(),
      );
}

class TextDialogWidget extends StatefulWidget {
  final String title;
  final String value;
  const TextDialogWidget({required this.title, required this.value});

  @override
  State<TextDialogWidget> createState() => _TextDialogWidgetState();
}

class _TextDialogWidgetState extends State<TextDialogWidget> {
  late TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TextEditingController(text: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Done')),
      ],
    );
  }
}
