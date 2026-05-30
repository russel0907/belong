import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/mock_data.dart';
import '../../core/widgets/belong_button.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({super.key});

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  ItemStatus? _selectedStatus;
  ItemCategory? _selectedCategory;
  bool _isUrgent = false;
  int _currentStep = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            ),
            child: const Icon(Icons.close_rounded, size: 22),
          ),
        ),
        title: Text(
          'Report Item',
          style: AppTypography.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgress(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _buildStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        children: List.generate(
          4,
          (index) => Expanded(
            child: Container(
              height: 3,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: index <= _currentStep
                    ? AppColors.primary
                    : AppColors.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_currentStep) {
      case 0:
        return _buildTypeStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildLocationStep();
      case 3:
        return _buildReviewStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildTypeStep() {
    return Padding(
      key: const ValueKey('step0'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What happened?',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Let us know if you lost something or found something.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _TypeOption(
            icon: Icons.search_rounded,
            title: 'I Lost Something',
            subtitle: 'Report an item you misplaced',
            color: AppColors.secondary,
            isSelected: _selectedStatus == ItemStatus.lost,
            onTap: () => setState(() => _selectedStatus = ItemStatus.lost),
          ),
          const SizedBox(height: AppSpacing.md),
          _TypeOption(
            icon: Icons.favorite_rounded,
            title: 'I Found Something',
            subtitle: 'Report an item you discovered',
            color: AppColors.primary,
            isSelected: _selectedStatus == ItemStatus.found,
            onTap: () => setState(() => _selectedStatus = ItemStatus.found),
          ),
          const Spacer(),
          BelongButton(
            label: 'Continue',
            onPressed: _selectedStatus != null
                ? () => setState(() => _currentStep = 1)
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsStep() {
    return Padding(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Item Details',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Describe the item as best you can.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Category',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: ItemCategory.values.map((cat) {
              final isSelected = _selectedCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = cat),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    border: isSelected
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 16,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        cat.label,
                        style: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Title',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g., Silver MacBook Pro',
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Description',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the item in detail...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Urgent toggle
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mark as urgent',
                      style: AppTypography.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text('Get faster responses', style: AppTypography.caption),
                  ],
                ),
              ),
              Switch(
                value: _isUrgent,
                onChanged: (v) => setState(() => _isUrgent = v),
                activeTrackColor: AppColors.secondary.withValues(alpha: 0.5),
                activeThumbColor: AppColors.secondary,
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: BelongButton(
                  label: 'Back',
                  isOutlined: true,
                  onPressed: () => setState(() => _currentStep = 0),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: BelongButton(
                  label: 'Continue',
                  onPressed:
                      _titleController.text.isNotEmpty &&
                          _selectedCategory != null
                      ? () => setState(() => _currentStep = 2)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return Padding(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Where?',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Tell us where this happened.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Location',
            style: AppTypography.titleMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'e.g., Central Park, NY',
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                size: 20,
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Map placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    size: 40,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Map integration coming soon',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: BelongButton(
                  label: 'Back',
                  isOutlined: true,
                  onPressed: () => setState(() => _currentStep = 1),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: BelongButton(
                  label: 'Continue',
                  onPressed: _locationController.text.isNotEmpty
                      ? () => setState(() => _currentStep = 3)
                      : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewStep() {
    return Padding(
      key: const ValueKey('step3'),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Almost done!',
            style: AppTypography.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Review your report before submitting.',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          // Summary card
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
              border: Border.all(color: AppColors.outline),
            ),
            child: Column(
              children: [
                _ReviewRow(
                  label: 'Type',
                  value: _selectedStatus == ItemStatus.lost
                      ? 'Lost Item'
                      : 'Found Item',
                ),
                const Divider(height: AppSpacing.lg),
                _ReviewRow(
                  label: 'Category',
                  value: _selectedCategory?.label ?? '',
                ),
                const Divider(height: AppSpacing.lg),
                _ReviewRow(label: 'Title', value: _titleController.text),
                const Divider(height: AppSpacing.lg),
                _ReviewRow(label: 'Location', value: _locationController.text),
                if (_isUrgent) ...[
                  const Divider(height: AppSpacing.lg),
                  _ReviewRow(label: 'Urgent', value: 'Yes'),
                ],
              ],
            ),
          ),
          const Spacer(),
          BelongButton(
            label: 'Submit Report',
            icon: Icons.check_rounded,
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusXl,
                          ),
                        ),
                        child: const Icon(
                          Icons.check_rounded,
                          size: 32,
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Report Submitted!',
                        style: AppTypography.headlineSmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Your report has been shared with the community. We\'ll notify you if there\'s a match.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      BelongButton(
                        label: 'Done',
                        onPressed: () {
                          context.pop();
                          context.pop();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TypeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.08) : AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(
            color: isSelected ? color : AppColors.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? color.withValues(alpha: 0.15)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? color : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: const Icon(
                  Icons.check_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  final String label;
  final String value;

  const _ReviewRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
