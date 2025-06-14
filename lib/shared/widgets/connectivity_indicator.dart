import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';
import '../../core/network/connectivity_manager.dart';
import '../../core/animations/nawa_animations.dart';

/// مؤشر حالة الاتصال بالإنترنت
class ConnectivityIndicator extends StatefulWidget {
  final Widget child;
  final bool showWhenConnected;
  final Duration hideDelay;

  const ConnectivityIndicator({
    super.key,
    required this.child,
    this.showWhenConnected = false,
    this.hideDelay = const Duration(seconds: 3),
  });

  @override
  State<ConnectivityIndicator> createState() => _ConnectivityIndicatorState();
}

class _ConnectivityIndicatorState extends State<ConnectivityIndicator>
    with TickerProviderStateMixin {
  final ConnectivityManager _connectivity = ConnectivityManager.instance;
  bool _isConnected = true;
  bool _showIndicator = false;
  ConnectionQuality _quality = ConnectionQuality.unknown;

  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeConnectivity();
  }

  void _initializeAnimations() {
    _slideController = AnimationController(
      duration: NawaAnimations.normal,
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: NawaAnimations.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  void _initializeConnectivity() {
    _isConnected = _connectivity.isConnected;
    _quality = _connectivity.connectionQuality;

    // مراقبة تغييرات الاتصال
    _connectivity.connectionStream.listen(_onConnectionChanged);
    _connectivity.qualityStream.listen(_onQualityChanged);
  }

  void _onConnectionChanged(bool isConnected) {
    if (mounted) {
      setState(() {
        _isConnected = isConnected;
      });

      if (!isConnected) {
        _showConnectionLost();
      } else {
        _showConnectionRestored();
      }
    }
  }

  void _onQualityChanged(ConnectionQuality quality) {
    if (mounted) {
      setState(() {
        _quality = quality;
      });
    }
  }

  void _showConnectionLost() {
    setState(() {
      _showIndicator = true;
    });
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  void _showConnectionRestored() {
    if (widget.showWhenConnected) {
      setState(() {
        _showIndicator = true;
      });
      _slideController.forward();
      _pulseController.stop();

      // إخفاء المؤشر بعد فترة
      Future.delayed(widget.hideDelay, () {
        if (mounted) {
          _hideIndicator();
        }
      });
    } else {
      _hideIndicator();
    }
  }

  void _hideIndicator() {
    _slideController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showIndicator = false;
        });
      }
    });
    _pulseController.stop();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showIndicator)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _slideAnimation,
              child: _buildIndicator(),
            ),
          ),
      ],
    );
  }

  Widget _buildIndicator() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(AppConstants.spacingMedium),
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: !_isConnected ? _pulseAnimation.value : 1.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingMedium,
                    vertical: AppConstants.spacingSmall,
                  ),
                  decoration: BoxDecoration(
                    color: _getIndicatorColor(),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    boxShadow: [
                      BoxShadow(
                        color: _getIndicatorColor().withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getIndicatorIcon(),
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Expanded(
                        child: Text(
                          _getIndicatorText(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (_isConnected && _quality != ConnectionQuality.unknown)
                        Container(
                          margin: const EdgeInsets.only(right: AppConstants.spacingSmall),
                          child: _buildQualityIndicator(),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQualityIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final isActive = index < _getQualityLevel();
        return Container(
          width: 3,
          height: 8 + (index * 2),
          margin: const EdgeInsets.only(left: 1),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.white 
                : Colors.white.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(1),
          ),
        );
      }),
    );
  }

  Color _getIndicatorColor() {
    if (!_isConnected) {
      return AppColors.error;
    }

    switch (_quality) {
      case ConnectionQuality.excellent:
        return AppColors.success;
      case ConnectionQuality.good:
        return AppColors.info;
      case ConnectionQuality.fair:
        return AppColors.warning;
      case ConnectionQuality.poor:
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }

  IconData _getIndicatorIcon() {
    if (!_isConnected) {
      return Icons.wifi_off;
    }

    switch (_quality) {
      case ConnectionQuality.excellent:
        return Icons.wifi;
      case ConnectionQuality.good:
        return Icons.wifi;
      case ConnectionQuality.fair:
        return Icons.signal_wifi_bad;
      case ConnectionQuality.poor:
        return Icons.signal_wifi_connected_no_internet_4;
      default:
        return Icons.wifi;
    }
  }

  String _getIndicatorText() {
    if (!_isConnected) {
      return 'لا يوجد اتصال بالإنترنت';
    }

    if (widget.showWhenConnected) {
      return 'تم استعادة الاتصال - ${_quality.displayName}';
    }

    return 'متصل - ${_quality.displayName}';
  }

  int _getQualityLevel() {
    switch (_quality) {
      case ConnectionQuality.excellent:
        return 4;
      case ConnectionQuality.good:
        return 3;
      case ConnectionQuality.fair:
        return 2;
      case ConnectionQuality.poor:
        return 1;
      default:
        return 0;
    }
  }
}

/// مؤشر مبسط لحالة الاتصال
class SimpleConnectivityIndicator extends StatelessWidget {
  final bool isConnected;
  final ConnectionQuality quality;
  final double size;

  const SimpleConnectivityIndicator({
    super.key,
    required this.isConnected,
    this.quality = ConnectionQuality.unknown,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Icon(
        _getIcon(),
        color: Colors.white,
        size: size * 0.6,
      ),
    );
  }

  Color _getColor() {
    if (!isConnected) {
      return AppColors.error;
    }

    switch (quality) {
      case ConnectionQuality.excellent:
        return AppColors.success;
      case ConnectionQuality.good:
        return AppColors.info;
      case ConnectionQuality.fair:
        return AppColors.warning;
      case ConnectionQuality.poor:
        return AppColors.error;
      default:
        return AppColors.success;
    }
  }

  IconData _getIcon() {
    if (!isConnected) {
      return Icons.wifi_off;
    }

    switch (quality) {
      case ConnectionQuality.excellent:
      case ConnectionQuality.good:
        return Icons.wifi;
      case ConnectionQuality.fair:
        return Icons.signal_wifi_bad;
      case ConnectionQuality.poor:
        return Icons.signal_wifi_connected_no_internet_4;
      default:
        return Icons.wifi;
    }
  }
}
