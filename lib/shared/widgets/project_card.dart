import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../models/project_model.dart';
import 'nawa_button.dart';

/// كرت عرض المشروع
/// يعرض معلومات المشروع بشكل مختصر وجذاب
class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback? onTap;
  final VoidCallback? onDonate;
  final VoidCallback? onLike;
  final bool isLiked;

  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.onDonate,
    this.onLike,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveHelper.isMobile(context)
            ? AppConstants.spacingMedium
            : AppConstants.spacingSmall,
        vertical: AppConstants.spacingSmall,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ========== صورة المشروع ==========
            _buildProjectImage(context),

            // ========== محتوى الكرت ==========
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // العنوان والموقع
                    _buildTitleAndLocation(context),

                    const SizedBox(height: AppConstants.spacingSmall),

                    // الوصف
                    _buildDescription(context),

                    const SizedBox(height: AppConstants.spacingMedium),

                    // شريط التقدم
                    _buildProgressBar(context),

                    const SizedBox(height: AppConstants.spacingSmall),

                    // المعلومات المالية
                    _buildFinancialInfo(context),

                    const SizedBox(height: AppConstants.spacingMedium),

                    // الأزرار
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectImage(BuildContext context) {
    return Stack(
      children: [
        // الصورة الأساسية
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(AppConstants.borderRadiusMedium),
            topRight: Radius.circular(AppConstants.borderRadiusMedium),
          ),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: project.media.mainImage != null
                ? Image.network(
                    project.media.mainImage!,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: AppColors.backgroundAccent,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
                  )
                : _buildPlaceholderImage(),
          ),
        ),
        
        // شارة الحالة
        Positioned(
          top: AppConstants.spacingSmall,
          right: AppConstants.spacingSmall,
          child: _buildStatusBadge(context),
        ),
        
        // زر الإعجاب
        Positioned(
          top: AppConstants.spacingSmall,
          left: AppConstants.spacingSmall,
          child: _buildLikeButton(context),
        ),
      ],
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: AppColors.backgroundAccent,
      child: const Center(
        child: Icon(
          Icons.image,
          size: 48,
          color: AppColors.helperGray,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color badgeColor;
    String statusText;

    switch (project.basic.status) {
      case 'active':
        badgeColor = AppColors.success;
        statusText = 'نشط';
        break;
      case 'completed':
        badgeColor = AppColors.primaryGreen;
        statusText = 'مكتمل';
        break;
      case 'pending':
        badgeColor = AppColors.warning;
        statusText = 'قيد المراجعة';
        break;
      default:
        badgeColor = AppColors.helperGray;
        statusText = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSmall,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Text(
        statusText,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textOnColor,
        ),
      ),
    );
  }

  Widget _buildLikeButton(BuildContext context) {
    return GestureDetector(
      onTap: onLike,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingSmall),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          color: isLiked ? AppColors.like : AppColors.helperGray,
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTitleAndLocation(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.basic.title,
                style: AppTextStyles.headlineSmall,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 16,
                    color: AppColors.helperGray,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${project.location.city} - ${project.location.district}',
                      style: AppTextStyles.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (project.verification.isVerified)
          const Icon(
            Icons.verified,
            color: AppColors.success,
            size: 20,
          ),
      ],
    );
  }

  Widget _buildDescription(BuildContext context) {
    return Text(
      project.basic.description,
      style: AppTextStyles.bodyMedium,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final progress = project.progressPercentage / 100;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'التقدم: ${project.progressPercentage.toStringAsFixed(1)}%',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
            Text(
              '${project.engagement.supporters} مساهم',
              style: AppTextStyles.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.progressBackground,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.progressBar),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildFinancialInfo(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تم جمع',
              style: AppTextStyles.labelSmall,
            ),
            Text(
              '\$${project.financial.currentAmount.toStringAsFixed(0)}',
              style: AppTextStyles.numberMedium.copyWith(
                color: AppColors.primaryGreen,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'الهدف',
              style: AppTextStyles.labelSmall,
            ),
            Text(
              '\$${project.financial.targetAmount.toStringAsFixed(0)}',
              style: AppTextStyles.numberMedium,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: NawaButton.primary(
            text: 'ساهم الآن',
            onPressed: onDonate,
            size: NawaButtonSize.small,
            icon: Icons.favorite,
          ),
        ),
        const SizedBox(width: AppConstants.spacingSmall),
        Expanded(
          child: NawaButton.secondary(
            text: 'التفاصيل',
            onPressed: onTap,
            size: NawaButtonSize.small,
          ),
        ),
      ],
    );
  }
}
