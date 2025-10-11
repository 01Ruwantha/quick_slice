import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Tutorial extends StatefulWidget {
  const Tutorial({super.key});

  @override
  State<Tutorial> createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> {
  List<String> studentsList = [];
  late Future<List<String>> futureStudents;

  Future<List<String>> addStudent() async {
    studentsList.clear(); // prevent duplicates
    var uri = Uri.parse('https://jsonplaceholder.typicode.com/users');
    http.Response res = await http.get(uri);
    var body = jsonDecode(res.body);
    for (var student in body) {
      studentsList.add(student['name']);
    }
    return studentsList;
  }

  @override
  void initState() {
    super.initState();
    futureStudents = addStudent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<String>>(
          future: futureStudents,
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final data = snapshot.data![index];
                    return ListTile(
                      title: Text(data),
                      leading: Text('🤣${index + 1}'),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
