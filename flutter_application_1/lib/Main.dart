// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'HiraganaDataModel.dart';
import 'KatakanaDataModel.dart';
import 'WordsDataModel.dart';
import 'CardPrivateContentModel.dart';
import 'CardContentModel.dart';

import 'Request.dart';

TextEditingController emailcontroller = TextEditingController();
TextEditingController namecontroller = TextEditingController();
TextEditingController passcontroller = TextEditingController();
TextEditingController secpasscontroller = TextEditingController();

TextEditingController searchWordcontroller = TextEditingController();

String searchTerm = "";
int pageNum = 1;
String descLang = 'ru';
bool fullMatch = false;
int pageSize = 5;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  checkSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Username') && prefs.containsKey('Pass')) {
      String? username = prefs.getString('Username');
      String? password = prefs.getString('Pass');

      /*
      print('prefs.containsKey(Username): ${username}.');
      print('prefs.containsKey(Username): ${password}.');
      */
      var lrsc = await postAuthData(username!, password!);

      if (lrsc == 200 || lrsc == 201) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkSharedPreferences();
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 127, 185),
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            // ignore: prefer_const_constructors
            SizedBox(
              width: double.infinity,
              child: const Text(
                'Welcome to Octopus!',
                textAlign: TextAlign.center,
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 32,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 60),
            SizedBox(
              width: 240,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 41, 127, 185)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                          width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                child: const Text("У меня уже есть аккаунт",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    )),
              ),
            ),
            SizedBox(
              width: 240,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 41, 127, 185)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: const BorderSide(
                          width: 1, color: Color.fromARGB(255, 255, 255, 255)),
                    ),
                  ),
                ),
                child: const Text("Зарегистрироваться",
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontSize: 16,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    )),
              ),
            )
          ],
        )));
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 127, 185),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(top: 80.0, bottom: 80.0),
                children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('OCTOPUS',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                      )),
                  const Divider(
                    color: Color.fromARGB(0, 0, 0, 0),
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const Text('Авторизация',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 28,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: namecontroller,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(235, 235, 87, 87),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              hintText: 'Ваше имя',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: passcontroller,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(235, 235, 87, 87),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              hintText: 'Ваш пароль',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            //Войти
                            //color: Color.fromARGB(235, 235, 87, 87),
                            margin: const EdgeInsets.all(0.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                String username = namecontroller.text;
                                String password = passcontroller.text;
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('Username', username);
                                prefs.setString('Pass', password);
                                /*
                                print(
                                    'prefs.containsKey(Username): ${username}.');
                                print(
                                    'prefs.containsKey(Username): ${password}.');*/
                                var lrsc =
                                    await postAuthData(username, password);

                                if (lrsc == 200 || lrsc == 201) {
                                  await Future.delayed(
                                      const Duration(seconds: 1));

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MainPage()));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Что-то пошло не так",
                                              textAlign: TextAlign.center,
                                              textDirection: TextDirection.ltr,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 54, 54, 54),
                                                fontSize: 16,
                                                fontFamily: 'Nunito',
                                                fontWeight: FontWeight.w400,
                                              )),
                                          content: SingleChildScrollView(
                                              child: ListBody(
                                                  children: const <Widget>[
                                                Text(
                                                    "Проверьте введенные Вами данные",
                                                    textAlign: TextAlign.center,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 54, 54, 54),
                                                      fontSize: 14,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ])),
                                        );
                                      });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(235, 235, 87, 87)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // ignore: prefer_const_constructors
                                    side: BorderSide(
                                        width: 0,
                                        color: const Color.fromARGB(
                                            235, 235, 87, 87)),
                                  ),
                                ),
                              ),
                              child: const Text("Войти",
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                  )),
                            )),
                        const Divider(
                          color: Colors.white,
                          indent: 40,
                          endIndent: 40,
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 37, 118, 171),
                                ),
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      FontAwesomeIcons.google,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      size: 18,
                                    ))),
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 37, 118, 171),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.vk,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 20,
                                  )),
                            ),
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 37, 118, 171),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.facebook,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 18,
                                  )),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(0, 0, 0, 0),
                          height: 10,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ForpassPage()));
                          },
                          child: const Text("Забыли пароль?",
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 206, 206, 206),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromARGB(0, 0, 0, 0),
                    height: 20,
                  ),
                  ElevatedButton(
                    //Есть аккаунт
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => RegPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 41, 127, 185)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: const Text("У меня нет аккаунта",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              )
            ])));
  }
}

class RegPage extends StatefulWidget {
  @override
  _RegPage createState() => _RegPage();
}

class _RegPage extends State<RegPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 127, 185),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(top: 80.0, bottom: 80.0),
                children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text('OCTOPUS',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                      )),
                  const Divider(
                    color: Color.fromARGB(0, 0, 0, 0),
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const Text('Регистрация',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 28,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: emailcontroller,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(235, 235, 87, 87),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              hintText: 'Ваш адрес электронной почты',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: namecontroller,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(235, 235, 87, 87),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              hintText: 'Ваше имя',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(10.0),
                          child: TextField(
                            controller: passcontroller,
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(255, 195, 195, 195),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color.fromARGB(235, 235, 87, 87),
                                      width: 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(64.0))),
                              hintText: 'Придумайте пароль',
                              hintStyle: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Container(
                            //Создать аккаунт
                            //color: Color.fromARGB(235, 235, 87, 87),
                            margin: const EdgeInsets.all(0.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                String username = namecontroller.text;
                                String password = passcontroller.text;
                                String email = emailcontroller.text;
                                postRegData(username, password, email);
                                if (responseStatusCode == 200) {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: const Text("Успешно!",
                                                textAlign: TextAlign.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 54, 54),
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            content: SingleChildScrollView(
                                                child: ListBody(
                                                    children: const <Widget>[
                                                  Text(
                                                      "Сейчас Вам нужно будет подтвердить свою почту, на нее было выслано письмо",
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 54, 54, 54),
                                                        fontSize: 14,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ])),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              LoginPage()));
                                                },
                                                child: const Text("Продолжить",
                                                    textAlign: TextAlign.center,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 16,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )
                                            ]);
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                            title: const Text(
                                                "Что-то пошло не так",
                                                textAlign: TextAlign.center,
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 54, 54, 54),
                                                  fontSize: 16,
                                                  fontFamily: 'Nunito',
                                                  fontWeight: FontWeight.w400,
                                                )),
                                            content: SingleChildScrollView(
                                                child: ListBody(
                                                    children: const <Widget>[
                                                  Text(
                                                      "Проверьте введенные Вами данные",
                                                      textAlign:
                                                          TextAlign.center,
                                                      textDirection:
                                                          TextDirection.ltr,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 54, 54, 54),
                                                        fontSize: 14,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                ])),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("ок",
                                                    textAlign: TextAlign.center,
                                                    textDirection:
                                                        TextDirection.ltr,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 16,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )
                                            ]);
                                      });
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(235, 235, 87, 87)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    side: const BorderSide(
                                        width: 0,
                                        color:
                                            Color.fromARGB(235, 235, 87, 87)),
                                  ),
                                ),
                              ),
                              child: const Text("Создать аккаунт",
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                  )),
                            )),
                        const Divider(
                          color: Colors.white,
                          indent: 40,
                          endIndent: 40,
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 37, 118, 171),
                                ),
                                child: IconButton(
                                    onPressed: () {},
                                    // ignore: prefer_const_constructors
                                    icon: Icon(
                                      FontAwesomeIcons.google,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255),
                                      size: 18,
                                    ))),
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 37, 118, 171),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    FontAwesomeIcons.vk,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    size: 20,
                                  )),
                            ),
                            Container(
                              height: 40,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 37, 118, 171),
                              ),
                              child: IconButton(
                                  onPressed: () {},
                                  // ignore: prefer_const_constructors
                                  icon: Icon(
                                    FontAwesomeIcons.facebook,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    size: 18,
                                  )),
                            ),
                          ],
                        ),
                        const Divider(
                          color: Color.fromARGB(0, 0, 0, 0),
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //Есть аккаунт
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(255, 41, 127, 185)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: const Text("У меня уже есть аккаунт",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ),
                ],
              )
            ])));
  }
}

