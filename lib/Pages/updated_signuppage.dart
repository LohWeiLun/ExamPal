import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class UpdatedSignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                        duration: Duration(seconds: 1),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1200),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1300),
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/clock.png'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      child: FadeInUp(
                        duration: Duration(milliseconds: 1600),
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    // Add a TextField for Name
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    // Add a TextField for Email Address
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Email Address",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    // Add a TextField for Password
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Password",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    // Add a TextField for Confirm Password
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: Color.fromRGBO(143, 148, 251, 1),
                            ),
                          ),
                        ),
                        child: TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Confirm Password",
                            hintStyle: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    // Replace the "Login" button with a "Sign Up" button
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    // Add a "Already have an account? Login" option
                    FadeInUp(
                      duration: Duration(milliseconds: 2000),
                      child: Text(
                        "Already have an account? Login",
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
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
}
