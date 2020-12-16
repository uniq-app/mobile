import 'package:flutter/material.dart';
import 'constants.dart';

class UniqButton extends StatelessWidget {
  final String text;
  final Function push;
  final Color color, textColor;
  const UniqButton({
    Key key,
    this.text,
    this.push,
    this.color = primaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: FlatButton(
          padding: EdgeInsets.symmetric(vertical: 20),
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
  const UniqInputField({
    Key key,
    this.onChanged,
    this.isObscure,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(29),
      ),
      child: TextField(
        obscureText: isObscure,
        onChanged: onChanged,
        cursorColor: primaryColor,
        decoration: InputDecoration(
          hintText: hintText,
          icon: Icon(
            Icons.lock,
            color: primaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class UniqBoardElement extends StatelessWidget {
  final String id;
  final String name, description, imageLink;
  final double widthFraction, heightFraction;
  final VoidCallback onTap;
  const UniqBoardElement(
      {Key key,
      this.id,
      this.onTap,
      this.name,
      this.description,
      this.widthFraction = 0.8,
      this.heightFraction = 0.15,
      this.imageLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
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
            padding: EdgeInsets.all(20),
            width: size.width * widthFraction,
            alignment: Alignment.topCenter,
            height: size.height * heightFraction,
            child: Table(
              columnWidths: {1: FractionColumnWidth(.1)},
              children: [
                TableRow(children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.w300)),
                  ),
                  IconButton(
                    icon: Icon(Icons.settings),
                    color: Colors.white,
                    onPressed: () {},
                  )
                ]),
                TableRow(children: [
                  Text(description,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w200)),
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
