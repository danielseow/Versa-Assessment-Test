import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BreweriesListsProvider extends ChangeNotifier {
  List breweriesLists = [];
  List favBreweriesLists = [];

  List getBreweriesLists() => breweriesLists;
  List getFavBreweriesLists() => favBreweriesLists;

  Future<List> getBreweriesListFromServer(int page) async {
    final url = Uri.parse("https://api.openbrewerydb.org/breweries?page=$page");
    try {
      final response = await http.get(url).timeout(const Duration(seconds: 30));
      final result = json.decode(response.body);
      // Error or Server issue
      if (response.statusCode != 200) {
        return ["error"];
      }
      breweriesLists.addAll(result);
      notifyListeners();

      return result;
    } on TimeoutException catch (_) {
      breweriesLists = ["timeout"];
      notifyListeners();

      return ["timeout"];
    } on SocketException catch (_) {
      breweriesLists = ["internet"];
      notifyListeners();

      log("Internet issue");
      return ["internet"];
    }
  }

  void updateBreweriesLists(List value) {
    breweriesLists = value;
    notifyListeners();
  }
  void addFavBreweriesLists(Map value) {
    favBreweriesLists.add(value);
    // notifyListeners();
  }

   void removeFavBreweriesLists(Map value) {
    favBreweriesLists.remove(value);
    notifyListeners();
  }

  bool checkFavContainBrewery(int index){    
    return favBreweriesLists.contains(breweriesLists[index]);
  }
}
