import 'package:flutter/material.dart';
import 'package:shoplazy/SignUp.dart';
import 'package:shoplazy/StartScreen.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  BuildContext scaffoldContext;
  bool isChecked = false;
  final formKey =
      new GlobalKey<FormState>(); //I know global variables ar bad, but idc atm

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Builder(builder: (BuildContext context) {
      scaffoldContext = context;
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _title(),
            _usernameAndPasswords(),
            _loginAndSignup(context),
          ],
        ),
      );
    }));
  }

  String _email;
  String _pass;

  Widget _loginAndSignup(context) {
    return Column(children: [
      ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: [
          OutlinedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => SignUp())),
              child: Text("Sign Up")),
          ElevatedButton(
              onPressed: () => validateAndSubmit(), child: Text("Login")),
        ],
      ),
      InkWell(
        onTap: () => setState(() => isChecked = !isChecked),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Checkbox(
              value: isChecked,
              onChanged: (bool) => setState(() => isChecked = !isChecked),
            ),
            Text("Stay logged in?")
          ],
        ),
      )
    ]);
  }

  void validateAndSubmit() {
    print("attempting to login");
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print(_email + ":" + _pass);

      if (_email != "test@test.com") {
        createSnackBar('No user found for that email.');
        return;
      }
      if (_pass != "test12") {
        createSnackBar('Wrong password provided for that user.');
        return;
      }
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => StartScreen()));
    } else {
      print("not validated!");
    }
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }

  Widget _usernameAndPasswords() {
    return Container(
        margin: const EdgeInsets.all(20.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              //margin: const EdgeInsets.only(bottom: 5.0),
              Container(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                    initialValue: "test@test.com",
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) => value.isEmpty ? 'BOOO!!!' : null,
                    onSaved: (value) => _email = value),
              ),
              TextFormField(
                  initialValue: "test12",
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  validator: (value) => value.isEmpty ? 'BOOO!!!' : null,
                  onSaved: (value) => _pass = value),
            ],
          ),
        ));
  }

  Widget _title() {
    return Text(
      "ShopLazy",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 50),
    );
  }
}
