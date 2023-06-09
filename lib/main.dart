import 'package:flutter/material.dart';

import 'package:flutter_application_1/repository/alter.dart';
import 'package:flutter_application_1/repository/create-page.dart';
import 'package:flutter_application_1/repository/rename-page%20(3)%20(2).dart';
import 'package:provider/provider.dart';

import 'provider/provider.dart';

void main() {
  runApp(const MyApp());
}

// User Class with some fields that is to be added into the list

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        body: ChangeNotifierProvider<UserProvider>(
            create: (context) => UserProvider(),
            child: Consumer<UserProvider>(builder: (context, provider, child) {
              if (provider.data == null) {
                //provider.getData(context);
                return RenamePage();
              } else
                return RenamePage();
            })),
      ),
    );
  }
}
