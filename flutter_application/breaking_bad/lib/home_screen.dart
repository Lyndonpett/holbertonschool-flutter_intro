import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import 'character_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Future<List<Character>> fetchBbCharacters() async {
    final response =
        await http.get(Uri.parse('https://breakingbadapi.com/api/characters'));
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      final List<Character> characters =
          body.map((dynamic item) => Character.fromJson(item)).toList();
      return characters;
    } else {
      throw Exception('Failed to load characters');
    }
  }

  /*
Override the build() function: Function prototype: Widget build(BuildContext context)

Returns: Scaffold() Inside the scaffold add an appBar with text “Breaking Bad Quotes”

Set scaffold body to FutureBuilder() where the future argument is the data returned by fetchBbCharacters() and the builder argument is a function that accepts two arguments context and snapshot and returns:

    If snapshot contains data : GridView.Builder()
    If snapshot returns an error : center widget with text “Error”
    If snapshot is still loading : center widget with circularProgressIndicator()
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Breaking Bad Quotes'),
      ),
      body: FutureBuilder(
        future: fetchBbCharacters(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return CharacterTile(
                  character: snapshot.data?[index],
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
                child: Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Error!'),
              ),
            ));
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
