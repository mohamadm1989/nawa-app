import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/safety/safe_widget.dart';
import '../../core/services/advanced_notification_service.dart';
import '../../shared/models/notification_model.dart';

/// صفحة إحصائيات الإشعارات
class NotificationAnalyticsScreen extends StatefulWidget {
  const NotificationAnalyticsScreen({super.key});

  @override
  State<NotificationAnalyticsScreen> createState() => _NotificationAnalyticsScreenState();
}

class _NotificationAnalyticsScreenState extends State<NotificationAnalyticsScreen> {
  final AdvancedNotificationService _notificationService = AdvancedNotificationService.instance;
  
  bool _isLoading = true;
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// تحميل البيانات
  Future<void> _loadData() async {
    try {
      setState(() => _isLoading = true);
      
      await _notificationService.initialize();
      _notifications = _notificationService.notifications;
      
      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ خطأ في تحميل بيانات الإحصائيات: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      widgetName: 'NotificationAnalyticsScreen',
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          title: const Text('إحصائيات الإشعارات'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          elevation: 0,
        ),
        body: _isLoading ? _buildLoadingState() : _buildContent(),
      ),
    );
  }

  /// بناء حالة التحميل
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الإحصائيات...'),
        ],
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildContent() {
    return SafeWidget(
      widgetName: 'AnalyticsContent',
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // الإحصائيات العامة
          _buildGeneralStats(),
          
          const SizedBox(height: 16),
          
          // إحصائيات الأنواع
          _buildTypeStats(),
          
          const SizedBox(height: 16),
          
          // إحصائيات الأولويات
          _buildPriorityStats(),
          
          const SizedBox(height: 16),
          
          // إحصائيات القراءة
          _buildReadingStats(),
          
          const SizedBox(height: 16),
          
          // الإشعارات الحديثة
          _buildRecentActivity(),
        ],
      ),
    );
  }

  /// بناء الإحصائيات العامة
  Widget _buildGeneralStats() {
    final totalCount = _notifications.length;
    final unreadCount = _notifications.where((n) => !n.isRead).length;
    final readCount = totalCount - unreadCount;
    final pinnedCount = _notifications.where((n) => n.isPinned).length;

    return _buildStatsCard(
      title: 'الإحصائيات العامة',
      icon: Icons.analytics,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                label: 'المجموع',
                value: totalCount.toString(),
                color: AppColors.primaryGreen,
                icon: Icons.notifications,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                label: 'غير مقروءة',
                value: unreadCount.toString(),
                color: Colors.orange,
                icon: Icons.mark_email_unread,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                label: 'مقروءة',
                value: readCount.toString(),
                color: Colors.green,
                icon: Icons.mark_email_read,
              ),
            ),
            Expanded(
              child: _buildStatItem(
                label: 'مثبتة',
                value: pinnedCount.toString(),
                color: Colors.blue,
                icon: Icons.push_pin,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// بناء إحصائيات الأنواع
  Widget _buildTypeStats() {
    final typeStats = <NotificationType, int>{};
    for (final notification in _notifications) {
      typeStats[notification.type] = (typeStats[notification.type] ?? 0) + 1;
    }

    return _buildStatsCard(
      title: 'إحصائيات الأنواع',
      icon: Icons.category,
      children: [
        ...typeStats.entries.map((entry) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Icon(
                  _getTypeIcon(entry.key),
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getTypeDisplayName(entry.key),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// بناء إحصائيات الأولويات
  Widget _buildPriorityStats() {
    final priorityStats = <NotificationPriority, int>{};
    for (final notification in _notifications) {
      priorityStats[notification.priority] = (priorityStats[notification.priority] ?? 0) + 1;
    }

    return _buildStatsCard(
      title: 'إحصائيات الأولويات',
      icon: Icons.priority_high,
      children: [
        ...priorityStats.entries.map((entry) => 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getPriorityColor(entry.key),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getPriorityDisplayName(entry.key),
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(entry.key).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.value.toString(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _getPriorityColor(entry.key),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// بناء إحصائيات القراءة
  Widget _buildReadingStats() {
    final totalCount = _notifications.length;
    final readCount = _notifications.where((n) => n.isRead).length;
    final readPercentage = totalCount > 0 ? (readCount / totalCount * 100).round() : 0;

    return _buildStatsCard(
      title: 'معدل القراءة',
      icon: Icons.trending_up,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'معدل القراءة',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: readPercentage / 100,
                    backgroundColor: Colors.grey.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$readPercentage% ($readCount من $totalCount)',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// بناء النشاط الحديث
  Widget _buildRecentActivity() {
    final recentNotifications = _notifications
        .where((n) => DateTime.now().difference(n.timestamp).inDays < 7)
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return _buildStatsCard(
      title: 'النشاط الأخير (7 أيام)',
      icon: Icons.history,
      children: [
        if (recentNotifications.isEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Text('لا توجد إشعارات حديثة'),
            ),
          )
        else
          ...recentNotifications.take(5).map((notification) => 
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(
                    notification.icon,
                    color: notification.color,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// بناء بطاقة إحصائيات
  Widget _buildStatsCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primaryGreen,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  /// بناء عنصر إحصائية
  Widget _buildStatItem({
    required String label,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// الحصول على أيقونة النوع
  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.donation:
        return Icons.favorite;
      case NotificationType.project:
        return Icons.work;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.update:
        return Icons.update;
      case NotificationType.achievement:
        return Icons.emoji_events;
      case NotificationType.reminder:
        return Icons.alarm;
      case NotificationType.social:
        return Icons.people;
      case NotificationType.security:
        return Icons.security;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  /// الحصول على اسم النوع
  String _getTypeDisplayName(NotificationType type) {
    switch (type) {
      case NotificationType.donation:
        return 'التبرعات';
      case NotificationType.project:
        return 'المشاريع';
      case NotificationType.system:
        return 'النظام';
      case NotificationType.update:
        return 'التحديثات';
      case NotificationType.achievement:
        return 'الإنجازات';
      case NotificationType.reminder:
        return 'التذكيرات';
      case NotificationType.social:
        return 'الاجتماعية';
      case NotificationType.security:
        return 'الأمان';
      case NotificationType.general:
        return 'العامة';
    }
  }

  /// الحصول على اسم الأولوية
  String _getPriorityDisplayName(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return 'عالية';
      case NotificationPriority.medium:
        return 'متوسطة';
      case NotificationPriority.low:
        return 'منخفضة';
      case NotificationPriority.info:
        return 'معلوماتية';
    }
  }

  /// الحصول على لون الأولوية
  Color _getPriorityColor(NotificationPriority priority) {
    switch (priority) {
      case NotificationPriority.high:
        return Colors.red;
      case NotificationPriority.medium:
        return Colors.orange;
      case NotificationPriority.low:
        return Colors.blue;
      case NotificationPriority.info:
        return Colors.green;
    }
  }

  /// تنسيق الوقت
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'الآن';
    } else if (difference.inHours < 1) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else if (difference.inDays < 1) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} يوم';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