class ForpassPage extends StatelessWidget {
  const ForpassPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 41, 127, 185),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(top: 100.0, bottom: 80.0),
                children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('OCTOPUS',
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 32,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                      )),
                  const Divider(
                    color: Color.fromARGB(0, 0, 0, 0),
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: const Color.fromARGB(255, 255, 255, 255),
                        )),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          child: const Text('Забыли пароль?',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 28,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                        Container(
                          color: const Color.fromARGB(0, 255, 26, 26),
                          height: 60,
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 30, left: 10, right: 10),
                          child: const Text(
                              "Введите ваш адрес электронной почты в поле ниже. Мы отправим ссылку для восстановления пароля.",
                              textAlign: TextAlign.left,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              )),
                        ),
                        Container(
                          height: 40,
                          margin: const EdgeInsets.all(10.0),
                          child: const TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(64.0))),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(235, 235, 87, 87),
                                        width: 1.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(64.0))),
                                hintText: 'Ваш адрес электроной почты',
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w300,
                                ),
                                counterText: "",
                                counterStyle: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 16,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                        ),
                        const Divider(
                          color: Color.fromARGB(0, 0, 0, 0),
                          height: 20,
                        ),
                        Container(
                            //Войти
                            //color: Color.fromARGB(235, 235, 87, 87),
                            margin: const EdgeInsets.all(0.0),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color.fromARGB(235, 235, 87, 87)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    // ignore: prefer_const_constructors
                                    side: BorderSide(
                                        width: 0,
                                        color: const Color.fromARGB(
                                            235, 235, 87, 87)),
                                  ),
                                ),
                              ),
                              child: const Text("Отправить ссылку",
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontSize: 16,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w400,
                                  )),
                            )),
                        const Divider(
                          color: Color.fromARGB(0, 0, 0, 0),
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ])));
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 62, 62, 62),
          ),
          backgroundColor: const Color.fromARGB(248, 248, 248, 248),
          title: const Text(
            'Octopus',
            style: TextStyle(
              color: Color.fromARGB(255, 62, 62, 62),
              fontSize: 26,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("lib/images/ru_flag.png"),
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Color.fromARGB(255, 62, 62, 62),
                  size: 20,
                )),
          ]),
      drawer: Drawer(
        child:
            ListView(padding: const EdgeInsets.symmetric(), children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    child: ClipOval(
                      child: SizedBox(
                        width: 30 * 2,
                        height: 30 * 2,
                        child: Image(
                          image: NetworkImage(avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 24,
                    indent: 24,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySett()));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.gear,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20,
                            )),
                      )
                    ],
                  )
                ]),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 209, 204, 192)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.houseChimney,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Главная",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.bookOpen,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivateDictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.book,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Личный словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Training()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.dumbbell,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Тренировки",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Courses()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.flagCheckered,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Курсы",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            children: [
              const Text(
                'Главная',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 26,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Divider(
                height: 14,
                color: Color.fromARGB(0, 62, 62, 62),
                thickness: 1,
                endIndent: 24,
                indent: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 69, 69, 69),
                ),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(0, 245, 0, 0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))
                          // ignore: prefer_const_constructors

                          ),
                    ),
                    child: Column(
                      children: const [
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text("Продолжить",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            )),
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text("Японский курс",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            )),
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                      ],
                    )),
              ),
              const Divider(
                height: 14,
                color: Color.fromARGB(0, 62, 62, 62),
                thickness: 1,
                endIndent: 24,
                indent: 24,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(0, 62, 62, 62),
                  image: const DecorationImage(
                      image: AssetImage("lib/images/jp_back.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.6),
                ),
                child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(0, 245, 0, 0)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0))
                          // ignore: prefer_const_constructors
                          ),
                    ),
                    child: Column(
                      children: const [
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text("Лучшие драмы на японском",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 18,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            )),
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text(
                            "Топ-15 поизведений от японских писателей, которые погрузят вас в атмосферу Японии и её культуры",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 14,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w400,
                            )),
                        Divider(
                          height: 8,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                      ],
                    )),
              ),
            ]),
      ),
    );
  }
}

class Dictionary extends StatefulWidget {
  @override
  _Dictionary createState() => _Dictionary();
}

class _Dictionary extends State<Dictionary> {
  int counter = 1;
  String buff = "";

  void counterPlus() {
    setState(() {
      counter++;
    });
  }

  void counterMin() {
    setState(() {
      if (counter >= 2) {
        counter--;
      }
    });
  }

