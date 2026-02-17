import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/logging/app_logger.dart';
import 'package:task_todo_app/core/network/api_client.dart';
import 'package:task_todo_app/core/network/dto/dto.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/badges/task_icon.dart';
import 'package:task_todo_app/shared/widgets/buttons/app_button.dart';

class AddProjectPage extends StatefulWidget {
  /// Optional pre-selected task group to add task to
  final TaskGroupDto? selectedGroup;

  const AddProjectPage({super.key, this.selectedGroup});

  @override
  State<AddProjectPage> createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
  final _taskNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _groupNameController = TextEditingController();

  // Group selection mode
  bool _isNewGroup = true;
  TaskGroupDto? _selectedExistingGroup;
  List<TaskGroupDto> _existingGroups = [];
  bool _isLoadingGroups = false;

  // New group customization
  Color _selectedColor = const Color(0xFFF478B8);
  String _selectedIconName = 'briefcase';

  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  // Available colors for group
  final List<Color> _availableColors = [
    const Color(0xFFF478B8), // Pink
    const Color(0xFF9260F4), // Purple
    const Color(0xFFFF7D53), // Orange
    const Color(0xFF4CAF50), // Green
    const Color(0xFF2196F3), // Blue
    const Color(0xFFFFEB3B), // Yellow
    const Color(0xFF00BCD4), // Cyan
    const Color(0xFF795548), // Brown
  ];

