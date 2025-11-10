import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page2 extends StatefulWidget {
  const Page2({super.key});

  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<Page2> {
  List<dynamic> _postData = [];
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    fetchData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response = await http.get(
      Uri.parse(
        'https://redluck-25.synology.me:3000/winners/basket/male/euroleague',
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _postData = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 50,
              width: double.infinity,
              margin: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('Spazio decorato')),
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(8),
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: _postData.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.white,
                      elevation: 2, // ombra
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: Colors.grey.shade300, // colore del bordo
                          width: 1, // spessore del bordo
                        ),
                      ),
                      clipBehavior: Clip.antiAlias, // importante se vuoi che i figli rispettino il radius
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              _postData[index]['team']['clubName'] ?? 'No Name',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
