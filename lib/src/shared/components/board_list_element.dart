import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'package:uniq/src/services/photo_api_provider.dart';

class BoardListElement extends StatelessWidget {
  final Board board;
  final VoidCallback boardLink, iconAction;
  final double widthFraction, heightFraction, iconSize;
  final Icon icon;
  final Color filterColor;
  BoardListElement(
      {Key key,
      this.board,
      this.boardLink,
      this.iconAction,
      this.widthFraction = 1.0,
      this.heightFraction = 0.2,
      this.icon,
      this.iconSize = 26,
      this.filterColor = Colors.grey})
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
                colorFilter: board.cover == ''
                    ? ColorFilter.mode(filterColor, BlendMode.multiply)
                    : ColorFilter.mode(Colors.grey[300], BlendMode.multiply),
                image: board.cover != ''
                    ? NetworkImage(url)
                    : AssetImage('assets/defaultCover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(8),
            width: size.width * widthFraction,
            alignment: Alignment.topCenter,
            height: size.height * heightFraction,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: size.height * heightFraction * 0.30,
                      width: size.width * 0.75,
                      child: Text(
                        board.name,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                    IconButton(
                      alignment: Alignment.topRight,
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
                    height: size.height * heightFraction * 0.50,
                    child: SingleChildScrollView(
                      child: Text(
                        board.description ?? '',
                        style: Theme.of(context).textTheme.bodyText1,
                        overflow: TextOverflow.fade,
                      ),
                    ),
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
