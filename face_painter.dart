import 'dart:math';
import 'package:flutter/material.dart';
import '../models/animal_config.dart';
import '../controllers/animation_controller.dart' as ctrl;

class FacePainter extends CustomPainter {
  final AnimalConfig animal;
  final ctrl.FaceState state;
  final double blinkProgress; // 0=open, 1=closed
  final double mouthOpenness; // 0=closed, 1=open
  final double earWiggle; // -1 to 1
  final double headBobOffset;
  final double pupilX;
  final double pupilY;

  const FacePainter({
    required this.animal,
    required this.state,
    required this.blinkProgress,
    required this.mouthOpenness,
    required this.earWiggle,
    required this.headBobOffset,
    required this.pupilX,
    required this.pupilY,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + headBobOffset;
    final r = min(size.width, size.height) * 0.36;

    canvas.save();
    canvas.translate(0, headBobOffset * 0.5);

    switch (animal.type) {
      case AnimalType.fox:
        _drawFox(canvas, cx, cy, r);
        break;
      case AnimalType.cat:
        _drawCat(canvas, cx, cy, r);
        break;
      case AnimalType.owl:
        _drawOwl(canvas, cx, cy, r);
        break;
      case AnimalType.axolotl:
        _drawAxolotl(canvas, cx, cy, r);
        break;
      case AnimalType.rabbit:
        _drawRabbit(canvas, cx, cy, r);
        break;
      case AnimalType.panda:
        _drawPanda(canvas, cx, cy, r);
        break;
    }

    canvas.restore();
  }

  // ─── shared helpers ───────────────────────────────────────────────

  Paint _fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;
  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round;

  void _drawEye(Canvas canvas, double ex, double ey, double er, Color eyeCol, Color pupilCol) {
    // white
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.2, height: er * 2 * (1 - blinkProgress * 0.98)),
      _fill(Colors.white),
    );
    if (blinkProgress < 0.8) {
      // iris
      canvas.drawCircle(Offset(ex + pupilX, ey + pupilY), er * 0.72, _fill(eyeCol));
      // pupil
      canvas.drawCircle(Offset(ex + pupilX, ey + pupilY), er * 0.42, _fill(const Color(0xFF1A1A2E)));
      // highlight
      canvas.drawCircle(Offset(ex + pupilX + er * 0.18, ey + pupilY - er * 0.2), er * 0.16, _fill(Colors.white.withOpacity(0.9)));
    }
    // eyelid
    if (blinkProgress > 0.1) {
      final lidH = er * blinkProgress * 2.2;
      canvas.drawRect(Rect.fromLTWH(ex - er * 1.2, ey - er * 1.1, er * 2.4, lidH), _fill(animal.furColor));
    }
    // outline
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.2, height: er * 2 * (1 - blinkProgress * 0.98)),
      _stroke(animal.primaryColor.withOpacity(0.5), 1.5),
    );
  }

  void _drawSmile(Canvas canvas, double cx, double cy, double w, double openness) {
    final path = Path();
    if (openness < 0.1) {
      path.moveTo(cx - w * 0.5, cy);
      path.quadraticBezierTo(cx, cy + w * 0.28, cx + w * 0.5, cy);
    } else {
      // open mouth oval
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + w * 0.1), width: w * openness, height: w * 0.35 * openness),
        _fill(const Color(0xFFB05070)),
      );
      // tongue
      canvas.drawOval(
        Rect.fromCenter(center: Offset(cx, cy + w * 0.22 * openness), width: w * 0.45 * openness, height: w * 0.2 * openness),
        _fill(const Color(0xFFE87090)),
      );
    }
    canvas.drawPath(path, _stroke(const Color(0xFFB05070), 2.5));
  }

  void _drawNose(Canvas canvas, double cx, double cy, double size, Color color) {
    final path = Path()
      ..moveTo(cx, cy + size)
      ..lineTo(cx - size * 1.1, cy - size * 0.5)
      ..quadraticBezierTo(cx, cy - size * 0.8, cx + size * 1.1, cy - size * 0.5)
      ..close();
    canvas.drawPath(path, _fill(color));
  }

  // ─── FOX ──────────────────────────────────────────────────────────

  void _drawFox(Canvas canvas, double cx, double cy, double r) {
    final wigRad = earWiggle * 0.18;
    // left ear
    canvas.save();
    canvas.translate(cx - r * 0.55, cy - r * 0.85);
    canvas.rotate(-0.25 + wigRad);
    final leftEar = Path()
      ..moveTo(0, 0)
      ..lineTo(-r * 0.3, -r * 0.55)
      ..lineTo(r * 0.28, -r * 0.5)
      ..close();
    canvas.drawPath(leftEar, _fill(animal.furColor));
    final leftInner = Path()
      ..moveTo(0, -r * 0.08)
      ..lineTo(-r * 0.16, -r * 0.42)
      ..lineTo(r * 0.14, -r * 0.38)
      ..close();
    canvas.drawPath(leftInner, _fill(animal.accentColor.withOpacity(0.6)));
    canvas.restore();

    // right ear
    canvas.save();
    canvas.translate(cx + r * 0.55, cy - r * 0.85);
    canvas.rotate(0.25 - wigRad);
    final rightEar = Path()
      ..moveTo(0, 0)
      ..lineTo(-r * 0.28, -r * 0.5)
      ..lineTo(r * 0.3, -r * 0.55)
      ..close();
    canvas.drawPath(rightEar, _fill(animal.furColor));
    final rightInner = Path()
      ..moveTo(0, -r * 0.08)
      ..lineTo(-r * 0.14, -r * 0.38)
      ..lineTo(r * 0.16, -r * 0.42)
      ..close();
    canvas.drawPath(rightInner, _fill(animal.accentColor.withOpacity(0.6)));
    canvas.restore();

    // head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 1.9),
      _fill(animal.furColor),
    );
    // white muzzle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.25), width: r * 1.05, height: r * 0.75),
      _fill(Colors.white.withOpacity(0.85)),
    );

    // eyes
    _drawEye(canvas, cx - r * 0.33, cy - r * 0.12, r * 0.22, animal.eyeColor, Colors.black);
    _drawEye(canvas, cx + r * 0.33, cy - r * 0.12, r * 0.22, animal.eyeColor, Colors.black);
    // nose
    _drawNose(canvas, cx, cy + r * 0.2, r * 0.1, const Color(0xFF2D2D2D));
    // mouth
    _drawSmile(canvas, cx, cy + r * 0.37, r * 0.42, mouthOpenness);
    // cheek marks
    _drawFoxCheeks(canvas, cx, cy, r);
  }

  void _drawFoxCheeks(Canvas canvas, double cx, double cy, double r) {
    final p = Paint()
      ..color = animal.primaryColor.withOpacity(0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawCircle(Offset(cx - r * 0.58, cy + r * 0.08), r * 0.2, p);
    canvas.drawCircle(Offset(cx + r * 0.58, cy + r * 0.08), r * 0.2, p);
    // whiskers
    for (var i = 0; i < 3; i++) {
      final yo = (i - 1) * r * 0.1;
      canvas.drawLine(
        Offset(cx - r * 0.25, cy + r * 0.28 + yo),
        Offset(cx - r * 0.85, cy + r * 0.2 + yo),
        _stroke(Colors.white.withOpacity(0.6), 1.0),
      );
      canvas.drawLine(
        Offset(cx + r * 0.25, cy + r * 0.28 + yo),
        Offset(cx + r * 0.85, cy + r * 0.2 + yo),
        _stroke(Colors.white.withOpacity(0.6), 1.0),
      );
    }
  }

  // ─── CAT ──────────────────────────────────────────────────────────

  void _drawCat(Canvas canvas, double cx, double cy, double r) {
    final wigRad = earWiggle * 0.22;
    // ears
    for (var side in [-1, 1]) {
      canvas.save();
      canvas.translate(cx + side * r * 0.5, cy - r * 0.82);
      canvas.rotate(side * (0.18 - wigRad * side));
      final ear = Path()
        ..moveTo(0, 0)
        ..lineTo(-r * 0.22, -r * 0.42)
        ..lineTo(r * 0.22, -r * 0.42)
        ..close();
      canvas.drawPath(ear, _fill(animal.furColor));
      final innerEar = Path()
        ..moveTo(0, -r * 0.05)
        ..lineTo(-r * 0.1, -r * 0.32)
        ..lineTo(r * 0.1, -r * 0.32)
        ..close();
      canvas.drawPath(innerEar, _fill(animal.accentColor.withOpacity(0.5)));
      canvas.restore();
    }
    // head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.9, height: r * 1.85),
      _fill(animal.furColor),
    );
    // muzzle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.28), width: r * 0.85, height: r * 0.58),
      _fill(Colors.white.withOpacity(0.7)),
    );
    // cat slit pupils
    _drawCatEye(canvas, cx - r * 0.32, cy - r * 0.1, r * 0.23);
    _drawCatEye(canvas, cx + r * 0.32, cy - r * 0.1, r * 0.23);
    _drawNose(canvas, cx, cy + r * 0.18, r * 0.08, const Color(0xFFFFB3C6));
    _drawSmile(canvas, cx, cy + r * 0.33, r * 0.36, mouthOpenness);
    // whiskers
    for (var i = 0; i < 3; i++) {
      final yo = (i - 1) * r * 0.1;
      canvas.drawLine(Offset(cx - r * 0.12, cy + r * 0.28 + yo), Offset(cx - r * 0.9, cy + r * 0.2 + yo), _stroke(Colors.white.withOpacity(0.55), 1.2));
      canvas.drawLine(Offset(cx + r * 0.12, cy + r * 0.28 + yo), Offset(cx + r * 0.9, cy + r * 0.2 + yo), _stroke(Colors.white.withOpacity(0.55), 1.2));
    }
  }

  void _drawCatEye(Canvas canvas, double ex, double ey, double er) {
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.2, height: er * 1.8 * (1 - blinkProgress * 0.98)),
      _fill(Colors.white),
    );
    if (blinkProgress < 0.8) {
      canvas.drawOval(
        Rect.fromCenter(center: Offset(ex, ey), width: er * 1.5, height: er * 1.5),
        _fill(animal.eyeColor),
      );
      // vertical slit
      canvas.drawOval(
        Rect.fromCenter(center: Offset(ex + pupilX, ey + pupilY), width: er * 0.28, height: er * 1.1),
        _fill(const Color(0xFF1A1A2E)),
      );
      canvas.drawCircle(Offset(ex + er * 0.2, ey - er * 0.22), er * 0.14, _fill(Colors.white.withOpacity(0.9)));
    }
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.2, height: er * 1.8 * (1 - blinkProgress * 0.98)),
      _stroke(animal.primaryColor.withOpacity(0.4), 1.5),
    );
  }

  // ─── OWL ──────────────────────────────────────────────────────────

  void _drawOwl(Canvas canvas, double cx, double cy, double r) {
    // body feather base
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.3), width: r * 1.7, height: r * 1.2),
      _fill(animal.furColor.withOpacity(0.6)),
    );
    // ear tufts
    for (var side in [-1, 1]) {
      canvas.save();
      canvas.translate(cx + side * r * 0.38, cy - r * 0.85);
      canvas.rotate(side * (earWiggle * 0.15));
      final tuft = Path()
        ..moveTo(-r * 0.12, r * 0.05)
        ..lineTo(-r * 0.18, -r * 0.35)
        ..lineTo(0, -r * 0.28)
        ..lineTo(r * 0.18, -r * 0.35)
        ..lineTo(r * 0.12, r * 0.05)
        ..close();
      canvas.drawPath(tuft, _fill(animal.furColor));
      canvas.restore();
    }
    // head
    canvas.drawCircle(Offset(cx, cy), r, _fill(animal.furColor));
    // facial disc rings
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.05), width: r * 1.55, height: r * 1.45),
      _fill(Colors.white.withOpacity(0.18)),
    );
    // big owl eyes
    _drawOwlEye(canvas, cx - r * 0.33, cy - r * 0.08, r * 0.3);
    _drawOwlEye(canvas, cx + r * 0.33, cy - r * 0.08, r * 0.3);
    // beak
    final beak = Path()
      ..moveTo(cx, cy + r * 0.18)
      ..lineTo(cx - r * 0.1, cy + r * 0.08)
      ..lineTo(cx + r * 0.1, cy + r * 0.08)
      ..close();
    canvas.drawPath(beak, _fill(animal.accentColor));
    // thinking dots
    if (state == ctrl.FaceState.thinking) {
      _drawThinkingDots(canvas, cx + r * 0.85, cy - r * 0.5, r);
    }
  }

  void _drawOwlEye(Canvas canvas, double ex, double ey, double er) {
    // ring
    canvas.drawCircle(Offset(ex, ey), er * 1.2, _fill(Colors.white.withOpacity(0.25)));
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.0, height: er * 1.9 * (1 - blinkProgress * 0.98)),
      _fill(Colors.white),
    );
    if (blinkProgress < 0.8) {
      canvas.drawCircle(Offset(ex, ey), er * 0.85, _fill(animal.eyeColor));
      canvas.drawCircle(Offset(ex + pupilX, ey + pupilY), er * 0.5, _fill(const Color(0xFF1A1A2E)));
      canvas.drawCircle(Offset(ex + er * 0.22, ey - er * 0.22), er * 0.18, _fill(Colors.white.withOpacity(0.9)));
    }
    canvas.drawOval(
      Rect.fromCenter(center: Offset(ex, ey), width: er * 2.0, height: er * 1.9 * (1 - blinkProgress * 0.98)),
      _stroke(animal.accentColor.withOpacity(0.5), 2),
    );
  }

  void _drawThinkingDots(Canvas canvas, double x, double y, double r) {
    for (var i = 0; i < 3; i++) {
      canvas.drawCircle(Offset(x + i * r * 0.22, y - i * r * 0.22), r * 0.07, _fill(animal.accentColor.withOpacity(0.7)));
    }
  }

  // ─── AXOLOTL ──────────────────────────────────────────────────────

  void _drawAxolotl(Canvas canvas, double cx, double cy, double r) {
    // gills (3 per side)
    for (var side in [-1, 1]) {
      for (var i = 0; i < 3; i++) {
        final gx = cx + side * (r * 0.75 + i * r * 0.08);
        final gy = cy - r * 0.55 + i * r * 0.25;
        final gr = r * (0.14 - i * 0.025);
        final gillPath = Path()
          ..moveTo(gx, gy + gr)
          ..quadraticBezierTo(gx + side * gr * 1.5, gy, gx, gy - gr * 1.5)
          ..quadraticBezierTo(gx - side * gr * 0.5, gy, gx, gy + gr);
        canvas.drawPath(gillPath, _fill(animal.accentColor.withOpacity(0.8 + earWiggle * 0.1)));
        // gill spots
        canvas.drawCircle(Offset(gx, gy - gr * 0.5), gr * 0.25, _fill(animal.primaryColor.withOpacity(0.6)));
      }
    }
    // head (wider, rounder)
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.05), width: r * 2.15, height: r * 1.8),
      _fill(animal.furColor),
    );
    // spots
    for (var i = 0; i < 5; i++) {
      final angle = i * pi / 2.5 + 0.3;
      canvas.drawCircle(
        Offset(cx + cos(angle) * r * 0.65, cy + sin(angle) * r * 0.55),
        r * 0.07,
        _fill(animal.primaryColor.withOpacity(0.35)),
      );
    }
    // eyes (big round)
    _drawEye(canvas, cx - r * 0.36, cy - r * 0.12, r * 0.26, animal.eyeColor, Colors.black);
    _drawEye(canvas, cx + r * 0.36, cy - r * 0.12, r * 0.26, animal.eyeColor, Colors.black);
    // tiny cute nose dots
    canvas.drawCircle(Offset(cx - r * 0.07, cy + r * 0.22), r * 0.045, _fill(const Color(0xFFAA6688)));
    canvas.drawCircle(Offset(cx + r * 0.07, cy + r * 0.22), r * 0.045, _fill(const Color(0xFFAA6688)));
    // smile
    _drawSmile(canvas, cx, cy + r * 0.38, r * 0.42, mouthOpenness);
    // blush
    final blush = Paint()..color = animal.primaryColor.withOpacity(0.3)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawCircle(Offset(cx - r * 0.55, cy + r * 0.1), r * 0.22, blush);
    canvas.drawCircle(Offset(cx + r * 0.55, cy + r * 0.1), r * 0.22, blush);
  }

  // ─── RABBIT ───────────────────────────────────────────────────────

  void _drawRabbit(Canvas canvas, double cx, double cy, double r) {
    // long ears
    for (var side in [-1, 1]) {
      canvas.save();
      canvas.translate(cx + side * r * 0.42, cy - r * 0.7);
      canvas.rotate(side * (earWiggle * 0.3));
      canvas.drawOval(
        Rect.fromCenter(center: Offset(0, -r * 0.55), width: r * 0.38, height: r * 1.1),
        _fill(animal.furColor),
      );
      canvas.drawOval(
        Rect.fromCenter(center: Offset(0, -r * 0.55), width: r * 0.2, height: r * 0.82),
        _fill(animal.accentColor.withOpacity(0.5)),
      );
      canvas.restore();
    }
    // head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 1.85, height: r * 1.78),
      _fill(animal.furColor),
    );
    // chubby cheeks
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - r * 0.52, cy + r * 0.15), width: r * 0.6, height: r * 0.5),
      _fill(Colors.white.withOpacity(0.4)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + r * 0.52, cy + r * 0.15), width: r * 0.6, height: r * 0.5),
      _fill(Colors.white.withOpacity(0.4)),
    );
    // blush
    final blush = Paint()..color = animal.accentColor.withOpacity(0.4)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9);
    canvas.drawCircle(Offset(cx - r * 0.5, cy + r * 0.18), r * 0.18, blush);
    canvas.drawCircle(Offset(cx + r * 0.5, cy + r * 0.18), r * 0.18, blush);
    // eyes
    _drawEye(canvas, cx - r * 0.3, cy - r * 0.1, r * 0.21, animal.eyeColor, Colors.black);
    _drawEye(canvas, cx + r * 0.3, cy - r * 0.1, r * 0.21, animal.eyeColor, Colors.black);
    _drawNose(canvas, cx, cy + r * 0.18, r * 0.09, animal.accentColor);
    _drawSmile(canvas, cx, cy + r * 0.35, r * 0.38, mouthOpenness);
  }

  // ─── PANDA ────────────────────────────────────────────────────────

  void _drawPanda(Canvas canvas, double cx, double cy, double r) {
    // ears
    for (var side in [-1, 1]) {
      canvas.drawCircle(
        Offset(cx + side * r * 0.68, cy - r * 0.72 + earWiggle * side * 3),
        r * 0.25,
        _fill(const Color(0xFF2D2D2D)),
      );
    }
    // head
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy), width: r * 2.0, height: r * 1.9),
      _fill(animal.furColor),
    );
    // eye patches
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx - r * 0.32, cy - r * 0.1), width: r * 0.58, height: r * 0.5),
      _fill(const Color(0xFF2D2D2D).withOpacity(0.88)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx + r * 0.32, cy - r * 0.1), width: r * 0.58, height: r * 0.5),
      _fill(const Color(0xFF2D2D2D).withOpacity(0.88)),
    );
    // eyes on patches
    _drawEye(canvas, cx - r * 0.32, cy - r * 0.1, r * 0.19, animal.eyeColor, Colors.black);
    _drawEye(canvas, cx + r * 0.32, cy - r * 0.1, r * 0.19, animal.eyeColor, Colors.black);
    // muzzle
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, cy + r * 0.28), width: r * 0.88, height: r * 0.62),
      _fill(Colors.white.withOpacity(0.9)),
    );
    _drawNose(canvas, cx, cy + r * 0.19, r * 0.1, const Color(0xFF2D2D2D));
    _drawSmile(canvas, cx, cy + r * 0.37, r * 0.4, mouthOpenness);
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) => true;
}