  Future<List<CardContent>> cardContents =
      postDictionarySearch(searchTerm, descLang, fullMatch, pageNum, pageSize);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 62, 62, 62),
            ),
            backgroundColor: const Color.fromARGB(248, 248, 248, 248),
            title: const Text(
              'Octopus',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 26,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              Container(
                height: 20,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("lib/images/ru_flag.png"),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.bell,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 20,
                  )),
            ]),
        drawer: Drawer(
          child: ListView(
              padding: const EdgeInsets.symmetric(),
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                          child: ClipOval(
                            child: SizedBox(
                              width: 30 * 2,
                              height: 30 * 2,
                              child: Image(
                                image: NetworkImage(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.0,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MySett()));
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.gear,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 20,
                                  )),
                            )
                          ],
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.houseChimney,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Главная",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 209, 204, 192)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.bookOpen,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Словарь",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivateDictionary()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.book,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Личный словарь",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Training()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.dumbbell,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Тренировки",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Courses()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.flagCheckered,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Курсы",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 10),
                children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Японо-русский словарь',
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 26,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Divider(
                      height: 14,
                      color: Color.fromARGB(0, 62, 62, 62),
                      thickness: 1,
                      endIndent: 24,
                      indent: 24,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: searchWordcontroller,
                        decoration: InputDecoration(
                          hintText: 'Поиск...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchWordcontroller.text = "";
                              searchTerm = "";
                              Future<List<CardContent>> newcardContents =
                                  postDictionarySearch(searchTerm, descLang,
                                      fullMatch, pageNum - 1, pageSize);
                              Future<List<CardContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardContents = bufcardContents;
                              });
                            },
                          ),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              buff = searchWordcontroller.text;
                              searchTerm = buff;

                              Future<List<CardContent>> newcardContents =
                                  postDictionarySearch(searchTerm, descLang,
                                      fullMatch, pageNum - 1, pageSize);
                              Future<List<CardContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardContents = bufcardContents;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 14,
                      color: Color.fromARGB(0, 62, 62, 62),
                      thickness: 1,
                      endIndent: 24,
                      indent: 24,
                    ),
                    Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 360,
                            child: FutureBuilder<List<CardContent>>(
                              future: cardContents,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  final cardContents = snapshot.data!;
                                  return buildWords(cardContents);
                                } else {
                                  return const Text("Нет данных");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 14,
                        color: Color.fromARGB(0, 62, 62, 62),
                        thickness: 1,
                        endIndent: 24,
                        indent: 24,
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              counterMin();

                              pageNum = counter;

                              Future<List<CardContent>> newcardContents =
                                  postDictionarySearch(searchTerm, descLang,
                                      fullMatch, pageNum - 1, pageSize);
                              Future<List<CardContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardContents = bufcardContents;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 52, 172, 224)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))
                                  // ignore: prefer_const_constructors

                                  ),
                            ),
                            child: const Text("Назад")),
                        const Divider(
                          height: 14,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text(
                          "$counter",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(
                          height: 14,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              counterPlus();
                              pageNum = counter;

                              Future<List<CardContent>> newcardContents =
                                  postDictionarySearch(searchTerm, descLang,
                                      fullMatch, pageNum - 1, pageSize);
                              Future<List<CardContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardContents = bufcardContents;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 52, 172, 224)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))
                                  // ignore: prefer_const_constructors

                                  ),
                            ),
                            child: const Text("Вперед")),
                      ],
                    )
                  ])
            ])));
  }

  Widget buildWords(List<CardContent> cardContents) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: cardContents.length,
        itemBuilder: (context, index) {
          final CardContent = cardContents[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      color: const Color.fromARGB(0, 209, 56, 56),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              CardContent.kj,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 62, 62, 62),
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Divider(
                              height: 10,
                              color: Color.fromARGB(0, 62, 62, 62),
                              thickness: 1,
                              endIndent: 24,
                              indent: 24,
                            ),
                            Text(
                              CardContent.ka,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 62, 62, 62),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ]),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 160,
                        //color: Color.fromARGB(0, 201, 209, 56),
                        child: Text(
                          CardContent.ds,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    Text(
                      "N${CardContent.lv}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(0, 59, 56, 209),
                      child: IconButton(
                          onPressed: () {
                            postAddToPrivateDictionary(CardContent.pk);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.bookmark,
                            color: Color.fromARGB(255, 98, 98, 98),
                            size: 20,
                          )),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 12,
                color: Color.fromARGB(0, 62, 62, 62),
              ),
            ],
          );
        },
      );
}

class PrivateDictionary extends StatefulWidget {
  @override
  _PrivateDictionary createState() => _PrivateDictionary();
}

class _PrivateDictionary extends State<PrivateDictionary> {
  int counter = 1;
  String buff = "";

  void counterPlus() {
    setState(() {
      counter++;
    });
  }

  void counterMin() {
    setState(() {
      if (counter >= 2) {
        counter--;
      }
    });
  }

