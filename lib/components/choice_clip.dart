import 'package:flutter/material.dart';

class ChoiceClip extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isFlightSelected;
  final Function onChoiceSelected;

  ChoiceClip({this.icon, this.text, this.isFlightSelected, this.onChoiceSelected});

  @override
  _ChoiceClipState createState() => _ChoiceClipState();
}

class _ChoiceClipState extends State<ChoiceClip> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChoiceSelected(widget.text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 5.0),
        decoration: addWhiteShade(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(widget.icon, color: Colors.white,),
            SizedBox(width: 8.0),
            Text(
              widget.text,
              style: TextStyle(color: Colors.white, fontSize: 14.0),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration addWhiteShade() {
    BoxDecoration shadeDecoration = BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.white.withOpacity(0.15)
    );

    if(widget.text == 'Flights' && widget.isFlightSelected){
      return shadeDecoration;
    }

    if(widget.text == 'Hotels' && !widget.isFlightSelected){
      return shadeDecoration;
    }

    return null;
  }
}
