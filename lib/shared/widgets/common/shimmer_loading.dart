import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zevaro_web/core/theme/app_colors.dart';
import 'package:zevaro_web/core/theme/app_spacing.dart';

/// Shimmer loading placeholder for cards
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 120,
    this.width,
  });

  final double height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.3),
      highlightColor: AppColors.surface,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
    );
  }
}

/// Shimmer loading for a list of cards
class ShimmerCardList extends StatelessWidget {
  const ShimmerCardList({
    super.key,
    this.itemCount = 3,
    this.cardHeight = 120,
    this.spacing = AppSpacing.sm,
  });

  final int itemCount;
  final double cardHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(height: spacing),
      itemBuilder: (_, __) => ShimmerCard(height: cardHeight),
    );
  }
}

/// Shimmer for a grid of cards
class ShimmerCardGrid extends StatelessWidget {
  const ShimmerCardGrid({
    super.key,
    this.itemCount = 6,
    this.cardHeight = 180,
    this.crossAxisCount = 3,
    this.spacing = AppSpacing.md,
  });

  final int itemCount;
  final double cardHeight;
  final int crossAxisCount;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        mainAxisExtent: cardHeight,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => ShimmerCard(height: cardHeight),
    );
  }
}

/// Shimmer placeholder for text lines
class ShimmerText extends StatelessWidget {
  const ShimmerText({
    super.key,
    this.lines = 3,
    this.lineHeight = 16,
    this.spacing = 8,
  });

  final int lines;
  final double lineHeight;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.border.withOpacity(0.3),
      highlightColor: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(lines, (index) {
          final isLast = index == lines - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing),
            child: Container(
              height: lineHeight,
              width: isLast ? 120 : double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        }),
      ),
    );
  }
}