  Future<List<CardPrivateContent>> cardPrivateContents =
      postPrivateDictionarySearch(
          searchTerm, descLang, fullMatch, pageNum - 1, pageSize);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 62, 62, 62),
            ),
            backgroundColor: const Color.fromARGB(248, 248, 248, 248),
            title: const Text(
              'Octopus',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 26,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              Container(
                height: 20,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("lib/images/ru_flag.png"),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.bell,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 20,
                  )),
            ]),
        drawer: Drawer(
          child: ListView(padding: const EdgeInsets.symmetric(), children: <
              Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      child: ClipOval(
                        child: SizedBox(
                          width: 30 * 2,
                          height: 30 * 2,
                          child: Image(
                            image: NetworkImage(avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1,
                      endIndent: 24,
                      indent: 24,
                      color: Color.fromARGB(0, 0, 0, 0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14.0,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MySett()));
                              },
                              icon: const Icon(
                                FontAwesomeIcons.gear,
                                color: Color.fromARGB(255, 255, 255, 255),
                                size: 20,
                              )),
                        )
                      ],
                    )
                  ]),
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              //color: Color.fromARGB(235, 235, 87, 87),
              margin: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainPage()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(235, 241, 241, 241)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                          width: 0,
                          color: const Color.fromARGB(0, 255, 255, 255)),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.houseChimney,
                      color: Color.fromARGB(255, 62, 62, 62),
                      size: 16,
                    ),
                    Divider(
                      indent: 14,
                    ),
                    Text("Главная",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 14,
              thickness: 1,
              endIndent: 24,
              indent: 24,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              //color: Color.fromARGB(235, 235, 87, 87),
              margin: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Dictionary()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(235, 241, 241, 241)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                          width: 0,
                          color: const Color.fromARGB(0, 255, 255, 255)),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.bookOpen,
                      color: Color.fromARGB(255, 62, 62, 62),
                      size: 16,
                    ),
                    Divider(
                      indent: 14,
                    ),
                    Text("Словарь",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 14,
              thickness: 1,
              endIndent: 24,
              indent: 24,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              //color: Color.fromARGB(235, 235, 87, 87),
              margin: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(235, 209, 204, 192)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                          width: 0,
                          color: const Color.fromARGB(0, 255, 255, 255)),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.book,
                      color: Color.fromARGB(255, 62, 62, 62),
                      size: 16,
                    ),
                    Divider(
                      indent: 14,
                    ),
                    Text("Личный словарь",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 14,
              thickness: 1,
              endIndent: 24,
              indent: 24,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              //color: Color.fromARGB(235, 235, 87, 87),
              margin: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Training()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(235, 241, 241, 241)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                          width: 0,
                          color: const Color.fromARGB(0, 255, 255, 255)),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.dumbbell,
                      color: Color.fromARGB(255, 62, 62, 62),
                      size: 16,
                    ),
                    Divider(
                      indent: 14,
                    ),
                    Text("Тренировки",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
            const Divider(
              height: 14,
              thickness: 1,
              endIndent: 24,
              indent: 24,
            ),
            Container(
              padding: const EdgeInsets.only(left: 12, right: 12),
              //color: Color.fromARGB(235, 235, 87, 87),
              margin: const EdgeInsets.all(0.0),
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Courses()));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(235, 241, 241, 241)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      // ignore: prefer_const_constructors
                      side: BorderSide(
                          width: 0,
                          color: const Color.fromARGB(0, 255, 255, 255)),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesomeIcons.flagCheckered,
                      color: Color.fromARGB(255, 62, 62, 62),
                      size: 16,
                    ),
                    Divider(
                      indent: 14,
                    ),
                    Text("Курсы",
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                          color: Color.fromARGB(255, 62, 62, 62),
                          fontSize: 16,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              ),
            ),
          ]),
        ),
        body: SafeArea(
            child: ListView(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text(
                      'Личный словарь',
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 26,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const Divider(
                      height: 14,
                      color: Color.fromARGB(0, 62, 62, 62),
                      thickness: 1,
                      endIndent: 24,
                      indent: 24,
                    ),
                    SizedBox(
                      height: 60,
                      child: TextField(
                        controller: searchWordcontroller,
                        decoration: InputDecoration(
                          hintText: 'Поиск...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              searchWordcontroller.text = "";
                              searchTerm = "";
                              Future<List<CardPrivateContent>> newcardContents =
                                  postPrivateDictionarySearch(
                                      searchTerm,
                                      descLang,
                                      fullMatch,
                                      pageNum - 1,
                                      pageSize);
                              Future<List<CardPrivateContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardPrivateContents = bufcardContents;
                              });
                            },
                          ),
                          prefixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              buff = searchWordcontroller.text;
                              searchTerm = buff;

                              Future<List<CardPrivateContent>> newcardContents =
                                  postPrivateDictionarySearch(
                                      searchTerm,
                                      descLang,
                                      fullMatch,
                                      pageNum - 1,
                                      pageSize);
                              Future<List<CardPrivateContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardPrivateContents = bufcardContents;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    ),
                    const Divider(
                      height: 14,
                      color: Color.fromARGB(0, 62, 62, 62),
                      thickness: 1,
                      endIndent: 24,
                      indent: 24,
                    ),
                    Column(children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 360,
                            child: FutureBuilder<List<CardPrivateContent>>(
                              future: cardPrivateContents,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                } else if (snapshot.hasData) {
                                  final cardPrivateContents = snapshot.data!;
                                  return buildPrivateWords(cardPrivateContents);
                                } else {
                                  return const Text("Нет данных");
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      const Divider(
                        height: 14,
                        color: Color.fromARGB(0, 62, 62, 62),
                        thickness: 1,
                        endIndent: 24,
                        indent: 24,
                      ),
                    ]),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              counterMin();

                              pageNum = counter;

                              Future<List<CardPrivateContent>> newcardContents =
                                  postPrivateDictionarySearch(
                                      searchTerm,
                                      descLang,
                                      fullMatch,
                                      pageNum - 1,
                                      pageSize);
                              Future<List<CardPrivateContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardPrivateContents = bufcardContents;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 52, 172, 224)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))
                                  // ignore: prefer_const_constructors

                                  ),
                            ),
                            child: const Text("Назад")),
                        const Divider(
                          height: 14,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        Text(
                          "$counter",
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(
                          height: 14,
                          color: Color.fromARGB(0, 62, 62, 62),
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              counterPlus();
                              pageNum = counter;

                              Future<List<CardPrivateContent>> newcardContents =
                                  postPrivateDictionarySearch(
                                      searchTerm,
                                      descLang,
                                      fullMatch,
                                      pageNum - 1,
                                      pageSize);
                              Future<List<CardPrivateContent>> bufcardContents =
                                  newcardContents;
                              setState(() {
                                cardPrivateContents = bufcardContents;
                              });
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 52, 172, 224)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0))
                                  // ignore: prefer_const_constructors

                                  ),
                            ),
                            child: const Text("Вперед")),
                      ],
                    )
                  ]),
            ])));
  }

  Widget buildPrivateWords(List<CardPrivateContent> cardPrivateContents) =>
      ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: cardPrivateContents.length,
        itemBuilder: (context, index) {
          final CardContent = cardPrivateContents[index];
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 100,
                      margin: const EdgeInsets.only(right: 10),
                      color: const Color.fromARGB(0, 209, 56, 56),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              CardContent.kj,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 62, 62, 62),
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Divider(
                              height: 10,
                              color: Color.fromARGB(0, 62, 62, 62),
                              thickness: 1,
                              endIndent: 24,
                              indent: 24,
                            ),
                            Text(
                              CardContent.ka,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 62, 62, 62),
                                fontSize: 16,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ]),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 160,
                        //color: Color.fromARGB(0, 201, 209, 56),
                        child: Text(
                          CardContent.ds,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 16,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                    Text(
                      "N${CardContent.lv}",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      color: const Color.fromARGB(0, 59, 56, 209),
                      child: IconButton(
                          onPressed: () {
                            postDeleteFromPrivateDictionary(CardContent.pk);
                          },
                          icon: const Icon(
                            FontAwesomeIcons.solidBookmark,
                            color: Color.fromARGB(255, 151, 20, 20),
                            size: 20,
                          )),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 12,
                color: Color.fromARGB(0, 62, 62, 62),
              ),
            ],
          );
        },
      );
}

class Training extends StatefulWidget {
  @override
  _Training createState() => _Training();
}

class _Training extends State<Training> {
  int hiraganacheckbox = 1;
  int hiragana_nigoricheckbox = 2;
  int hiragana_hannigoricheckbox = 3;
  int hiragana_yoncheckbox = 4;
  int hiragana_nigoriyoncheckbox = 5;

  bool? hiragana = true;
  bool? hiragana_nigori = false;
  bool? hiragana_hannigori = false;
  bool? hiragana_yon = false;
  bool? hiragana_nigoriyon = false;

  void addToHiraganaMap(bool hiropt, int whihir) {
    if (whihir == 1) {
      hiraganaMap.addAll(hiragana_baseMap);
    }
    if (whihir == 2) {
      hiraganaMap.addAll(hiragana_nigoriMap);
    }
    if (whihir == 3) {
      hiraganaMap.addAll(hiragana_hannigoriMap);
    }
    if (whihir == 4) {
      hiraganaMap.addAll(hiragana_yonMap);
    }
    if (whihir == 5) {
      hiraganaMap.addAll(hiragana_nigoriyonMap);
    }
  }

  void removeFromHiraganaMap(bool hiropt, int whihir) {
    if (whihir == 1) {
      for (var key in hiragana_baseMap.keys) {
        hiraganaMap.remove(key);
      }
    }
    if (whihir == 2) {
      for (var key in hiragana_nigoriMap.keys) {
        hiraganaMap.remove(key);
      }
    }
    if (whihir == 3) {
      for (var key in hiragana_hannigoriMap.keys) {
        hiraganaMap.remove(key);
      }
    }
    if (whihir == 4) {
      for (var key in hiragana_yonMap.keys) {
        hiraganaMap.remove(key);
      }
    }
    if (whihir == 5) {
      for (var key in hiragana_nigoriyonMap.keys) {
        hiraganaMap.remove(key);
      }
    }
  }

  int katakanacheckbox = 1;
  int katakana_nigoricheckbox = 2;
  int katakana_hannigoricheckbox = 3;
  int katakana_yoncheckbox = 4;
  int katakana_nigoriyoncheckbox = 5;

  bool? katakana = true;
  bool? katakana_nigori = false;
  bool? katakana_hannigori = false;
  bool? katakana_yon = false;
  bool? katakana_nigoriyon = false;

  void addToKatakanaMap(bool hiropt, int whihir) {
    if (whihir == 1) {
      katakanaMap.addAll(katakana_baseMap);
    }
    if (whihir == 2) {
      katakanaMap.addAll(katakana_nigoriMap);
    }
    if (whihir == 3) {
      katakanaMap.addAll(katakana_hannigoriMap);
    }
    if (whihir == 4) {
      katakanaMap.addAll(katakana_yonMap);
    }
    if (whihir == 5) {
      katakanaMap.addAll(katakana_nigoriyonMap);
    }
  }

