// ignore_for_file: unnecessary_brace_in_string_interps, file_names, unused_import, avoid_print, unused_local_variable

import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:io';

import 'UserDataModel.dart';
import 'CardContentModel.dart';
import 'CardPrivateContentModel.dart';
import 'WordsDataModel.dart';
import 'Main.dart';
import 'RefreshDataModel.dart';

var responseStatusCode = 200;

String access = "";
String refresh = "";

String username = "";
String email = "";
String avatar = "";
String language = "";

/*POST ЗАПРОС ДЛЯ РЕГИСТРАЦИИ*/
Future<int> postRegData(String username, String password, String email) async {
  final url = Uri.parse('https://octodevserver.duckdns.org:8080/register');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'password': password,
    'email': email,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Request postRegData success: ${response.statusCode}.');
    responseStatusCode = response.statusCode;

    return responseStatusCode;
  } else {
    print('Request postRegData failed with status: ${response.statusCode}.');
    responseStatusCode = response.statusCode;

    return responseStatusCode;
  }
}

/*POST ЗАПРОС ДЛЯ АВТОРИЗАЦИИ*/
Future<int> postAuthData(String username, String password) async {
  final url = Uri.parse('https://octodevserver.duckdns.org:8080/auth');
  final headers = {'Content-Type': 'application/json'};
  final body = json.encode({
    'username': username,
    'password': password,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    final data = json.decode(response.body);

    final result = refreshDataModelFromJson(data);

    access = result.access;
    refresh = result.refresh;
    print('Request postAuthData result.access success: ${result.access}.');
    print('Request postAuthData access success: ${access}.');
    print('Request postAuthData result.refresh success: ${result.refresh}.');
    print('Request postAuthData refresh success: ${refresh}.');

    refreshTokenLoop(refresh);
    getUserData();
    responseStatusCode = response.statusCode;
    return responseStatusCode;
  } else {
    print('Request postAuthData failed with status: ${response.statusCode}.');
    return response.statusCode;
  }
}

/*POST ЗАПРОС ДЛЯ Refresh   */
Future<void> refreshTokenLoop(String refresh) async {
  while (true) {
    // wait for 10 minutes
    await Future.delayed(const Duration(minutes: 10));

    final url = Uri.parse('https://octodevserver.duckdns.org:8080/refresh');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'refresh': refresh,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      final result = refreshDataModelFromJson(data);

      access = result.access;
      refresh = result.refresh;
      // print('Request refreshTokenLoop result.access: ${result.access}.');
      //print('Request refreshTokenLoop access: ${access}.');
      // print('Request refreshTokenLoop result.refresh: ${result.refresh}.');
      //print('Request refreshTokenLoop refresh: ${refresh}.');

      print('Request refreshTokenLoop success: ${response.statusCode}.');
    } else {
      print(
          'Request refreshTokenLoop failed with status: ${response.statusCode}.');
    }
  }
}

/*POST ЗАПРОС ДЛЯ DictionarySearch*/
Future<List<CardContent>> postDictionarySearch(String searchTerm,
    String descLang, bool fullMatch, int pageNum, int pageSize) async {
  final url = Uri.parse('https://octodevserver.duckdns.org:8080/dictionary');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };
  final body = json.encode({
    "SearchTerm": searchTerm,
    "DescLang": descLang,
    "FullMatch": fullMatch,
    "PageNum": pageNum,
    "PageSize": pageSize,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print('Request postDictionarySearch success: ${response.statusCode}.');
    final data = json.decode(response.body);
    print("${data}");
    return data.map<CardContent>(CardContent.fromJson).toList();
  }
  return <CardContent>[];
}

/*POST ЗАПРОС ДЛЯ PrivateDictionarySearch*/
Future<List<CardPrivateContent>> postPrivateDictionarySearch(String searchTerm,
    String descLang, bool fullMatch, int pageNum, int pageSize) async {
  final url =
      Uri.parse('https://octodevserver.duckdns.org:8080/userDictionary');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };
  final body = json.encode({
    "SearchTerm": searchTerm,
    "DescLang": descLang,
    "FullMatch": fullMatch,
    "PageNum": pageNum,
    "PageSize": pageSize,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(
        'Request postPrivateDictionarySearch success: ${response.statusCode}.');
    final data = json.decode(response.body);
    print("${data}");
    return data.map<CardPrivateContent>(CardPrivateContent.fromJson).toList();
  }
  return <CardPrivateContent>[];
}

void postAddToPrivateDictionary(int pk) async {
  final url = Uri.parse(
      'https://octodevserver.duckdns.org:8080/addWordToUserDictionary');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };
  final body = json.encode({
    "Id": pk,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(
        'Request postAddToPrivateDictionary success: ${response.statusCode}.');
  }
}

void postDeleteFromPrivateDictionary(int pk) async {
  final url = Uri.parse(
      'https://octodevserver.duckdns.org:8080/deleteWordFromUserDictionary');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };
  final body = json.encode({
    "Id": pk,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(
        'Request postDeleteFromPrivateDictionary success: ${response.statusCode}.');
  }
}

Future<void> getUserData() async {
  final url = Uri.parse('https://octodevserver.duckdns.org:8080/userData');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };

  try {
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        username = data["Username"];
        email = data["Email"];
        avatar = data["Avatar"];
        language = data["Language"];

        print('Request getUserData success: ${username}.');
        print('Request getUserData success: ${email}.');
        print('Request getUserData success: ${avatar}.');
        print('Request getUserData success: ${language}.');

        print('Request getUserData success : ${response.statusCode}.');
      } else {
        print('Response body is empty.');
      }
    } else {
      print('Request getUserData failed with status: ${response.statusCode}.');
    }
  } catch (exception) {
    print('Exception occured: $exception');
  }
}

void postPrivateDictionaryWords(String searchTerm, String descLang,
    bool fullMatch, int pageNum, int pageSize) async {
  final url =
      Uri.parse('https://octodevserver.duckdns.org:8080/userDictionary');
  final headers = {
    'Authorization': 'Bearer $access',
    'Accept': 'application/json'
  };
  final body = json.encode({
    "SearchTerm": searchTerm,
    "DescLang": descLang,
    "FullMatch": fullMatch,
    "PageNum": pageNum,
    "PageSize": pageSize,
  });

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200 || response.statusCode == 201) {
    print(
        'Request postPrivateDictionaryWords success: ${response.statusCode}.');
    final data = json.decode(response.body);
    print("${data}");
    for (var item in data) {
      if (item.containsKey('Kj') &&
          item.containsKey('Ds') &&
          item.containsKey('Ka')) {
        String key = item['Kj'];
        if (key == "  " || key == " " || key == "") {
          key = item['Ka'];
        }
        String value = item['Ds'];
        WordsMap[key] = value;
      }
    }
    print("${WordsMap}");
  }
}
