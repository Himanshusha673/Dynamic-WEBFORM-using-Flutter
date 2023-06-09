import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/create_model.dart';

class UserProvider extends ChangeNotifier {
  MyData? data;
  Future getData(context) async {
    try {
      var response = await http.get(
        Uri.parse('http://127.0.0.1:5000/old_schema'),
      );
      log(response.body);
      debugPrint("the value${response.statusCode.toString()}");
      if (response.statusCode == 200) {
        var val = response.body;

        log(val);

        // data = MyData.fromJson(jsonDecode(val));

        if (kDebugMode) {
          print("Here in proider");
        }
      } else {
        throw Exception('Failed to fetch old schema');
      }
    } catch (e) {
      log(e.toString());
    }

    this.notifyListeners();
  }
}
