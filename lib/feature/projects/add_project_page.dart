import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';

class AddProjectPage extends StatefulWidget {
  const AddProjectPage({super.key});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _projectNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedTaskGroup = 'Work';
  DateTime? _startDate;
  DateTime? _endDate;

  final List<Map<String, dynamic>> _taskGroups = [
    {'name': 'Work', 'icon': IconsaxPlusBold.briefcase, 'color': const Color(0xFFF478B8)},
    {'name': 'Personal', 'icon': IconsaxPlusBold.user, 'color': const Color(0xFF9260F4)},
    {'name': 'Study', 'icon': IconsaxPlusBold.book_1, 'color': const Color(0xFFFF7D53)},
  ];

  @override
  void dispose() {
    _projectNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: Column(
          children: [
            const SizedBox(height: 16),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildHeader(colors),
            ),

            const SizedBox(height: 24),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Task Group Dropdown
                    _buildTaskGroupDropdown(colors),

                    const SizedBox(height: 20),

                    // Project Name
                    _buildTextField(
                      colors: colors,
                      label: 'Project Name',
                      controller: _projectNameController,
                      hint: 'Enter project name',
                    ),

                    const SizedBox(height: 20),

                    // Description
                    _buildDescriptionField(colors),

                    const SizedBox(height: 20),

                    // Start Date
                    _buildDateField(
                      colors: colors,
                      label: 'Start Date',
                      value: _startDate,
                      onDateSelected: (date) => setState(() => _startDate = date),
                    ),

                    const SizedBox(height: 20),

                    // End Date
                    _buildDateField(
                      colors: colors,
                      label: 'End Date',
                      value: _endDate,
                      onDateSelected: (date) => setState(() => _endDate = date),
                    ),

                    const SizedBox(height: 20),

                    // Logo Section
                    _buildLogoSection(colors),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Add Project Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppButton.primary(
                label: 'Add Project',
                onPressed: _handleAddProject,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back button
        GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Icon(
              IconsaxPlusLinear.arrow_left,
              color: colors.textPrimary,
              size: 24,
            ),
          ),
        ),

        // Title
        Text(
          "Add Project",
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
          ),
        ),

        // Notification Bell
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Icon(
                IconsaxPlusBold.notification,
                color: colors.textPrimary,
                size: 22,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: colors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskGroupDropdown(AppColorsLight colors) {
    final selectedGroup = _taskGroups.firstWhere(
      (g) => g['name'] == _selectedTaskGroup,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          TaskIcon(
            groupIcon: selectedGroup['icon'],
            iconColor: selectedGroup['color'],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Task Group',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTaskGroup,
                    isDense: true,
                    isExpanded: true,
                    icon: const SizedBox.shrink(),
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                    items: _taskGroups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group['name'],
                        child: Text(group['name']),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedTaskGroup = value);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Icon(
            IconsaxPlusLinear.arrow_down_1,
            color: colors.textPrimary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required AppColorsLight colors,
    required String label,
    required TextEditingController controller,
    String? hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          TextField(
            controller: controller,
            style: AppTypography.titleMedium.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: const EdgeInsets.only(top: 4),
              hintText: hint,
              hintStyle: AppTypography.titleMedium.copyWith(
                color: colors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionField(AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter project description',
              hintStyle: AppTypography.bodyMedium.copyWith(
                color: colors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required AppColorsLight colors,
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onDateSelected(date);
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            TaskIcon(
              groupIcon: IconsaxPlusBold.calendar,
              iconColor: colors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTypography.bodySmall.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value != null ? _formatDate(value) : 'Select date',
                    style: AppTypography.titleMedium.copyWith(
                      color: value != null ? colors.textPrimary : colors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              IconsaxPlusLinear.arrow_down_1,
              color: colors.textPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection(AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Logo placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF00897B),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                'Grocery\nshop',
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Logo name
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Grocery\n',
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: 'shop',
                    style: AppTypography.titleMedium.copyWith(
                      color: const Color(0xFFFF7D53),
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Change Logo button
          AppButton.secondary(
            label: 'Change Logo',
            onPressed: () {
              // Handle logo change
            },
            size: AppButtonSize.small,
            fullWidth: false,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  void _handleAddProject() {
    // Handle project creation
    final projectName = _projectNameController.text;
    final description = _descriptionController.text;

    if (projectName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a project name')),
      );
      return;
    }

    // TODO: Add project creation logic
    debugPrint('Creating project: $projectName');
    debugPrint('Description: $description');
    
    Navigator.maybePop(context);
  }
}