  void removeFromKatakanaMap(bool hiropt, int whihir) {
    if (whihir == 1) {
      for (var key in katakana_baseMap.keys) {
        katakanaMap.remove(key);
      }
    }
    if (whihir == 2) {
      for (var key in katakana_nigoriMap.keys) {
        katakanaMap.remove(key);
      }
    }
    if (whihir == 3) {
      for (var key in katakana_hannigoriMap.keys) {
        katakanaMap.remove(key);
      }
    }
    if (whihir == 4) {
      for (var key in katakana_yonMap.keys) {
        katakanaMap.remove(key);
      }
    }
    if (whihir == 5) {
      for (var key in katakana_nigoriyonMap.keys) {
        katakanaMap.remove(key);
      }
    }
  }

  String st = "";
  int pn = 0;
  String dl = 'ru';
  bool fm = false;
  int ps = 16;

  void getWords() {
    postPrivateDictionaryWords(st, dl, fm, pn, ps);
  }

  @override
  Widget build(BuildContext context) {
    addToHiraganaMap(hiragana!, hiraganacheckbox);
    addToKatakanaMap(katakana!, katakanacheckbox);
    getWords();
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 62, 62, 62),
          ),
          backgroundColor: const Color.fromARGB(248, 248, 248, 248),
          title: const Text(
            'Octopus',
            style: TextStyle(
              color: Color.fromARGB(255, 62, 62, 62),
              fontSize: 26,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("lib/images/ru_flag.png"),
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Color.fromARGB(255, 62, 62, 62),
                  size: 20,
                )),
          ]),
      drawer: Drawer(
        child:
            ListView(padding: const EdgeInsets.symmetric(), children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    child: ClipOval(
                      child: SizedBox(
                        width: 30 * 2,
                        height: 30 * 2,
                        child: Image(
                          image: NetworkImage(avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 24,
                    indent: 24,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySett()));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.gear,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20,
                            )),
                      )
                    ],
                  )
                ]),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.houseChimney,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Главная",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.bookOpen,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivateDictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.book,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Личный словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 209, 204, 192)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.houseChimney,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Тренировки",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Courses()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.flagCheckered,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Курсы",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            children: [
              const Text(
                'Тренировки',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 26,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Divider(
                height: 14,
                color: Color.fromARGB(0, 62, 62, 62),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(mainAxisSize: MainAxisSize.max, children: [
                  const Divider(
                    height: 6,
                    color: Color.fromARGB(0, 62, 62, 62),
                  ),
                  const Text(
                    'Основа',
                    style: TextStyle(
                      color: Color.fromARGB(255, 62, 62, 62),
                      fontSize: 22,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Divider(
                    height: 10,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: 164,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 222, 245, 255),
                          ),
                          child: Column(
                            children: [
                              const Text("Хирагана",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 62, 62, 62),
                                    fontSize: 18,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                  )),
                              const Divider(
                                height: 10,
                                color: Color.fromARGB(0, 0, 0, 0),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: hiragana,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                hiragana = newBool;
                                              });
                                              if (hiragana == true) {
                                                addToHiraganaMap(hiragana!,
                                                    hiraganacheckbox);
                                              } else {
                                                removeFromHiraganaMap(hiragana!,
                                                    hiraganacheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Основная азбука",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: hiragana_nigori,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                hiragana_nigori = newBool;
                                              });
                                              if (hiragana_nigori == true) {
                                                addToHiraganaMap(
                                                    hiragana_nigori!,
                                                    hiragana_nigoricheckbox);
                                              } else {
                                                removeFromHiraganaMap(
                                                    hiragana_nigori!,
                                                    hiragana_nigoricheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Нигори",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: hiragana_hannigori,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                hiragana_hannigori = newBool;
                                              });
                                              if (hiragana_hannigori == true) {
                                                addToHiraganaMap(
                                                    hiragana_hannigori!,
                                                    hiragana_hannigoricheckbox);
                                              } else {
                                                removeFromHiraganaMap(
                                                    hiragana_hannigori!,
                                                    hiragana_hannigoricheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Ханнигори",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: hiragana_yon,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                hiragana_yon = newBool;
                                              });
                                              if (hiragana_yon == true) {
                                                addToHiraganaMap(hiragana_yon!,
                                                    hiragana_yoncheckbox);
                                              } else {
                                                removeFromHiraganaMap(
                                                    hiragana_yon!,
                                                    hiragana_yoncheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Ёон",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: hiragana_nigoriyon,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                hiragana_nigoriyon = newBool;
                                              });
                                              if (hiragana_nigoriyon == true) {
                                                addToHiraganaMap(
                                                    hiragana_nigoriyon!,
                                                    hiragana_nigoriyoncheckbox);
                                              } else {
                                                removeFromHiraganaMap(
                                                    hiragana_nigoriyon!,
                                                    hiragana_nigoriyoncheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Нигори ёон",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                  ]),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrainingHiragana()));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 34, 197, 94)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))
                                      // ignore: prefer_const_constructors

                                      ),
                                ),
                                child: const Text("Начать",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 164,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color.fromARGB(255, 222, 245, 255),
                          ),
                          child: Column(
                            children: [
                              const Text("Катакана",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 62, 62, 62),
                                    fontSize: 18,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w800,
                                  )),
                              const Divider(
                                height: 10,
                                color: Color.fromARGB(0, 0, 0, 0),
                              ),
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: katakana,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                katakana = newBool;
                                              });
                                              if (katakana == true) {
                                                addToKatakanaMap(katakana!,
                                                    katakanacheckbox);
                                              } else {
                                                removeFromKatakanaMap(katakana!,
                                                    katakanacheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Основная азбука",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: katakana_nigori,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                katakana_nigori = newBool;
                                              });
                                              if (katakana_nigori == true) {
                                                addToKatakanaMap(
                                                    katakana_nigori!,
                                                    katakana_nigoricheckbox);
                                              } else {
                                                removeFromKatakanaMap(
                                                    katakana_nigori!,
                                                    katakana_nigoricheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Нигори",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: katakana_hannigori,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                katakana_hannigori = newBool;
                                              });
                                              if (katakana_hannigori == true) {
                                                addToKatakanaMap(
                                                    katakana_hannigori!,
                                                    katakana_hannigoricheckbox);
                                              } else {
                                                removeFromKatakanaMap(
                                                    katakana_hannigori!,
                                                    katakana_hannigoricheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Ханнигори",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: katakana_yon,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                katakana_yon = newBool;
                                              });
                                              if (katakana_yon == true) {
                                                addToKatakanaMap(katakana_yon!,
                                                    katakana_yoncheckbox);
                                              } else {
                                                removeFromKatakanaMap(
                                                    katakana_yon!,
                                                    katakana_yoncheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Ёон",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                    Row(children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: Checkbox(
                                            shape: const CircleBorder(),
                                            value: katakana_nigoriyon,
                                            activeColor: const Color.fromARGB(
                                                255, 52, 172, 224),
                                            onChanged: (newBool) {
                                              setState(() {
                                                katakana_nigoriyon = newBool;
                                              });
                                              if (katakana_nigoriyon == true) {
                                                addToKatakanaMap(
                                                    katakana_nigoriyon!,
                                                    katakana_nigoriyoncheckbox);
                                              } else {
                                                removeFromKatakanaMap(
                                                    katakana_nigoriyon!,
                                                    katakana_nigoriyoncheckbox);
                                              }
                                            }),
                                      ),
                                      const Text("Нигори ёон",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 62, 62, 62),
                                            fontSize: 14,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ]),
                                    const Divider(
                                      height: 10,
                                      color: Color.fromARGB(0, 0, 0, 0),
                                    ),
                                  ]),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              TrainingKatakana()));
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color.fromARGB(255, 34, 197, 94)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0))
                                      // ignore: prefer_const_constructors

                                      ),
                                ),
                                child: const Text("Начать",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 255, 255, 255),
                                      fontSize: 16,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w600,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ]),
                  const Divider(
                    height: 10,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                ]),
              ),
              const Divider(
                height: 14,
                color: Color.fromARGB(0, 62, 62, 62),
                thickness: 1,
                endIndent: 24,
                indent: 24,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 14.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Слово-перевод",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 22,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w900,
                          )),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TrainingWords()));
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 34, 197, 94)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0))
                              // ignore: prefer_const_constructors

                              ),
                        ),
                        child: const Text("Начать",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ],
                  ))
            ]),
      ),
    );
  }
}

