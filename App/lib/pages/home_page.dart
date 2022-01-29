import 'dart:convert';
import 'package:application/pages/post_details_page.dart';
import 'package:application/services/api_service.dart';
import 'package:application/models/post_model.dart';
import 'package:application/services/shared_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String dropdownValue = 'Likes';
  late Future<List<PostModel>> futureData;
  @override
  void initState() {
    super.initState();
    fetch('Likes');
  }

  void fetch(String sort) async {
    futureData = APIService.fetchPost(sort);
    print(futureData.toString());
  }

  final ButtonStyle style = ElevatedButton.styleFrom(
      primary: Colors.deepPurpleAccent,
      textStyle: const TextStyle(
        fontSize: 20,
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('reddit'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/mycommunities', (route) => false);
              },
              icon: const Icon(
                Icons.people,
                color: Colors.black,
              )),
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/newpost', (route) => false);
            },
            icon: const Icon(
              Icons.library_books_outlined,
              color: Colors.black,
              size: 20,
            ),
          ),
          IconButton(
              onPressed: () {
                SharedService.logout(context);
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              )),
        ],
        backgroundColor: Colors.grey,
      ),
      body: _homeWidget(context),
    );
  }

  Widget _homeWidget(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                  fetch(newValue);
                });
              },
              items: <String>['Likes', 'Comments', 'Newest']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Container(
              height: height * 0.8,
              child: FutureBuilder<List<PostModel>>(
                future: futureData,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<PostModel>? data = snapshot.data;
                    return ListView.builder(
                        itemCount: data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(data[index].publisherName),
                              subtitle: Text(data[index].text),
                              leading: SizedBox(
                                width: 50,
                                height: 50,
                                child: Image.asset("assets/images/profile.png",
                                    width: 50, fit: BoxFit.contain),
                              ),
                              trailing: Text(
                                  'Likes : ${data[index].likes.length} | Dislikes : ${data[index].dislikes.length} | comments : ${data[index].comments.length}'),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PostDetailsPage(
                                          model: data[index],
                                        )));
                              },
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  }
                  // By default show a loading spinner.
                  return CircularProgressIndicator();
                },
              ),
              // By default show a loading spinner.
            )
          ],
        ),
      ),
    );
  }
}
