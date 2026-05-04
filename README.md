AGENTFACE — Give Your AI Agent a Face
Cross-Platform Animated Avatar App
Written in Flutter/Dart
=

# WHAT IS AGENTFACE?

AgentFace is an open-source, cross-platform application that gives any AI agent
or chatbot a living, animated 2D animal avatar. Instead of talking to a text box,
you interact with a creature that breathes, blinks, reacts, and expresses emotion
in real time.

The app runs natively on:
         
         * Android (phone & tablet)
         * iOS (iPhone & iPad)
         * macOS (Apple Silicon & Intel)
         * Windows (x64 & ARM)
         * Linux (x64, ARM, Raspberry Pi 4/5, and most open-source SBCs)

It is built entirely in Flutter (Dart), which compiles to native code on every
platform listed above with a single shared codebase — no web browser required.


# ANIMAL AVATARS INCLUDED

The user can choose from six distinct animal personalities, each with its own
color palette, animation style, and conversational tone:

    * 🦊 FOX       — Clever & Curious       — warm orange, green eyes, sly wit
    * 🐱 CAT       — Elegant & Witty        — purple-lavender, teal slit pupils
    * 🦉 OWL       — Wise & Patient         — slate grey, golden eyes, ear tufts
    * 🦎 AXOLOTL   — Playful & Regenerative — bubblegum pink, indigo eyes, gills
    * 🐰 RABBIT    — Swift & Energetic      — cream white, hot-pink eyes, tall ears
    * 🐼 PANDA     — Calm & Thoughtful      — black & white, eye patches

Switching animals instantly changes the avatar, color theme of the entire UI,
and the personality of the agent's text responses.


# HOW 2D ANIMATION IS GENERATED

Every face is drawn in real time using Flutter's CustomPainter API, which gives
direct access to a 2D Canvas. No sprite sheets, image files, or pre-rendered
frames are used. Every curve, shadow, and highlight is computed mathematically
on each frame.

The animation system has five independent layers that combine:

  1. BREATHING LAYER
     A slow sine-wave AnimationController (3.2 s period) gently scales the
     entire head ±0.3% and shifts it vertically by ±0.5 px, mimicking the
     subtle rise and fall of breathing. This runs 100% of the time.

  2. BLINK LAYER
     A randomised Timer fires every 2–5 seconds and drives a fast 140 ms
     AnimationController. The `blinkProgress` value (0=open → 1=closed)
     is passed to the FacePainter, which draws a fur-colored rectangle over
     the eye oval, scaled by that value. The result is a smooth eyelid drop.

  3. PUPIL / GAZE LAYER
     A second randomised Timer fires every 3–8 seconds and offsets the pupil
     draw position by a small (±3 px) random vector, making the agent appear
     to glance sideways. Pupils center again 800 ms later.

  4. EAR / GILL WIGGLE LAYER
     An elastic-curve AnimationController drives ear rotation (foxes, cats,
     rabbits) or gill swell (axolotl). It fires on happy state transitions
     and during talking peaks. The rotation angle is passed to the painter and
     applied with Canvas.rotate() around the ear base.

  5. HEAD BOB LAYER
     When the agent enters "thinking" state, an 800 ms repeating controller
     produces a small vertical offset applied as a Canvas.translate(). This
     subtly nods the head during processing.

  6. MOUTH LAYER
     During "talking" state, a Timer fires every 150 ms and sets a random
     `mouthOpenness` value (0.15–0.85). The painter uses this to scale the
     height of the mouth oval and tongue ellipse. When openness > 0.1, a
     filled oval (mouth cavity) and a smaller ellipse (tongue) are drawn.
     When closed, a quadratic Bézier curve draws a simple smile.

# FACE STATE MACHINE

The AgentAnimationController holds an enum FaceState with these states:

     * idle        — breathing + random blinks + random glances only
     * listening   — slight pupil attention shift toward center
     * thinking    — head bob + random gaze movement
     * talking     — mouth open/close loop at ~7 fps randomised
     * happy       — ear wiggle burst + brief blush amplification
     * surprised   — wide pupils + elevated head position
     * sleeping    — all loops stopped, eyes closed, slow breathing

These states are driven externally by the chat interaction loop: when the user
sends a message, the state machine transitions listening → thinking → talking →
idle automatically, giving the illusion of genuine response behaviour.


# HOW THE CANVAS DRAWING WORKS

Each animal is drawn by a dedicated method inside FacePainter. The painter
receives a normalized radius `r` derived from the widget size so faces scale
perfectly at any resolution.

Drawing primitives used:

    * canvas.drawOval()        — head shape, eyes, muzzle, mouth cavity
    * canvas.drawCircle()      — ears, iris, pupils, blush spots, gill knobs
    * Path + quadraticBezierTo — smile curve, ear triangles, beak shape
    * Paint.maskFilter (blur)  — blush glow, thinking dots, ambient lighting
    * canvas.save/restore      — isolates ear rotation without affecting face
    * canvas.translate()       — applies head bob offset cleanly

Highlights (tiny white circles offset from pupil center) make eyes appear
glossy and alive. A specular-style shadow ring behind the face gives depth.


# PERSONALITY AND RESPONSE SYSTEM

Each animal has a curated list of 5 scripted response templates that match its
personality archetype. The agent randomly picks from its own list when replying,
so repeated messages feel varied. In a production integration, these slots are
replaced by real LLM API calls (Claude, GPT-4, Llama, Mistral, etc.) while the
avatar animation layer remains unchanged.


# ADDING A REAL AI BACKEND

To connect to a real language model:

  1. Add the `http` package to pubspec.yaml
  2. In HomeScreen._sendMessage(), replace the delay + scripted response with
     an HTTP POST to your LLM API endpoint
  3. Stream the response tokens and call:
         _animController.setState(FaceState.talking);
         _addAgentMessage(chunk);
  4. When the stream ends:
         _animController.setState(FaceState.idle);

The animation system is fully decoupled from the response source — swapping
scripted text for real AI output requires zero changes to any painter or
animation controller.


# FILE STRUCTURE
 
  lib/
    main.dart                          — App entry point
    agent_face_app.dart                — MaterialApp + dark theme setup
    theme/app_theme.dart               — Color scheme and font config
    models/animal_config.dart          — AnimalConfig + AnimalType enum
    controllers/animation_controller.dart — FaceState machine + value holders
    painters/face_painter.dart         — CustomPainter: all animal drawing code
    widgets/
      animated_face_widget.dart        — Drives all AnimationControllers + timers
      animal_selector_widget.dart      — Horizontal carousel for picking animals
      chat_bubble.dart                 — Message UI (agent left, user right)
    screens/home_screen.dart           — Full app layout + chat logic


# RUNNING ON OPEN-SOURCE HARDWARE

Flutter supports Linux ARM targets. To run on Raspberry Pi 4/5 or similar:

  sudo apt install clang cmake ninja-build pkg-config libgtk-3-dev
  flutter config --enable-linux-desktop
  flutter run -d linux

The app renders entirely on CPU canvas — no GPU required — making it suitable
for single-board computers with limited graphics capabilities.


#LICENSE & PHILOSOPHY

AgentFace is designed to be embedded, forked, and extended. The separation
between avatar rendering, animation state, and conversation logic means you can:
      
      * Swap in any LLM
      * Add new animal types by adding a new enum variant + draw method
      * Use the face widget in any existing Flutter app as a drop-in component
      * Export to web (Flutter Web) with no code changes

The goal: every AI agent deserves a face that feels alive.

================================================================================