class TrainingHiragana extends StatefulWidget {
  @override
  _TrainingHiraganaState createState() => _TrainingHiraganaState();
}

class _TrainingHiraganaState extends State<TrainingHiragana> {
  Random random = Random();
  late String currentSymbol;
  List<String> options = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int progress = -1;

  void generateQuestion() {
    setState(() {
      currentSymbol =
          hiraganaMap.keys.elementAt(random.nextInt(hiraganaMap.length));

      options.clear();
      options.add(hiraganaMap[currentSymbol]!);

      while (options.length < 4) {
        String randomReading =
            hiraganaMap.values.elementAt(random.nextInt(hiraganaMap.length));
        if (!options.contains(randomReading)) {
          options.add(randomReading);
        }
      }

      options.shuffle();
      progress++;
    });
  }

  void handleAnswer(String selectedAnswer) {
    if (selectedAnswer == hiraganaMap[currentSymbol]) {
      // Верный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Верно!",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 360,
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              correctAnswers++;
                            });
                            if (progress == 9) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('Результаты тренировки',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 22,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w800,
                                          )),
                                      content: Text(
                                          'Количество ошибок: $incorrectAnswers',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                          )),
                                      actions: <Widget>[
                                        Row(children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  random = Random();
                                                  currentSymbol;
                                                  options = [];
                                                  correctAnswers = 0;
                                                  incorrectAnswers = 0;
                                                  progress = -1;
                                                  generateQuestion();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              34,
                                                              197,
                                                              94)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text(
                                                    "Пройти снова",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Training()));
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              52,
                                                              172,
                                                              224)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text("Закончить",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                        ]),
                                      ]);
                                },
                              );
                            } else {
                              generateQuestion();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 40, 167, 69)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          child: const Text("Продолжить",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              )),
                        )),
                  ],
                ),
              ]);
        },
      );
    } else {
      // Неправильный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Неверно!',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 360,
                          margin: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                incorrectAnswers++;
                              });
                              if (progress == 9) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            'Результаты тренировки',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 22,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w800,
                                            )),
                                        content: Text(
                                            'Количество ошибок: $incorrectAnswers',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 20,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500,
                                            )),
                                        actions: <Widget>[
                                          Row(children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    random = Random();
                                                    currentSymbol;
                                                    options = [];
                                                    correctAnswers = 0;
                                                    incorrectAnswers = 0;
                                                    progress = -1;
                                                    generateQuestion();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                34,
                                                                197,
                                                                94)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text(
                                                      "Пройти снова",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Training()));
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                52,
                                                                172,
                                                                224)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text("Закончить",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                          ]),
                                        ]);
                                  },
                                );
                              } else {
                                generateQuestion();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 239, 68, 68)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text("Продолжить",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                )),
                          )),
                    ])
              ]);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 62, 62, 62),
        ),
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        title: const Text(
          'Тренировка хираганы',
          style: TextStyle(
            color: Color.fromARGB(255, 62, 62, 62),
            fontSize: 26,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 62, 62, 62),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: const Color.fromARGB(255, 193, 207, 226),
                color: const Color.fromARGB(255, 52, 172, 224),
                value: progress / 9,
              ),
            ),
            const Text(
              'Выберите верный перевод:',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 18,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 187, 221, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentSymbol,
                style: const TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 64,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 2,
                children: options.map((option) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () => handleAnswer(option),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 255, 255)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))
                              // ignore: prefer_const_constructors

                              ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 36,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingKatakana extends StatefulWidget {
  @override
  _TrainingKatakanaState createState() => _TrainingKatakanaState();
}

class _TrainingKatakanaState extends State<TrainingKatakana> {
  Random random = Random();
  late String currentSymbol;
  List<String> options = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int progress = -1;

  void generateQuestion() {
    setState(() {
      currentSymbol =
          katakanaMap.keys.elementAt(random.nextInt(katakanaMap.length));

      options.clear();
      options.add(katakanaMap[currentSymbol]!);

      while (options.length < 4) {
        String randomReading =
            katakanaMap.values.elementAt(random.nextInt(katakanaMap.length));
        if (!options.contains(randomReading)) {
          options.add(randomReading);
        }
      }

      options.shuffle();
      progress++;
    });
  }

  void handleAnswer(String selectedAnswer) {
    if (selectedAnswer == katakanaMap[currentSymbol]) {
      // Верный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Верно!",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 360,
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              correctAnswers++;
                            });
                            if (progress == 9) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('Результаты тренировки',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 22,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w800,
                                          )),
                                      content: Text(
                                          'Количество ошибок: $incorrectAnswers',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                          )),
                                      actions: <Widget>[
                                        Row(children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  random = Random();
                                                  currentSymbol;
                                                  options = [];
                                                  correctAnswers = 0;
                                                  incorrectAnswers = 0;
                                                  progress = -1;
                                                  generateQuestion();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              34,
                                                              197,
                                                              94)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text(
                                                    "Пройти снова",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Training()));
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              52,
                                                              172,
                                                              224)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text("Закончить",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                        ]),
                                      ]);
                                },
                              );
                            } else {
                              generateQuestion();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 40, 167, 69)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          child: const Text("Продолжить",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              )),
                        )),
                  ],
                ),
              ]);
        },
      );
    } else {
      // Неправильный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Неверно!',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 360,
                          margin: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                incorrectAnswers++;
                              });
                              if (progress == 9) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            'Результаты тренировки',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 22,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w800,
                                            )),
                                        content: Text(
                                            'Количество ошибок: $incorrectAnswers',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 20,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500,
                                            )),
                                        actions: <Widget>[
                                          Row(children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    random = Random();
                                                    currentSymbol;
                                                    options = [];
                                                    correctAnswers = 0;
                                                    incorrectAnswers = 0;
                                                    progress = -1;
                                                    generateQuestion();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                34,
                                                                197,
                                                                94)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text(
                                                      "Пройти снова",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Training()));
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                52,
                                                                172,
                                                                224)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text("Закончить",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                          ]),
                                        ]);
                                  },
                                );
                              } else {
                                generateQuestion();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 239, 68, 68)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text("Продолжить",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                )),
                          )),
                    ])
              ]);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 62, 62, 62),
        ),
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        title: const Text(
          'Тренировка катаканы',
          style: TextStyle(
            color: Color.fromARGB(255, 62, 62, 62),
            fontSize: 26,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 62, 62, 62),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: const Color.fromARGB(255, 193, 207, 226),
                color: const Color.fromARGB(255, 52, 172, 224),
                value: progress / 10,
              ),
            ),
            const Text(
              'Выберите верный перевод:',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 18,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              width: 140,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 187, 221, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentSymbol,
                style: const TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 64,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 2,
                children: options.map((option) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () => handleAnswer(option),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 255, 255)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))
                              // ignore: prefer_const_constructors

                              ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 36,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingWords extends StatefulWidget {
  @override
  _TrainingWordsState createState() => _TrainingWordsState();
}

