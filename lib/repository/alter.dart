import 'package:flutter/material.dart';
import 'package:flutter_application_1/provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:provider/provider.dart';

import '../models/create_model.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
// old schema data is Here
  MyData? copyOfOldSchema;

  Future postData(String tableName, String dataSetName,
      List<ColumnFileds> updatedSchema) async {
    try {
      MyData data = MyData(schema: updatedSchema);
      print(copyOfOldSchema!.schema.map((e) => e.columnDescription));
      // print(tableName);
      // print(dataSetName);

      // print(data.schema.map((e) => e.columnName));

      var dataBody = data.toJson();
// posting new Chnages on NewSchema
      var response = await http
          .post(Uri.parse('http://127.0.0.1:5000/new_schema'), body: dataBody);

// posting Old Schema to the Api NewSchema
      var oldSchemaData = copyOfOldSchema!.toJson();
      var responseAfterOld = await http.post(
          Uri.parse('http://127.0.0.1:5000/new_schema'),
          body: oldSchemaData);

      print(response.statusCode);
      print(responseAfterOld.statusCode);
    } catch (e) {}
  }

// for schemaname dropdown
  final List<String> dataSetName = [
    'Marketing and Sales',
    'Service',
    'Product',
    'Customer Bill',
    'Business Partner and Supplier',
    'Common Business Supoort',
    'Colleague Data'
  ];
  bool isShowTable = false;
  String dropDownValue = 'Product';

  late List<TextEditingController> _textControllers;

  final List<String> tableName = ['MRD', 'LOG_TABLE', 'BILLING'];
  String dropDownValueTbaleName = 'LOG_TABLE';

  bool isLoading = false;
  List<ColumnFileds> listOfData = [];

  List<ColumnFileds> selectedUsers = [];

  final List<String> modeValuelist = ['NULLABLE', 'Required', 'Repeated'];
  String modeDropValue = 'NULLABLE';

  onSelectedRow(bool selected, ColumnFileds user) {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  Future editColumnName(ColumnFileds editUser) async {
    final editedName = await showTextDialog(
      context,
      title: 'Change Column Name',
      value: editUser.columnName,
    );

    setState(
      () => listOfData = listOfData.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(columnName: editedName) : user;
      }).toList(),
    );
  }

  Future editdesc(ColumnFileds editUser) async {
    final editedName = await showTextDialog(
      context,
      title: 'Give description',
      value: editUser.columnDescription,
    );
    setState(
      () => listOfData = listOfData.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(columnDescription: editedName) : user;
      }).toList(),
    );
  }

  Future editMode(ColumnFileds editUser, String modeValue) async {
    setState(
      () => listOfData = listOfData.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(mode: modeValue) : user;
      }).toList(),
    );
  }

  Future editDataType(ColumnFileds editUser) async {
    final editedName = await showTextDialog(
      context,
      title: 'Change DataType',
      value: editUser.dataType,
    );

    setState(
      () => listOfData = listOfData.map((user) {
        final isEditorUser = user == editUser;

        return isEditorUser ? user.copy(datatype: editedName) : user;
      }).toList(),
    );
  }

  @override
  // void didChangeDependencies() {

  //   super.didChangeDependencies();
  // }

  Future<T?> showTextDialog<T>(
    BuildContext contex, {
    required String title,
    required String value,
  }) =>
      showDialog<T>(
          context: context,
          builder: (context) => TextDialogWidget(
                title: title,
                value: value,
              ));

  deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<ColumnFileds> temp = [];
        temp.addAll(selectedUsers);
        for (ColumnFileds user in temp) {
          listOfData.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }

  void resetSchema() {}

  @override
  // void initState() {
  //   UserProvider provider = Provider.of<UserProvider>(context, listen: false);
  //   provider.getData(context);
  //   copyOfOldSchema = provider.data;

  //   listOfData = provider.data!.schema;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
