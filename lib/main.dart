// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:apiapp/models/user.dart';
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
      debugShowCheckedModeBanner: false,
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
  Future<List<UserModel>> getUsers() async {
    var response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    final List data = jsonDecode(response.body);

    return data.map((e) => UserModel.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: getUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong! Please, try again'),
            );
          }

          var users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (_, index) => ListTile(
              leading: const Icon(Icons.person),
              title: Text(users[index].name),
              subtitle: Text(users[index].email),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => setState(() {}),
        tooltip: 'Get Users',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
