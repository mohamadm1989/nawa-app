import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/animations/nawa_animations.dart';
import '../../core/routes/app_routes.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/permissions_service.dart';
import '../../core/services/web_notification_service.dart';
import '../../shared/models/models.dart';

/// صفحة الإشعارات
/// تعرض جميع الإشعارات مع إمكانية التفاعل معها
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;

  // الإشعارات التجريبية
  final List<Map<String, dynamic>> _allNotifications = [
    {
      'id': '1',
      'type': 'donation_success',
      'title': 'تم استلام تبرعك بنجاح! 💝',
      'message': 'شكراً لك! تبرعك بمبلغ \$100 لمشروع "ترميم مدرسة الأمل" تم استلامه بنجاح',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 30)),
      'isRead': false,
      'priority': 'high',
      'actionType': 'view_project',
      'actionData': {'projectId': 'project1'},
      'icon': Icons.favorite,
      'color': AppColors.success,
    },
    {
      'id': '2',
      'type': 'project_update',
      'title': 'تحديث مشروع ترميم المدرسة 🏫',
      'message': 'تم الانتهاء من 75% من أعمال الترميم! شاهد الصور الجديدة والتقدم المحرز',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
      'isRead': false,
      'priority': 'medium',
      'actionType': 'view_project',
      'actionData': {'projectId': 'project1'},
      'icon': Icons.construction,
      'color': AppColors.info,
    },
    {
      'id': '3',
      'type': 'achievement',
      'title': 'إنجاز جديد! 🏆',
      'message': 'مبروك! حصلت على شارة "قلب كبير" لتبرعك بأكثر من \$1000',
      'timestamp': DateTime.now().subtract(const Duration(hours: 5)),
      'isRead': true,
      'priority': 'high',
      'actionType': 'view_profile',
      'actionData': {},
      'icon': Icons.emoji_events,
      'color': AppColors.warning,
    },
    {
      'id': '4',
      'type': 'project_complete',
      'title': 'مشروع مكتمل! 🎉',
      'message': 'مشروع "المياه النظيفة" اكتمل بنجاح! شاهد التأثير الذي ساهمت في تحقيقه',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'priority': 'high',
      'actionType': 'view_impact',
      'actionData': {'projectId': 'project2'},
      'icon': Icons.check_circle,
      'color': AppColors.primaryGreen,
    },
    {
      'id': '5',
      'type': 'new_project',
      'title': 'مشروع جديد متاح! ✨',
      'message': 'مشروع "إعادة تأهيل المستشفى" متاح الآن للمساهمة. كن من أول المساهمين!',
      'timestamp': DateTime.now().subtract(const Duration(days: 2)),
      'isRead': true,
      'priority': 'medium',
      'actionType': 'view_project',
      'actionData': {'projectId': 'project3'},
      'icon': Icons.add_circle,
      'color': AppColors.info,
    },
    {
      'id': '6',
      'type': 'reminder',
      'title': 'تذكير ودود 💙',
      'message': 'لم تساهم منذ أسبوع! هناك مشاريع جديدة تحتاج دعمك',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
      'isRead': true,
      'priority': 'low',
      'actionType': 'browse_projects',
      'actionData': {},
      'icon': Icons.schedule,
      'color': AppColors.helperGray,
    },
    {
      'id': '7',
      'type': 'donation_receipt',
      'title': 'إيصال التبرع جاهز 📄',
      'message': 'إيصال تبرعك بمبلغ \$50 لمشروع "ترميم المدرسة" جاهز للتحميل',
      'timestamp': DateTime.now().subtract(const Duration(hours: 6)),
      'isRead': false,
      'priority': 'medium',
      'actionType': 'view_donations',
      'actionData': {'donationId': 'donation123'},
      'icon': Icons.receipt,
      'color': AppColors.info,
    },
    {
      'id': '8',
      'type': 'system_update',
      'title': 'تحديث التطبيق متاح 🔄',
      'message': 'إصدار جديد من التطبيق متاح مع مميزات محسنة وإصلاحات',
      'timestamp': DateTime.now().subtract(const Duration(hours: 12)),
      'isRead': false,
      'priority': 'medium',
      'actionType': 'view_settings',
      'actionData': {},
      'icon': Icons.system_update,
      'color': AppColors.warning,
    },
    {
      'id': '9',
      'type': 'community_milestone',
      'title': 'إنجاز مجتمعي رائع! 🌟',
      'message': 'تم الوصول لـ 1000 متبرع في منصة نِواة! شكراً لكونك جزء من هذا الإنجاز',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
      'isRead': true,
      'priority': 'high',
      'actionType': 'browse_projects',
      'actionData': {},
      'icon': Icons.celebration,
      'color': AppColors.primaryGreen,
    },
    {
      'id': '10',
      'type': 'project_urgent',
      'title': 'مشروع عاجل! ⚡',
      'message': 'مشروع "إسعاف طوارئ" يحتاج تمويل عاجل. باقي 3 أيام فقط لإكمال التمويل',
      'timestamp': DateTime.now().subtract(const Duration(minutes: 45)),
      'isRead': false,
      'priority': 'high',
      'actionType': 'view_project',
      'actionData': {'projectId': 'urgent_project'},
      'icon': Icons.emergency,
      'color': AppColors.error,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkNotificationPermissions();
  }

  /// التحقق من أذونات الإشعارات
  Future<void> _checkNotificationPermissions() async {
    // تأخير التحقق لتجنب مشاكل البناء
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      if (kIsWeb) {
        // للويب، نتحقق من دعم الإشعارات
        final isSupported = WebNotificationService.instance.isNotificationSupported;
        if (!isSupported && mounted) {
          _showPermissionDialog();
        }
      } else {
        // للموبايل، نتحقق من الأذونات العادية
        try {
          final isGranted = await PermissionsService.instance.isNotificationPermissionGranted();
          if (!isGranted && mounted) {
            _showPermissionDialog();
          }
        } catch (e) {
          debugPrint('خطأ في التحقق من أذونات الإشعارات: $e');
        }
      }
    });
  }

  /// عرض حوار طلب أذونات الإشعارات
  void _showPermissionDialog() {
    // التحقق من المنصة أولاً
    if (kIsWeb) {
      // للويب، نستخدم الحل المخصص
      WebNotificationService.instance.showWebNotificationSettings(context);
    } else {
      // للموبايل، نستخدم الطريقة العادية
      PermissionsService.instance.showPermissionDialog(
        context,
        title: 'إذن الإشعارات مطلوب',
        message: 'للحصول على إشعارات فورية حول التبرعات والمشاريع، يرجى منح إذن الإشعارات.',
        permissionName: 'الإشعارات',
        requestPermission: () => PermissionsService.instance.requestNotificationPermission(),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeWidget(
      widgetName: 'NotificationsScreen',
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: _buildAppBar(),
        body: SafeWidget(
          widgetName: 'NotificationsBody',
          child: Column(
            children: [
              // الإحصائيات السريعة
              SafeWidget(
                widgetName: 'QuickStats',
                child: _buildQuickStats(),
              ),

              // التبويبات
              SafeWidget(
                widgetName: 'TabBar',
                child: _buildTabBar(),
              ),

              // محتوى التبويبات
              Expanded(
                child: SafeWidget(
                  widgetName: 'TabBarView',
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SafeWidget(
                        widgetName: 'AllNotifications',
                        child: _buildAllNotifications(),
                      ),
                      SafeWidget(
                        widgetName: 'UnreadNotifications',
                        child: _buildUnreadNotifications(),
                      ),
                      SafeWidget(
                        widgetName: 'ImportantNotifications',
                        child: _buildImportantNotifications(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final unreadCount = _allNotifications.where((n) => !n['isRead']).length;
    
    return AppBar(
      title: const Text('الإشعارات'),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      actions: [
        // عدد الإشعارات غير المقروءة
        if (unreadCount > 0)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$unreadCount',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textOnColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        
        // زر تحديد الكل كمقروء
        IconButton(
          onPressed: _markAllAsRead,
          icon: const Icon(Icons.done_all),
          tooltip: 'تحديد الكل كمقروء',
        ),
        
        // زر اختبار الإشعارات
        IconButton(
          onPressed: _testNotification,
          icon: const Icon(Icons.notification_add),
          tooltip: 'اختبار إشعار',
        ),

        // زر الإعدادات
        IconButton(
          onPressed: _showNotificationSettings,
          icon: const Icon(Icons.settings),
          tooltip: 'إعدادات الإشعارات',
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final totalCount = _allNotifications.length;
    final unreadCount = _allNotifications.where((n) => !n['isRead']).length;
    final todayCount = _allNotifications.where((n) {
      final today = DateTime.now();
      final notificationDate = n['timestamp'] as DateTime;
      return notificationDate.day == today.day &&
             notificationDate.month == today.month &&
             notificationDate.year == today.year;
    }).length;

    return Container(
      margin: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      padding: EdgeInsets.all(ResponsiveHelper.getSpacing(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen.withValues(alpha: 0.1),
            AppColors.secondaryBeige.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
      ),
      child: ResponsiveHelper.isMobile(context)
          ? _buildMobileNotificationStats(totalCount, unreadCount, todayCount)
          : _buildTabletDesktopNotificationStats(totalCount, unreadCount, todayCount),
    );
  }

  Widget _buildMobileNotificationStats(int totalCount, int unreadCount, int todayCount) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(
                title: 'المجموع',
                value: '$totalCount',
                icon: Icons.notifications,
                color: AppColors.info,
              ),
            ),
            SizedBox(width: ResponsiveHelper.getSpacing(context)),
            Expanded(
              child: _buildStatItem(
                title: 'غير مقروء',
                value: '$unreadCount',
                icon: Icons.mark_email_unread,
                color: AppColors.error,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveHelper.getSpacing(context)),
        _buildStatItem(
          title: 'اليوم',
          value: '$todayCount',
          icon: Icons.today,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildTabletDesktopNotificationStats(int totalCount, int unreadCount, int todayCount) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            title: 'المجموع',
            value: '$totalCount',
            icon: Icons.notifications,
            color: AppColors.info,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildStatItem(
            title: 'غير مقروء',
            value: '$unreadCount',
            icon: Icons.mark_email_unread,
            color: AppColors.error,
          ),
        ),
        Container(
          width: 1,
          height: 40,
          color: AppColors.primaryGreen.withValues(alpha: 0.3),
        ),
        Expanded(
          child: _buildStatItem(
            title: 'اليوم',
            value: '$todayCount',
            icon: Icons.today,
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.numberMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppTextStyles.labelSmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorPadding: const EdgeInsets.all(4),
        labelColor: AppColors.textOnColor,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTextStyles.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('الكل'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('غير مقروء'),
            ),
          ),
          Tab(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text('مهم'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllNotifications() {
    return _buildNotificationsList(_allNotifications);
  }

  Widget _buildUnreadNotifications() {
    final unreadNotifications = _allNotifications
        .where((notification) => !notification['isRead'])
        .toList();
    
    if (unreadNotifications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.mark_email_read,
        title: 'لا توجد إشعارات غير مقروءة',
        message: 'رائع! قرأت جميع الإشعارات 👏',
      );
    }
    
    return _buildNotificationsList(unreadNotifications);
  }

  Widget _buildImportantNotifications() {
    final importantNotifications = _allNotifications
        .where((notification) => notification['priority'] == 'high')
        .toList();
    
    if (importantNotifications.isEmpty) {
      return _buildEmptyState(
        icon: Icons.priority_high,
        title: 'لا توجد إشعارات مهمة',
        message: 'ستظهر الإشعارات المهمة هنا',
      );
    }
    
    return _buildNotificationsList(importantNotifications);
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return SafeWidget(
        widgetName: 'EmptyNotifications',
        child: _buildEmptyState(
          icon: Icons.notifications_none,
          title: 'لا توجد إشعارات',
          message: 'ستظهر الإشعارات الجديدة هنا',
        ),
      );
    }

    return SafeWidget(
      widgetName: 'NotificationsList',
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return SafeWidget(
            widgetName: 'NotificationItem_$index',
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300 + (index * 50)),
              curve: Curves.easeOutBack,
              transform: Matrix4.translationValues(0, 0, 0),
              child: InteractiveAnimation(
                onTap: () => _handleNotificationTap(notification),
                child: SafeWidget(
                  widgetName: 'NotificationCard_$index',
                  child: _buildNotificationCard(notification),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = UserDataManager.getSafeBool(notification, 'isRead', false);
    final timestamp = notification['timestamp'] as DateTime? ?? DateTime.now();
    final timeAgo = _getTimeAgo(timestamp);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead
            ? AppColors.backgroundCard
            : AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead
              ? AppColors.helperGray.withValues(alpha: 0.2)
              : AppColors.primaryGreen.withValues(alpha: 0.3),
          width: isRead ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _handleNotificationTap(notification),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الأيقونة
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (notification['color'] as Color? ?? AppColors.primaryGreen).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    notification['icon'] as IconData? ?? Icons.notifications,
                    color: notification['color'] as Color? ?? AppColors.primaryGreen,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 12),

                // المحتوى
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // العنوان والوقت
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              UserDataManager.getSafeString(notification, 'title', 'إشعار'),
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                                color: isRead ? AppColors.textPrimary : AppColors.primaryGreen,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            timeAgo,
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // الرسالة
                      Text(
                        UserDataManager.getSafeString(notification, 'message', 'لا توجد رسالة'),
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      // أزرار العمل
                      _buildNotificationActions(notification),
                    ],
                  ),
                ),

                // مؤشر عدم القراءة
                if (!isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationActions(Map<String, dynamic> notification) {
    final actionType = UserDataManager.getSafeString(notification, 'actionType', 'view');

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // زر العمل الأساسي
          Flexible(
            child: TextButton.icon(
              onPressed: () => _handleNotificationAction(notification),
              icon: Icon(
                _getActionIcon(actionType),
                size: 16,
                color: AppColors.primaryGreen,
              ),
              label: Text(
                _getActionText(actionType),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          const SizedBox(width: 4),

          // زر تحديد كمقروء/غير مقروء
          IconButton(
            onPressed: () => _toggleReadStatus(notification),
            icon: Icon(
              UserDataManager.getSafeBool(notification, 'isRead', false) ? Icons.mark_email_unread : Icons.mark_email_read,
              size: 16,
              color: AppColors.helperGray,
            ),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),

          // زر الحذف
          IconButton(
            onPressed: () => _deleteNotification(notification),
            icon: const Icon(
              Icons.delete_outline,
              size: 16,
              color: AppColors.error,
            ),
            style: IconButton.styleFrom(
              padding: const EdgeInsets.all(4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.helperGray.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.helperGray,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.helperGray,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ========== معالجات الأحداث ==========

  void _handleNotificationTap(Map<String, dynamic> notification) {
    // تحديد الإشعار كمقروء عند النقر
    if (!UserDataManager.getSafeBool(notification, 'isRead', false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            notification['isRead'] = true;
          });
        }
      });
    }

    // تنفيذ العمل
    _handleNotificationAction(notification);
  }

  void _handleNotificationAction(Map<String, dynamic> notification) {
    final actionType = UserDataManager.getSafeString(notification, 'actionType', 'view');
    final actionData = notification['actionData'] as Map<String, dynamic>? ?? <String, dynamic>{};

    switch (actionType) {
      case 'view_project':
        _navigateToProject(actionData);
        break;
      case 'view_profile':
        _navigateToProfile();
        break;
      case 'view_impact':
        _navigateToImpact(actionData);
        break;
      case 'browse_projects':
        _navigateToHome();
        break;
      case 'view_donations':
        _navigateToDonations();
        break;
      case 'view_settings':
        _navigateToSettings();
        break;
      default:
        _showInfoMessage('عذراً، هذا الإجراء غير متاح حالياً');
    }
  }

  // ========== دوال التنقل ==========

  void _navigateToProject(Map<String, dynamic> actionData) {
    final projectId = UserDataManager.getSafeString(actionData, 'projectId', '');

    if (projectId.isNotEmpty) {
      // إنشاء مشروع تجريبي للعرض
      final sampleProject = _createSampleProject(projectId);

      Navigator.of(context).pushNamed(
        AppRoutes.projectDetails,
        arguments: sampleProject,
      ).then((_) {
        _showSuccessMessage('تم عرض تفاصيل المشروع');
      });
    } else {
      _showErrorMessage('معرف المشروع غير صحيح');
    }
  }

  void _navigateToProfile() {
    Navigator.of(context).pushNamed(AppRoutes.profile).then((_) {
      _showSuccessMessage('تم فتح الملف الشخصي');
    });
  }

  void _navigateToImpact(Map<String, dynamic> actionData) {
    final projectId = UserDataManager.getSafeString(actionData, 'projectId', '');

    if (projectId.isNotEmpty) {
      // إنشاء مشروع تجريبي للعرض
      final sampleProject = _createSampleProject(projectId);

      Navigator.of(context).pushNamed(
        AppRoutes.projectDetails,
        arguments: sampleProject,
      ).then((_) {
        _showSuccessMessage('تم عرض تأثير المشروع');
      });
    } else {
      _showErrorMessage('معرف المشروع غير صحيح');
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
    );
    _showSuccessMessage('تم الانتقال للصفحة الرئيسية');
  }

  void _navigateToDonations() {
    Navigator.of(context).pushNamed(AppRoutes.profile).then((_) {
      _showSuccessMessage('تم عرض تبرعاتك');
    });
  }

  void _navigateToSettings() {
    _showNotificationSettings();
  }

  void _toggleReadStatus(Map<String, dynamic> notification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          final currentStatus = UserDataManager.getSafeBool(notification, 'isRead', false);
          notification['isRead'] = !currentStatus;
        });

        final newStatus = UserDataManager.getSafeBool(notification, 'isRead', false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              newStatus ? 'تم تحديد الإشعار كمقروء' : 'تم تحديد الإشعار كغير مقروء',
            ),
          ),
        );
      }
    });
  }

  void _deleteNotification(Map<String, dynamic> notification) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          final notificationId = UserDataManager.getSafeString(notification, 'id', '');
          _allNotifications.removeWhere((n) => UserDataManager.getSafeString(n, 'id', '') == notificationId);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حذف الإشعار')),
        );
      }
    });
  }

  void _markAllAsRead() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          for (var notification in _allNotifications) {
            notification['isRead'] = true;
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تحديد جميع الإشعارات كمقروءة')),
        );
      }
    });
  }

  /// اختبار إشعار محلي
  Future<void> _testNotification() async {
    try {
      if (kIsWeb) {
        // للويب، نستخدم الحل المخصص
        await WebNotificationService.instance.sendTestNotification();
        if (mounted) {
          _showInfoMessage('تم إرسال إشعار تجريبي للويب! 🌐');
        }
      } else {
        // للموبايل، نستخدم الطريقة العادية
        final success = await NotificationService.instance.showLocalNotification(
          title: 'إشعار تجريبي 🔔',
          body: 'هذا إشعار تجريبي من تطبيق نوى للتأكد من عمل الإشعارات بشكل صحيح',
          type: NotificationType.general,
          data: {
            'action': 'test',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );

        if (mounted) {
          if (success) {
            _showInfoMessage('تم إرسال إشعار تجريبي بنجاح! 🎉');
          } else {
            _showInfoMessage('فشل في إرسال الإشعار. تحقق من الأذونات.');
          }
        }
      }
    } catch (e) {
      debugPrint('❌ خطأ في اختبار الإشعار: $e');
      if (mounted) {
        _showErrorMessage('حدث خطأ في اختبار الإشعار');
      }
    }
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationSettingsSheet(),
    );
  }

  Widget _buildNotificationSettingsSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // مقبض السحب
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppColors.helperGray.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // العنوان
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.settings,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'إعدادات الإشعارات',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  color: AppColors.helperGray,
                ),
              ],
            ),
          ),

          // المحتوى
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSettingSection(
                    'أنواع الإشعارات',
                    [
                      _buildSettingItem('إشعارات التبرعات', true, Icons.favorite),
                      _buildSettingItem('تحديثات المشاريع', true, Icons.construction),
                      _buildSettingItem('الإنجازات والشارات', false, Icons.emoji_events),
                      _buildSettingItem('المشاريع الجديدة', true, Icons.add_circle),
                      _buildSettingItem('التذكيرات', false, Icons.schedule),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSettingSection(
                    'إعدادات الصوت',
                    [
                      _buildSettingItem('تفعيل الصوت', true, Icons.volume_up),
                      _buildSettingItem('الاهتزاز', true, Icons.vibration),
                    ],
                  ),

                  const SizedBox(height: 24),

                  _buildSettingSection(
                    'أوقات الإشعارات',
                    [
                      _buildTimeSettingItem('من الساعة', '08:00'),
                      _buildTimeSettingItem('إلى الساعة', '22:00'),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // أزرار الحفظ والإلغاء
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: AppColors.helperGray),
                          ),
                          child: Text(
                            'إلغاء',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.helperGray,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _showSuccessMessage('تم حفظ الإعدادات بنجاح');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            'حفظ',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildSettingItem(String title, bool value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.helperGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: value ? AppColors.primaryGreen : AppColors.helperGray,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // TODO: تحديث الإعدادات
            },
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSettingItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.helperGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            color: AppColors.primaryGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: فتح منتقي الوقت
              _showInfoMessage('سيتم إضافة منتقي الوقت قريباً');
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: AppColors.primaryGreen.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                time,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primaryGreen,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ========== دوال مساعدة ==========

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}د';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}س';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}ي';
    } else {
      return '${difference.inDays ~/ 7}أ';
    }
  }

  IconData _getActionIcon(String actionType) {
    switch (actionType) {
      case 'view_project':
        return Icons.visibility;
      case 'view_profile':
        return Icons.person;
      case 'view_impact':
        return Icons.analytics;
      case 'browse_projects':
        return Icons.explore;
      case 'view_donations':
        return Icons.receipt_long;
      case 'view_settings':
        return Icons.settings;
      default:
        return Icons.open_in_new;
    }
  }

  String _getActionText(String actionType) {
    switch (actionType) {
      case 'view_project':
        return 'عرض المشروع';
      case 'view_profile':
        return 'الملف الشخصي';
      case 'view_impact':
        return 'عرض التأثير';
      case 'browse_projects':
        return 'تصفح المشاريع';
      case 'view_donations':
        return 'عرض التبرعات';
      case 'view_settings':
        return 'الإعدادات';
      default:
        return 'عرض';
    }
  }

  // ========== دوال إنشاء البيانات التجريبية ==========

  ProjectModel _createSampleProject(String projectId) {
    // إنشاء مشروع تجريبي بناءً على المعرف
    return ProjectModel(
      projectId: projectId,
      basic: ProjectBasic(
        title: _getProjectTitleById(projectId),
        description: _getProjectDescriptionById(projectId),
        category: 'education',
        status: 'active',
        priority: 'high',
        tags: ['تعليم', 'ترميم', 'مدرسة'],
      ),
      location: const ProjectLocation(
        city: 'دمشق',
        district: 'المزة',
        address: 'شارع الثورة، بناء رقم 123',
        coordinates: GeoCoordinates(lat: 33.5138, lng: 36.2765),
      ),
      financial: const ProjectFinancial(
        targetAmount: 50000,
        currentAmount: 37500,
        currency: 'USD',
        breakdown: ProjectBreakdown(
          materials: 30000,
          labor: 15000,
          other: 5000,
        ),
      ),
      timeline: ProjectTimeline(
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        startDate: DateTime.now().subtract(const Duration(days: 20)),
        expectedEndDate: DateTime.now().add(const Duration(days: 60)),
      ),
      creator: const ProjectCreator(
        uid: 'creator123',
        name: 'أحمد محمد',
        role: 'مدير المشروع',
        contact: 'ahmed@example.com',
      ),
      media: const ProjectMedia(
        mainImage: 'https://via.placeholder.com/400x300',
        gallery: [
          'https://via.placeholder.com/400x300',
          'https://via.placeholder.com/400x300',
        ],
        documents: [],
      ),
      engagement: const ProjectEngagement(
        supporters: 125,
        likes: 89,
        comments: 23,
        shares: 15,
        views: 456,
      ),
      verification: const ProjectVerification(
        status: 'verified',
        verifiedBy: 'admin',
        verificationDate: null,
        documents: [],
      ),
    );
  }

  String _getProjectTitleById(String projectId) {
    switch (projectId) {
      case 'project1':
        return 'ترميم مدرسة الأمل';
      case 'project2':
        return 'مشروع المياه النظيفة';
      case 'project3':
        return 'إعادة تأهيل المستشفى';
      default:
        return 'مشروع إعادة الإعمار';
    }
  }

  String _getProjectDescriptionById(String projectId) {
    switch (projectId) {
      case 'project1':
        return 'مشروع ترميم وإعادة تأهيل مدرسة الأمل في منطقة المزة لتوفير بيئة تعليمية آمنة ومناسبة للأطفال.';
      case 'project2':
        return 'مشروع توفير المياه النظيفة والصالحة للشرب للمناطق المتضررة من خلال حفر آبار وتركيب أنظمة تنقية.';
      case 'project3':
        return 'إعادة تأهيل وتجهيز المستشفى المحلي بالمعدات الطبية الحديثة لتقديم خدمات صحية أفضل للمجتمع.';
      default:
        return 'مشروع إعادة إعمار يهدف إلى تحسين الحياة في المجتمع السوري.';
    }
  }

  // ========== دوال الرسائل ==========

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showInfoMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }


}
