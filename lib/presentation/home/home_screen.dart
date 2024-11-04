import 'package:flutter/material.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _isDrawerOpen = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.home, label: 'Home', 
      actions: ['Create Dashboard', 'View Analytics', 'Manage Settings']),
    NavigationItem(icon: Icons.folder, label: 'Projects', 
      actions: ['New Project', 'Import Project', 'Project Templates']),
    NavigationItem(icon: Icons.dashboard_outlined, label: 'Templates', 
      actions: ['Create Template', 'Browse Templates', 'Import Template']),
    NavigationItem(icon: Icons.brush, label: 'Brand', 
      actions: ['Brand Guidelines', 'Logo Assets', 'Color Palettes']),
    NavigationItem(icon: Icons.apps, label: 'Apps', 
      actions: ['Connect App', 'App Settings', 'Integration Guide']),
    NavigationItem(icon: Icons.interests, label: 'Dream Lab', 
      actions: ['New Experiment', 'Lab Reports', 'Research Tools']),
    NavigationItem(icon: Icons.lightbulb_outline, label: 'Glow Up', 
      actions: ['Start Project', 'View Tutorials', 'Community']),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Scaffold(
      key: _scaffoldKey,
      drawer: isDesktop ? null : _buildDrawer(),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            extended: false,
            minWidth: 72,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
                if (!isDesktop) {
                  _scaffoldKey.currentState?.openDrawer();
                } else {
                  _isDrawerOpen = true;
                }
              });
            },
            leading: _buildNavigationRailLeading(isDesktop),
            destinations: _navigationItems
                .map((item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      label: Text(item.label),
                    ))
                .toList(),
          ),

          if (_isDrawerOpen && isDesktop)
            Container(
              width: 320,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: _buildFeaturesList(isDesktop),
            ),

          Expanded(
            child: Container(
              color: Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: _buildMainContent(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRailLeading(bool isDesktop) {
    return Column(
      children: [
        const SizedBox(height: 8),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            if (!isDesktop) {
              _scaffoldKey.currentState?.openDrawer();
            } else {
              setState(() {
                _isDrawerOpen = !_isDrawerOpen;
              });
            }
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 48,
          height: 48,
          child: ElevatedButton(
            onPressed: () => _showCreateMenu(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }

  void _showCreateMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final Offset offset = button.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + button.size.height,
        offset.dx + button.size.width,
        offset.dy + button.size.height,
      ),
      items: _navigationItems[_selectedIndex].actions.map((String action) {
        return PopupMenuItem<String>(
          value: action,
          child: Text(action),
        );
      }).toList(),
    ).then((String? value) {
      if (value != null) {
        _handleActionSelected(value);
      }
    });
  }

  void _handleActionSelected(String action) {
    // Handle the action selection
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected action: $action')),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: _buildFeaturesList(false),
    );
  }

  Widget _buildFeaturesList(bool isDesktop) {
    return Column(
      children: [
        _buildFeatureHeader(isDesktop),
        const Divider(),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildActionButtons(),
                const Divider(height: 32),
                _buildRecentSection(),
                const Divider(height: 32),
                _buildFeatureCards(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureHeader(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _navigationItems[_selectedIndex].label,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (isDesktop)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isDrawerOpen = false;
                });
              },
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _navigationItems[_selectedIndex].actions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: ElevatedButton(
              onPressed: () => _handleActionSelected(action),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.purple),
                ),
              ),
              child: Text(action),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRecentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Recent',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 3,
          itemBuilder: (context, index) {
            return ListTile(
              leading: const Icon(Icons.access_time),
              title: Text('Recent ${_navigationItems[_selectedIndex].label} ${index + 1}'),
              subtitle: Text('Last modified ${index + 1}d ago'),
              onTap: () {},
            );
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCards() {
    return Column(
      children: [
        _buildInfoCard(
          'Quick Start',
          'Get started with ${_navigationItems[_selectedIndex].label}',
          Icons.rocket_launch,
        ),
        _buildInfoCard(
          'Templates',
          'Browse pre-made templates',
          Icons.dashboard,
        ),
        _buildInfoCard(
          'Help & Resources',
          'Learn more about features',
          Icons.help_outline,
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String subtitle, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search projects...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
          CircleAvatar(
            backgroundColor: Colors.purple.shade100,
            child: const Icon(Icons.person_outline, color: Colors.purple),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to ${_navigationItems[_selectedIndex].label}',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 600 ? 1 : 
                               MediaQuery.of(context).size.width < 1000 ? 2 : 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Card(
                  child: Center(
                    child: Text('Project ${index + 1}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class NavigationItem {
  final IconData icon;
  final String label;
  final List<String> actions;

  NavigationItem({
    required this.icon, 
    required this.label, 
    this.actions = const []
  });
}