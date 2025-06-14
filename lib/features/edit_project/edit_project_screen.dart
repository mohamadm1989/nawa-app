import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/models.dart';

/// صفحة تعديل المشروع
class EditProjectScreen extends StatefulWidget {
  final ProjectModel project;
  
  const EditProjectScreen({
    super.key,
    required this.project,
  });

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  // ========== المتحكمات ==========
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _targetAmountController;
  late TextEditingController _contactController;
  late TextEditingController _roleController;

  // ========== المتغيرات ==========
  late String _selectedCategory;
  late String _selectedPriority;
  late String _selectedStatus;
  late String _selectedCurrency;
  late DateTime? _expectedEndDate;
  late List<String> _selectedTags;
  bool _isLoading = false;
  bool _hasChanges = false;

  // ========== قوائم البيانات ==========
  final List<Map<String, dynamic>> _categories = [
    {'value': 'education', 'label': 'تعليم', 'icon': Icons.school},
    {'value': 'health', 'label': 'صحة', 'icon': Icons.local_hospital},
    {'value': 'infrastructure', 'label': 'بنية تحتية', 'icon': Icons.construction},
    {'value': 'housing', 'label': 'إسكان', 'icon': Icons.home},
    {'value': 'social', 'label': 'اجتماعي', 'icon': Icons.people},
    {'value': 'economic', 'label': 'اقتصادي', 'icon': Icons.business},
  ];

  final List<Map<String, dynamic>> _priorities = [
    {'value': 'low', 'label': 'منخفضة', 'color': AppColors.success},
    {'value': 'medium', 'label': 'متوسطة', 'color': AppColors.warning},
    {'value': 'high', 'label': 'عالية', 'color': AppColors.error},
    {'value': 'urgent', 'label': 'عاجلة', 'color': AppColors.error},
  ];

  final List<Map<String, dynamic>> _statuses = [
    {'value': 'pending', 'label': 'في انتظار المراجعة', 'color': AppColors.warning},
    {'value': 'active', 'label': 'نشط', 'color': AppColors.success},
    {'value': 'paused', 'label': 'متوقف مؤقتاً', 'color': AppColors.helperGray},
    {'value': 'completed', 'label': 'مكتمل', 'color': AppColors.primaryGreen},
    {'value': 'cancelled', 'label': 'ملغي', 'color': AppColors.error},
  ];

  final List<String> _currencies = ['USD', 'EUR', 'SYP'];

  final List<String> _availableTags = [
    'ترميم', 'بناء', 'تأهيل', 'طوارئ', 'أطفال', 'نساء', 
    'مسنين', 'ذوي احتياجات خاصة', 'لاجئين', 'نازحين'
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // تهيئة المتحكمات بالقيم الحالية للمشروع
    _titleController = TextEditingController(text: widget.project.basic.title);
    _descriptionController = TextEditingController(text: widget.project.basic.description);
    _addressController = TextEditingController(text: widget.project.location.address);
    _cityController = TextEditingController(text: widget.project.location.city);
    _districtController = TextEditingController(text: widget.project.location.district);
    _targetAmountController = TextEditingController(text: widget.project.financial.targetAmount.toString());
    _contactController = TextEditingController(text: widget.project.creator.contact);
    _roleController = TextEditingController(text: widget.project.creator.role);

    // تهيئة المتغيرات
    _selectedCategory = widget.project.basic.category;
    _selectedPriority = widget.project.basic.priority;
    _selectedStatus = widget.project.basic.status;
    _selectedCurrency = widget.project.financial.currency;
    _expectedEndDate = widget.project.timeline.expectedEndDate;
    _selectedTags = List<String>.from(widget.project.basic.tags);

    // إضافة مستمعين للتغييرات
    _addChangeListeners();
  }

