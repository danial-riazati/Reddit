import 'package:application/models/login_response_model.dart';
import 'package:application/models/register_request_model.dart';
import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool isAPIcallProcess = false;
  bool hidePssword = true;
  GlobalKey<FormState> globalFormKey = GlobalKey();
  String? username;
  String? password;
  String? email;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: HexColor("#C5C5C5"),
        body: ProgressHUD(
          key: UniqueKey(),
          inAsyncCall: isAPIcallProcess,
          child: Form(key: globalFormKey, child: _registerUI(context)),
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _registerUI(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 50, bottom: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    padding: const EdgeInsets.all(15),
                    onPressed: () {
                      return Navigator.pop(context);
                    },
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back)),
                const Text("Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white))
              ],
            ),
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
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: FormHelper.inputFieldWidget(
                context, const Icon(Icons.vpn_key), "password", "password",
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
                      icon: Icon(hidePssword
                          ? Icons.visibility_off
                          : Icons.visibility)),
                )),
          ),
          FormHelper.inputFieldWidget(
              context, const Icon(Icons.email), "email", "email", (onValidate) {
            if (onValidate.isEmpty) return 'email can\'t be empty';
          }, (onSaved) {
            email = onSaved;
          },
              borderFocusColor: Colors.white,
              textColor: Colors.white,
              hintColor: Colors.white.withOpacity(0.4),
              prefixIconColor: Colors.white,
              borderColor: Colors.white,
              validationColor: Colors.deepPurpleAccent,
              obscureText: false),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    isAPIcallProcess = true;
                  });
                  RegisterRequestModel model = RegisterRequestModel(
                      username: username!, password: password!, email: email!);
                  APIService.register(model).then((res) {
                    setState(() {
                      isAPIcallProcess = false;
                    });
                    if (res.runtimeType == LoginRegisterResponseModel) {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/login', (route) => false);
                    } else {
                      showToast(context, res);
                    }
                  });
                }
              },
              btnColor: Colors.deepPurpleAccent,
              borderColor: Colors.deepPurpleAccent,
            ),
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

  void showToast(BuildContext context, String body) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(body),
        action: SnackBarAction(
            label: 'UNDO', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
