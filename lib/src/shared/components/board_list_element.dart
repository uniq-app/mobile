import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/services/photo_api_provider.dart';

class BoardListElement extends StatelessWidget {
  final Board board;
  final VoidCallback boardLink, editLink;
  final double widthFraction, heightFraction;

  BoardListElement(
      {Key key,
      this.board,
      this.boardLink,
      this.editLink,
      this.widthFraction = 0.8,
      this.heightFraction = 0.15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String url = "${PhotoApiProvider.apiUrl}/thumbnail/${board.cover}";
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: boardLink,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
                // TODO: ???
                image: NetworkImage((board.cover != '')
                    ? url
                    : "https://fajnepodroze.pl/wp-content/uploads/2020/06/Welsh-Corgi-Pembroke.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(12),
            width: size.width * widthFraction,
            alignment: Alignment.topCenter,
            height: size.height * heightFraction,
            child: Table(
              //border: TableBorder.all(color: Colors.black),
              columnWidths: {1: FractionColumnWidth(.1)},
              children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 3),
                    child: Text(board.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w300)),
                  ),
                  IconButton(
                    alignment: Alignment.topRight,
                    padding: EdgeInsets.only(top: 0),
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: editLink,
                  )
                ]),
                TableRow(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      color: Color(0x77181818),
                      height: size.width * 0.11,
                      child: Text(board.description ?? '',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w200)),
                    ),
                  ),
                  SizedBox()
                ]),
                TableRow(children: [
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  SizedBox()
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
