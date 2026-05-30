import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class BelongButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool isOutlined;
  final bool isDestructive;
  final Color? color;
  final double? height;
  final double? width;

  const BelongButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.isOutlined = false,
    this.isDestructive = false,
    this.color,
    this.height,
    this.width,
  });

  @override
  State<BelongButton> createState() => _BelongButtonState();
}

class _BelongButtonState extends State<BelongButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.97,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor =
        widget.color ??
        (widget.isDestructive ? AppColors.secondary : AppColors.primary);

    return AnimatedScale(
      scale: _scaleAnimation.value,
      duration: Duration.zero,
      child: SizedBox(
        width: widget.isFullWidth
            ? (widget.width ?? double.infinity)
            : widget.width,
        height: widget.height ?? AppSpacing.buttonHeight,
        child: widget.isOutlined
            ? _buildOutlinedButton(buttonColor)
            : _buildFilledButton(buttonColor),
      ),
    );
  }

  Widget _buildFilledButton(Color color) {
    return Material(
      color: widget.onPressed != null ? color : color.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: widget.onPressed,
        onTapDown: widget.onPressed != null
            ? (_) => _controller.forward()
            : null,
        onTapUp: widget.onPressed != null ? (_) => _controller.reverse() : null,
        onTapCancel: () => _controller.reverse(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildContent(Colors.white),
        ),
      ),
    );
  }

  Widget _buildOutlinedButton(Color color) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: InkWell(
        onTap: widget.onPressed,
        onTapDown: widget.onPressed != null
            ? (_) => _controller.forward()
            : null,
        onTapUp: widget.onPressed != null ? (_) => _controller.reverse() : null,
        onTapCancel: () => _controller.reverse(),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.outline, width: 1.5),
          ),
          child: _buildContent(color),
        ),
      ),
    );
  }

  Widget _buildContent(Color textColor) {
    return Center(
      child: widget.isLoading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: widget.isOutlined
                    ? (widget.color ?? AppColors.primary)
                    : Colors.white,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 20, color: textColor),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                    letterSpacing: -0.01,
                  ),
                ),
              ],
            ),
    );
  }
}
