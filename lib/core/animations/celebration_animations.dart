import 'package:flutter/material.dart';
import 'dart:math' as math;

/// رسوم متحركة للاحتفال والنجاح
class CelebrationAnimations {
  /// عرض احتفال النجاح
  static void showSuccessCelebration(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => const SuccessCelebrationDialog(),
    );
  }

  /// عرض احتفال التبرع
  static void showDonationCelebration(BuildContext context, double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => DonationCelebrationDialog(amount: amount),
    );
  }

  /// عرض احتفال الإنجاز
  static void showAchievementCelebration(BuildContext context, String achievement) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (context) => AchievementCelebrationDialog(achievement: achievement),
    );
  }
}

/// حوار احتفال النجاح العام
class SuccessCelebrationDialog extends StatefulWidget {
  const SuccessCelebrationDialog({super.key});

  @override
  State<SuccessCelebrationDialog> createState() => _SuccessCelebrationDialogState();
}

class _SuccessCelebrationDialogState extends State<SuccessCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
  }

  void _startAnimations() {
    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _confettiController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // الكونفيتي
        AnimatedBuilder(
          animation: _confettiController,
          builder: (context, child) {
            return CustomPaint(
              painter: ConfettiPainter(_confettiController.value),
              size: MediaQuery.of(context).size,
            );
          },
        ),
        
        // الحوار
        Center(
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF4A7C59),
                          Color(0xFF5A8B69),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // أيقونة النجاح المتحركة
                        const PulsingIcon(
                          icon: Icons.check_circle,
                          color: Colors.white,
                          size: 80,
                        ),
                        
                        const SizedBox(height: 20),
                        
                        const Text(
                          '🎉 تم بنجاح! 🎉',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 12),
                        
                        const Text(
                          'الله يعطيك العافية! 💚',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 24),
                        
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF4A7C59),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: const Text(
                            'رائع!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// حوار احتفال التبرع
class DonationCelebrationDialog extends StatefulWidget {
  final double amount;

  const DonationCelebrationDialog({
    super.key,
    required this.amount,
  });

  @override
  State<DonationCelebrationDialog> createState() => _DonationCelebrationDialogState();
}

class _DonationCelebrationDialogState extends State<DonationCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleController.forward();
  }

  @override
  void dispose() {
    _heartController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: Curves.elasticOut.transform(_scaleController.value),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFE4B896),
                      Color(0xFFF0C8A0),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // قلوب متحركة
                    AnimatedBuilder(
                      animation: _heartController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + 0.2 * _heartController.value,
                          child: const Text(
                            '💝',
                            style: TextStyle(fontSize: 60),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'شكراً لك من كل قلبنا!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A7C59),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      'تبرعك بمبلغ \$${widget.amount.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4A7C59),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'رح يفرق كتير في حياة الناس! 🌟',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF6B4E3D),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A7C59),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'الله يبارك فيك! 🤲',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// حوار احتفال الإنجاز
class AchievementCelebrationDialog extends StatefulWidget {
  final String achievement;

  const AchievementCelebrationDialog({
    super.key,
    required this.achievement,
  });

  @override
  State<AchievementCelebrationDialog> createState() => _AchievementCelebrationDialogState();
}

class _AchievementCelebrationDialogState extends State<AchievementCelebrationDialog>
    with TickerProviderStateMixin {
  late AnimationController _trophyController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _trophyController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _sparkleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _trophyController.forward();
  }

  @override
  void dispose() {
    _trophyController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _trophyController,
        builder: (context, child) {
          return Transform.scale(
            scale: Curves.bounceOut.transform(_trophyController.value),
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFFA500),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // كأس متحرك مع تألق
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // تألق خلفي
                        AnimatedBuilder(
                          animation: _sparkleController,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _sparkleController.value * 2 * math.pi,
                              child: const Text(
                                '✨',
                                style: TextStyle(fontSize: 40),
                              ),
                            );
                          },
                        ),
                        
                        // الكأس
                        const Text(
                          '🏆',
                          style: TextStyle(fontSize: 80),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'إنجاز جديد! 🎉',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Text(
                      widget.achievement,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    const Text(
                      'مبروك! إنت رائع! 🌟',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 24),
                    
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFFA500),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'شكراً! 🙏',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// أيقونة نابضة
class PulsingIcon extends StatefulWidget {
  final IconData icon;
  final Color color;
  final double size;

  const PulsingIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.size,
  });

  @override
  State<PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 + 0.1 * _controller.value,
          child: Icon(
            widget.icon,
            color: widget.color,
            size: widget.size,
          ),
        );
      },
    );
  }
}

/// رسام الكونفيتي
class ConfettiPainter extends CustomPainter {
  final double progress;
  final List<ConfettiParticle> particles;

  ConfettiPainter(this.progress) : particles = _generateParticles();

  static List<ConfettiParticle> _generateParticles() {
    final random = math.Random();
    return List.generate(50, (index) {
      return ConfettiParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        color: [
          const Color(0xFF4A7C59),
          const Color(0xFFE4B896),
          const Color(0xFFFFD700),
          const Color(0xFFFF6B6B),
          const Color(0xFF4ECDC4),
        ][random.nextInt(5)],
        size: 3 + random.nextDouble() * 5,
        rotation: random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color.withValues(alpha: 1.0 - progress)
        ..style = PaintingStyle.fill;

      final x = particle.x * size.width;
      final y = particle.y * size.height + progress * size.height;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(particle.rotation + progress * 4 * math.pi);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// جسيم الكونفيتي
class ConfettiParticle {
  final double x;
  final double y;
  final Color color;
  final double size;
  final double rotation;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.rotation,
  });
}
