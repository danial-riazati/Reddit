import 'dart:html';

import 'package:application/models/post_model.dart';
import 'package:application/services/shared_service.dart';
import 'package:flutter/material.dart';

class PostDetailsPage extends StatefulWidget {
  PostDetailsPage({Key? key, required this.model}) : super(key: key);

  PostModel model;
  bool like = false;
  @override
  _PostDetailsPageState createState() => _PostDetailsPageState();
}

class _PostDetailsPageState extends State<PostDetailsPage> {
  @override
  initState() {
    super.initState();
    widget.like = widget.model.likes.contains(SharedService.loginDetails().id);
  }

  @override
  Widget build(BuildContext context) {
    var comments = widget.model.comments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('reddit'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(widget.model.publisherName),
                leading: SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset("assets/images/profile.png",
                      width: 50, fit: BoxFit.contain),
                ),
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  widget.model.text,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.like ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.like = !widget.like;
                            // if (!widget.like) {
                            //   widget.model.likes
                            //       .remove(SharedService.loginDetails().id);
                            // } else {
                            //   widget.model.likes
                            //       .add(SharedService.loginDetails().id);
                            //   widget.model.likes =
                            //       widget.model.likes.toSet().toList();
                            // }
                          });
                        },
                      ),
                      Text('Likes: ${widget.model.likes.length}')
                    ],
                  ),
                  Text(
                    widget.model.createdDate,
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: Text(
                  'Comments : ',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 20),
                height: MediaQuery.of(context).size.height / 3,
                child: ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey,
                      child: ListTile(
                        title: Text(comments[index].toString()),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