  void _addChangeListeners() {
    _titleController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
    _addressController.addListener(_onFieldChanged);
    _cityController.addListener(_onFieldChanged);
    _districtController.addListener(_onFieldChanged);
    _targetAmountController.addListener(_onFieldChanged);
    _contactController.addListener(_onFieldChanged);
    _roleController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() {
        _hasChanges = true;
      });
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _targetAmountController.dispose();
    _contactController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تعديل المشروع'),
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: AppColors.textOnColor,
          actions: [
            // زر الحفظ
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'حفظ',
                      style: TextStyle(
                        color: _hasChanges ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            
            // قائمة الخيارات
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: _handleMenuAction,
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'duplicate',
                  child: Row(
                    children: [
                      Icon(Icons.copy, size: 20),
                      SizedBox(width: 8),
                      Text('نسخ المشروع'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'archive',
                  child: Row(
                    children: [
                      Icon(Icons.archive, size: 20),
                      SizedBox(width: 8),
                      Text('أرشفة'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('حذف', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // معلومات المشروع
                _buildProjectInfoCard(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // معلومات أساسية
                _buildSectionHeader('المعلومات الأساسية', Icons.info),
                _buildBasicInfoSection(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // حالة المشروع
                _buildSectionHeader('حالة المشروع', Icons.track_changes),
                _buildStatusSection(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // الموقع
                _buildSectionHeader('الموقع', Icons.location_on),
                _buildLocationSection(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // التمويل
                _buildSectionHeader('التمويل', Icons.attach_money),
                _buildFinancialSection(),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // معلومات التواصل
                _buildSectionHeader('معلومات التواصل', Icons.contact_phone),
                _buildContactSection(),
                
                const SizedBox(height: AppConstants.spacingXLarge),
                
                // أزرار الحفظ والإلغاء
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'معلومات المشروع',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: AppConstants.spacingMedium),
            
            // معرف المشروع
            _buildInfoRow('معرف المشروع:', widget.project.projectId),
            
            // تاريخ الإنشاء
            _buildInfoRow(
              'تاريخ الإنشاء:', 
              '${widget.project.timeline.createdAt.day}/${widget.project.timeline.createdAt.month}/${widget.project.timeline.createdAt.year}'
            ),
            
            // المبلغ المجمع
            _buildInfoRow(
              'المبلغ المجمع:', 
              '${widget.project.financial.currentAmount.toStringAsFixed(0)} ${widget.project.financial.currency}'
            ),
            
            // عدد المتبرعين
            _buildInfoRow('عدد المتبرعين:', '${widget.project.engagement.supporters}'),
            
            // عدد المشاهدات
            _buildInfoRow('عدد المشاهدات:', '${widget.project.engagement.views}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: AppConstants.spacingSmall),
          Text(
            title,
            style: AppTextStyles.headlineSmall.copyWith(
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      children: [
        // عنوان المشروع
        TextFormField(
          controller: _titleController,
          decoration: const InputDecoration(
            labelText: 'عنوان المشروع *',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال عنوان المشروع';
            }
            return null;
          },
          maxLength: 100,
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // وصف المشروع
        TextFormField(
          controller: _descriptionController,
          decoration: const InputDecoration(
            labelText: 'وصف المشروع *',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال وصف المشروع';
            }
            return null;
          },
          maxLength: 500,
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // تصنيف المشروع
        DropdownButtonFormField<String>(
          value: _selectedCategory,
          decoration: const InputDecoration(
            labelText: 'تصنيف المشروع *',
            prefixIcon: Icon(Icons.category),
          ),
          items: _categories.map((category) {
            return DropdownMenuItem<String>(
              value: category['value'],
              child: Row(
                children: [
                  Icon(category['icon'], size: 20),
                  const SizedBox(width: 8),
                  Text(category['label']),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCategory = value!;
              _hasChanges = true;
            });
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // أولوية المشروع
        DropdownButtonFormField<String>(
          value: _selectedPriority,
          decoration: const InputDecoration(
            labelText: 'أولوية المشروع *',
            prefixIcon: Icon(Icons.priority_high),
          ),
          items: _priorities.map((priority) {
            return DropdownMenuItem<String>(
              value: priority['value'],
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: priority['color'],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(priority['label']),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value!;
              _hasChanges = true;
            });
          },
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return DropdownButtonFormField<String>(
      value: _selectedStatus,
      decoration: const InputDecoration(
        labelText: 'حالة المشروع *',
        prefixIcon: Icon(Icons.track_changes),
      ),
      items: _statuses.map((status) {
        return DropdownMenuItem<String>(
          value: status['value'],
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: status['color'],
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(status['label']),
            ],
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedStatus = value!;
          _hasChanges = true;
        });
      },
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'المدينة *',
            prefixIcon: Icon(Icons.location_city),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال المدينة';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        TextFormField(
          controller: _districtController,
          decoration: const InputDecoration(
            labelText: 'المنطقة/الحي *',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال المنطقة أو الحي';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildFinancialSection() {
    return TextFormField(
      controller: _targetAmountController,
      decoration: InputDecoration(
        labelText: 'المبلغ المطلوب ($_selectedCurrency) *',
        prefixIcon: const Icon(Icons.attach_money),
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'يرجى إدخال المبلغ المطلوب';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'يرجى إدخال مبلغ صحيح';
        }
        return null;
      },
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        TextFormField(
          controller: _contactController,
          decoration: const InputDecoration(
            labelText: 'رقم التواصل *',
            prefixIcon: Icon(Icons.phone),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال رقم التواصل';
            }
            return null;
          },
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        TextFormField(
          controller: _roleController,
          decoration: const InputDecoration(
            labelText: 'الصفة/المنصب',
            prefixIcon: Icon(Icons.work),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _saveChanges,
            child: _isLoading
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('جاري الحفظ...'),
                    ],
                  )
                : const Text('حفظ التغييرات'),
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => _cancelChanges(),
            child: const Text('إلغاء'),
          ),
        ),
      ],
    );
  }

  // ========== الدوال المساعدة ==========

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;

    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('لديك تغييرات غير محفوظة. هل تريد الخروج بدون حفظ؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('خروج بدون حفظ'),
          ),
        ],
      ),
    ) ?? false;
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expectedEndDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      locale: const Locale('ar'),
    );

    if (picked != null && picked != _expectedEndDate) {
      setState(() {
        _expectedEndDate = picked;
        _hasChanges = true;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('يرجى تصحيح الأخطاء في النموذج');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _hasChanges = false;
        });
        _showSuccessSnackBar('تم حفظ التغييرات بنجاح');
      }

    } catch (e) {
      _showErrorSnackBar('حدث خطأ أثناء حفظ التغييرات');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _cancelChanges() {
    Navigator.pop(context);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'duplicate':
        _showSuccessSnackBar('تم نسخ المشروع بنجاح');
        break;
      case 'archive':
        _showSuccessSnackBar('تم أرشفة المشروع بنجاح');
        break;
      case 'delete':
        Navigator.pop(context, 'deleted');
        break;
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
