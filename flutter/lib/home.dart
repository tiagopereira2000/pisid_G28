import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart'; // Import the mysql1 package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'dart:io';


import 'New folder/readings3.dart';

class Home extends StatelessWidget{
  const Home({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    const appTitle = 'Home Page';

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(appTitle),
      ),
      body: const ReadingsMain(),
    );
  }

}

class ReadingsMain extends StatefulWidget {
  const ReadingsMain({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ReadingsMain> {
  List<String> items = []; //lista vazia onde vão ser inseridas as experiências do Investigador
  List<bool> checkedItems = [];
  bool isButtonEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchExperimentNames();
  }

  Future<void> fetchExperimentNames() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String? password = prefs.getString('password');
    String? ip = prefs.getString('ip');
    String? port = prefs.getString('port');
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '127.0.0.1',
      port: int.parse(port!),
      user: username!,
      password: password!,
      db: 'pisid_new',
    ));

    final results = await conn.query('SELECT IDexperiencia, Descrição FROM experiencia');
    for (var row in results) {
      items.add(row['Descrição'].toString());
    }

    await conn.close();

    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:[
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Text(
          //     'Sem Experiências Ativas',
          //     style: TextStyle(
          //       fontSize: 24,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          // ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(items[index]),
                  value: checkedItems[index],
                  onChanged: (bool? value) {
                    setState(() {
                      checkedItems[index] = value!;
                      isButtonEnabled = checkedItems.contains(true);
                    });
                  },
                );
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: isButtonEnabled ? () {} : null,
              child: Text(
                'Começar Experiência',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: ElevatedButton(
          onPressed: (){
            Navigator.pop(context);
          }, 
          child: const Text('Alerts'),
        ),
      ),

    );
    // TODO: implement build
    throw UnimplementedError();
  }
}