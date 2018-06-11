import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
final Color GRADIENT_TOP = const Color(0xFFF5F5F5);
// ignore: non_constant_identifier_names
final Color GRADIENT_BOTTOM = const Color(0xFFE8E8E8);

class EggTimerDial extends StatefulWidget {
  @override
  _EggTimerDialState createState() => _EggTimerDialState();
}

class _EggTimerDialState extends State<EggTimerDial> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(left: 45.0, right: 45.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Container(
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
            child: Padding(
              padding: const EdgeInsets.all(65.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomPaint(

                      painter: ArrowPainter(),
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
                          border: Border.all(
                              color: Color(0xFFDFDFDF),
                              width: 1.5

                          )

                      ),
                      child: Center(
                        child: Image.network('https://avatars3.githubusercontent.com/u/14101776?s=400&v=4',
                          width: 50.0,
                          height: 50.0,
                          color: Colors.black,),
                      ),
                    ),
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class ArrowPainter extends CustomPainter {

  final Paint dialArrowPaint;

  ArrowPainter(): dialArrowPaint = Paint() {
    dialArrowPaint.color = Colors.black;
    dialArrowPaint.style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    // translates the center of the canvas
    canvas.translate(size.width / 2, 0.0);

    Path path = Path();

    // Creates the path
    path.moveTo(0.0, -10.0); // tip of the triangle
    path.lineTo(10.0, 5.0); // diagonal line at 45 degrees.
    path.lineTo(-10.0, 5.0); // Horizontal line from right to left
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