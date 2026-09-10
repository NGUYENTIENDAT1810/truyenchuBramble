import 'package:flutter/material.dart';
import '../theme/bramble_colors.dart';

class BrambleSkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const BrambleSkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 14,
  });

  @override
  State<BrambleSkeletonBox> createState() => _BrambleSkeletonBoxState();
}

class _BrambleSkeletonBoxState extends State<BrambleSkeletonBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

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
        final t = _controller.value;
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment(-1.0 - t * 2, 0),
              end: Alignment(1.0 - t * 2, 0),
              colors: const [
                BrambleColors.creamSurface,
                BrambleColors.creamSurfaceHover,
                BrambleColors.creamSurface,
              ],
              stops: const [0.25, 0.5, 0.75],
            ).createShader(bounds);
          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: BrambleColors.creamSurface,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
          ),
        );
      },
    );
  }
}

class HomeSkeletonView extends StatelessWidget {
  const HomeSkeletonView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  BrambleSkeletonBox(width: 120, height: 12),
                  SizedBox(height: 8),
                  BrambleSkeletonBox(width: 190, height: 24),
                ],
              ),
              const BrambleSkeletonBox(width: 74, height: 34, borderRadius: 999),
            ],
          ),
          const SizedBox(height: 22),
          const BrambleSkeletonBox(height: 120, borderRadius: 28),
          const SizedBox(height: 24),
          SizedBox(
            height: 138,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: 13),
              itemBuilder: (_, __) => const BrambleSkeletonBox(width: 98, height: 138),
            ),
          ),
          const SizedBox(height: 24),
          Column(
            children: List.generate(
              3,
              (_) => const Padding(
                padding: EdgeInsets.only(bottom: 11),
                child: BrambleSkeletonBox(height: 64, borderRadius: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
