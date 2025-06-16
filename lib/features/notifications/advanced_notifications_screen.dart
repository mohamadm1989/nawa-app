import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/safety/safe_widget.dart';
import '../../core/services/advanced_notification_service.dart';
import '../../core/services/web_notification_service.dart';
import '../../shared/models/notification_model.dart';
import 'notification_settings_screen.dart';
import 'notification_analytics_screen.dart';

/// صفحة الإشعارات المتقدمة والآمنة
class AdvancedNotificationsScreen extends StatefulWidget {
  const AdvancedNotificationsScreen({super.key});

  @override
  State<AdvancedNotificationsScreen> createState() => _AdvancedNotificationsScreenState();
}

class _AdvancedNotificationsScreenState extends State<AdvancedNotificationsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  
  late TabController _tabController;
  final AdvancedNotificationService _notificationService = AdvancedNotificationService.instance;
  
  // حالة التحميل والبحث
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // فلاتر متقدمة
  NotificationType? _selectedTypeFilter;
  NotificationPriority? _selectedPriorityFilter;
  bool _showReadOnly = false;
  bool _showUnreadOnly = false;

  // قوائم الإشعارات
  List<NotificationModel> _allNotifications = [];
  List<NotificationModel> _unreadNotifications = [];
  List<NotificationModel> _importantNotifications = [];
  List<NotificationModel> _filteredNotifications = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeNotifications();
  }

  /// تهيئة الإشعارات
  Future<void> _initializeNotifications() async {
    try {
      setState(() => _isLoading = true);
      
      // تهيئة خدمة الإشعارات
      await _notificationService.initialize();
      
      // تحميل البيانات
      await _loadNotifications();
      
      // الاستماع للتحديثات
      _notificationService.notificationsStream.listen((notifications) {
        if (mounted) {
          _updateNotificationLists(notifications);
        }
      });

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ خطأ في تهيئة الإشعارات: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// تحميل الإشعارات
  Future<void> _loadNotifications() async {
    try {
      final notifications = _notificationService.notifications;
      _updateNotificationLists(notifications);
    } catch (e) {
      debugPrint('❌ خطأ في تحميل الإشعارات: $e');
    }
  }

  /// تحديث قوائم الإشعارات
  void _updateNotificationLists(List<NotificationModel> notifications) {
    if (!mounted) return;
    
    setState(() {
      _allNotifications = notifications;
      _unreadNotifications = _notificationService.getUnreadNotifications();
      _importantNotifications = _notificationService.getImportantNotifications();
      _applySearch();
    });
  }

  /// تطبيق البحث والفلاتر
  void _applySearch() {
    var currentNotifications = _getCurrentTabNotifications();

    // تطبيق فلتر النوع
    if (_selectedTypeFilter != null) {
      currentNotifications = currentNotifications.where((n) => n.type == _selectedTypeFilter).toList();
    }

    // تطبيق فلتر الأولوية
    if (_selectedPriorityFilter != null) {
      currentNotifications = currentNotifications.where((n) => n.priority == _selectedPriorityFilter).toList();
    }

    // تطبيق فلتر حالة القراءة
    if (_showReadOnly) {
      currentNotifications = currentNotifications.where((n) => n.isRead).toList();
    } else if (_showUnreadOnly) {
      currentNotifications = currentNotifications.where((n) => !n.isRead).toList();
    }

    // تطبيق البحث النصي
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      currentNotifications = currentNotifications.where((notification) {
        return notification.title.toLowerCase().contains(query) ||
               notification.message.toLowerCase().contains(query) ||
               notification.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    _filteredNotifications = currentNotifications;
  }

  /// الحصول على إشعارات التبويب الحالي
  List<NotificationModel> _getCurrentTabNotifications() {
    switch (_tabController.index) {
      case 0:
        return _allNotifications;
      case 1:
        return _unreadNotifications;
      case 2:
        return _importantNotifications;
      default:
        return _allNotifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    
    return SafeWidget(
      widgetName: 'AdvancedNotificationsScreen',
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: _buildAppBar(),
        body: SafeArea(
          child: SafeWidget(
            widgetName: 'NotificationsBody',
            child: _isLoading ? _buildLoadingState() : _buildContent(),
          ),
        ),
      ),
    );
  }

  /// بناء شريط التطبيق
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('الإشعارات'),
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.textOnColor,
      elevation: 0,
      actions: [
        // زر البحث
        SafeWidget(
          widgetName: 'SearchButton',
          child: IconButton(
            onPressed: _toggleSearch,
            icon: const Icon(Icons.search),
            tooltip: 'البحث',
          ),
        ),
        // زر الفلترة
        SafeWidget(
          widgetName: 'FilterButton',
          child: IconButton(
            onPressed: _showFilterDialog,
            icon: const Icon(Icons.filter_list),
            tooltip: 'فلترة الإشعارات',
          ),
        ),
        // زر تحديد الكل كمقروء
        SafeWidget(
          widgetName: 'MarkAllReadButton',
          child: IconButton(
            onPressed: _unreadNotifications.isNotEmpty ? _markAllAsRead : null,
            icon: const Icon(Icons.done_all),
            tooltip: 'تحديد الكل كمقروء',
          ),
        ),
        // زر الإحصائيات
        SafeWidget(
          widgetName: 'AnalyticsButton',
          child: IconButton(
            onPressed: _openAnalytics,
            icon: const Icon(Icons.analytics),
            tooltip: 'إحصائيات الإشعارات',
          ),
        ),
        // زر الإعدادات
        SafeWidget(
          widgetName: 'SettingsButton',
          child: IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'إعدادات الإشعارات',
          ),
        ),
        // زر اختبار الإشعارات
        SafeWidget(
          widgetName: 'TestNotificationButton',
          child: IconButton(
            onPressed: _sendTestNotification,
            icon: const Icon(Icons.notification_add),
            tooltip: 'اختبار إشعار',
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SafeWidget(
          widgetName: 'AppBarBottom',
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // الإحصائيات السريعة
                Expanded(
                  flex: 1,
                  child: SafeWidget(
                    widgetName: 'QuickStats',
                    child: _buildQuickStats(),
                  ),
                ),

                // التبويبات
                SafeWidget(
                  widgetName: 'TabBar',
                  child: _buildTabBar(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// بناء شريط البحث
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'البحث في الإشعارات...',
          hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  onPressed: _clearSearch,
                  icon: const Icon(Icons.clear, color: Colors.white),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
            _applySearch();
          });
        },
      ),
    );
  }

  /// بناء الإحصائيات السريعة
  Widget _buildQuickStats() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            icon: Icons.notifications,
            label: 'المجموع',
            count: _notificationService.totalCount,
            color: Colors.white,
          ),
          _buildStatItem(
            icon: Icons.mark_email_unread,
            label: 'غير مقروءة',
            count: _notificationService.unreadCount,
            color: Colors.orange,
          ),
          _buildStatItem(
            icon: Icons.priority_high,
            label: 'مهمة',
            count: _importantNotifications.length,
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  /// بناء عنصر إحصائية
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            count.toString(),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 11,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// بناء شريط التبويبات
  Widget _buildTabBar() {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.white,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withValues(alpha: 0.7),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        isScrollable: false,
        tabAlignment: TabAlignment.fill,
        onTap: (index) {
          setState(() {
            _applySearch();
          });
        },
        tabs: [
          Tab(text: 'الكل (${_allNotifications.length})'),
          Tab(text: 'غير مقروءة (${_unreadNotifications.length})'),
          Tab(text: 'مهمة (${_importantNotifications.length})'),
        ],
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
          Text('جاري تحميل الإشعارات...'),
        ],
      ),
    );
  }

  /// بناء المحتوى الرئيسي
  Widget _buildContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildNotificationsList(_filteredNotifications.isEmpty ? _allNotifications : _filteredNotifications),
        _buildNotificationsList(_filteredNotifications.isEmpty ? _unreadNotifications : _filteredNotifications),
        _buildNotificationsList(_filteredNotifications.isEmpty ? _importantNotifications : _filteredNotifications),
      ],
    );
  }

  /// بناء قائمة الإشعارات
  Widget _buildNotificationsList(List<NotificationModel> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return SafeWidget(
      widgetName: 'NotificationsList',
      child: RefreshIndicator(
        onRefresh: _refreshNotifications,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return SafeWidget(
              widgetName: 'NotificationItem_${notification.id}',
              child: _buildNotificationCard(notification, index),
            );
          },
        ),
      ),
    );
  }

  /// بناء بطاقة الإشعار البسيطة والجميلة
  Widget _buildNotificationCard(NotificationModel notification, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : AppColors.primaryGreen.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: notification.isPinned
              ? AppColors.primaryGreen
              : Colors.grey.withValues(alpha: 0.2),
          width: notification.isPinned ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _handleNotificationTap(notification),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // الرأس
              Row(
                children: [
                  // أيقونة النوع
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: notification.color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      notification.icon,
                      color: notification.color,
                      size: 20,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // العنوان ونوع الإشعار
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          notification.typeDescription,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: notification.color,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // مؤشرات الحالة
                  Column(
                    children: [
                      if (notification.isPinned)
                        Icon(
                          Icons.push_pin,
                          color: AppColors.primaryGreen,
                          size: 16,
                        ),
                      if (notification.isNew)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'جديد',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // أزرار الإجراءات البسيطة
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // زر القراءة
                      IconButton(
                        onPressed: () => _toggleReadStatus(notification),
                        icon: Icon(
                          notification.isRead ? Icons.mark_email_unread : Icons.mark_email_read,
                          size: 16,
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                      ),

                      // زر التثبيت
                      IconButton(
                        onPressed: () => _togglePinStatus(notification),
                        icon: Icon(
                          notification.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                          size: 16,
                          color: AppColors.primaryGreen,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                      ),

                      // زر الحذف
                      IconButton(
                        onPressed: () => _deleteNotification(notification),
                        icon: const Icon(
                          Icons.delete_outline,
                          size: 16,
                          color: Colors.red,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 28,
                          minHeight: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // الرسالة
              Text(
                notification.message,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // التذييل
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // التاريخ
                  Text(
                    _formatTimestamp(notification.timestamp),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // العلامات
                  if (notification.tags.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      children: notification.tags.take(2).map((tag) =>
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryGreen,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }





  /// بناء حالة فارغة
  Widget _buildEmptyState() {
    String title;
    String message;
    IconData icon;

    switch (_tabController.index) {
      case 1:
        title = 'لا توجد إشعارات غير مقروءة';
        message = 'جميع إشعاراتك مقروءة!';
        icon = Icons.mark_email_read;
        break;
      case 2:
        title = 'لا توجد إشعارات مهمة';
        message = 'لا توجد إشعارات مثبتة أو عالية الأولوية';
        icon = Icons.priority_high;
        break;
      default:
        title = 'لا توجد إشعارات';
        message = 'ستظهر الإشعارات الجديدة هنا';
        icon = Icons.notifications_none;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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

  /// التعامل مع النقر على الإشعار
  Future<void> _handleNotificationTap(NotificationModel notification) async {
    try {
      // تحديد كمقروء إذا لم يكن مقروءاً
      if (!notification.isRead) {
        await _notificationService.markAsRead(notification.id);
      }

      // تنفيذ الإجراء المرتبط بالإشعار
      if (notification.actionData != null) {
        _handleNotificationAction(notification);
      }
    } catch (e) {
      debugPrint('❌ خطأ في التعامل مع النقر على الإشعار: $e');
    }
  }

  /// التعامل مع إجراءات الإشعار
  void _handleNotificationAction(NotificationModel notification) {
    // يمكن إضافة منطق التنقل هنا حسب نوع الإشعار
    _showMessage('تم النقر على إشعار: ${notification.title}');
  }

  /// تبديل حالة القراءة
  void _toggleReadStatus(NotificationModel notification) {
    setState(() {
      _notificationService.markAsRead(notification.id);
      _applySearch();
    });
  }

  /// تبديل حالة التثبيت
  void _togglePinStatus(NotificationModel notification) {
    setState(() {
      // إنشاء نسخة جديدة مع حالة التثبيت المحدثة
      final updatedNotification = notification.copyWith(
        isPinned: !notification.isPinned,
      );

      // تحديث الإشعار في الخدمة
      _notificationService.updateNotification(updatedNotification);
      _applySearch();
    });
  }

  /// حذف الإشعار
  void _deleteNotification(NotificationModel notification) {
    setState(() {
      _notificationService.deleteNotification(notification.id);
      _applySearch();
    });
  }



  /// تبديل البحث
  void _toggleSearch() {
    setState(() {
      if (_searchController.text.isNotEmpty || _searchQuery.isNotEmpty) {
        _clearSearch();
      } else {
        // فتح البحث
        _searchController.text = _searchQuery;
      }
    });
  }

  /// مسح البحث
  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _applySearch();
    });
  }

  /// تحديد الكل كمقروء
  Future<void> _markAllAsRead() async {
    try {
      await _notificationService.markAllAsRead();
      _showMessage('تم تحديد جميع الإشعارات كمقروءة');
    } catch (e) {
      debugPrint('❌ خطأ في تحديد الكل كمقروء: $e');
      _showMessage('حدث خطأ في تحديد الإشعارات كمقروءة');
    }
  }

  /// إرسال إشعار تجريبي
  Future<void> _sendTestNotification() async {
    try {
      if (kIsWeb) {
        await WebNotificationService.instance.sendTestNotification();
        _showMessage('تم إرسال إشعار تجريبي للويب! 🌐');
      } else {
        await _notificationService.sendTestNotification();
        _showMessage('تم إرسال إشعار تجريبي! 🔔');
      }
    } catch (e) {
      debugPrint('❌ خطأ في إرسال الإشعار التجريبي: $e');
      _showMessage('حدث خطأ في إرسال الإشعار التجريبي');
    }
  }

  /// تحديث الإشعارات
  Future<void> _refreshNotifications() async {
    try {
      await _loadNotifications();
      _showMessage('تم تحديث الإشعارات');
    } catch (e) {
      debugPrint('❌ خطأ في تحديث الإشعارات: $e');
      _showMessage('حدث خطأ في تحديث الإشعارات');
    }
  }

  /// فتح صفحة الإحصائيات
  void _openAnalytics() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationAnalyticsScreen(),
      ),
    );
  }

  /// فتح صفحة الإعدادات
  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationSettingsScreen(),
      ),
    );
  }

  /// عرض حوار الفلترة
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('فلترة الإشعارات'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // فلتر النوع
            DropdownButtonFormField<NotificationType?>(
              value: _selectedTypeFilter,
              decoration: const InputDecoration(
                labelText: 'نوع الإشعار',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<NotificationType?>(
                  value: null,
                  child: Text('جميع الأنواع'),
                ),
                ...NotificationType.values.map((type) =>
                  DropdownMenuItem<NotificationType?>(
                    value: type,
                    child: Text(_getTypeDisplayName(type)),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedTypeFilter = value);
              },
            ),

            const SizedBox(height: 16),

            // فلتر الأولوية
            DropdownButtonFormField<NotificationPriority?>(
              value: _selectedPriorityFilter,
              decoration: const InputDecoration(
                labelText: 'الأولوية',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem<NotificationPriority?>(
                  value: null,
                  child: Text('جميع الأولويات'),
                ),
                ...NotificationPriority.values.map((priority) =>
                  DropdownMenuItem<NotificationPriority?>(
                    value: priority,
                    child: Text(priority.name),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedPriorityFilter = value);
              },
            ),

            const SizedBox(height: 16),

            // فلاتر حالة القراءة
            CheckboxListTile(
              title: const Text('المقروءة فقط'),
              value: _showReadOnly,
              onChanged: (value) {
                setState(() {
                  _showReadOnly = value ?? false;
                  if (_showReadOnly) _showUnreadOnly = false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('غير المقروءة فقط'),
              value: _showUnreadOnly,
              onChanged: (value) {
                setState(() {
                  _showUnreadOnly = value ?? false;
                  if (_showUnreadOnly) _showReadOnly = false;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _selectedTypeFilter = null;
                _selectedPriorityFilter = null;
                _showReadOnly = false;
                _showUnreadOnly = false;
                _applySearch();
              });
              Navigator.of(context).pop();
            },
            child: const Text('مسح الفلاتر'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              _applySearch();
              Navigator.of(context).pop();
            },
            child: const Text('تطبيق'),
          ),
        ],
      ),
    );
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



  /// عرض رسالة
  void _showMessage(String message) {
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