  // Available icons for group
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'briefcase', 'icon': IconsaxPlusBold.briefcase},
    {'name': 'user', 'icon': IconsaxPlusBold.user},
    {'name': 'book', 'icon': IconsaxPlusBold.book_1},
    {'name': 'palette', 'icon': IconsaxPlusBold.paintbucket},
    {'name': 'home', 'icon': IconsaxPlusBold.home_2},
    {'name': 'health', 'icon': IconsaxPlusBold.health},
    {'name': 'shopping', 'icon': IconsaxPlusBold.shopping_cart},
    {'name': 'car', 'icon': IconsaxPlusBold.car},
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingGroups();
    
    // If a group was pre-selected, use it
    if (widget.selectedGroup != null) {
      _isNewGroup = false;
      _selectedExistingGroup = widget.selectedGroup;
    }
  }

  Future<void> _loadExistingGroups() async {
    setState(() => _isLoadingGroups = true);
    
    try {
      final groups = await taskApiService.getAllTaskGroups();
      if (mounted) {
        setState(() {
          _existingGroups = groups;
          _isLoadingGroups = false;
          
          // If pre-selected group, find it in loaded groups
          if (widget.selectedGroup != null) {
            _selectedExistingGroup = groups.firstWhere(
              (g) => g.id == widget.selectedGroup!.id,
              orElse: () => groups.isNotEmpty ? groups.first : widget.selectedGroup!,
            );
          }
        });
      }
    } catch (e) {
      log.e('Failed to load task groups', e);
      if (mounted) {
        setState(() => _isLoadingGroups = false);
      }
    }
  }

  @override
  void dispose() {
    _taskNameController.dispose();
    _descriptionController.dispose();
    _groupNameController.dispose();
    super.dispose();
  }

  IconData _getIconByName(String? name) {
    final iconData = _availableIcons.firstWhere(
      (i) => i['name'] == name,
      orElse: () => _availableIcons.first,
    );
    return iconData['icon'] as IconData;
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
                    // Group Type Toggle
                    _buildGroupTypeToggle(colors),

                    const SizedBox(height: 20),

                    // Group Selection/Creation
                    if (_isNewGroup)
                      _buildNewGroupSection(colors)
                    else
                      _buildExistingGroupSection(colors),

                    const SizedBox(height: 20),

                    // Task Name
                    _buildTextField(
                      colors: colors,
                      label: 'Task Name',
                      controller: _taskNameController,
                      hint: 'Enter task name',
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            // Add Task Button
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppButton.primary(
                label: 'Create Task',
                onPressed: _isLoading ? null : _handleCreateTask,
                isLoading: _isLoading,
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
        Text(
          "Add Task",
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
          ),
        ),
        const SizedBox(width: 40), // Balance the back button
      ],
    );
  }

  Widget _buildGroupTypeToggle(AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isNewGroup = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _isNewGroup ? colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _isNewGroup
                      ? [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: 4,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'New Group',
                    style: AppTypography.labelLarge.copyWith(
                      color: _isNewGroup ? colors.primary : colors.textSecondary,
                      fontWeight: _isNewGroup ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isNewGroup = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_isNewGroup ? colors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: !_isNewGroup
                      ? [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: 4,
                          )
                        ]
                      : null,
                ),
                child: Center(
                  child: Text(
                    'Existing Group',
                    style: AppTypography.labelLarge.copyWith(
                      color: !_isNewGroup ? colors.primary : colors.textSecondary,
                      fontWeight: !_isNewGroup ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewGroupSection(AppColorsLight colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Name
        _buildTextField(
          colors: colors,
          label: 'Group Name',
          controller: _groupNameController,
          hint: 'e.g., Work, Personal, Study',
        ),

        const SizedBox(height: 16),

        // Color Picker
        Text(
          'Group Color',
          style: AppTypography.labelMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableColors.map((color) {
            final isSelected = color == _selectedColor;
            return GestureDetector(
              onTap: () => setState(() => _selectedColor = color),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: isSelected
                      ? Border.all(color: colors.textPrimary, width: 3)
                      : null,
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: color.withValues(alpha: 0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ]
                      : null,
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : null,
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Icon Picker
        Text(
          'Group Icon',
          style: AppTypography.labelMedium.copyWith(
            color: colors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _availableIcons.map((iconData) {
            final isSelected = iconData['name'] == _selectedIconName;
            return GestureDetector(
              onTap: () => setState(() => _selectedIconName = iconData['name'] as String),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isSelected
                      ? _selectedColor.withValues(alpha: 0.2)
                      : colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: isSelected
                      ? Border.all(color: _selectedColor, width: 2)
                      : null,
                ),
                child: Icon(
                  iconData['icon'] as IconData,
                  color: isSelected ? _selectedColor : colors.textSecondary,
                  size: 24,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExistingGroupSection(AppColorsLight colors) {
    if (_isLoadingGroups) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: CircularProgressIndicator(color: colors.primary),
        ),
      );
    }

    if (_existingGroups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              IconsaxPlusLinear.folder_2,
              size: 48,
              color: colors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No existing groups',
              style: AppTypography.bodyLarge.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a new group above',
              style: AppTypography.bodySmall.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (_selectedExistingGroup != null)
            TaskIcon(
              groupIcon: _getIconByName(_selectedExistingGroup!.icon),
              iconColor: _parseHexColor(_selectedExistingGroup!.hexColor),
            ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Group',
                  style: AppTypography.bodySmall.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedExistingGroup?.id,
                    isDense: true,
                    isExpanded: true,
                    hint: Text(
                      'Choose a group',
                      style: AppTypography.titleMedium.copyWith(
                        color: colors.textHint,
                      ),
                    ),
                    icon: const SizedBox.shrink(),
                    style: AppTypography.titleMedium.copyWith(
                      color: colors.textPrimary,
                    ),
                    items: _existingGroups.map((group) {
                      return DropdownMenuItem<String>(
                        value: group.id,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _parseHexColor(group.hexColor),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(group.name),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedExistingGroup = _existingGroups.firstWhere(
                            (g) => g.id == value,
                          );
                        });
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
            'Description (optional)',
            style: AppTypography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: AppTypography.bodyMedium.copyWith(
              color: colors.textPrimary,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              hintText: 'Enter task description',
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

  Color _parseHexColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]}, ${date.year}';
  }

  String _colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';
  }

  Future<void> _handleCreateTask() async {
    final taskName = _taskNameController.text.trim();
    final description = _descriptionController.text.trim();

    // Validation
    if (taskName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task name')),
      );
      return;
    }

    if (_isNewGroup) {
      final groupName = _groupNameController.text.trim();
      if (groupName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a group name')),
        );
        return;
      }
    } else {
      if (_selectedExistingGroup == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a group')),
        );
        return;
      }
    }

    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start date')),
      );
      return;
    }

    if (_endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end date')),
      );
      return;
    }

    if (_endDate!.isBefore(_startDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End date must be after start date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      late final CreateTaskRequestDto request;

      if (_isNewGroup) {
        // Creating new group
        request = CreateTaskRequestDto(
          groupName: _groupNameController.text.trim(),
          groupColor: _colorToHex(_selectedColor),
          groupIcon: _selectedIconName,
          taskName: taskName,
          taskDescription: description.isNotEmpty ? description : null,
          startDate: _startDate!,
          endDate: _endDate!,
        );
      } else {
        // Adding to existing group
        request = CreateTaskRequestDto(
          groupName: _selectedExistingGroup!.name,
          groupColor: _selectedExistingGroup!.hexColor,
          groupIcon: _selectedExistingGroup!.icon,
          taskName: taskName,
          taskDescription: description.isNotEmpty ? description : null,
          startDate: _startDate!,
          endDate: _endDate!,
        );
      }

      log.i('Creating task', request.toJson());
      await taskApiService.createTask(request);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to trigger refresh
      }
    } on ApiException catch (e, stackTrace) {
      log.e('Failed to create task', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, stackTrace) {
      log.e('Unexpected error creating task', e, stackTrace);
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create task: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
