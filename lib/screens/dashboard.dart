import 'dart:convert' as convert;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/server.dart';
import '../models/mockapi.dart';

class OneScreen extends StatefulWidget {
  OneScreen({Key key}) : super(key: key);

  @override
  _OneScreenState createState() => _OneScreenState();
}

class _OneScreenState extends State<OneScreen> {
  List<Mockapi> datareceived = [];
  var _press;
  storedata() async {
    http.Response response = await Server.fetchdata();
    // print('data is here ${response.body}');
    // print('runtime type of body ${response.body.runtimeType}');
    List<dynamic> list = convert.jsonDecode(response.body);
    datareceived = list
        .map((dynamic userdetails) => new Mockapi(userdetails['name'],
            userdetails['avatar'], userdetails['createdAt']))
        .toList();
    // print("!!!${datareceived.length}!!!");
  }

  onPress(bool pressed) {
    _press = pressed;
    return _press;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storedata();
  }

  // _nodatarecieved() {
  //   return Container(
  //     child: Center(
  //       child: CircularProgressIndicator(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'DashBoard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.grey,
      ),
      // floatingActionButton: MaterialButton(
      //   elevation: 5,
      //   highlightColor: Colors.white,
      //   shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.all(Radius.circular(15))),
      //   color: Colors.blueGrey,
      //   child: Text(
      //     'Fetch',
      //     style: TextStyle(color: Colors.white60, fontStyle: FontStyle.italic),
      //   ),
      //   onPressed: () {},
      // ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            onPress(true);
            print('FAB set state called');
          });
        },
        label: Text('Download Data'),
        elevation: 5,
        icon: Icon(Icons.cloud_download_outlined),
        backgroundColor: Colors.blueGrey,
        splashColor: Colors.white,
      ),
      body: Container(
          child: _press == true
              ? FutureBuilder(
                  future: Server.fetchdata(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapShot) {
                    print(snapShot);
                    if (snapShot.hasData == true &&
                        snapShot.connectionState == ConnectionState.done &&
                        snapShot.data != null) {
                      // dynamic userdetails = snapShot.data[''];
                      print('Here I\'m ${snapShot.connectionState}');
                      return ListView.builder(
                          itemCount: datareceived.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(datareceived[index].avatar),
                                ),
                                title: Text(datareceived[index].name),
                                subtitle: Text(datareceived[index].createdAt),
                              ),
                            );
                          });
                    } else if (snapShot.hasError) {
                      return Center(
                        child: Text(
                          'Some Error Occur ',
                          style: TextStyle(fontSize: 40),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.lightBlue),
                          backgroundColor: Colors.blueGrey,
                        ),
                      );
                    }
                  },
                )
              : Center(
                  child: Text(
                    'Press Button to Fetch Data',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54),
                  ),
                )),
    );
  }
}
