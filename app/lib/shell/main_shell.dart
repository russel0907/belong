import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';

class MainShell extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.outline.withValues(alpha: 0.5)),
        ),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: 'Home',
                isSelected: widget.navigationShell.currentIndex == 0,
                onTap: () => _goToTab(0),
              ),
              _NavItem(
                icon: Icons.search_outlined,
                activeIcon: Icons.search_rounded,
                label: 'Lost',
                isSelected: widget.navigationShell.currentIndex == 1,
                onTap: () => _goToTab(1),
              ),
              _NavItem(
                icon: Icons.favorite_outline,
                activeIcon: Icons.favorite_rounded,
                label: 'Found',
                isSelected: widget.navigationShell.currentIndex == 2,
                onTap: () => _goToTab(2),
              ),
              _NavItem(
                icon: Icons.notifications_outlined,
                activeIcon: Icons.notifications_rounded,
                label: 'Alerts',
                isSelected: widget.navigationShell.currentIndex == 3,
                onTap: () => _goToTab(3),
              ),
              _NavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person_rounded,
                label: 'Profile',
                isSelected: widget.navigationShell.currentIndex == 4,
                onTap: () => _goToTab(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToTab(int index) {
    if (index == widget.navigationShell.currentIndex) return;
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _springController;
  late Animation<double> _springAnimation;

  @override
  void initState() {
    super.initState();
    _springController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _springAnimation = CurvedAnimation(
      parent: _springController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void didUpdateWidget(_NavItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _springController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _springAnimation,
          builder: (context, child) {
            final scale = widget.isSelected
                ? 1.0 + (0.15 * (1.0 - _springAnimation.value))
                : 1.0;
            return Transform.scale(
              scale: scale,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      widget.isSelected ? widget.activeIcon : widget.icon,
                      key: ValueKey(widget.isSelected),
                      size: 24,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: widget.isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.textTertiary,
                      letterSpacing: 0.02,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
