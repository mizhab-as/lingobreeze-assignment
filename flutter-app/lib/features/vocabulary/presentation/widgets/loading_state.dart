import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class LoadingState extends StatefulWidget {
  const LoadingState({super.key});

  @override
  State<LoadingState> createState() => _LoadingStateState();
}

class _LoadingStateState extends State<LoadingState> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacityAnimation = Tween<double>(begin: 0.35, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppColors.surfaceDark : Colors.white;
    final shimmerColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 4,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: shimmerColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 120,
                          height: 20,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 16,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 200,
                      height: 14,
                      decoration: BoxDecoration(
                        color: shimmerColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
