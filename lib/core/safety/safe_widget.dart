import 'package:flutter/material.dart';
import 'safety_monitor.dart';
import '../constants/constants.dart';

/// Widget آمن يحمي من الأخطاء ويوفر بديل في حالة الفشل
class SafeWidget extends StatelessWidget {
  final Widget child;
  final String widgetName;
  final Widget? fallbackWidget;
  final VoidCallback? onError;
  final bool showErrorDetails;

  const SafeWidget({
    required this.child,
    required this.widgetName,
    this.fallbackWidget,
    this.onError,
    this.showErrorDetails = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _SafeWidgetWrapper(
      widgetName: widgetName,
      fallbackWidget: fallbackWidget,
      onError: onError,
      showErrorDetails: showErrorDetails,
      child: child,
    );
  }
}

class _SafeWidgetWrapper extends StatefulWidget {
  final Widget child;
  final String widgetName;
  final Widget? fallbackWidget;
  final VoidCallback? onError;
  final bool showErrorDetails;

  const _SafeWidgetWrapper({
    required this.child,
    required this.widgetName,
    this.fallbackWidget,
    this.onError,
    this.showErrorDetails = false,
  });

  @override
  State<_SafeWidgetWrapper> createState() => _SafeWidgetWrapperState();
}

class _SafeWidgetWrapperState extends State<_SafeWidgetWrapper> {
  bool _hasError = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallbackWidget ?? _buildErrorFallback(context);
    }

    return _SafeErrorBoundary(
      onError: _handleError,
      child: widget.child,
    );
  }

  void _handleError(dynamic error, StackTrace stackTrace) {
    setState(() {
      _hasError = true;
      _errorMessage = error.toString();
    });

    SafetyMonitor.logError(widget.widgetName, error, stackTrace);
    widget.onError?.call();
  }

  Widget _buildErrorFallback(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: AppColors.error,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'حدث خطأ في ${widget.widgetName}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (widget.showErrorDetails && _errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _errorMessage = null;
                  });
                },
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyle(color: AppColors.primaryGreen),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Error Boundary للتعامل مع الأخطاء
class _SafeErrorBoundary extends StatefulWidget {
  final Widget child;
  final Function(dynamic error, StackTrace stackTrace) onError;

  const _SafeErrorBoundary({
    required this.child,
    required this.onError,
  });

  @override
  State<_SafeErrorBoundary> createState() => _SafeErrorBoundaryState();
}

class _SafeErrorBoundaryState extends State<_SafeErrorBoundary> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _catchErrors();
  }

  void _catchErrors() {
    FlutterError.onError = (FlutterErrorDetails details) {
      widget.onError(details.exception, details.stack ?? StackTrace.current);
    };
  }
}

/// Safe Builder للعمليات الآمنة
class SafeBuilder extends StatelessWidget {
  final String operationName;
  final Widget Function() builder;
  final Widget? fallback;
  final bool showErrorDetails;

  const SafeBuilder({
    required this.operationName,
    required this.builder,
    this.fallback,
    this.showErrorDetails = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    try {
      final result = builder();
      SafetyMonitor.logSuccess(operationName);
      return result;
    } catch (error, stackTrace) {
      SafetyMonitor.logError(operationName, error, stackTrace);
      
      return fallback ?? _buildDefaultFallback(context, error);
    }
  }

  Widget _buildDefaultFallback(BuildContext context, dynamic error) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber,
            color: AppColors.warning,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            'حدث خطأ في $operationName',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          if (showErrorDetails) ...[
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Safe Future Builder
class SafeFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext context, T data) builder;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final String operationName;

  const SafeFutureBuilder({
    required this.future,
    required this.builder,
    required this.operationName,
    this.loadingWidget,
    this.errorWidget,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingWidget ?? _buildDefaultLoading();
        }

        if (snapshot.hasError) {
          SafetyMonitor.logError(operationName, snapshot.error);
          return errorWidget ?? _buildDefaultError(context, snapshot.error);
        }

        if (snapshot.hasData) {
          try {
            SafetyMonitor.logSuccess(operationName);
            return builder(context, snapshot.data!);
          } catch (error, stackTrace) {
            SafetyMonitor.logError('$operationName Builder', error, stackTrace);
            return errorWidget ?? _buildDefaultError(context, error);
          }
        }

        return _buildDefaultEmpty();
      },
    );
  }

  Widget _buildDefaultLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: AppColors.primaryGreen,
      ),
    );
  }

  Widget _buildDefaultError(BuildContext context, dynamic error) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'يرجى المحاولة مرة أخرى',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultEmpty() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            color: AppColors.helperGray,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'لا توجد بيانات',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
