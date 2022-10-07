import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'dart:convert';

extension Log on Object {
  void log() => devtools.log(toString());
}

void main() { runApp(MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
        home: const HomePage(),
    ),
  );
}

@immutable
class Person{
  final String name;
  final int age;

  const Person({
    required this.name,
    required this.age,
  });

  Person.fromJson(Map<String, dynamic> json)
    : name = json['name'] as String,
      age = json['age'] as int;

  @override 
  String toString() {
    return 'Person ($name, $age, years old)';
  }

}

const people1Url = 'http://127.0.0.1:5500/apis/people.json';
const people2Url = 'http://127.0.0.1:5500/apis/people2.json';

Future<Iterable<Person>> parseJson(url) => HttpClient()
  .getUrl(Uri.parse(url))
  .then((req) => req.close())
  .then((resp) => resp.transform(utf8.decoder).join())
  .then((str) => json.decode(str) as List<dynamic>)
  .then((json) => json.map((e) => Person.fromJson(e)));

void testIt() async {
  final persons = await Future.wait([
    parseJson(people1Url),/// .catchError((_, __) => Iterable<Person>.empty()),
    parseJson(people2Url)
  ]).catchError((_, __) => Iterable<Person>.empty()); /// forma 2 para capturar errores  // pueden denominarse individualmente o en bloque de varios llamados
  persons.log();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    testIt();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: const Center(
        child: Text('Hello World'),
      ),
    );
  }
}
