
// import 'dart:async';

// import 'package:flutter/material.dart';

// import '../../sos/screens/sos_screen.dart';

// class SosCard extends StatefulWidget {
//   const SosCard({super.key});

//   @override
//   State<SosCard> createState() => _SosCardState();
// }

// class _SosCardState extends State<SosCard> {
//   Timer? _countdownTimer;

//   int _countdown = 5;
//   bool _isHolding = false;

//   @override
//   void dispose() {
//     _countdownTimer?.cancel();
//     super.dispose();
//   }

//   void _startHold() {
//     if (_isHolding) return;

//     setState(() {
//       _isHolding = true;
//       _countdown = 5;
//     });

//     _countdownTimer = Timer.periodic(
//       const Duration(seconds: 1),
//       (timer) {
//         if (!mounted) {
//           timer.cancel();
//           return;
//         }

//         if (_countdown > 1) {
//           setState(() {
//             _countdown--;
//           });
//         } else {
//           timer.cancel();

//           setState(() {
//             _countdown = 0;
//             _isHolding = false;
//           });

//           _openActiveSos();
//         }
//       },
//     );
//   }

//   void _endHold() {
//     if (!_isHolding) return;

//     _countdownTimer?.cancel();

//     setState(() {
//       _isHolding = false;
//       _countdown = 5;
//     });
//   }

//   void _openActiveSos() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => const SosScreen(
//           startActive: true,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onLongPressStart: (_) {
//         _startHold();
//       },

    

//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),

//         width: double.infinity,

//         padding: const EdgeInsets.symmetric(
//           horizontal: 24,
//           vertical: 28,
//         ),

//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: _isHolding
//                 ? const [
//                     Color(0xFFC62828),
//                     Color(0xFFB71C1C),
//                   ]
//                 : const [
//                     Color(0xFFE53935),
//                     Color(0xFFD32F2F),
//                   ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),

//           borderRadius: BorderRadius.circular(28),

//           boxShadow: [
//             BoxShadow(
//               color: Colors.red.withOpacity(
//                 _isHolding ? 0.45 : 0.30,
//               ),
//               blurRadius: _isHolding ? 30 : 20,
//               spreadRadius: _isHolding ? 4 : 0,
//               offset: const Offset(0, 8),
//             ),
//           ],
//         ),

//         child: Column(
//           children: [

//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),

//               child: _isHolding
//                   ? Column(
//                       key: const ValueKey("countdown"),
//                       children: [

//                         Text(
//                           "$_countdown",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 68,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),

//                         const SizedBox(height: 4),

//                         const Text(
//                           "KEEP HOLDING",
//                           style: TextStyle(
//                             color: Colors.white70,
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             letterSpacing: 2,
//                           ),
//                         ),
//                       ],
//                     )
//                   : const Icon(
//                       Icons.shield_outlined,
//                       key: ValueKey("shield"),
//                       color: Colors.white,
//                       size: 55,
//                     ),
//             ),

//             const SizedBox(height: 16),

//             AnimatedSwitcher(
//               duration: const Duration(milliseconds: 200),

//               child: Text(
//                 _isHolding
//                     ? "Emergency SOS"
//                     : "EMERGENCY SOS",

//                 key: ValueKey(
//                   _isHolding,
//                 ),

//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 25,
//                   fontWeight: FontWeight.bold,
//                   letterSpacing: 1,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               "Protection Beyond an SOS",
//               style: TextStyle(
//                 color: Colors.white70,
//                 fontSize: 15,
//                 fontStyle: FontStyle.italic,
//               ),
//             ),

//             const SizedBox(height: 14),

//             Text(
//               _isHolding
//                   ? "SOS will activate when the countdown reaches zero."
//                   : "Press & Hold to instantly notify\nyour trusted guardians.",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 15,
//                 height: 1.5,
//               ),
//             ),

//             const SizedBox(height: 24),

//             AnimatedContainer(
//               duration: const Duration(milliseconds: 200),

//               padding: const EdgeInsets.symmetric(
//                 horizontal: 26,
//                 vertical: 12,
//               ),

//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(40),
//               ),

//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [

//                   Icon(
//                     _isHolding
//                         ? Icons.timer_outlined
//                         : Icons.touch_app,

//                     color: Colors.red,
//                   ),

//                   const SizedBox(width: 8),

//                   Text(
//                     _isHolding
//                         ? "RELEASE TO CANCEL"
//                         : "PRESS & HOLD",

//                     style: const TextStyle(
//                       color: Colors.red,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';

import '../../sos/screens/sos_screen.dart';

class SosCard extends StatefulWidget {
  const SosCard({super.key});

  @override
  State<SosCard> createState() => _SosCardState();
}

class _SosCardState extends State<SosCard> {
  Timer? _countdownTimer;

  int _countdown = 5;
  bool _isCountingDown = false;

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_isCountingDown) return;

    setState(() {
      _isCountingDown = true;
      _countdown = 5;
    });

    _countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        if (_countdown > 1) {
          setState(() {
            _countdown--;
          });
        } else {
          timer.cancel();

          setState(() {
            _countdown = 0;
            _isCountingDown = false;
          });

          _openSosActiveScreen();
        }
      },
    );
  }

  void _stopCountdown() {
    _countdownTimer?.cancel();

    setState(() {
      _isCountingDown = false;
      _countdown = 5;
    });
  }

  void _openSosActiveScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const SosScreen(
          startActive: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: _isCountingDown ? null : _startCountdown,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        width: double.infinity,

        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isCountingDown
                ? const [
                    Color(0xFFC62828),
                    Color(0xFFB71C1C),
                  ]
                : const [
                    Color(0xFFE53935),
                    Color(0xFFD32F2F),
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(
                _isCountingDown ? 0.45 : 0.30,
              ),
              blurRadius: _isCountingDown ? 30 : 20,
              spreadRadius: _isCountingDown ? 4 : 0,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          children: [

            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),

              child: _isCountingDown
                  ? Column(
                      key: const ValueKey("countdown"),
                      children: [
                        Text(
                          "$_countdown",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 68,
                            fontWeight: FontWeight.w900,
                          ),
                        ),

                        const SizedBox(height: 4),

                        const Text(
                          "SOS COUNTDOWN",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    )
                  : const Icon(
                      Icons.shield_outlined,
                      key: ValueKey("shield"),
                      color: Colors.white,
                      size: 55,
                    ),
            ),

            const SizedBox(height: 16),

            Text(
              _isCountingDown
                  ? "Emergency SOS"
                  : "EMERGENCY SOS",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Protection Beyond an SOS",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              _isCountingDown
                  ? "Emergency SOS will activate automatically."
                  : "Press & Hold to start the emergency countdown.",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 24),

            GestureDetector(
              onTap: _isCountingDown
                  ? _stopCountdown
                  : null,

              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),

                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(40),
                ),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    Icon(
                      _isCountingDown
                          ? Icons.stop_circle_outlined
                          : Icons.touch_app,
                      color: Colors.red,
                    ),

                    const SizedBox(width: 8),

                    Text(
                      _isCountingDown
                          ? "STOP"
                          : "PRESS & HOLD",
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}