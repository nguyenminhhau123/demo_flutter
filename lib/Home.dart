import 'package:demo/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final userList;
  const Home({Key? key, @required this.userList}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String lastname;
  late String firstname;
  late String mobile;
  late String email;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Map<String, dynamic> userdata = widget.userList;
    lastname = userdata['lastname'];
    firstname = userdata['firstname'];
    mobile = userdata['mobile'];
    email = userdata['email'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  // alignment: Alignment.topLeft,
                  child: Text(
                    'Welcome,' + firstname + ' ' + lastname,
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.phone),
                      label: Text(mobile)),
                ),
                Container(
                  child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.email),
                      label: Text(email)),
                ),
                Container(
                  child: OutlinedButton.icon(
                      onPressed: () {
                        logout();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Login()));
                      },
                      icon: Icon(Icons.logout),
                      label: Text('Logout')),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      Response response = await get(
        // Uri.parse('https://dummyjson.com/auth/login'),
        Uri.parse(
            'https://e-commerce-backend-u0i4.onrender.com/api/user/logout'),
      );
      Data data = Data.fromJson(jsonDecode(response.body.toString()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          data.mess,
        ),
        backgroundColor: Colors.red,
      ));
      print(data.mess);
    } catch (e) {
      print(e.toString());
    }
  }
}

class Data {
  late String mess;
  Data(this.mess);
  Data.fromJson(Map<String, dynamic> json) {
    mess = json["mess"];
  }
}
