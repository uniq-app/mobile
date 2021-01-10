import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/services/photo_api_provider.dart';

class BoardListElement extends StatelessWidget {
  final Board board;
  final VoidCallback boardLink, iconAction;
  final double widthFraction, heightFraction, iconSize;
  final Icon icon;
  BoardListElement(
      {Key key,
      this.board,
      this.boardLink,
      this.iconAction,
      this.widthFraction = 0.8,
      this.heightFraction = 0.16,
      this.icon,
      this.iconSize = 26})
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
                image: board.cover != ''
                    ? NetworkImage(url)
                    : AssetImage('assets/defaultCover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(12),
            width: size.width * widthFraction,
            alignment: Alignment.topCenter,
            height: size.height * heightFraction,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(board.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w300)),
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(top: 0),
                      icon: icon,
                      color: Colors.white,
                      iconSize: iconSize,
                      onPressed: iconAction,
                    ),
                  ],
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.symmetric(horizontal: 3),
                    color: Color(0x77181818),
                    height: size.height * heightFraction * 0.37,
                    child: Text(board.description ?? '',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w200)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
