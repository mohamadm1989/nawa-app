import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/constants.dart';
import '../../shared/widgets/widgets.dart';
import '../../shared/models/models.dart';

/// صفحة إضافة مشروع جديد
class AddProjectScreen extends StatefulWidget {
  const AddProjectScreen({super.key});

  @override
  State<AddProjectScreen> createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  // ========== المتحكمات ==========
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _targetAmountController = TextEditingController();
  final _materialsController = TextEditingController();
  final _laborController = TextEditingController();
  final _otherController = TextEditingController();
  final _contactController = TextEditingController();
  final _roleController = TextEditingController();

  // ========== المتغيرات ==========
  String _selectedCategory = 'education';
  String _selectedPriority = 'medium';
  String _selectedCurrency = 'USD';
  DateTime? _expectedEndDate;
  List<String> _selectedTags = [];
  List<String> _selectedImages = [];
  List<String> _selectedDocuments = [];
  String? _selectedVideo;
  bool _isLoading = false;
  bool _enableCommunityVoting = false;
  double? _selectedLatitude;
  double? _selectedLongitude;

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

  final List<String> _currencies = ['USD', 'EUR', 'SYP'];

  final List<String> _availableTags = [
    'ترميم', 'بناء', 'تأهيل', 'طوارئ', 'أطفال', 'نساء', 
    'مسنين', 'ذوي احتياجات خاصة', 'لاجئين', 'نازحين'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _targetAmountController.dispose();
    _materialsController.dispose();
    _laborController.dispose();
    _otherController.dispose();
    _contactController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة مشروع جديد'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.textOnColor,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _submitProject,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'حفظ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
              // معلومات أساسية
              _buildSectionHeader('المعلومات الأساسية', Icons.info),
              _buildBasicInfoSection(),
              
              const SizedBox(height: AppConstants.spacingLarge),
              
              // الموقع
              _buildSectionHeader('الموقع', Icons.location_on),
              _buildLocationSection(),
              
              const SizedBox(height: AppConstants.spacingLarge),
              
              // التمويل
              _buildSectionHeader('التمويل', Icons.attach_money),
              _buildFinancialSection(),
              
              const SizedBox(height: AppConstants.spacingLarge),
              
              // الصور
              _buildSectionHeader('الصور', Icons.photo_library),
              _buildImagesSection(),
              
              const SizedBox(height: AppConstants.spacingLarge),
              
              // التوثيق والمراجعة
              _buildSectionHeader('التوثيق والمراجعة', Icons.verified_user),
              _buildVerificationSection(),

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
            hintText: 'مثال: ترميم مدرسة الأمل',
            prefixIcon: Icon(Icons.title),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال عنوان المشروع';
            }
            if (value.trim().length < 5) {
              return 'العنوان يجب أن يكون 5 أحرف على الأقل';
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
            hintText: 'اكتب وصفاً مفصلاً عن المشروع وأهدافه...',
            prefixIcon: Icon(Icons.description),
          ),
          maxLines: 4,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال وصف المشروع';
            }
            if (value.trim().length < 20) {
              return 'الوصف يجب أن يكون 20 حرف على الأقل';
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
            });
          },
        ),
        
        const SizedBox(height: AppConstants.spacingMedium),
        
        // تاريخ الانتهاء المتوقع
        InkWell(
          onTap: _selectEndDate,
          child: InputDecorator(
            decoration: const InputDecoration(
              labelText: 'تاريخ الانتهاء المتوقع',
              prefixIcon: Icon(Icons.calendar_today),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
            child: Text(
              _expectedEndDate != null
                  ? '${_expectedEndDate!.day}/${_expectedEndDate!.month}/${_expectedEndDate!.year}'
                  : 'اختر التاريخ',
              style: _expectedEndDate != null
                  ? null
                  : TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // العلامات (Tags)
        _buildTagsSection(),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        // المدينة
        TextFormField(
          controller: _cityController,
          decoration: const InputDecoration(
            labelText: 'المدينة *',
            hintText: 'مثال: حلب',
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

        // المنطقة/الحي
        TextFormField(
          controller: _districtController,
          decoration: const InputDecoration(
            labelText: 'المنطقة/الحي *',
            hintText: 'مثال: الصالحين',
            prefixIcon: Icon(Icons.location_on),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'يرجى إدخال المنطقة أو الحي';
            }
            return null;
          },
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // العنوان التفصيلي
        TextFormField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: 'العنوان التفصيلي',
            hintText: 'مثال: شارع المدرسة، بناء رقم 15',
            prefixIcon: Icon(Icons.home),
          ),
          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildFinancialSection() {
    return Column(
      children: [
        // المبلغ المطلوب
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: _targetAmountController,
                decoration: const InputDecoration(
                  labelText: 'المبلغ المطلوب *',
                  hintText: '5000',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
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
              ),
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            Expanded(
              flex: 1,
              child: DropdownButtonFormField<String>(
                value: _selectedCurrency,
                decoration: const InputDecoration(
                  labelText: 'العملة',
                ),
                items: _currencies.map((currency) {
                  return DropdownMenuItem<String>(
                    value: currency,
                    child: Text(currency),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value!;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // تفصيل التكاليف
        Text(
          'تفصيل التكاليف (اختياري)',
          style: AppTextStyles.labelLarge,
        ),

        const SizedBox(height: AppConstants.spacingSmall),

        // تكلفة المواد
        TextFormField(
          controller: _materialsController,
          decoration: const InputDecoration(
            labelText: 'تكلفة المواد',
            hintText: '3000',
            prefixIcon: Icon(Icons.build),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // تكلفة العمالة
        TextFormField(
          controller: _laborController,
          decoration: const InputDecoration(
            labelText: 'تكلفة العمالة',
            hintText: '1500',
            prefixIcon: Icon(Icons.engineering),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // تكاليف أخرى
        TextFormField(
          controller: _otherController,
          decoration: const InputDecoration(
            labelText: 'تكاليف أخرى',
            hintText: '500',
            prefixIcon: Icon(Icons.more_horiz),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
          ],
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العلامات (اختياري)',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _availableTags.map((tag) {
            final isSelected = _selectedTags.contains(tag);
            return FilterChip(
              label: Text(tag),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTags.add(tag);
                  } else {
                    _selectedTags.remove(tag);
                  }
                });
              },
              selectedColor: AppColors.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppColors.primaryGreen,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف صور للمشروع (اختياري)',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),

        // منطقة رفع الصور
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              style: BorderStyle.solid,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            color: AppColors.backgroundCard,
          ),
          child: InkWell(
            onTap: _pickImages,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cloud_upload,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط لرفع الصور',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'PNG, JPG حتى 5MB',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),

        // عرض الصور المختارة
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingMedium),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: AppColors.backgroundCard,
                          child: const Icon(
                            Icons.image,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildVerificationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // رفع فيديو تعريفي
        _buildVideoUploadSection(),

        const SizedBox(height: AppConstants.spacingLarge),

        // رفع مستندات داعمة
        _buildDocumentsSection(),

        const SizedBox(height: AppConstants.spacingLarge),

        // تحديد الموقع على الخريطة
        _buildLocationPickerSection(),

        const SizedBox(height: AppConstants.spacingLarge),

        // خيار التصويت المجتمعي
        _buildCommunityVotingSection(),
      ],
    );
  }

  Widget _buildVideoUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'فيديو تعريفي (اختياري)',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'أضف فيديو قصير تشرح فيه المشروع وأهميته (يساعد في زيادة الثقة)',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            color: AppColors.backgroundCard,
          ),
          child: InkWell(
            onTap: _pickVideo,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedVideo != null ? Icons.video_file : Icons.videocam,
                  size: 32,
                  color: _selectedVideo != null ? AppColors.success : AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedVideo != null ? 'تم رفع الفيديو' : 'اضغط لرفع فيديو',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selectedVideo != null ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
                if (_selectedVideo == null)
                  Text(
                    'MP4, MOV حتى 50MB',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
              ],
            ),
          ),
        ),

        if (_selectedVideo != null) ...[
          const SizedBox(height: AppConstants.spacingSmall),
          Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.success, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _selectedVideo!,
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.success),
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _selectedVideo = null),
                icon: const Icon(Icons.close, size: 16),
                color: AppColors.error,
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'مستندات داعمة (اختياري)',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'أضف مستندات تدعم مشروعك (خطاب من جمعية، موافقة مختار، إلخ)',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.border,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            color: AppColors.backgroundCard,
          ),
          child: InkWell(
            onTap: _pickDocuments,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.upload_file,
                  size: 32,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  'اضغط لرفع المستندات',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'PDF, DOC, JPG حتى 10MB',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ),

        // عرض المستندات المرفوعة
        if (_selectedDocuments.isNotEmpty) ...[
          const SizedBox(height: AppConstants.spacingMedium),
          ...List.generate(_selectedDocuments.length, (index) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.backgroundAccent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Icon(Icons.description, color: AppColors.primaryGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _selectedDocuments[index],
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeDocument(index),
                    icon: const Icon(Icons.close, size: 16),
                    color: AppColors.error,
                  ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      children: [
        // رقم التواصل
        TextFormField(
          controller: _contactController,
          decoration: const InputDecoration(
            labelText: 'رقم التواصل *',
            hintText: '+963912345678',
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

        // الصفة/المنصب
        TextFormField(
          controller: _roleController,
          decoration: const InputDecoration(
            labelText: 'الصفة/المنصب',
            hintText: 'مثال: مدير المدرسة',
            prefixIcon: Icon(Icons.work),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // زر الحفظ
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitProject,
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
                : const Text('حفظ المشروع'),
          ),
        ),

        const SizedBox(height: AppConstants.spacingMedium),

        // زر الإلغاء
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
        ),
      ],
    );
  }

  // ========== الدوال المساعدة ==========

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      locale: const Locale('ar'),
    );

    if (picked != null) {
      setState(() {
        _expectedEndDate = picked;
      });
    }
  }

  void _pickImages() {
    // TODO: تنفيذ رفع الصور
    // يمكن استخدام image_picker package
    setState(() {
      _selectedImages.add('image_${_selectedImages.length + 1}.jpg');
    });

    _showSuccessSnackBar('تم إضافة الصورة بنجاح');
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _submitProject() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('يرجى تصحيح الأخطاء في النموذج');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // إنشاء نموذج المشروع
      final project = _createProjectModel();

      // محاكاة حفظ المشروع
      await Future.delayed(const Duration(seconds: 2));

      // TODO: حفظ المشروع في قاعدة البيانات
      // await ProjectService.createProject(project);

      if (mounted) {
        _showSuccessSnackBar('تم إرسال المشروع للمراجعة بنجاح');
        Navigator.pop(context, true);
      }

    } catch (e) {
      _showErrorSnackBar('حدث خطأ أثناء حفظ المشروع');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  ProjectModel _createProjectModel() {
    final targetAmount = double.tryParse(_targetAmountController.text) ?? 0.0;
    final materials = double.tryParse(_materialsController.text) ?? 0.0;
    final labor = double.tryParse(_laborController.text) ?? 0.0;
    final other = double.tryParse(_otherController.text) ?? 0.0;

    return ProjectModel(
      projectId: DateTime.now().millisecondsSinceEpoch.toString(),
      basic: ProjectBasic(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        status: 'pending', // في انتظار المراجعة
        priority: _selectedPriority,
        tags: _selectedTags,
      ),
      location: ProjectLocation(
        city: _cityController.text.trim(),
        district: _districtController.text.trim(),
        address: _addressController.text.trim(),
        coordinates: GeoCoordinates(
          lat: _selectedLatitude ?? 0.0,
          lng: _selectedLongitude ?? 0.0,
        ),
      ),
      financial: ProjectFinancial(
        targetAmount: targetAmount,
        currentAmount: 0.0,
        currency: _selectedCurrency,
        breakdown: ProjectBreakdown(
          materials: materials,
          labor: labor,
          other: other,
        ),
      ),
      timeline: ProjectTimeline(
        createdAt: DateTime.now(),
        startDate: DateTime.now(),
        expectedEndDate: _expectedEndDate ?? DateTime.now().add(const Duration(days: 90)),
      ),
      creator: ProjectCreator(
        uid: 'current_user_id', // TODO: الحصول على معرف المستخدم الحالي
        name: 'المستخدم الحالي', // TODO: الحصول على اسم المستخدم
        role: _roleController.text.trim().isNotEmpty ? _roleController.text.trim() : 'مقدم المشروع',
        contact: _contactController.text.trim(),
      ),
      media: ProjectMedia(
        mainImage: _selectedImages.isNotEmpty ? _selectedImages.first : '',
        gallery: _selectedImages,
        documents: _selectedDocuments,
        video: _selectedVideo,
      ),
      engagement: const ProjectEngagement(
        supporters: 0,
        likes: 0,
        comments: 0,
        shares: 0,
        views: 0,
      ),
      verification: ProjectVerification(
        status: 'pending',
        documents: _selectedDocuments,
        communityVotingEnabled: _enableCommunityVoting,
        communityVotes: 0,
        requiredVotes: 10,
      ),
    );
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

  // ========== دوال التوثيق الجديدة ==========

  void _pickVideo() {
    // TODO: تنفيذ رفع الفيديو
    // يمكن استخدام image_picker package للفيديو
    setState(() {
      _selectedVideo = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    });
    _showSuccessSnackBar('تم إضافة الفيديو بنجاح');
  }

  void _pickDocuments() {
    // TODO: تنفيذ رفع المستندات
    // يمكن استخدام file_picker package
    setState(() {
      _selectedDocuments.add('document_${_selectedDocuments.length + 1}.pdf');
    });
    _showSuccessSnackBar('تم إضافة المستند بنجاح');
  }

  void _removeDocument(int index) {
    setState(() {
      _selectedDocuments.removeAt(index);
    });
  }

  Widget _buildLocationPickerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تحديد الموقع على الخريطة',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'حدد موقع المشروع بدقة على الخريطة لزيادة الثقة',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            color: AppColors.backgroundCard,
          ),
          child: InkWell(
            onTap: _pickLocation,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _selectedLatitude != null ? Icons.location_on : Icons.map,
                  size: 32,
                  color: _selectedLatitude != null ? AppColors.success : AppColors.textSecondary,
                ),
                const SizedBox(height: 8),
                Text(
                  _selectedLatitude != null
                      ? 'تم تحديد الموقع'
                      : 'اضغط لتحديد الموقع',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _selectedLatitude != null ? AppColors.success : AppColors.textSecondary,
                  ),
                ),
                if (_selectedLatitude != null)
                  Text(
                    'خط العرض: ${_selectedLatitude!.toStringAsFixed(6)}\nخط الطول: ${_selectedLongitude!.toStringAsFixed(6)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommunityVotingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التصويت المجتمعي',
          style: AppTextStyles.labelLarge,
        ),
        const SizedBox(height: AppConstants.spacingSmall),
        Text(
          'اطلب من سكان الحي التصويت لمشروعك لزيادة المصداقية',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: AppConstants.spacingMedium),

        Container(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          decoration: BoxDecoration(
            color: AppColors.backgroundAccent,
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفعيل التصويت المجتمعي',
                      style: AppTextStyles.labelMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'سيتم إرسال دعوات للجيران للتصويت على مشروعك',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _enableCommunityVoting,
                onChanged: (value) {
                  setState(() {
                    _enableCommunityVoting = value;
                  });
                },
                activeColor: AppColors.primaryGreen,
              ),
            ],
          ),
        ),

        if (_enableCommunityVoting) ...[
          const SizedBox(height: AppConstants.spacingMedium),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'سيحتاج مشروعك لـ 10 أصوات موافقة من الجيران قبل النشر',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  void _pickLocation() {
    // TODO: فتح خريطة لاختيار الموقع
    // يمكن استخدام Google Maps أو OpenStreetMap
    setState(() {
      _selectedLatitude = 36.2021; // حلب كمثال
      _selectedLongitude = 37.1343;
    });
    _showSuccessSnackBar('تم تحديد الموقع بنجاح');
  }
}
