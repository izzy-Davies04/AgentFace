import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/animal_config.dart';
import '../controllers/animation_controller.dart' as ctrl;
import '../widgets/animated_face_widget.dart';
import '../widgets/animal_selector_widget.dart';
import '../widgets/chat_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ctrl.AgentAnimationController _animController;
  AnimalConfig _selectedAnimal = AnimalConfig.all[0]; // Fox default
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;
  final Random _rand = Random();

  // Scripted responses per personality
  static const Map<AnimalType, List<String>> _responses = {
    AnimalType.fox: [
      "Clever question! Here's what I think...",
      "Ooh, let me piece that puzzle together for you 🦊",
      "I've been pondering exactly this. My take: complexity hides the answer.",
      "Smart thinking. Here's a twist you might not have considered!",
      "Ha! I love a good riddle. The answer is simpler than it looks.",
    ],
    AnimalType.cat: [
      "I suppose I'll grace you with an answer...",
      "Mmm. Interesting. I've thought about this during my naps.",
      "Very well. My vast experience informs me that...",
      "You're fortunate I'm in a helpful mood today.",
      "I've considered this thoroughly. The answer, obviously, is...",
    ],
    AnimalType.owl: [
      "Wisdom gathered over ages tells us...",
      "Let me reflect on that carefully... yes, I see the path.",
      "The ancient texts would suggest...",
      "Patience. All things become clear with time.",
      "A profound question. Allow me to illuminate.",
    ],
    AnimalType.axolotl: [
      "Omg yes!! I was just thinking about this!! 🌸",
      "AHH so cool!! Here's what I found out!!",
      "I regenerate ideas super fast, so here goes!!",
      "YES! This is exactly my zone! Let me share!! ✨",
      "Weeee! Okay thinking cap on!! 🎀",
    ],
    AnimalType.rabbit: [
      "ZIP! Got it! Here's the quick answer!",
      "Bounce bounce! Already on it, here we go!",
      "Fast fast fast — my brain's already there!",
      "Done! Here's what you need to know right now!",
      "Hop to it! The answer is on its way!",
    ],
    AnimalType.panda: [
      "Let us be still and consider this together.",
      "Breathe. The answer will come to us.",
      "I have sat with this question. Here is what I believe.",
      "Quietly and carefully now... yes, I see it.",
      "There is no rush. Here is my thoughtful response.",
    ],
  };

  @override
  void initState() {
    super.initState();
    _animController = ctrl.AgentAnimationController(_selectedAnimal);
    Future.delayed(const Duration(milliseconds: 600), _sendGreeting);
  }

  void _sendGreeting() {
    _addAgentMessage(_selectedAnimal.greeting);
    _animController.setState(ctrl.FaceState.happy);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) _animController.setState(ctrl.FaceState.idle);
    });
  }

  void _changeAnimal(AnimalConfig animal) {
    setState(() {
      _selectedAnimal = animal;
      _messages.clear();
    });
    _animController.setAnimal(animal);
    Future.delayed(const Duration(milliseconds: 300), _sendGreeting);
  }

  void _addAgentMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, role: MessageRole.agent));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty || _isThinking) return;

    _inputController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, role: MessageRole.user));
      _isThinking = true;
    });
    _scrollToBottom();

    // face enters listening then thinking
    _animController.setState(ctrl.FaceState.listening);
    await Future.delayed(const Duration(milliseconds: 500));
    _animController.setState(ctrl.FaceState.thinking);

    // simulate thinking delay
    final thinkMs = 1200 + _rand.nextInt(1000);
    await Future.delayed(Duration(milliseconds: thinkMs));

    // face starts talking
    _animController.setState(ctrl.FaceState.talking);

    // pick a response
    final responses = _responses[_selectedAnimal.type] ?? ['Interesting!'];
    final response = responses[_rand.nextInt(responses.length)];
    _addAgentMessage(response);

    // talk animation duration
    await Future.delayed(Duration(milliseconds: 600 + response.length * 32));
    _animController.setState(ctrl.FaceState.idle);
    setState(() => _isThinking = false);
  }

  @override
  void dispose() {
    _animController.dispose();
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = _selectedAnimal.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D14),
      body: SafeArea(
        child: Column(
          children: [
            // ─── Header ───────────────────────────────────────────
            _buildHeader(color),

            // ─── Face canvas ──────────────────────────────────────
            _buildFaceArea(color),

            // ─── Animal selector ──────────────────────────────────
            AnimalSelectorWidget(
              selected: _selectedAnimal,
              onSelected: _changeAnimal,
            ),

            // ─── Status bar ───────────────────────────────────────
            _buildStatusBar(color),

            // ─── Chat log ─────────────────────────────────────────
            Expanded(child: _buildChatLog()),

            // ─── Input bar ────────────────────────────────────────
            _buildInputBar(color),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Text(
              'AGENT_FACE',
              style: TextStyle(color: color, fontSize: 11, letterSpacing: 2.5, fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          _StateIndicator(controller: _animController, accentColor: color),
        ],
      ),
    );
  }

  Widget _buildFaceArea(Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF13131C),
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.25), blurRadius: 40, spreadRadius: 8),
              BoxShadow(color: color.withOpacity(0.08), blurRadius: 80, spreadRadius: 20),
            ],
            border: Border.all(color: color.withOpacity(0.2), width: 1.5),
          ),
          child: ClipOval(
            child: AnimatedFaceWidget(controller: _animController),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBar(Color color) {
    return ListenableBuilder(
      listenable: _animController,
      builder: (_, __) {
        final label = switch (_animController.state) {
          ctrl.FaceState.idle => '● idle',
          ctrl.FaceState.talking => '▶ speaking',
          ctrl.FaceState.thinking => '◈ thinking...',
          ctrl.FaceState.happy => '♥ happy!',
          ctrl.FaceState.listening => '◉ listening',
          ctrl.FaceState.sleeping => '☽ sleeping',
          ctrl.FaceState.surprised => '! surprised',
          ctrl.FaceState.blinking => '— blink',
        };
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.65),
              fontSize: 11,
              letterSpacing: 1.8,
            ),
          ),
        );
      },
    );
  }

  Widget _buildChatLog() {
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'Say something...',
          style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 13, letterSpacing: 1),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _messages.length,
      itemBuilder: (_, i) => ChatBubble(message: _messages[i], animal: _selectedAnimal),
    );
  }

  Widget _buildInputBar(Color color) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: color.withOpacity(0.12))),
        color: const Color(0xFF0D0D14),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _inputController,
              style: const TextStyle(color: Colors.white, fontSize: 13.5, fontFamily: 'Courier'),
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Talk to your agent...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 13, fontFamily: 'Courier'),
                filled: true,
                fillColor: const Color(0xFF16161F),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color.withOpacity(0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color.withOpacity(0.18)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: color.withOpacity(0.55), width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _isThinking ? color.withOpacity(0.2) : color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _isThinking ? Icons.hourglass_empty_rounded : Icons.send_rounded,
                color: _isThinking ? color : const Color(0xFF0D0D14),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── State indicator dot ──────────────────────────────────────────────────────

class _StateIndicator extends StatelessWidget {
  final ctrl.AgentAnimationController controller;
  final Color accentColor;

  const _StateIndicator({required this.controller, required this.accentColor});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (_, __) {
        final isActive = controller.state != ctrl.FaceState.idle && controller.state != ctrl.FaceState.sleeping;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              controller.animal.personality,
              style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 11, letterSpacing: 0.5),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive ? accentColor : accentColor.withOpacity(0.3),
                boxShadow: isActive ? [BoxShadow(color: accentColor, blurRadius: 6)] : [],
              ),
            ),
          ],
        );
      },
    );
  }
}
