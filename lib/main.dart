// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API Integration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'API Integration Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> users = [];

  getUsers() async {
    try {
      var response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );
      print(response.statusCode);
      print(response.body.runtimeType);

      final data = jsonDecode(response.body);

      users.clear();

      for (var user in data) {
        users.add({"name": user['name'], "email": user['email']});
      }

      setState(() {});
    } catch (e) {
      print(e.runtimeType);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (_, index) => ListTile(
          leading: const Icon(Icons.person),
          title: Text(users[index]['name']!),
          subtitle: Text(users[index]['email']!),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getUsers,
        tooltip: 'Get Users',
        child: const Icon(Icons.add),
      ),
    );
  }
}
