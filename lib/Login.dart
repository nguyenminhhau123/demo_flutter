import 'dart:convert';
import 'dart:convert' as convert;
import 'package:demo/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late SharedPreferences prefs;
  @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   initSharedPref();
  // }
  //
  // void initSharedPref() async {
  //   prefs = await SharedPreferences.getInstance();
  // }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 34, fontWeight: FontWeight.w700),
                            ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Welcome back, Guys',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.green),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'Email',
                          suffixIcon: Icon(Icons.email),
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        labelText: 'Password',
                        suffixIcon: Icon(Icons.password),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        login(emailController.text.toString(),
                            passwordController.text.toString());
                      },
                      child: Container(
                        height: 60,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> login(String email, String password) async {
    var reqBody = {'email': email, 'password': password};
    try {
      Response response = await post(
          Uri.parse(
              'https://e-commerce-backend-u0i4.onrender.com/api/user/login/'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      // final data = BaseResponse<Token>.fromJson(jsonDecode(response), () => Token());

      if (email.isEmpty || password.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Missing input",
          ),
          backgroundColor: Colors.red,
        ));
      } else if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success']) {
          print(jsonResponse['userData']);
          var myData = jsonResponse['userData'];
          // prefs.setString('token', myToken);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home(userList: myData)));
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Login success")));
        }
        print('Response body: ${response.body}');
      } else if (response.statusCode == 404) {
        print('Not found');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Invalid Credential"),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

class BaseResponse<T> {
  bool success;
  T userData;

  BaseResponse({required this.success, required this.userData});

  BaseResponse parseJson(Map<String, dynamic> json, BaseObject target) {
    return BaseResponse(
      success: json['success'],
      userData: target.fromJson(json['userData']),
    );
  }
}

abstract class BaseObject<T> {
  T fromJson(Map<String, dynamic> json);
}

class Token extends BaseObject<Token> {
  String accessToken;
  List<dataUser> userdata;

  Token({required this.accessToken, required this.userdata});

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["accessToken"],
        userdata: parseProductList(json),
      );

  static List<dataUser> parseProductList(Map<String, dynamic> map) {
    if (map['userData'] is List) {
      var list = map['userData'] as List;
      return list.map((user) => dataUser.fromJson(user)).toList();
    } else {
      // Handle the case where 'userData' is not a list, perhaps by returning an empty list or throwing an exception.
      return [];
    }
  }

  @override
  Token fromJson(Map<String, dynamic> json) {
    return Token.fromJson(json);
  }
}

class dataUser {
  String id;
  String firstname;
  String lastname;
  String email;
  String mobile;

  dataUser({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.mobile,
  });

  factory dataUser.fromJson(Map<String, dynamic> json) => dataUser(
        id: json["id"],
        firstname: json["firstname"].toString(),
        lastname: json["lastname"].toString(),
        email: json["email"].toString(),
        mobile: json["mobile"],
      );
}
