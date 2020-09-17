import 'package:flutter/material.dart';
import 'dart:math';


class RoundButton extends StatefulWidget {
  final Text text;
  final Function onPress;
  final Color color;

  RoundButton({this.text, this.onPress, this.color});
  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> with TickerProviderStateMixin {

  AnimationController controller;
  Animation<double> animation;
  Tween<double> flashingTween = Tween(begin: 1, end: 20);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 1));

    animation = flashingTween.animate(controller);
    animation.addListener(() {
      setState(() {

      });
    });

    animation.addStatusListener((status) { if (status == AnimationStatus.completed)
    {
      controller.reverse();
    }
    else if (status == AnimationStatus.dismissed)
    {
      controller.forward();
    }});

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(10),
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        border: Border.all(color: Colors.cyan[300], width: animation.value),
      ),
      child: RawMaterialButton(
        child: widget.text,
        elevation: 11,
        onPressed: widget.onPress,
        shape: CircleBorder(),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}


class ItemCard extends StatelessWidget {
  final Widget child;

  const ItemCard({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: child,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white70, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 20,
      margin: EdgeInsets.all(20),
      color: Colors.yellow[200],
    );
  }
}


class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> with TickerProviderStateMixin{

  AnimationController controller;
  Animation<double> animation;
  Tween<double> _rotationTween = Tween(begin: -pi, end: pi);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(seconds: 30));

    animation = _rotationTween.animate(controller);
    animation.addListener(() {
      setState(() {

      });
    });

    animation.addStatusListener((status) { if (status == AnimationStatus.completed)
    {
      controller.repeat();
    }
    else if (status == AnimationStatus.dismissed)
    {
      controller.forward();
    }});

    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Center(
        child: Stack(
            children:  <Widget>[
              new Container(
                width: double.infinity,
                child: new CustomPaint(
                  painter: new BellsAndLegsPainter(),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: new BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    //border: Border.all(color: Colors.cyan[300], width: 15),
                    boxShadow: [BoxShadow(
                      offset: new Offset(0.0, 5.0),
                      blurRadius: 30.0,
                      spreadRadius: 10.0,
                      color: Colors.blue,
                    )]
                ),
              ),
              ClockFace(animation.value),
              ClockHand(lengthFactor: 4, animationValue: animation.value,),
            ]
        ),
      ),
    );
  }
}


class BellsAndLegsPainter extends CustomPainter{

  final Paint bellPaint;
  final Paint legPaint;

  BellsAndLegsPainter():
        bellPaint= new Paint(),
        legPaint= new Paint(){
    bellPaint.color=  Colors.blue;
    bellPaint.style= PaintingStyle.fill;

    legPaint.color= Colors.blue;
    legPaint.style= PaintingStyle.stroke;
    legPaint.strokeWidth= 10.0;
    legPaint.strokeCap= StrokeCap.round;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = size.width / 2;
    canvas.save();

    canvas.translate(center, center);

    canvas.rotate(2.75*3.14/12);
    drawBellAndLeg(radius, canvas);
    canvas.rotate(-5.5*3.14/12);
    drawBellAndLeg(radius, canvas);


    canvas.restore();



  }

  void drawBellAndLeg(radius, canvas){
    //bell
    Path path1 = new Path();
    path1.moveTo(-55.0, -radius - 5); //x (goes left to right) and y axis (goes top to bottom)
    path1.lineTo(55.0, -radius-5);
    path1.quadraticBezierTo(0.0, -radius-75, -55.0, -radius-10);

    //leg
    Path path2= new Path();
    path2.addOval(new Rect.fromCircle(center: new Offset(0.0, -radius-50), radius: 3.0));
    path2.moveTo(0.0, -radius-50);
    path2.lineTo(0.0, radius - 20);

    //draw the bell on top on the leg
    canvas.drawPath(path2, legPaint);
    canvas.drawPath(path1, bellPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}

class ClockFace extends StatelessWidget {
  double animationValue;

  ClockFace(this.animationValue);

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(10.0),
      child: new AspectRatio(
        aspectRatio: 1.0,
        child: new Container(
          width: double.infinity,
          decoration: new BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),

          child: new Stack(
            children: <Widget>[
              //dial and numbers go here
              new Container(
                width: double.infinity,
                height: double.infinity,
                padding: const EdgeInsets.all(10.0),
                child:new CustomPaint(
                  painter: new ClockDialPainter(clockText: ClockText.roman, animationValue: animationValue),
                ),
              ),
              //centerpoint
              new Center(
                child: new Container(
                  width: 15.0,
                  height: 15.0,
                  decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                ),
              ),
              //clock hands go here
            ],
          ),
        ),

      ),
    );
  }
}


