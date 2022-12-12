// @dart=2.9
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/firebase_ml_api.dart';
import 'package:project/function.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = '';
  File image;
  var output = [];
  var disease_;
  var alternative_med = [];

  final url = 'http://127.0.0.1:5000/api/med/';

  Future fetchdata() async {
    http.Response response;
    response = await http.get(Uri.parse(url + 'detect/' + text));
    if (response.statusCode == 200) {
      setState(() {
        disease_ = response.body;
      });
      print(disease_);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchdata();
  }

  detect_data() async {
    var data = await jsonDecode(fetchData(url + 'detect/' + text));
    setState(() {
      output = data;
    });
  }

  disease() async {
    var data = await (fetchData(url + text));
    setState(() {
      disease_ = data['aid'];
    });
  }

  alternative() async {
    var data = await jsonDecode(fetchData(url + 'disease/' + disease_));
    setState(() {
      alternative_med = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('S U N H A C K  22'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[300],
                  ),
                  child: image != null
                      ? Image.file(image)
                      : Icon(
                          Icons.photo,
                          size: 60,
                        ),
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      pickImage();
                    },
                    child: Text('Choose from gallery'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      pickImageFromCamera();
                    },
                    child: Text('Choose from camera'),
                  ),
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        scanText();

                        Future.delayed(Duration(seconds: 2), () {
                          detect_data();
                          Future.delayed(Duration(seconds: 2), () {
                            fetchdata();
                            Future.delayed(Duration(seconds: 1), () {
                              alternative();
                            });
                          });
                        });
                      },
                      child: Text('scan for text'),
                    ),
                  ),
                  Container(
                    width: 170,
                    child: ElevatedButton(
                      onPressed: () {
                        clear();
                      },
                      child: Text('clear'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.center,
                  child: SelectableText(
                    text + '  disease=>' + disease_.toString(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: 05),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        output.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: 200,
                      decoration: BoxDecoration(border: Border.all()),
                      child: Text(
                        alternative_med.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    setImage(File(file.path));
  }

  Future pickImageFromCamera() async {
    final file = await ImagePicker().getImage(source: ImageSource.camera);
    setImage(File(file.path));
  }

  Future scanText() async {
    showDialog(
        context: context,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    final text = await FirebaseMLApi.recogniseText(image);

    setText(text);

    Navigator.of(context).pop();
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  void clear() {
    setImage(null);
    setText('');
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }
}
