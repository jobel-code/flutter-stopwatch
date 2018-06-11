import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stopwatch/egg_timer_knob.dart';



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
            // This padding pushes in from the outer circle
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: TickPainter(

                    )
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(65.0),
                  child: EggTimerDialKnob(),

                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}



class TickPainter extends CustomPainter {
  final LONG_TICK = 14.0;
  final SHORT_TICK = 4.0;

  final tickCount;
  final ticksPerSection;
  final ticksInset;
  final tickPaint;

  TickPainter({
    this.tickCount = 35,
    this.ticksPerSection = 5,
    this.ticksInset = 0.0,
}) : tickPaint = Paint() {
    tickPaint.color = Colors.black;
    tickPaint.strokeWidth = 1.5;
  }






  @override
  void paint(Canvas canvas, Size size) {
    // moving center of canvas to the center of the circles
    canvas.translate(size.width / 2, size.height / 2);

    // Saving position before rotating canvas.
    canvas.save();

    // radius to draw the offset
    final radius = size.width / 2;

    // Painting short ticks.
    for (var i = 0; i < tickCount; ++i) {

      final tickLength = i % ticksPerSection == 0 ? LONG_TICK : SHORT_TICK;

      canvas.drawLine(
          Offset(0.0, radius),
          Offset(0.0, radius + tickLength), // negative goes up // plus keeps it on the exterior
          tickPaint
      );
      
      canvas.rotate(2 * pi / tickCount);
    }

    // restore after drawing all ticks
    canvas.restore();


  }
  
  
  

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

