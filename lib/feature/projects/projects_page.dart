import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:task_todo_app/core/di/injection.dart';
import 'package:task_todo_app/core/network/api_client.dart';
import 'package:task_todo_app/core/network/dto/dto.dart';
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

  List<TaskGroupDto> _groups = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final groups = await taskApiService.getAllTaskGroups();

      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoading = false;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load projects. Pull to refresh.';
        });
      }
    }
  }

  List<_ProjectData> get _projects {
    return _groups.map((group) {
      final isCompleted = group.completed >= 1.0;

      return _ProjectData(
        group: group,
        progressPercent: group.completed,
        isCompleted: isCompleted,
      );
    }).toList();
  }

  List<_ProjectData> get _filteredProjects {
    var filtered = _projects;

    // Filter by status
    if (_selectedFilterIndex == 1) {
      filtered = filtered.where((p) => !p.isCompleted).toList();
    } else if (_selectedFilterIndex == 2) {
      filtered = filtered.where((p) => p.isCompleted).toList();
    }

    // Filter by search query
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered
          .where((p) => p.group.name.toLowerCase().contains(query))
          .toList();
    }

    return filtered;
  }

  Color _parseHexColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  IconData _getIconForGroup(String? iconName) {
    switch (iconName) {
      case 'briefcase':
        return IconsaxPlusBold.briefcase;
      case 'user':
        return IconsaxPlusBold.user;
      case 'palette':
        return IconsaxPlusBold.paintbucket;
      case 'book':
        return IconsaxPlusBold.book_1;
      default:
        return IconsaxPlusBold.folder_2;
    }
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
        child: RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : _errorMessage != null
                        ? _buildErrorState(colors)
                        : _filteredProjects.isEmpty
                            ? _buildEmptyState(colors)
                            : Column(
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
    ),
  );
  }

  Widget _buildErrorState(AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              IconsaxPlusLinear.warning_2,
              size: 48,
              color: colors.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: AppTypography.bodyLarge.copyWith(
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _loadData,
              icon: const Icon(IconsaxPlusLinear.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppColorsLight colors) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Center(
        child: Column(
          children: [
            Icon(
              IconsaxPlusLinear.folder_2,
              size: 48,
              color: colors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              'No projects yet',
              style: AppTypography.bodyLarge.copyWith(
                color: colors.textSecondary,
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

  Widget _buildProjectCard(_ProjectData project, AppColorsLight colors) {
    final groupColor = _parseHexColor(project.group.hexColor);
    final backgroundColor = groupColor.withValues(alpha: 0.15);

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
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIconForGroup(project.group.icon),
              color: groupColor,
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
                  project.group.name,
                  style: AppTypography.titleMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Progress bar
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: project.progressPercent,
                          backgroundColor: colors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(groupColor),
                          minHeight: 6,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(project.progressPercent * 100).toInt()}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: project.isCompleted
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

class _ProjectData {
  final TaskGroupDto group;
  final double progressPercent;
  final bool isCompleted;

  _ProjectData({
    required this.group,
    required this.progressPercent,
    required this.isCompleted,
  });
}
