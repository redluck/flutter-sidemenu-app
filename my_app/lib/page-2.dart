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
            ElevatedButton(
              onPressed: fetchData,
              child: const Text('Fetch Data'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _postData.length,
                itemBuilder: (context, index) {
                  return Card(
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
          ],
        ),
      ),
    );
  }
}
