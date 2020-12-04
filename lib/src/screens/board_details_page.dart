import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board_results.dart';

// TODO: Pass Board on route -> with parameter
class BoardDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bloc.getBoards("123");
    return Scaffold(
      appBar: AppBar(
        title: Text("Uniq"),
      ),
      // TODO: Stream builder
      body: StreamBuilder(
        stream: bloc.boardResults,
        builder: (context, AsyncSnapshot<BoardResults> snapshot) {
          if (snapshot.hasData) {
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            return Text(
              snapshot.error.toString(),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        tooltip: 'Route',
        child: Icon(Icons.navigate_before),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<BoardResults> snapshot) {
    List<String> photos = snapshot.data.results[0].photos;
    // TODO: Na koncu dodać button ala img "dodaj pic" ;))
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: photos.length,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            photos[index],
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            color: Colors.blue[200],
          );
        });
  }
}
