import 'package:core_package/core_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';

/// The home screen — the first screen shown after login.
///
/// Demonstrates [AppSearchField] and [AppPaginatedListView] wired
/// together against a small in-memory dataset, standing in for a real
/// paginated API-backed list (e.g. leads, orders). New apps built from
/// this template replace `_allItems` and the artificial delay in
/// [_loadMore] with a real repository call.
class HomeScreen extends ConsumerStatefulWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const _pageSize = 10;
  static final _allItems = List.generate(
    42,
    (index) => 'Activity item ${index + 1}',
  );

  late final PaginationController _paginationController;
  String _query = '';
  int _visibleCount = _pageSize;

  @override
  void initState() {
    super.initState();
    _paginationController = PaginationController(onLoadMore: _loadMore);
  }

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }

  List<String> get _filteredItems {
    if (_query.isBlank) return _allItems;
    final lowerQuery = _query.toLowerCase();
    return _allItems.where((item) {
      return item.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  Future<void> _loadMore() async {
    // Simulates network latency for the next "page" — replace with a
    // real repository call in an app built from this template.
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    setState(() {
      _visibleCount = (_visibleCount + _pageSize).clamp(
        0,
        _filteredItems.length,
      );
    });
    _paginationController.setHasMore(_visibleCount < _filteredItems.length);
  }

  void _onSearchChanged(String query) {
    setState(() {
      _query = query;
      _visibleCount = _pageSize;
    });
    _paginationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final config = AppThemeScope.of(context);
    final authState = ref.watch(authControllerProvider);
    final visibleItems = _filteredItems.take(_visibleCount).toList();

    return Padding(
      padding: EdgeInsets.all(config.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${authState.user?.name ?? ''}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: config.spacing.md),
          AppSearchField(
            hintText: 'Search activity',
            onChanged: _onSearchChanged,
          ),
          SizedBox(height: config.spacing.md),
          Expanded(
            child: AppPaginatedListView<String>(
              items: visibleItems,
              controller: _paginationController,
              emptyState: const AppEmptyState(
                title: 'No matching activity',
                message: 'Try a different search term.',
              ),
              itemBuilder: (context, item) => Padding(
                padding: EdgeInsets.only(bottom: config.spacing.sm),
                child: AppCard(
                  child: Row(
                    children: [
                      Icon(Icons.history, color: config.primary),
                      SizedBox(width: config.spacing.sm),
                      Expanded(child: Text(item)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