/////////////////////////////////////////////////////
    ///
    ///
    ///
    ///
    ///
    UserProvider provider = Provider.of<UserProvider>(context);

    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  right: (MediaQuery.of(context).size.width * 0.4)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("random",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Colors.greenAccent,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            )),
                        disabledHint: Text("Can't select"),
                        value: dropDownValue,
                        items: dataSetName.map((String item) {
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.only(
                  right: (MediaQuery.of(context).size.width / 2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text("ramdom",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: DropdownButtonFormField(
                        borderRadius: BorderRadius.circular(20),
                        dropdownColor: Colors.greenAccent,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey,
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            )),
                        value: dropDownValueTbaleName,
                        items: tableName.map((String item) {
                          return DropdownMenuItem(
                            child: Text(item),
                            value: item,
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropDownValueTbaleName = newValue!;
                          });
                        }),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: OutlinedButton(
                  child: Text('Populate Table Info'),
                  onPressed: () {
                    UserProvider provider =
                        Provider.of<UserProvider>(context, listen: false);
                    provider.getData(context);
                    copyOfOldSchema = provider.data;
                    setState(() {
                      listOfData = provider.data!.schema;
                      isShowTable = true;
                    });
                  } //_fetchOldSchema,
                  ),
            ),
            const SizedBox(
              height: 25,
            ),
            //  _buildOldSchemaWidget(),
            const SizedBox(
              height: 25,
            ),
            //////////////////////////////////////////
            ////////////////////////
            //////////////
            isShowTable
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                        'Please Alter the changes below which you want to change ',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  )
                : Container(),
            const SizedBox(
              height: 25,
            ),
            isShowTable
                ? DataTable(
                    border: TableBorder.all(color: Colors.black),
                    columns: [
                      DataColumn(
                          label: Text('COLUMN_Id'),
                          numeric: true,
                          tooltip: 'This is column Name'),
                      DataColumn(
                          label: Text('COLUMN_NAME'),
                          numeric: false,
                          tooltip: 'This is column Name'),
                      DataColumn(
                          label: Text('DataType'),
                          numeric: false,
                          tooltip: 'This is DataType '),
                      DataColumn(
                          label: Text('Mode'),
                          numeric: false,
                          tooltip: 'This is NotNull'),
                      DataColumn(
                          label: Text('Description'),
                          numeric: true,
                          tooltip: 'This is  Description'),
                    ],
                    //rows: [],
                    rows: listOfData
                        .map((user) => DataRow(
                                selected: selectedUsers.contains(user),
                                onSelectChanged: (value) {
                                  onSelectedRow(value!, user);
                                },
                                cells: [
                                  DataCell(
                                    Text(user.columnId.toString()),
                                  ),
                                  DataCell(
                                    Text(user.columnName),
                                    showEditIcon: true,
                                    onTap: () {
                                      editColumnName(user);
                                    },
                                  ),
                                  DataCell(
                                    Text(user.dataType),
                                    showEditIcon: true,
                                    onTap: () {
                                      editDataType(user);
                                    },
                                  ),
                                  DataCell(
                                    DropdownButtonFormField(
                                        borderRadius: BorderRadius.circular(20),
                                        dropdownColor: Colors.white,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                        ),
                                        disabledHint: Text("Can't select"),
                                        value: user.mode,
                                        items: modeValuelist.map((String item) {
                                          return DropdownMenuItem(
                                            child: Text(item),
                                            value: item,
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          editMode(user, newValue!);
                                        }),
                                  ),
                                  DataCell(
                                    Text(user.columnDescription),
                                    showEditIcon: true,
                                    onTap: () {
                                      editdesc(user);
                                    },
                                  ),
                                ]))
                        .toList(),
                  )
                : Container(),

            const SizedBox(
              height: 25,
            ),
            isShowTable
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          child: Text('Add Column'),
                          onPressed: () {
                            setState(() {
                              listOfData.add(ColumnFileds(
                                  columnName: "",
                                  dataType: "",
                                  columnDescription: "",
                                  mode: "Nullable",
                                  columnId: listOfData.length + 1));
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          child:
                              Text('DELETE SELECTED ${selectedUsers.length}'),
                          onPressed: () {
                            deleteSelected();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(20.0),
                        child: OutlinedButton(
                          child: Text('Reset Schema'),
                          onPressed: () {
                            initState();
                          },
                        ),
                      ),
                    ],
                  )
                : Container(),
            isShowTable
                ? Padding(
                    padding: EdgeInsets.all(20.0),
                    child: ElevatedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        postData(
                            dropDownValue, dropDownValueTbaleName, listOfData);
                      },
                    ),
                  )
                : Container()
          ],
        ),
      ),
    )));
  }
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
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: Text('Done')),
      ],
    );
  }
}
