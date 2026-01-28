import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import '../../../../core/theme/theme.dart';
import '../../../../shared/shared.dart';
import '../../../../shared/widgets/navigation/custom_bottom_nav.dart';

/// Showcase page demonstrating all widgets and theme.
class ShowcasePage extends StatefulWidget {
  const ShowcasePage({super.key});

  @override
  State<ShowcasePage> createState() => _ShowcasePageState();
}

class _ShowcasePageState extends State<ShowcasePage> {
  int _navIndex = 0;
  int _selectedFilter = 0;
  int _selectedDay = 2;
  DateTime? _selectedDate;
  final _textController = TextEditingController();
  String? _dropdownValue;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      extendBody: true, // Required for glass effect on bottom nav
      backgroundColor: colors.background,
      appBar: AppTopBar(
        title: 'Widget Showcase',
        showBackButton: false,
        actions: [
          IconButton(
            icon: Icon(IconsaxPlusLinear.sun_1, color: colors.textPrimary),
            onPressed: () {
              // Toggle theme would go here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: AppSpacing.paddingMD,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection('Colors', _buildColorsSection()),
            _buildSection('Typography', _buildTypographySection()),
            _buildSection('Buttons', _buildButtonsSection()),
            _buildSection('Status Badges', _buildBadgesSection()),
            _buildSection('Progress Indicators', _buildProgressSection()),
            _buildSection('Filter Chips', _buildChipsSection()),
            _buildSection('Calendar Strip', _buildCalendarSection()),
            _buildSection('Avatars', _buildAvatarsSection()),
            _buildSection('Input Fields', _buildInputsSection()),
            _buildSection('Task Cards', _buildCardsSection()),
            _buildSection('Progress Card', _buildProgressCardSection()),
            AppSpacing.gapVerticalXL,
          ],
        ),
      ),
      floatingActionButton: AppFab(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Add button pressed!')));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _navIndex,
        items: const [
          NavItem(
            icon: IconsaxPlusLinear.home_2,
            activeIcon: IconsaxPlusBold.home_2,
            label: 'Home',
          ),
          NavItem(
            icon: IconsaxPlusLinear.calendar_1,
            activeIcon: IconsaxPlusBold.calendar_1,
            label: 'Calendar',
          ),
          NavItem(
            icon: IconsaxPlusLinear.document_text,
            activeIcon: IconsaxPlusBold.document_text,
            label: 'Documents',
          ),
          NavItem(
            icon: IconsaxPlusLinear.profile_2user,
            activeIcon: IconsaxPlusBold.profile_2user,
            label: 'Profile',
          ),
        ],
        onTap: (index) => setState(() => _navIndex = index),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSpacing.gapVerticalLG,
        Text(
          title,
          style: AppTypography.headlineSmall.copyWith(
            color: colors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        AppSpacing.gapVerticalSM,
        Divider(color: colors.border),
        AppSpacing.gapVerticalSM,
        content,
      ],
    );
  }

  Widget _buildColorsSection() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        _colorChip('Primary', AppColorPalette.primary),
        _colorChip('Primary Light', AppColorPalette.primaryLight),
        _colorChip('Primary Surface', AppColorPalette.primarySurface),
        _colorChip('Secondary', AppColorPalette.secondary),
        _colorChip('Success', AppColorPalette.success),
        _colorChip('Warning', AppColorPalette.warning),
        _colorChip('Error', AppColorPalette.error),
        _colorChip('Info', AppColorPalette.info),
        _colorChip('Cat. Orange', AppColorPalette.categoryOrange),
        _colorChip('Cat. Purple', AppColorPalette.categoryPurple),
        _colorChip('Cat. Green', AppColorPalette.categoryGreen),
        _colorChip('Cat. Pink', AppColorPalette.categoryPink),
      ],
    );
  }

  Widget _colorChip(String name, Color color) {
    final isLight = color.computeLuminance() > 0.5;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: AppRadius.borderRadiusSM,
      ),
      child: Text(
        name,
        style: AppTypography.labelSmall.copyWith(
          color: isLight ? AppColorPalette.grey900 : AppColorPalette.white,
        ),
      ),
    );
  }

  Widget _buildTypographySection() {
    final colors = AppColors.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Display Large',
          style: AppTypography.displayLarge.copyWith(color: colors.textPrimary),
        ),
        Text(
          'Headline Medium',
          style: AppTypography.headlineMedium.copyWith(
            color: colors.textPrimary,
          ),
        ),
        Text(
          'Title Large',
          style: AppTypography.titleLarge.copyWith(color: colors.textPrimary),
        ),
        Text(
          'Body Large - Regular text content',
          style: AppTypography.bodyLarge.copyWith(color: colors.textPrimary),
        ),
        Text(
          'Body Medium - Secondary content',
          style: AppTypography.bodyMedium.copyWith(color: colors.textSecondary),
        ),
        Text(
          'Label Small - Caption text',
          style: AppTypography.labelSmall.copyWith(color: colors.textHint),
        ),
      ],
    );
  }

  Widget _buildButtonsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(label: 'Primary', onPressed: () {}, fullWidth: false),
            AppButton(
              label: 'Secondary',
              variant: AppButtonVariant.secondary,
              onPressed: () {},
              fullWidth: false,
            ),
            AppButton(
              label: 'Text',
              variant: AppButtonVariant.text,
              onPressed: () {},
              fullWidth: false,
            ),
          ],
        ),
        AppSpacing.gapVerticalSM,
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            AppButton(
              label: 'With Arrow',
              showArrow: true,
              onPressed: () {},
              fullWidth: false,
            ),
            AppButton(
              label: 'Loading',
              isLoading: true,
              onPressed: () {},
              fullWidth: false,
            ),
            const AppButton(
              label: 'Disabled',
              onPressed: null,
              fullWidth: false,
            ),
          ],
        ),
        AppSpacing.gapVerticalSM,
        Row(
          children: [
            AppIconButton(icon: IconsaxPlusLinear.edit_2, onPressed: () {}),
            AppSpacing.gapHorizontalSM,
            AppIconButton(
              icon: IconsaxPlusLinear.trash,
              backgroundColor: AppColorPalette.errorLight,
              iconColor: AppColorPalette.error,
              onPressed: () {},
            ),
            AppSpacing.gapHorizontalSM,
            AppIconButton(
              icon: IconsaxPlusLinear.heart,
              backgroundColor: AppColorPalette.primarySurface,
              iconColor: AppColorPalette.primary,
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadgesSection() {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        const StatusBadge(status: TaskStatus.todo),
        const StatusBadge(status: TaskStatus.inProgress),
        const StatusBadge(status: TaskStatus.done),
        AppSpacing.gapHorizontalMD,
        CategoryDot.orange(),
        CategoryDot.purple(),
        CategoryDot.green(),
      ],
    );
  }

  Widget _buildProgressSection() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircularProgressWidget(progress: 0.25, size: 60, strokeWidth: 6),
        CircularProgressWidget(progress: 0.50, size: 60, strokeWidth: 6),
        CircularProgressWidget(progress: 0.75, size: 60, strokeWidth: 6),
        CircularProgressWidget(progress: 1.0, size: 60, strokeWidth: 6),
        MiniProgressIndicator(progress: 0.65),
      ],
    );
  }

  Widget _buildChipsSection() {
    final filters = ['All', 'To Do', 'In Progress', 'Done'];

    return FilterChipRow(
      filters: filters,
      selectedIndex: _selectedFilter,
      onFilterSelected: (index) => setState(() => _selectedFilter = index),
    );
  }

  Widget _buildCalendarSection() {
    final days = CalendarDayData.generateDays(
      daysBefore: 2,
      daysAfter: 4,
      showMonth: true,
    );

    return CalendarStrip(
      days: days,
      selectedIndex: _selectedDay,
      onDaySelected: (index) => setState(() => _selectedDay = index),
    );
  }

  Widget _buildAvatarsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            AppAvatar(name: 'John', size: AvatarSize.xs),
            AppSpacing.gapHorizontalSM,
            AppAvatar(name: 'Jane Doe', size: AvatarSize.small),
            AppSpacing.gapHorizontalSM,
            AppAvatar(name: 'Bob Smith', size: AvatarSize.medium),
            AppSpacing.gapHorizontalSM,
            AppAvatar(name: 'Alice', size: AvatarSize.large),
          ],
        ),
        AppSpacing.gapVerticalMD,
        const Row(
          children: [
            AppAvatar(
              name: 'Online User',
              showOnlineStatus: true,
              isOnline: true,
            ),
            AppSpacing.gapHorizontalMD,
            AppAvatar(
              name: 'Offline User',
              showOnlineStatus: true,
              isOnline: false,
            ),
          ],
        ),
        AppSpacing.gapVerticalMD,
        const AvatarStack(
          avatars: [
            AvatarData(name: 'Alice'),
            AvatarData(name: 'Bob'),
            AvatarData(name: 'Charlie'),
            AvatarData(name: 'Diana'),
            AvatarData(name: 'Eve'),
          ],
          maxVisible: 3,
        ),
      ],
    );
  }

  Widget _buildInputsSection() {
    return Column(
      children: [
        AppTextField(
          label: 'Task Name',
          hint: 'Enter task name...',
          controller: _textController,
          prefixIcon: IconsaxPlusLinear.task_square,
        ),
        AppSpacing.gapVerticalMD,
        AppDropdownField<String>(
          label: 'Category',
          hint: 'Select category',
          value: _dropdownValue,
          items: const [
            DropdownMenuItem(value: 'work', child: Text('Work')),
            DropdownMenuItem(value: 'personal', child: Text('Personal')),
            DropdownMenuItem(value: 'study', child: Text('Study')),
          ],
          onChanged: (value) => setState(() => _dropdownValue = value),
        ),
        AppSpacing.gapVerticalMD,
        AppDateField(
          label: 'Due Date',
          hint: 'Select due date',
          value: _selectedDate,
          onDateSelected: (date) => setState(() => _selectedDate = date),
        ),
      ],
    );
  }

  Widget _buildCardsSection() {
    return Column(
      children: [
        TaskCard(
          category: 'Design System',
          title: 'Create color palette and typography',
          time: '10:00 AM',
          status: TaskStatus.done,
          onTap: () {},
        ),
        AppSpacing.gapVerticalSM,
        TaskCard(
          category: 'UI Development',
          title: 'Build reusable UI components',
          time: '2:30 PM',
          status: TaskStatus.inProgress,
          onTap: () {},
        ),
        AppSpacing.gapVerticalSM,
        TaskCard(
          category: 'Documentation',
          title: 'Write widget usage documentation',
          time: '4:00 PM',
          status: TaskStatus.todo,
          onTap: () {},
        ),
        AppSpacing.gapVerticalMD,
        TaskGroupCard(
          icon: IconsaxPlusLinear.briefcase,
          iconColor: AppColorPalette.categoryOrange,
          title: 'Office Project',
          taskCount: 12,
          progress: 0.67,
          onTap: () {},
        ),
        AppSpacing.gapVerticalSM,
        TaskGroupCard(
          icon: IconsaxPlusLinear.user,
          iconColor: AppColorPalette.categoryPurple,
          title: 'Personal Tasks',
          taskCount: 8,
          progress: 0.25,
          onTap: () {},
        ),
        AppSpacing.gapVerticalMD,
        const Row(
          children: [
            Expanded(
              child: InProgressCard(
                projectName: 'Mobile App',
                title: 'UI Development',
              ),
            ),
            AppSpacing.gapHorizontalSM,
            Expanded(
              child: InProgressCard(
                projectName: 'Web App',
                title: 'Backend Integration',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCardSection() {
    return const ProgressSummaryCard(
      title: "Your today's task\nalmost done!",
      progress: 0.85,
      buttonLabel: 'View Task',
    );
  }
}
