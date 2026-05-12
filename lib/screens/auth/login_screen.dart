import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -6.0, end: 6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    Navigator.pushReplacementNamed(context, '/onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.3),
            radius: 1.2,
            colors: [
              Color(0xFF1A1A3E),
              Color(0xFF0D0D22),
              Color(0xFF080815),
            ],
          ),
        ),
        child: Stack(
          children: [
            const _StarField(),
            Positioned(
              bottom: -60,
              left: 0,
              right: 0,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF6C3BFF).withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Top bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mind Space',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      // Floating orbs
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: SizedBox(
                          height: 120,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _GlowOrb(
                                color: const Color(0xFF9B5CF5),
                                size: 75,
                                glowColor: const Color(0xFF9B5CF5),
                                glowRadius: 25,
                              ),
                              const SizedBox(width: 14),
                              _GlowOrb(
                                color: const Color(0xFFFFD93D),
                                size: 95,
                                glowColor: const Color(0xFFFFD93D),
                                glowRadius: 35,
                              ),
                              const SizedBox(width: 14),
                              _GlowOrb(
                                color: const Color(0xFF60B8FF),
                                size: 75,
                                glowColor: const Color(0xFF60B8FF),
                                glowRadius: 25,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      Center(
                        child: Text(
                          'Welcome back',
                          style: GoogleFonts.inter(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          'Continue your journey of self-understanding',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF9090B0),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 36),
                      _SpaceTextField(
                        controller: _emailController,
                        hint: 'Email',
                        obscure: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _SpaceTextField(
                        controller: _passwordController,
                        hint: 'Password',
                        obscure: true,
                      ),
                      const SizedBox(height: 24),
                      // Log In button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFFAA3EFF),
                                Color(0xFF7B2FFF),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF9B3FFF).withOpacity(0.55),
                                blurRadius: 22,
                                spreadRadius: 1,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            onPressed: _onLogin,
                            child: Text(
                              'Log In',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // OR divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.18),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Text(
                              'or',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 13,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 1,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.18),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Continue with Google
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1A1A2E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          onPressed: _onLogin,
                          icon: const _GoogleLogo(),
                          label: Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A1A2E),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      Center(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text(
                            'Forgot password?',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.45),
                              fontSize: 11,
                            ),
                            children: [
                              const TextSpan(
                                  text: 'By continuing, you agree to our '),
                              TextSpan(
                                text: 'Terms of Service',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  decoration: TextDecoration.underline,
                                  fontSize: 11,
                                ),
                              ),
                              const TextSpan(text: ' and\n'),
                              TextSpan(
                                text: 'Privacy Policy',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  decoration: TextDecoration.underline,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Glow Orb ──────────────────────────────────────────────────────────────────
class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;
  final Color glowColor;
  final double glowRadius;

  const _GlowOrb({
    required this.color,
    required this.size,
    required this.glowColor,
    required this.glowRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.95),
            color.withOpacity(0.75),
            color.withOpacity(0.3),
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.65),
            blurRadius: glowRadius * 1.5,
            spreadRadius: glowRadius * 0.3,
          ),
          BoxShadow(
            color: glowColor.withOpacity(0.25),
            blurRadius: glowRadius * 3,
            spreadRadius: glowRadius * 0.8,
          ),
        ],
      ),
    );
  }
}

// ── Space Text Field ───────────────────────────────────────────────────────────
class _SpaceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final TextInputType? keyboardType;

  const _SpaceTextField({
    required this.controller,
    required this.hint,
    required this.obscure,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: const Color(0xFF1C1C3A),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontSize: 14.5,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.35),
            fontSize: 14.5,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 15,
          ),
        ),
      ),
    );
  }
}

// ── Google Logo ───────────────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  const _GoogleLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: RichText(text: TextSpan(children: [TextSpan(text: "G", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF000000)))])),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double r = size.width / 2;

    // White background circle
    canvas.drawCircle(Offset(cx, cy), r, Paint()..color = Colors.white);

    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r * 0.85);

    // Blue segment (right, includes the gap for the bar)
    final paintBlue = Paint()
      ..color = const Color(0xFF000000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.35
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -0.52, 1.57, false, paintBlue);

    // Red segment (top-left)
    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.35
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, -2.09, 1.57, false, paintRed);

    // Yellow segment (bottom-left)
    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.35
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 2.62, 0.79, false, paintYellow);

    // Green segment (bottom)
    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.35
      ..strokeCap = StrokeCap.butt;
    canvas.drawArc(rect, 3.41, 0.83, false, paintGreen);

    // White center circle
    canvas.drawCircle(Offset(cx, cy), r * 0.5, Paint()..color = Colors.white);

    // Blue horizontal bar (the G crossbar)
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.13, r * 0.85, r * 0.28),
      Paint()..color = const Color(0xFF000000),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Arc {
  final Color color;
  final double startDeg;
  final double sweepDeg;
  const _Arc(this.color, this.startDeg, this.sweepDeg);
}

// ── Star Field ────────────────────────────────────────────────────────────────
class _StarField extends StatelessWidget {
  const _StarField();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _StarPainter(), size: Size.infinite);
  }
}

class _StarPainter extends CustomPainter {
  static const List<List<double>> _stars = [
    [0.05, 0.03, 1.2], [0.12, 0.08, 0.8], [0.22, 0.05, 1.0],
    [0.35, 0.02, 1.4], [0.48, 0.07, 0.9], [0.61, 0.04, 1.1],
    [0.74, 0.01, 0.8], [0.88, 0.06, 1.3], [0.95, 0.03, 1.0],
    [0.08, 0.15, 0.7], [0.19, 0.12, 1.2], [0.31, 0.18, 0.9],
    [0.45, 0.14, 1.1], [0.57, 0.11, 0.8], [0.69, 0.16, 1.3],
    [0.82, 0.13, 1.0], [0.91, 0.19, 0.7], [0.03, 0.25, 1.1],
    [0.16, 0.29, 0.9], [0.28, 0.23, 1.2], [0.42, 0.27, 0.8],
    [0.54, 0.21, 1.4], [0.66, 0.26, 1.0], [0.79, 0.22, 0.7],
    [0.93, 0.28, 1.1], [0.07, 0.72, 0.9], [0.18, 0.78, 1.2],
    [0.29, 0.74, 0.8], [0.41, 0.81, 1.1], [0.53, 0.76, 0.7],
    [0.64, 0.83, 1.3], [0.75, 0.79, 0.9], [0.86, 0.75, 1.0],
    [0.96, 0.82, 0.8], [0.11, 0.88, 1.1], [0.23, 0.92, 0.9],
    [0.36, 0.86, 1.2], [0.49, 0.91, 0.8], [0.62, 0.89, 1.4],
    [0.73, 0.94, 1.0], [0.85, 0.87, 0.7], [0.97, 0.93, 1.1],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final s in _stars) {
      paint.color = Colors.white.withOpacity(0.4 + s[2] * 0.25);
      canvas.drawCircle(
        Offset(s[0] * size.width, s[1] * size.height),
        s[2] * 1.2,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
