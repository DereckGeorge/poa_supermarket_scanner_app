import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../providers/branch_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/stats_card.dart';
import '../widgets/quick_action_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );

    if (branchProvider.selectedBranch != null) {
      await productProvider.fetchProducts(
        branchId: branchProvider.selectedBranch!.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome section
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primaryRed, AppTheme.darkRed],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppTheme.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          authProvider.user?.name ?? 'User',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Consumer<BranchProvider>(
                          builder: (context, branchProvider, child) {
                            final branch = branchProvider.selectedBranch;
                            return Row(
                              children: [
                                const Icon(
                                  Icons.store,
                                  color: AppTheme.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  branch?.name ?? 'No Branch Selected',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(color: AppTheme.white),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Quick actions
              Text(
                'Quick Actions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.qr_code_scanner,
                      title: 'Scan Product',
                      subtitle: 'Scan barcode to view or add products',
                      color: AppTheme.primaryRed,
                      onTap: () {
                        // Navigate to scanner
                        DefaultTabController.of(context)?.animateTo(1);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: QuickActionCard(
                      icon: Icons.add_box,
                      title: 'Add Product',
                      subtitle: 'Manually add new product',
                      color: Colors.green,
                      onTap: () {
                        // Navigate to add product
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Statistics section
              Text(
                'Overview',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Consumer<ProductProvider>(
                builder: (context, productProvider, child) {
                  if (productProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final stats = productProvider.statistics;
                  if (stats == null) {
                    return const Center(child: Text('No statistics available'));
                  }

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: 'Total Products',
                              value: stats.totalProducts.toString(),
                              subtitle: 'Items in inventory',
                              icon: Icons.inventory,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatsCard(
                              title: 'Low Stock',
                              value: stats.lowStockProducts.toString(),
                              subtitle: 'Need restocking',
                              icon: Icons.warning,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: StatsCard(
                              title: 'Out of Stock',
                              value: stats.outOfStockProducts.toString(),
                              subtitle: 'Unavailable items',
                              icon: Icons.error,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatsCard(
                              title: 'Inventory Value',
                              value:
                                  'KSh ${stats.inventoryValue.toStringAsFixed(0)}',
                              subtitle: 'Total worth',
                              icon: Icons.monetization_on,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),

              // Recent activity placeholder
              Text(
                'Recent Activity',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.history, size: 48, color: AppTheme.textGrey),
                      const SizedBox(height: 16),
                      Text(
                        'No recent activity',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: AppTheme.textGrey),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your recent scans and activities will appear here',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.textGrey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