class _TrainingWordsState extends State<TrainingWords> {
  Random random = Random();
  late String currentSymbol;
  List<String> options = [];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int progress = -1;

  void generateQuestion() {
    setState(() {
      currentSymbol = WordsMap.keys.elementAt(random.nextInt(WordsMap.length));

      options.clear();
      options.add(WordsMap[currentSymbol]!);

      while (options.length < 4) {
        String randomReading =
            WordsMap.values.elementAt(random.nextInt(WordsMap.length));
        if (!options.contains(randomReading)) {
          options.add(randomReading);
        }
      }

      options.shuffle();
      progress++;
    });
  }

  void handleAnswer(String selectedAnswer) {
    if (selectedAnswer == WordsMap[currentSymbol]) {
      // Верный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text("Верно!",
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        width: 360,
                        margin: const EdgeInsets.only(
                            right: 10, left: 10, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            setState(() {
                              correctAnswers++;
                            });
                            if (progress == 9) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                      title: const Text('Результаты тренировки',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 22,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w800,
                                          )),
                                      content: Text(
                                          'Количество ошибок: $incorrectAnswers',
                                          textAlign: TextAlign.center,
                                          textDirection: TextDirection.ltr,
                                          style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 54, 54, 54),
                                            fontSize: 20,
                                            fontFamily: 'Nunito',
                                            fontWeight: FontWeight.w500,
                                          )),
                                      actions: <Widget>[
                                        Row(children: [
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  random = Random();
                                                  currentSymbol;
                                                  options = [];
                                                  correctAnswers = 0;
                                                  incorrectAnswers = 0;
                                                  progress = -1;
                                                  generateQuestion();
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              34,
                                                              197,
                                                              94)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text(
                                                    "Пройти снова",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 10),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Training()));
                                                },
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          const Color.fromARGB(
                                                              255,
                                                              52,
                                                              172,
                                                              224)),
                                                  shape: MaterialStateProperty.all(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0))
                                                      // ignore: prefer_const_constructors

                                                      ),
                                                ),
                                                child: const Text("Закончить",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                      fontSize: 18,
                                                      fontFamily: 'Nunito',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              )),
                                        ]),
                                      ]);
                                },
                              );
                            } else {
                              generateQuestion();
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color.fromARGB(255, 40, 167, 69)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                          ),
                          child: const Text("Продолжить",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 18,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w400,
                              )),
                        )),
                  ],
                ),
              ]);
        },
      );
    } else {
      // Неправильный ответ
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: const Text('Неверно!',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.ltr,
                  style: TextStyle(
                    color: Color.fromARGB(255, 54, 54, 54),
                    fontSize: 22,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  )),
              actions: <Widget>[
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                          width: 360,
                          margin: const EdgeInsets.only(
                              right: 10, left: 10, bottom: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              setState(() {
                                incorrectAnswers++;
                              });
                              if (progress == 9) {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                        title: const Text(
                                            'Результаты тренировки',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 22,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w800,
                                            )),
                                        content: Text(
                                            'Количество ошибок: $incorrectAnswers',
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.ltr,
                                            style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 54, 54, 54),
                                              fontSize: 20,
                                              fontFamily: 'Nunito',
                                              fontWeight: FontWeight.w500,
                                            )),
                                        actions: <Widget>[
                                          Row(children: [
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                    random = Random();
                                                    currentSymbol;
                                                    options = [];
                                                    correctAnswers = 0;
                                                    incorrectAnswers = 0;
                                                    progress = -1;
                                                    generateQuestion();
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                34,
                                                                197,
                                                                94)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text(
                                                      "Пройти снова",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                            Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10,
                                                    left: 10,
                                                    bottom: 10),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                Training()));
                                                  },
                                                  style: ButtonStyle(
                                                    backgroundColor:
                                                        MaterialStateProperty
                                                            .all(const Color
                                                                    .fromARGB(
                                                                255,
                                                                52,
                                                                172,
                                                                224)),
                                                    shape: MaterialStateProperty.all(
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0))
                                                        // ignore: prefer_const_constructors

                                                        ),
                                                  ),
                                                  child: const Text("Закончить",
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 255, 255, 255),
                                                        fontSize: 18,
                                                        fontFamily: 'Nunito',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      )),
                                                )),
                                          ]),
                                        ]);
                                  },
                                );
                              } else {
                                generateQuestion();
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  const Color.fromARGB(255, 239, 68, 68)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            ),
                            child: const Text("Продолжить",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  fontSize: 18,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w400,
                                )),
                          )),
                    ])
              ]);
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    generateQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 62, 62, 62),
        ),
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        title: const Text(
          'Тренировка Слов',
          style: TextStyle(
            color: Color.fromARGB(255, 62, 62, 62),
            fontSize: 26,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              height: 10,
              decoration: BoxDecoration(
                color: const Color.fromARGB(0, 62, 62, 62),
                borderRadius: BorderRadius.circular(10),
              ),
              child: LinearProgressIndicator(
                minHeight: 10,
                backgroundColor: const Color.fromARGB(255, 193, 207, 226),
                color: const Color.fromARGB(255, 52, 172, 224),
                value: progress / 10,
              ),
            ),
            const Text(
              'Выберите верный перевод:',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 18,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(10.0),
              width: 280,
              height: 100,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 187, 221, 245),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                currentSymbol,
                style: const TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 36,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(26.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 20.0,
                crossAxisSpacing: 20.0,
                crossAxisCount: 2,
                children: options.map((option) {
                  return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ElevatedButton(
                        onPressed: () => handleAnswer(option),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              const Color.fromARGB(255, 255, 255, 255)),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))
                              // ignore: prefer_const_constructors

                              ),
                        ),
                        child: Text(
                          option,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 62, 62, 62),
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Courses extends StatefulWidget {
  @override
  _Courses createState() => _Courses();
}

