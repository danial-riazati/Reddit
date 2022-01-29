import 'package:application/models/community_model.dart';
import 'package:application/pages/community_detail_page.dart';
import 'package:application/services/api_service.dart';
import 'package:application/services/shared_service.dart';
import 'package:flutter/material.dart';

class MyCommunitiesPage extends StatefulWidget {
  const MyCommunitiesPage({Key? key}) : super(key: key);

  @override
  _MyCommunitiesPageState createState() => _MyCommunitiesPageState();
}

class _MyCommunitiesPageState extends State<MyCommunitiesPage> {
  late Future<List<CommunityModel>> futureData;
  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    futureData = APIService.fetchCommunity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('reddit'),
        backgroundColor: Colors.grey,
      ),
      body: _myWidget(context),
    );
  }

  Widget _myWidget(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
        child: Column(
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
          Center(
              child: Container(
            height: height * 0.8,
            child: FutureBuilder<List<CommunityModel>>(
              future: futureData,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<CommunityModel>? data = snapshot.data;
                  return ListView.builder(
                      itemCount: data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: ListTile(
                            title: Text(data[index].name),
                            leading: SizedBox(
                              width: 50,
                              height: 50,
                              child: Image.asset("assets/images/community.png",
                                  width: 50, fit: BoxFit.contain),
                            ),
                            trailing: Text(
                                'Members : ${data[index].users.length} | Admins : ${data[index].admins.length}'),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CommunityDetailsPage(
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
          )),
        ]));
  }
}
