import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:uniq/src/blocs/board_bloc.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/models/board_results.dart';
import 'package:uniq/src/screens/photo_hero.dart';
import 'package:uniq/src/shared/constants.dart';
import 'package:uniq/src/shared/utilities.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    print("Jestem boards!");
    bloc.getBoards("123");
    super.initState();
  }

  @override
  void dispose() {
    print("Umieram");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Boards"),
      ),
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

      // TODO: Switch to proper icons and labels, "switch" screen without routing
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.pushReplacementNamed(context, homeRoute);
              },
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.camera),
              onPressed: () async {
                // Ensure that camera is initialized
                WidgetsFlutterBinding.ensureInitialized();
                final cameras = await availableCameras();
                final firstCamera = cameras.first;
                Navigator.pushNamed(context, cameraRoute,
                    arguments: firstCamera);
              },
            ),
            label: 'Camera',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, boardDetailsRoute);
        },
        tooltip: 'Route',
        child: Icon(Icons.navigate_next),
      ),
    );
  }

  Widget buildList(AsyncSnapshot<BoardResults> snapshot) {
    List<Board> boards = snapshot.data.results;
    return ListView.builder(
      padding: EdgeInsets.all(10),
      itemCount: boards.length,
      itemBuilder: (BuildContext context, int index) {
        String name = boards[index].name;
        return UniqBoardElement(
            name: name,
            onTap: () {
              Navigator.pushNamed(context, boardDetailsRoute,
                  arguments: boards[index]);
            });
      },
    );
  }
}
