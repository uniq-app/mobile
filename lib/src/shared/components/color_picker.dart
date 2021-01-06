import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class BoardColorPicker extends StatefulWidget {
  Color boardColor;
  BoardColorPicker({
    Key key,
    this.boardColor = Colors.amberAccent,
  }) : super(key: key);

  @override
  _BoardColorPickerState createState() => _BoardColorPickerState();
}

class _BoardColorPickerState extends State<BoardColorPicker> {
  /*
  // Define custom colors. The 'guide' color values are from
  // https://material.io/design/color/the-color-system.html#color-theme-creation
  static const Color guidePrimary = Color(0xFF6200EE);
  static const Color guidePrimaryVariant = Color(0xFF3700B3);
  static const Color guideSecondary = Color(0xFF03DAC6);
  static const Color guideSecondaryVariant = Color(0xFF018786);
  static const Color guideError = Color(0xFFB00020);
  static const Color guideErrorDark = Color(0xFFCF6679);
  static const Color blueBlues = Color(0xFF174378);

  // Make a custom ColorSwatch to name map from the above custom colors.
  final Map<ColorSwatch<Object>, String> colorsNameMap =
      <ColorSwatch<Object>, String>{
    ColorTools.createPrimarySwatch(guidePrimary): 'Guide Purple',
    ColorTools.createPrimarySwatch(guidePrimaryVariant): 'Guide Purple Variant',
    ColorTools.createAccentSwatch(guideSecondary): 'Guide Teal',
    ColorTools.createAccentSwatch(guideSecondaryVariant): 'Guide Teal Variant',
    ColorTools.createPrimarySwatch(guideError): 'Guide Error',
    ColorTools.createPrimarySwatch(guideErrorDark): 'Guide Error Dark',
    ColorTools.createPrimarySwatch(blueBlues): 'Blue blues',
  };*/

  @override
  void initState() {
    super.initState();
  }

  Future<bool> colorPickerDialog(boardColor) async {
    return ColorPicker(
      color: boardColor,
      onColorChanged: (Color color) =>
          setState(() => widget.boardColor = color),
      width: 40,
      height: 40,
      borderRadius: 15,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 250,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showMaterialName: true,
      showColorName: true,
      showColorCode: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.caption,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: false,
        ColorPickerType.primary: true,
        ColorPickerType.accent: true,
        ColorPickerType.bw: false,
        ColorPickerType.custom: false,
        ColorPickerType.wheel: true,
      },
      //customColorSwatchesAndNames: colorsNameMap,
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 460, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ColorIndicator(
      color: widget.boardColor,
      onSelect: () async {
        final Color colorBeforeDialog = widget.boardColor;
        if (!(await colorPickerDialog(widget.boardColor))) {
          setState(() {
            widget.boardColor = colorBeforeDialog;
          });
        }
      },
    );
  }
}
