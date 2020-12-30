import 'package:flutter/material.dart';

class BoardListElement extends StatelessWidget {
  final String name, description, imageLink;
  final String id;
  final VoidCallback boardLink, editLink;
  final double widthFraction, heightFraction;
  const BoardListElement(
      {Key key,
      this.name,
      this.description,
      this.imageLink =
          "https://images.unsplash.com/photo-1455582916367-25f75bfc6710?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
      this.id,
      this.boardLink,
      this.editLink,
      this.widthFraction = 0.8,
      this.heightFraction = 0.15})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                image: NetworkImage(imageLink),
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
                    child: Text(name,
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
                      child: Text(description ?? '',
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
