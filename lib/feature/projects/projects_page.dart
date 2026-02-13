import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/theme/app_colors.dart';
import 'package:task_todo_app/core/theme/app_typography.dart';
import 'package:task_todo_app/shared/custom_app_background.dart';
import 'package:task_todo_app/shared/widgets/app_section_bar.dart';
import 'package:task_todo_app/shared/widgets/chips/filter_chip.dart';
import 'package:task_todo_app/shared/widgets/inputs/app_text_field.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _filterTabs = ['All', 'Active', 'Completed'];

  // Sample project data
  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'Grocery shopping app design',
      'category': 'Mobile App',
      'icon': IconsaxPlusBold.mobile,
      'iconColor': const Color(0xFFF478B8),
      'backgroundColor': const Color(0xFFFFF0F7),
      'progressPercent': 0.75,
      'progressColor': const Color(0xFFF478B8),
      'taskCount': 12,
      'completedTasks': 9,
      'isCompleted': false,
    },
    {
      'title': 'Uber Eats redesign challenge',
      'category': 'UI/UX Design',
      'icon': IconsaxPlusBold.brush_1,
      'iconColor': const Color(0xFF9260F4),
      'backgroundColor': const Color(0xFFF3EFFF),
      'progressPercent': 0.45,
      'progressColor': const Color(0xFF9260F4),
      'taskCount': 8,
      'completedTasks': 4,
      'isCompleted': false,
    },
    {
      'title': 'About design sprint',
      'category': 'Learning',
      'icon': IconsaxPlusBold.book_1,
      'iconColor': const Color(0xFFFF7D53),
      'backgroundColor': const Color(0xFFFFF0EB),
      'progressPercent': 0.30,
      'progressColor': const Color(0xFFFF7D53),
      'taskCount': 5,
      'completedTasks': 2,
      'isCompleted': false,
    },
    {
      'title': 'Portfolio website',
      'category': 'Web Development',
      'icon': IconsaxPlusBold.code,
      'iconColor': const Color(0xFF0ECC5A),
      'backgroundColor': const Color(0xFFE8FAF0),
      'progressPercent': 1.0,
      'progressColor': const Color(0xFF0ECC5A),
      'taskCount': 10,
      'completedTasks': 10,
      'isCompleted': true,
    },
    {
      'title': 'Brand identity design',
      'category': 'Branding',
      'icon': IconsaxPlusBold.magicpen,
      'iconColor': const Color(0xFF5F33E1),
      'backgroundColor': const Color(0xFFEDE8FB),
      'progressPercent': 1.0,
      'progressColor': const Color(0xFF5F33E1),
      'taskCount': 6,
      'completedTasks': 6,
      'isCompleted': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredProjects {
    var filtered = _projects;

    // Filter by status
    if (_selectedFilterIndex == 1) {
      filtered = filtered.where((p) => !p['isCompleted']).toList();
    } else if (_selectedFilterIndex == 2) {
      filtered = filtered.where((p) => p['isCompleted']).toList();
    }

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p['title'].toLowerCase().contains(query) ||
              p['category'].toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      body: CustomAppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildHeader(colors),
              ),

              const SizedBox(height: 20),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppTextField(
                  controller: _searchController,
                  hint: 'Search projects...',
                  prefixIcon: IconsaxPlusLinear.search_normal,
                  onChanged: (_) => setState(() {}),
                ),
              ),

              const SizedBox(height: 16),

              // Filter chips
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: FilterChipRow(
                  filters: _filterTabs,
                  selectedIndex: _selectedFilterIndex,
                  onFilterSelected: (index) {
                    setState(() => _selectedFilterIndex = index);
                  },
                ),
              ),

              const SizedBox(height: 24),

              // Projects section header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AppSectionBar(
                  title: 'Projects',
                  count: _filteredProjects.length,
                ),
              ),

              const SizedBox(height: 16),

              // Projects list
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: _filteredProjects
                      .map((project) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildProjectCard(project, colors),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 100), // Bottom padding for nav bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppColorsLight colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Projects',
          style: AppTypography.headlineLarge.copyWith(
            color: colors.textPrimary,
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: colors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              IconsaxPlusLinear.notification,
              color: colors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectCard(Map<String, dynamic> project, AppColorsLight colors) {
    final int taskCount = project['taskCount'];
    final int completedTasks = project['completedTasks'];
    final double progress = project['progressPercent'];
    final bool isCompleted = project['isCompleted'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Project icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: project['backgroundColor'],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              project['icon'],
              color: project['iconColor'],
              size: 24,
            ),
          ),

          const SizedBox(width: 16),

          // Project info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project['title'],
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      project['category'],
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.textTertiary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$completedTasks/$taskCount Tasks',
                      style: AppTypography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          backgroundColor: colors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            project['progressColor'],
                          ),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: isCompleted
                            ? colors.success
                            : colors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Chevron
          Icon(
            IconsaxPlusLinear.arrow_right_3,
            color: colors.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }
}
