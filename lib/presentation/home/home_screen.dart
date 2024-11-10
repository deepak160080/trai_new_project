import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> with SingleTickerProviderStateMixin {
   int _selectedIndex = 0;
  bool _isDrawerOpen = false;
  bool _isProfileMenuVisible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _profileLayerLink = LayerLink();
  OverlayEntry? _profileOverlayEntry;

// Add these variables to _ProjectsPageState class
Timer? _breakTimer;
DateTime? _breakStartTime;
int _elapsedSeconds = 0;
bool _isOnBreak = false;

// Add this method to _ProjectsPageState class
void _startBreak(String breakType) {
  setState(() {
    _isOnBreak = true;
    _breakStartTime = DateTime.now();
    _startBreakTimer();
  });
  
  // Update the UI to show break status
  _showBreakConfirmation(breakType);
}

void _startBreakTimer() {
  _breakTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_breakStartTime != null) {
      setState(() {
        _elapsedSeconds = DateTime.now().difference(_breakStartTime!).inSeconds;
      });
    }
  });
}

void _endBreak() {
  _breakTimer?.cancel();
  setState(() {
    _isOnBreak = false;
    _breakStartTime = null;
    _elapsedSeconds = 0;
  });
}

void _showEndShiftDialog() {
  final startTime = _breakStartTime ?? DateTime.now();
  final totalTime = DateTime.now().difference(startTime);
  
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'End Shift',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${totalTime.inMinutes}m',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Total Shift Time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Start time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(startTime),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'End time',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle end shift logic here
                      Navigator.of(context).pop();
                      _endBreak();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('End Shift'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

// Update the _showBreakConfirmation method
void _showBreakConfirmation(String breakType) {
  Navigator.of(context).pop(); // Close break type dialog
  _removeProfileOverlay(); // Close profile overlay
  
  showDialog(
    context: context,
    barrierDismissible: false, // Changed to false to prevent dismissal while on break
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isOnBreak) ...[
                Text(
                  '${(_elapsedSeconds / 60).floor()}m taken of your break',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _endBreak();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('End Break'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showEndShiftDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('End Shift'),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    // Handle edit shift logic
                  },
                  child: const Text('Edit shift'),
                ),
              ] else ...[
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.timer,
                    size: 50,
                    color: Colors.green.shade600,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Starting $breakType',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Break started at ${DateFormat('hh:mm a').format(DateTime.now())}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}

// Update the _buildProfileOverlay method to include break status
Widget _buildProfileStatus() {
  if (_isOnBreak) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'On Break',
            style: TextStyle(
              color: Colors.orange.shade700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(0.1),
      borderRadius: BorderRadius.circular(12),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'On Shift',
          style: TextStyle(
            color: Colors.green,
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
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
  void dispose() {
    _searchController.dispose();
    _removeProfileOverlay();
    super.dispose();
  }

  void _toggleProfileMenu() {
    setState(() {
      _isProfileMenuVisible = !_isProfileMenuVisible;
      if (_isProfileMenuVisible) {
        _showProfileOverlay();
      } else {
        _removeProfileOverlay();
      }
    });
  }

  void _removeProfileOverlay() {
    _profileOverlayEntry?.remove();
    _profileOverlayEntry = null;
  }



  void _showProfileOverlay() {
    _removeProfileOverlay();

    final OverlayState overlayState = Overlay.of(context);

    _profileOverlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full screen transparent overlay to detect outside taps
          Positioned.fill(
            child: GestureDetector(
              onTap: _removeProfileOverlay,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          // Profile menu
          Positioned(
            width: 200,
            child: CompositedTransformFollower(
              link: _profileLayerLink,
              offset: const Offset(-160, 60),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Text(
                                    'TR',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    width: 12,
                                    height: 12,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.white, width: 2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Tushar Rai',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'On Shift',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Started 2:13pm at Admin',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _toggleProfileMenu();
                                          _showBreakDialog();
                                        },
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.blue,
                                          side: const BorderSide(color: Colors.blue),
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                        ),
                                        child: const Text(
                                          'Start Break',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 16),
                                        ),
                                        child: const Text(
                                          'End Shift',
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 30),
                              ),
                              child: const Text('Edit shift'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlayState.insert(_profileOverlayEntry!);
  }

  // void _showBreakConfirmation(String breakType) {
  //   Navigator.of(context).pop(); // Close break type dialog
  //   _removeProfileOverlay(); // Close profile overlay
    
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         child: Container(
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Align(
  //                 alignment: Alignment.topRight,
  //                 child: IconButton(
  //                   icon: const Icon(Icons.close),
  //                   onPressed: () => Navigator.of(context).pop(),
  //                   padding: EdgeInsets.zero,
  //                   constraints: const BoxConstraints(),
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Container(
  //                 width: 100,
  //                 height: 100,
  //                 decoration: BoxDecoration(
  //                   color: Colors.green.shade100,
  //                   shape: BoxShape.circle,
  //                 ),
  //                 child: Icon(
  //                   Icons.thumb_up,
  //                   size: 50,
  //                   color: Colors.green.shade600,
  //                 ),
  //               ),
  //               const SizedBox(height: 24),
  //               Text(
  //                 'Enjoy your ${breakType.toLowerCase()}!',
  //                 style: const TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                 ),
  //               ),
  //               const SizedBox(height: 8),
  //               const Text(
  //                 'See you back soon.',
  //                 style: TextStyle(
  //                   color: Colors.grey,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void _showBreakDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Which break do you want to start?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F36),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 20,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _showBreakConfirmation('Meal Break (unpaid)'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Meal Break',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '(unpaid)',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Unscheduled',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => _showBreakConfirmation('Rest Break (paid)'),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Rest Break',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '(paid)',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Unscheduled',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: (){
                        _startBreak("");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: const Text('Start Break'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }
      
  
  @override
  Widget build(BuildContext context) {
    final bool isDesktop = MediaQuery.of(context).size.width >= 1200;
    
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          _buildTopBar(),
          Expanded(
            child: Row(
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
                      color: Colors.white,
                    ),
                    child: _buildFeaturesList(isDesktop),
                  ),
                
                Expanded(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: _buildMainContent(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: !isDesktop ? Drawer(child: _buildFeaturesList(false)) : null,
    );
  } 
  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.purple),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                  tooltip: 'Notifications',
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                  tooltip: 'Settings',
                ),
                const SizedBox(width: 8),
                CompositedTransformTarget(
                  link: _profileLayerLink,
                  child: GestureDetector(
                    onTap: _toggleProfileMenu,
                    child: CircleAvatar(
                      backgroundColor: Colors.purple.shade100,
                      child: const Icon(Icons.person_outline, color: Colors.purple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
    String? badge,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          tooltip: tooltip,
          splashRadius: 24,
        ),
        if (badge != null)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                badge,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
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