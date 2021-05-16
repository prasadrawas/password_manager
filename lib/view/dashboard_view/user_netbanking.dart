import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:password_manager/contoller/search_controller.dart';
import 'package:password_manager/utils/databasehelper.dart';
import 'package:password_manager/utils/encryption.dart';
import 'package:password_manager/view/details_section/netbanking_details.dart';

class UserNetBanking extends StatelessWidget {
  String _query = '';
  List<Map<String, dynamic>> data = [];

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: width * 0.03,
                  right: width * 0.03,
                ),
                child: Form(
                  child: Container(
                    height: height * 0.070,
                    decoration: BoxDecoration(
                      color: Color(0xfff2f2f2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GetBuilder<SearchController>(builder: (controller) {
                      return TextFormField(
                        autofocus: false,
                        onChanged: (s) {
                          _query = s;
                          if (s.isEmpty) {
                            controller.stopSearching();
                          } else {
                            controller.startSearching();
                          }
                        },
                        decoration: InputDecoration(
                          hintStyle: TextStyle(fontSize: height * 0.020),
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF1461e3),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.all(height * 0.020),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              SizedBox(
                height: height * 0.020,
              ),
              Expanded(
                child: GetBuilder<SearchController>(builder: (controller) {
                  return FutureBuilder(
                    future: controller.isSearching
                        ? filterSearchResults() as Future
                        : getDataFromDatabase(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(color: Colors.black),
                          ),
                        );
                      } else {
                        if (snapshot.data.length == 0)
                          return Center(
                            child: Text(
                              'No Data Found',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                      }

                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount:
                            snapshot.data == null ? 0 : snapshot.data.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Get.to(
                                  () => NetBankingDetails(
                                      snapshot.data[index]['id']),
                                  transition: Transition.rightToLeft);
                            },
                            child: ListTile(
                              leading: FadeInImage(
                                image: NetworkImage(snapshot.data[index]
                                        ['url'] +
                                    "/favicon.ico"),
                                placeholder:
                                    AssetImage("assets/images/loading.png"),
                                height: height * 0.050,
                                imageErrorBuilder:
                                    (context, error, stacktrace) {
                                  return Icon(
                                    Icons.language,
                                    color: Colors.black54,
                                    size: height * 0.035,
                                  );
                                },
                              ),
                              title: Text(
                                snapshot.data[index]['bank'],
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: height * 0.022,
                                ),
                              ),
                              subtitle: Text(
                                Encryption.decryptText(
                                    snapshot.data[index]['userid']),
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: height * 0.0160,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  getDataFromDatabase() async {
    DatabaseHelper helper = new DatabaseHelper();
    var response = await helper.fetchNetbanking();

    data = response;
    return data;
  }

  filterSearchResults() async {
    List<Map<String, dynamic>> filteredResults = [];
    for (Map<String, dynamic> entry in data) {
      if (entry['bank'].toLowerCase().contains(_query.toLowerCase())) {
        filteredResults.add(entry);
      }
    }
    return filteredResults;
  }
}
