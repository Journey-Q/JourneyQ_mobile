// shared/widgets/common/loading_widget.dart
import 'package:flutter/material.dart';

class LoadingWidget extends StatefulWidget {
  final Color? color;
  final double size;
  final double strokeWidth;
  
  const LoadingWidget({
    Key? key,
    this.color,
    this.size = 24.0,
    this.strokeWidth = 3.0,
  }) : super(key: key);

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CircularProgressIndicator(
              value: null,
              strokeWidth: widget.strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(
                widget.color ?? const Color(0xFF0088cc),
              ),
            );
          },
        ),
      ),
    );
  }
}

// Alternative custom loading widget with gradient
class GradientLoadingWidget extends StatefulWidget {
  final double size;
  final double strokeWidth;
  
  const GradientLoadingWidget({
    Key? key,
    this.size = 24.0,
    this.strokeWidth = 3.0,
  }) : super(key: key);

  @override
  State<GradientLoadingWidget> createState() => _GradientLoadingWidgetState();
}

class _GradientLoadingWidgetState extends State<GradientLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _controller.value * 2 * 3.14159,
              child: CustomPaint(
                painter: GradientCircularProgressPainter(
                  strokeWidth: widget.strokeWidth,
                ),
                size: Size(widget.size, widget.size),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  
  GradientCircularProgressPainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = const SweepGradient(
      colors: [
        Color(0xFF0088cc),
        Color(0xFF33a3dd),
        Colors.transparent,
      ],
      stops: [0.0, 0.7, 1.0],
    );
    
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Pulse loading widget
class PulseLoadingWidget extends StatefulWidget {
  final Color? color;
  final double size;
  
  const PulseLoadingWidget({
    Key? key,
    this.color,
    this.size = 24.0,
  }) : super(key: key);

  @override
  State<PulseLoadingWidget> createState() => _PulseLoadingWidgetState();
}

class _PulseLoadingWidgetState extends State<PulseLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _animation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.color ?? const Color(0xFF0088cc),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Dots loading widget
class DotsLoadingWidget extends StatefulWidget {
  final Color? color;
  final double size;
  
  const DotsLoadingWidget({
    Key? key,
    this.color,
    this.size = 8.0,
  }) : super(key: key);

  @override
  State<DotsLoadingWidget> createState() => _DotsLoadingWidgetState();
}

class _DotsLoadingWidgetState extends State<DotsLoadingWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _animations = List.generate(3, (index) {
      return Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(
          index * 0.2,
          0.6 + index * 0.2,
          curve: Curves.easeInOut,
        ),
      ));
    });
    
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: widget.size * 0.2),
                child: Opacity(
                  opacity: _animations[index].value,
                  child: Transform.scale(
                    scale: _animations[index].value,
                    child: Container(
                      width: widget.size,
                      height: widget.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.color ?? const Color(0xFF0088cc),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}