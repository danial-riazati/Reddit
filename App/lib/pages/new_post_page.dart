import 'package:application/models/post_model.dart';
import 'package:application/models/request_post_model.dart';
import 'package:application/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  GlobalKey<FormState> globalFormKey = GlobalKey();
  bool isAPIcallProcess = false;
  String? community_name;
  String? text;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('reddit'),
          backgroundColor: Colors.grey,
        ),
        body: ProgressHUD(
          key: UniqueKey(),
          inAsyncCall: isAPIcallProcess,
          child: Form(key: globalFormKey, child: _myWidget(context)),
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget _myWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/home', (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.grey,
            )),
        Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: FormHelper.inputFieldWidget(
                      context,
                      const Icon(
                        Icons.people_outline,
                        color: Colors.deepPurple,
                      ),
                      "Community name",
                      "Community name", (onValidate) {
                    if (onValidate.isEmpty)
                      return 'Community name can\'t be empty';
                  }, (onSaved) {
                    community_name = onSaved;
                  },
                      borderFocusColor: Colors.deepPurple,
                      textColor: Colors.black,
                      hintColor: Colors.deepPurple.withOpacity(0.4),
                      prefixIconColor: Colors.white,
                      borderColor: Colors.deepPurple,
                      validationColor: Colors.deepPurpleAccent),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: FormHelper.inputFieldWidget(
                      context,
                      const Icon(
                        Icons.text_fields,
                        color: Colors.deepPurple,
                      ),
                      "text",
                      "text", (onValidate) {
                    if (onValidate.isEmpty) return 'text can\'t be empty';
                  }, (onSaved) {
                    text = onSaved;
                  },
                      borderFocusColor: Colors.deepPurple,
                      textColor: Colors.black,
                      hintColor: Colors.deepPurple.withOpacity(0.4),
                      prefixIconColor: Colors.white,
                      borderColor: Colors.deepPurple,
                      validationColor: Colors.deepPurpleAccent),
                ),
                Center(
                  child: FormHelper.submitButton(
                    "Add Post",
                    () {
                      if (validateAndSave()) {
                        setState(() {
                          isAPIcallProcess = true;
                        });
                        RequestPostModel model = RequestPostModel(
                            communityName: community_name!, text: text!);
                        APIService.addPost(model).then((res) {
                          setState(() {
                            isAPIcallProcess = false;
                          });
                          if (res.runtimeType == PostModel) {
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/home', (route) => false);
                          } else {
                            showToast(context, res);
                          }
                        });
                      }
                    },
                    btnColor: Colors.deepPurpleAccent,
                    borderColor: Colors.deepPurpleAccent,
                  ),
                )
              ]),
        )
      ],
    );
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
