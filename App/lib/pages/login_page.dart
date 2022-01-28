import 'dart:developer';
import 'dart:html';

import 'package:application/models/login_request_model.dart';
import 'package:application/models/login_response_model.dart';
import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAPIcallProcess = false;
  bool hidePssword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey();
  String? username;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#5B5B5B"),
        body: ProgressHUD(
          key: UniqueKey(),
          inAsyncCall: isAPIcallProcess,
          child: Form(key: globalFormKey, child: _loginUI(context)),
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Container(
            width: width,
            height: height / 3,
            decoration: BoxDecoration(
                color: HexColor("#FFFFFF"),
                borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(80),
                    bottomLeft: Radius.circular(80))),
            child: Align(
              alignment: Alignment.center,
              child: Image.asset("assets/images/logo.png",
                  width: 200, fit: BoxFit.contain),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 50, bottom: 50),
            child: Text("Login",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: FormHelper.inputFieldWidget(
                context, const Icon(Icons.person), "username", "username",
                (onValidate) {
              if (onValidate.isEmpty) return 'Username can\'t be empty';
            }, (onSaved) {
              username = onSaved;
            },
                borderFocusColor: Colors.white,
                textColor: Colors.white,
                hintColor: Colors.white.withOpacity(0.4),
                prefixIconColor: Colors.white,
                borderColor: Colors.white,
                validationColor: Colors.red),
          ),
          FormHelper.inputFieldWidget(
              context, const Icon(Icons.person), "password", "password",
              (onValidate) {
            if (onValidate.isEmpty) return 'Password can\'t be empty';
          }, (onSaved) {
            password = onSaved;
          },
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.4),
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              validationColor: Colors.red,
              obscureText: hidePssword,
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePssword = !hidePssword;
                      });
                    },
                    color: Colors.white.withOpacity(0.7),
                    icon: Icon(
                        hidePssword ? Icons.visibility_off : Icons.visibility)),
              )),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Login",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  LoginRegisterRequestModel model = LoginRegisterRequestModel(
                      username: username!, password: password!);
                  APIService.login(model).then((res) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (res) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } else {
                      showToast(context);
                    }
                  });
                }
              },
              btnColor: Colors.redAccent,
              borderColor: Colors.redAccent,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
              child: Text("OR",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold))),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: FormHelper.submitButton("Register", () {
              Navigator.pushNamed(context, "/register");
            }, btnColor: HexColor("#5B5B5B"), borderColor: Colors.white),
          ),
        ]));
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void showToast(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Invalid Username/Password! '),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
