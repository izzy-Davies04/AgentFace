import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/animal_config.dart';
import '../controllers/animation_controller.dart' as ctrl;
import '../painters/face_painter.dart';

class AnimatedFaceWidget extends StatefulWidget {
  final ctrl.AgentAnimationController controller;

  const AnimatedFaceWidget({super.key, required this.controller});

  @override
  State<AnimatedFaceWidget> createState() => _AnimatedFaceWidgetState();
}

class _AnimatedFaceWidgetState extends State<AnimatedFaceWidget>
    with TickerProviderStateMixin {
  late AnimationController _blinkController;
  late AnimationController _breatheController;
  late AnimationController _earController;
  late AnimationController _mouthController;
  late AnimationController _bobController;

  late Animation<double> _breatheAnim;
  late Animation<double> _earAnim;

  Timer? _blinkTimer;
  Timer? _glanceTimer;
  Timer? _stateTimer;

  final Random _rand = Random();

  @override
  void initState() {
    super.initState();

    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 140));
    _breatheController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3200))..repeat(reverse: true);
    _earController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _mouthController = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _bobController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _breatheAnim = Tween<double>(begin: 0, end: 5).animate(CurvedAnimation(parent: _breatheController, curve: Curves.easeInOut));
    _earAnim = Tween<double>(begin: -1, end: 1).animate(CurvedAnimation(parent: _earController, curve: Curves.elasticOut));

    _breatheController.addListener(() => setState(() {}));
    _blinkController.addListener(() => setState(() {}));
    _earController.addListener(() => setState(() {}));
    _mouthController.addListener(() => setState(() {}));
    _bobController.addListener(() => setState(() {}));

    widget.controller.addListener(_onControllerUpdate);

    _scheduleRandomBlink();
    _scheduleRandomGlance();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    setState(() {});
    _syncAnimationsToState();
  }

  void _syncAnimationsToState() {
    final state = widget.controller.state;
    switch (state) {
      case ctrl.FaceState.talking:
        _startMouthLoop();
        break;
      case ctrl.FaceState.thinking:
        _startThinkBob();
        break;
      case ctrl.FaceState.happy:
        _wiggleEars();
        break;
      case ctrl.FaceState.sleeping:
        _stopAllLoops();
        break;
      case ctrl.FaceState.idle:
      case ctrl.FaceState.blinking:
      case ctrl.FaceState.listening:
      case ctrl.FaceState.surprised:
        break;
    }
  }

  void _startMouthLoop() {
    _stateTimer?.cancel();
    _stateTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (widget.controller.state != ctrl.FaceState.talking) {
        _stateTimer?.cancel();
        widget.controller.setMouthOpenness(0);
        return;
      }
      final open = _rand.nextDouble() * 0.7 + 0.15;
      widget.controller.setMouthOpenness(open);
    });
  }

  void _startThinkBob() {
    _bobController.repeat(reverse: true);
    _stateTimer?.cancel();
    _stateTimer = Timer.periodic(const Duration(milliseconds: 400), (_) {
      if (widget.controller.state != ctrl.FaceState.thinking) {
        _stateTimer?.cancel();
        _bobController.stop();
        widget.controller.setHeadBob(0);
        return;
      }
      widget.controller.setPupil(_rand.nextDouble() * 4 - 2, _rand.nextDouble() * 2 - 1);
    });
  }

  void _wiggleEars() {
    _earController.forward(from: 0).then((_) {
      _earController.reverse();
    });
  }

  void _stopAllLoops() {
    _stateTimer?.cancel();
    widget.controller.setMouthOpenness(0);
  }

  void _scheduleRandomBlink() {
    final delay = Duration(milliseconds: 2000 + _rand.nextInt(3500));
    _blinkTimer = Timer(delay, () {
      if (!mounted) return;
      _blinkController.forward(from: 0).then((_) {
        _blinkController.reverse().then((_) {
          _scheduleRandomBlink();
        });
      });
    });
  }

  void _scheduleRandomGlance() {
    final delay = Duration(milliseconds: 3000 + _rand.nextInt(5000));
    _glanceTimer = Timer(delay, () {
      if (!mounted) return;
      widget.controller.randomGlance();
      Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        widget.controller.centerPupil();
        _scheduleRandomGlance();
      });
    });
  }

  @override
  void dispose() {
    _blinkTimer?.cancel();
    _glanceTimer?.cancel();
    _stateTimer?.cancel();
    _blinkController.dispose();
    _breatheController.dispose();
    _earController.dispose();
    _mouthController.dispose();
    _bobController.dispose();
    widget.controller.removeListener(_onControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final bobVal = _bobController.isAnimating ? (_bobController.value - 0.5) * 8 : 0.0;
    final breatheVal = _breatheAnim.value;
    final scaleFactor = 1.0 + breatheVal * 0.003;

    return Transform.scale(
      scale: scaleFactor,
      child: CustomPaint(
        painter: FacePainter(
          animal: c.animal,
          state: c.state,
          blinkProgress: _blinkController.value,
          mouthOpenness: c.mouthOpenness,
          earWiggle: _earAnim.value,
          headBobOffset: bobVal + breatheVal * 0.5,
          pupilX: c.pupilX,
          pupilY: c.pupilY,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}