class _Courses extends State<Courses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(248, 248, 248, 248),
      appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Color.fromARGB(255, 62, 62, 62),
          ),
          backgroundColor: const Color.fromARGB(248, 248, 248, 248),
          title: const Text(
            'Octopus',
            style: TextStyle(
              color: Color.fromARGB(255, 62, 62, 62),
              fontSize: 26,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            Container(
              height: 20,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage("lib/images/ru_flag.png"),
                ),
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  FontAwesomeIcons.bell,
                  color: Color.fromARGB(255, 62, 62, 62),
                  size: 20,
                )),
          ]),
      drawer: Drawer(
        child:
            ListView(padding: const EdgeInsets.symmetric(), children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                    child: ClipOval(
                      child: SizedBox(
                        width: 30 * 2,
                        height: 30 * 2,
                        child: Image(
                          image: NetworkImage(avatar),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 24,
                    indent: 24,
                    color: Color.fromARGB(0, 0, 0, 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              username,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14.0,
                                fontFamily: 'Nunito',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ]),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MySett()));
                            },
                            icon: const Icon(
                              FontAwesomeIcons.gear,
                              color: Color.fromARGB(255, 255, 255, 255),
                              size: 20,
                            )),
                      )
                    ],
                  )
                ]),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainPage()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.houseChimney,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Главная",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Dictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.bookOpen,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrivateDictionary()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.book,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Личный словарь",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Training()));
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 241, 241, 241)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.dumbbell,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Тренировки",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
          const Divider(
            height: 14,
            thickness: 1,
            endIndent: 24,
            indent: 24,
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            //color: Color.fromARGB(235, 235, 87, 87),
            margin: const EdgeInsets.all(0.0),
            child: OutlinedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(235, 209, 204, 192)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    // ignore: prefer_const_constructors
                    side: BorderSide(
                        width: 0,
                        color: const Color.fromARGB(0, 255, 255, 255)),
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(
                    FontAwesomeIcons.houseChimney,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 16,
                  ),
                  Divider(
                    indent: 14,
                  ),
                  Text("Курсы",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                      )),
                ],
              ),
            ),
          ),
        ]),
      ),
      body: SafeArea(
        child: ListView(
            padding: const EdgeInsets.all(16),
            scrollDirection: Axis.vertical,
            children: const [
              Text(
                'Курсы',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 26,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w900,
                ),
              ),
              Divider(
                height: 14,
                color: Color.fromARGB(0, 62, 62, 62),
                thickness: 1,
                endIndent: 24,
                indent: 24,
              ),
              Text(
                'Здесь пока ничего нет...',
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 18,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]),
      ),
    );
  }
}

class MySett extends StatefulWidget {
  @override
  _MySett createState() => _MySett();
}

class _MySett extends State<MySett> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(248, 248, 248, 248),
        appBar: AppBar(
            centerTitle: true,
            iconTheme: const IconThemeData(
              color: Color.fromARGB(255, 62, 62, 62),
            ),
            backgroundColor: const Color.fromARGB(248, 248, 248, 248),
            title: const Text(
              'Octopus',
              style: TextStyle(
                color: Color.fromARGB(255, 62, 62, 62),
                fontSize: 26,
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w900,
              ),
            ),
            actions: [
              Container(
                height: 20,
                width: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: AssetImage("lib/images/ru_flag.png"),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    FontAwesomeIcons.bell,
                    color: Color.fromARGB(255, 62, 62, 62),
                    size: 20,
                  )),
            ]),
        drawer: Drawer(
          child: ListView(
              padding: const EdgeInsets.symmetric(),
              children: <Widget>[
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                          child: ClipOval(
                            child: SizedBox(
                              width: 30 * 2,
                              height: 30 * 2,
                              child: Image(
                                image: NetworkImage(avatar),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          height: 20,
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.0,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  Text(
                                    email,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 14.0,
                                      fontFamily: 'Nunito',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              height: 40,
                              width: 40,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    FontAwesomeIcons.gear,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    size: 20,
                                  )),
                            )
                          ],
                        )
                      ]),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainPage()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.houseChimney,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Главная",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.bookOpen,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Словарь",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrivateDictionary()));
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.book,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Личный словарь",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.dumbbell,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Тренировки",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  //color: Color.fromARGB(235, 235, 87, 87),
                  margin: const EdgeInsets.all(0.0),
                  child: OutlinedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(235, 241, 241, 241)),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // ignore: prefer_const_constructors
                          side: BorderSide(
                              width: 0,
                              color: const Color.fromARGB(0, 255, 255, 255)),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          FontAwesomeIcons.flagCheckered,
                          color: Color.fromARGB(255, 62, 62, 62),
                          size: 16,
                        ),
                        Divider(
                          indent: 14,
                        ),
                        Text("Курсы",
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(
                              color: Color.fromARGB(255, 62, 62, 62),
                              fontSize: 16,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            )),
                      ],
                    ),
                  ),
                ),
              ]),
        ),
        body: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Основная информация',
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 26,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                  child: RawMaterialButton(
                    onPressed: () {},
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                      child: ClipOval(
                        child: SizedBox(
                          width: 30 * 2,
                          height: 30 * 2,
                          child: Image(
                            image: NetworkImage(avatar),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: namecontroller,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 62, 62, 62),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(235, 235, 87, 87),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      hintText: 'Ваше имя',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: emailcontroller,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 62, 62, 62),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(235, 235, 87, 87),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      hintText: 'Ваш адрес электронной почты',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                const Text(
                  'Безопасность',
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 26,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: secpasscontroller,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 62, 62, 62),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(235, 235, 87, 87),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      hintText: 'Введите новый пароль',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 10,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                  height: 40,
                  child: TextField(
                    controller: secpasscontroller,
                    textAlignVertical: TextAlignVertical.bottom,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 62, 62, 62),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(235, 235, 87, 87),
                              width: 1.0),
                          borderRadius:
                              BorderRadius.all(Radius.circular(64.0))),
                      hintText: 'Подтвердите новый пароль',
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 62, 62, 62),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 14,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                    child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MainPage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 52, 172, 224)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // ignore: prefer_const_constructors
                        side: BorderSide(
                            width: 0,
                            color: const Color.fromARGB(255, 52, 172, 224)),
                      ),
                    ),
                  ),
                  child: const Text("Сохранить изменения",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      )),
                )),
                const Divider(
                  height: 20,
                  color: Color.fromARGB(0, 62, 62, 62),
                  thickness: 1,
                  endIndent: 24,
                  indent: 24,
                ),
                SizedBox(
                    child: ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('Username');
                    prefs.remove('Pass');
                    await Future.delayed(const Duration(seconds: 1));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => WelcomePage()));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(235, 235, 87, 87)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        // ignore: prefer_const_constructors
                        side: BorderSide(
                            width: 0,
                            color: const Color.fromARGB(235, 235, 87, 87)),
                      ),
                    ),
                  ),
                  child: const Text("Выйти из аккаунта",
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w400,
                      )),
                )),
              ]),
        )));
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ByteData data =
      await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
  SecurityContext.defaultContext
      .setTrustedCertificatesBytes(data.buffer.asUint8List());

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: WelcomePage(),
    routes: {
      '/wel': (BuildContext context) => WelcomePage(),
      '/log': (BuildContext context) => LoginPage(),
      '/reg': (BuildContext context) => RegPage(),
      '/fpass': (BuildContext context) => const ForpassPage(),
      '/main': (BuildContext context) => MainPage(),
      '/dict': (BuildContext context) => Dictionary(),
      '/mydict': (BuildContext context) => PrivateDictionary(),
      '/sett': (BuildContext context) => MySett(),
      '/train': (BuildContext context) => Training(),
      '/train_hira': (BuildContext context) => TrainingHiragana(),
      '/train_kata': (BuildContext context) => TrainingKatakana(),
      '/train_words': (BuildContext context) => TrainingWords(),
      '/course': (BuildContext context) => Courses(),
    },
  ));
}