class ClockDialPainter extends CustomPainter{
  double animationValue;
  final clockText;

  final hourTickMarkLength= 10.0;
  final minuteTickMarkLength = 5.0;

  final hourTickMarkWidth= 6.0;
  final minuteTickMarkWidth = 3.0;

  final Paint tickPaint;
  final TextPainter textPainter;
  final TextStyle textStyle;

  final romanNumeralList= [ 'XII','I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X', 'XI'];

  ClockDialPainter({this.clockText= ClockText.roman, this.animationValue})
      :tickPaint= new Paint(),
        textPainter= new TextPainter(
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
        ),
        textStyle= const TextStyle(
          color: Colors.black,
          fontFamily: 'Times New Roman',
          fontSize: 15.0,
        )


  {
    tickPaint.color= Colors.red;
    tickPaint.strokeWidth = 10;
  }

  @override
  void paint(Canvas canvas, Size size) {

    var tickMarkLength;
    final angle= 2* 3.14 / 60 ;
    final radius= size.width/2;
    //canvas.translate(radius, size.height/2);
    canvas.save();
    canvas.drawLine(Offset(0,0), Offset(0,0), tickPaint);

    // drawing
    canvas.translate(radius, radius);
    for (var i = 0; i< 60; i++ ) {

      //make the length and stroke of the tick marker longer and thicker depending
      tickMarkLength = i % 5 == 0 ? hourTickMarkLength: minuteTickMarkLength;
      tickPaint.strokeWidth= i % 5 == 0 ? hourTickMarkWidth : minuteTickMarkWidth;
      canvas.drawLine(
          new Offset(radius*cos(animationValue), -radius*sin(animationValue)),
          new Offset((radius-tickMarkLength)*cos(animationValue), -(radius-tickMarkLength)*sin(animationValue)),
          tickPaint);



      //draw the text
      if (i%5==0){
        canvas.save();
        canvas.translate(0.0, -radius+20.0);

        textPainter.text= new TextSpan(
          text: this.clockText==ClockText.roman?
          '${romanNumeralList[i~/5]}'
              :'${i == 0 ? 12 : i~/5}'
          ,
          style: textStyle,
        );

        //helps make the text painted vertically
        canvas.rotate(-angle*i);

        textPainter.layout();


        textPainter.paint(canvas, new Offset(-(textPainter.width/2), -(textPainter.height/2)));

        canvas.restore();

      }

      canvas.rotate(angle);
    }

    canvas.restore();

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomClockHand extends CustomPainter{

  final Paint handPaint;
  final double lengthFactor;
  double animationValue;


CustomClockHand({this.lengthFactor, this.animationValue}):handPaint = new Paint(){
  handPaint.color = Colors.blue;
  handPaint.style= PaintingStyle.fill;
  handPaint.strokeWidth = 30;
  handPaint.strokeCap = StrokeCap.round;
}



@override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
  final halfWidth = size.width/2;
  final halfHeight = size.height/2;
  final radius = -size.height/2+ 50; // length of hand
  canvas.save();
  canvas.translate(halfWidth, halfHeight); //move to center of the app



  Offset p1 = Offset(0,0), p2 = Offset( radius*cos(animationValue), radius*sin(animationValue));
  canvas.drawLine(p1, p2, handPaint);

  canvas.restore();
}

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return true;
  }

}
enum ClockText{
  roman,
  arabic
}

class ClockHand extends StatelessWidget {
  final double lengthFactor;
  double animationValue;

  ClockHand({this.lengthFactor, this.animationValue});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: new Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20.0),
        child: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new CustomPaint(
              painter: new CustomClockHand(lengthFactor: lengthFactor, animationValue: animationValue),
            )
          ],
        ),
      ),
    );
  }

}
