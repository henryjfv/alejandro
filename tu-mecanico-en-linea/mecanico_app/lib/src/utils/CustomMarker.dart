import 'package:flutter/material.dart';
import 'package:mecanico_app/src/utils/styles.dart';

class MyMarker extends CustomPainter {
  final String label;

  MyMarker(this.label);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect rRect = RRect.fromRectAndRadius(rect, Radius.circular(10.0));

    paint.color = Colors.white;
    canvas.drawRRect(rRect, paint);

    paint.color = Colors.indigo;

    canvas.drawCircle(Offset(20, size.height / 2), 10, paint);

    final textPainter = TextPainter(
        text: TextSpan(
          text: this.label,
          style: CustomStyles().getStyleFont(Colors.black, 15.0),
        ),
        maxLines: 2,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: size.width - 50);
    textPainter.paint(
        canvas, Offset(40, size.height / 2 - textPainter.size.height / 2));
  }

  @override
  bool shouldRepaint(MyMarker oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(MyMarker oldDelegate) => false;
}
