import 'package:flutter/material.dart';
import 'package:uniq/src/models/board.dart';
import 'constants.dart';

class UniqButton extends StatelessWidget {
  final String text;
  final Function push;
  final Color color, textColor;
  final double radius, screenWidth, screenHeight, margin, padding;
  const UniqButton({
    Key key,
    this.text,
    this.push,
    this.color,
    this.textColor = Colors.white,
    this.radius = 15,
    this.screenWidth = 0.8,
    this.screenHeight = 0.07,
    this.margin = 10,
    this.padding = 20,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      width: size.width * screenWidth,
      height: size.height * screenHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: padding),
          color: color,
          onPressed: push,
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}

class UniqInputField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final bool isObscure;
  final String hintText;
  final IconData inputIcon;
  final Color color;
  final double fieldRounding;
  const UniqInputField({
    Key key,
    this.onChanged,
    this.isObscure = false,
    this.hintText,
    this.inputIcon,
    this.color,
    this.fieldRounding = 15.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(fieldRounding),
      ),
      child: TextField(
        obscureText: isObscure,
        onChanged: onChanged,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            inputIcon,
            color: Theme.of(context).primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class UniqBoardElement extends StatefulWidget {
  final String name, description, imageLink;
  final String id;
  final VoidCallback boardLink, editLink, deleteLink;
  const UniqBoardElement(
      {Key key,
      this.name,
      this.description,
      this.imageLink =
          "https://images.unsplash.com/photo-1455582916367-25f75bfc6710?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60",
      this.id,
      this.boardLink,
      this.editLink,
      this.deleteLink})
      : super(key: key);
  @override
  _UniqBoardElement createState() => _UniqBoardElement();
}

class _UniqBoardElement extends State<UniqBoardElement> {
  double widthFraction = 0.8, heightFraction = 0.15;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    var imageLink =
        "https://images.unsplash.com/photo-1455582916367-25f75bfc6710?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NHx8fGVufDB8fHw%3D&auto=format&fit=crop&w=500&q=60";
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: widget.boardLink,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.grey, BlendMode.multiply),
                image: NetworkImage(widget.imageLink),
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
                    child: Text(widget.name,
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
                    onPressed: () {
                      print('Imhere');
                      setState(() {
                        if (isExpanded) {
                          heightFraction = heightFraction / 1.48;
                          isExpanded = false;
                        } else {
                          heightFraction = heightFraction * 1.48;
                          isExpanded = true;
                        }
                      });
                      print("Fraction $heightFraction");
                    },
                  )
                ]),
                TableRow(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(7),
                    child: Container(
                      color: Color(0x77181818),
                      height: size.width * 0.11,
                      child: Text(widget.description ?? '',
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
                TableRow(children: [
                  Padding(
                    padding: EdgeInsets.only(left: size.width * 0.1),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        UniqButton(
                          color: Theme.of(context).primaryColor,
                          text: "Edit",
                          textColor: Colors.white,
                          screenWidth: 0.25,
                          screenHeight: 0.05,
                          padding: 10,
                          margin: 2,
                          push: widget.editLink,
                        ),
                        UniqButton(
                          color: Color(0xccff1122),
                          text: "Delete",
                          textColor: Colors.white,
                          screenWidth: 0.25,
                          screenHeight: 0.05,
                          padding: 10,
                          margin: 2,
                          push: widget.deleteLink,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(),
                ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DeleteAlert extends StatelessWidget {
  final Board board;
  const DeleteAlert({Key key, this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String boardID = board.id, boardName = board.name;
    return AlertDialog(
      title: Text("Confirmation"),
      content: Text("Are you sure to delete $boardName?"),
      actions: [
        FlatButton(
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Yes")),
        FlatButton(
            color: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("No")),
      ],
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15.0)),
    );
  }
}
