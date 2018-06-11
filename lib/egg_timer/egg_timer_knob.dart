import 'dart:math';

import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
// ignore: non_constant_identifier_names
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDialKnob extends StatefulWidget {

  final rotationPercent;

  EggTimerDialKnob({
    this.rotationPercent,
  });

  @override
  _EggTimerDialKnobState createState() => _EggTimerDialKnobState();
}

class _EggTimerDialKnobState extends State<EggTimerDialKnob> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         Container(
          width: double.infinity,
          height: double.infinity,
          child: CustomPaint(
              // Independently transform the widget to rotate.
              painter: ArrowPainter(
                rotationPercent: widget.rotationPercent,
              ),
            ),
          ),


          Container(
            padding: EdgeInsets.all(10.0), // THIS is for the child border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [GRADIENT_TOP, GRADIENT_BOTTOM]),
              boxShadow: [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 2.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.0, 1.0),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                      color: Color(0xFFDFDFDF),
                      width: 1.5,
                  ),
              ),
              child: Center(
                child: Transform(
                  transform: Matrix4.rotationZ(2 * pi * widget.rotationPercent),
                  alignment: Alignment.center,
                  child: Image.network('https://avatars3.githubusercontent.com/u/14101776?s=400&v=4',
                    width: 50.0,
                    height: 50.0,
                    color: Colors.black,),
                ),
              ),
            ),
          ),
        ]
    );
  }
}

class ArrowPainter extends CustomPainter {

  final Paint dialArrowPaint;
  final double rotationPercent;

  ArrowPainter({
    this.rotationPercent
  }) : dialArrowPaint = Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();

    final radius = size.height / 2;
    // translates now from the center of the canvas
    canvas.translate(radius, radius);
    canvas.rotate(2 * pi * rotationPercent);

    Path path = Path();

    // Creates the path
    path.moveTo(0.0, -radius -10.0); // tip of the triangle
    path.lineTo(10.0,-radius + 5.0); // diagonal line at 45 degrees.
    path.lineTo(-10.0, -radius + 5.0); // Horizontal line from right to left
    path.close();

    // Draw the path

    canvas.drawPath(path, dialArrowPaint);
    canvas.drawShadow(path, Colors.black, 3.0, false);

    canvas.restore();


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}