// File: lib/screens/admin_dashboard.dart
import 'package:flutter/material.dart';
import 'dart:async';
import '../services/api_service.dart';
//import 'login_screen.dart';
import 'manage_users_screen.dart';

class AdminDashboard extends StatefulWidget {
  final String adminName;

  const AdminDashboard({super.key, required this.adminName});

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Counter animations for stats
  late AnimationController _counterController;
  late Animation<int> _unitsAnimation;
  late Animation<double> _qualityAnimation;
  late Animation<int> _tasksAnimation;
  late Animation<int> _deliveriesAnimation;

  // Progress bar animations
  late AnimationController _progressController;
  late Animation<double> _progress1Animation;
  late Animation<double> _progress2Animation;
  late Animation<double> _progress3Animation;
  late Animation<double> _progress4Animation;

  Map<String, dynamic> dashboardData = {};
  
  @override
  void initState() {
    super.initState();
    _loadDashboardData();

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _counterController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Counter animations
    _unitsAnimation = IntTween(begin: 0, end: 1245).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );
    _qualityAnimation = Tween<double>(begin: 0, end: 98.5).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );
    _tasksAnimation = IntTween(begin: 0, end: 156).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );
    _deliveriesAnimation = IntTween(begin: 0, end: 23).animate(
      CurvedAnimation(parent: _counterController, curve: Curves.easeOut),
    );

    // Progress animations
    _progress1Animation = Tween<double>(begin: 0, end: 0.85).animate(
      CurvedAnimation(parent: _progressController, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );
    _progress2Animation = Tween<double>(begin: 0, end: 0.73).animate(
      CurvedAnimation(parent: _progressController, curve: const Interval(0.2, 0.6, curve: Curves.easeOut)),
    );
    _progress3Animation = Tween<double>(begin: 0, end: 0.98).animate(
      CurvedAnimation(parent: _progressController, curve: const Interval(0.4, 0.8, curve: Curves.easeOut)),
    );
    _progress4Animation = Tween<double>(begin: 0, end: 0.91).animate(
      CurvedAnimation(parent: _progressController, curve: const Interval(0.6, 1.0, curve: Curves.easeOut)),
    );

    // Start animations
    _startAnimations();
  }
  
  void _loadDashboardData() async {
    try {
      final data = await ApiService.getDashboardData('Admin');
      setState(() {
        dashboardData = data;
      });
    } catch (e) {
      print('Failed to load dashboard data: $e');
    }
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _fadeController.forward();
    _slideController.forward();
    
    await Future.delayed(const Duration(milliseconds: 300));
    _scaleController.forward();
    
    await Future.delayed(const Duration(milliseconds: 500));
    _counterController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));
    _progressController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _counterController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animated Header Section
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildHeader(context),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Quick Stats Overview
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildQuickStatsSection(),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Operations Status Cards
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildOperationsSection(),
                ),
                const SizedBox(height: 30),

                // Animated Recent Activity & Performance
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _buildActivitySection(),
                  ),
                ),
                const SizedBox(height: 30),

                // Animated Action Buttons
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildActionButtons(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.black87, Colors.black54],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1000),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: const Text(
                        'Welcome back,',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1200),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - value) * 20),
                      child: Opacity(
                        opacity: value,
                        child: Text(
                          widget.adminName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 1400),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: const Text(
                        'Manufacturing Operations Dashboard',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.dashboard,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Today\'s Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _unitsAnimation,
                builder: (context, child) {
                  final unitsValue = _unitsAnimation.value ?? 0;
                  return _buildQuickStatCard(
                    unitsValue.toString(),
                    'Total Units',
                    Icons.inventory,
                    Colors.blue,
                    '+12%',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _qualityAnimation,
                builder: (context, child) {
                  final qualityValue = _qualityAnimation.value.isNaN ? 0.0 : _qualityAnimation.value;
                  return _buildQuickStatCard(
                    '${qualityValue.toStringAsFixed(1)}%',
                    'Quality Rate',
                    Icons.verified,
                    Colors.green,
                    '+0.3%',
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _tasksAnimation,
                builder: (context, child) {
                  final tasksValue = _tasksAnimation.value ?? 0;
                  return _buildQuickStatCard(
                    tasksValue.toString(),
                    'Active Tasks',
                    Icons.assignment,
                    Colors.orange,
                    '+8',
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AnimatedBuilder(
                animation: _deliveriesAnimation,
                builder: (context, child) {
                  final deliveriesValue = _deliveriesAnimation.value ?? 0;
                  return _buildQuickStatCard(
                    deliveriesValue.toString(),
                    'Deliveries',
                    Icons.local_shipping,
                    Colors.purple,
                    '+5',
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(String value, String label, IconData icon, Color color, String change) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, animValue, child) {
        return Transform.scale(
          scale: 0.8 + (animValue * 0.2),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(icon, color: color, size: 20),
                          ),
                        );
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        change,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOperationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Operations Status',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        AnimatedBuilder(
          animation: _progress1Animation,
          builder: (context, child) {
            return _buildOperationCard(
              'Incoming Inspection',
              'Active Units: 45',
              'Avg Time: 12 min',
              'Success Rate: 96.2%',
              Icons.input,
              Colors.blue,
              85,
              _progress1Animation.value,
            );
          },
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _progress2Animation,
          builder: (context, child) {
            return _buildOperationCard(
              'Finishing Operations',
              'In Progress: 23',
              'Completed Today: 67',
              'Tools Status: 8/9 Working',
              Icons.build,
              Colors.orange,
              73,
              _progress2Animation.value,
            );
          },
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _progress3Animation,
          builder: (context, child) {
            return _buildOperationCard(
              'Quality Control',
              'Inspected: 89',
              'Pass Rate: 98.9%',
              'Failed: 1 (Tolerance)',
              Icons.verified,
              Colors.green,
              98,
              _progress3Animation.value,
            );
          },
        ),
        const SizedBox(height: 12),
        AnimatedBuilder(
          animation: _progress4Animation,
          builder: (context, child) {
            return _buildOperationCard(
              'Delivery Management',
              'Dispatched: 23',
              'In Transit: 12',
              'Delivered: 145',
              Icons.local_shipping,
              Colors.purple,
              91,
              _progress4Animation.value,
            );
          },
        ),
      ],
    );
  }

  Widget _buildOperationCard(String title, String stat1, String stat2, String stat3, IconData icon, Color color, int progressValue, double animatedProgress) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, (1 - value) * 20),
          child: Opacity(
            opacity: value,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 700),
                        tween: Tween(begin: 0.0, end: 1.0),
                        builder: (context, animValue, child) {
                          return Transform.scale(
                            scale: animValue,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(icon, color: color, size: 24),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Performance: $progressValue%',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      TweenAnimationBuilder<int>(
                        duration: const Duration(milliseconds: 1000),
                        tween: IntTween(begin: 0, end: progressValue),
                        builder: (context, value, child) {
                          final safeValue = value ?? 0;
                          return Text(
                            '$safeValue%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: animatedProgress,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatItem(stat1),
                      _buildStatItem(stat2),
                      _buildStatItem(stat3),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String text) {
    return Expanded(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[700],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Quality Control Failed',
                'Part ID: QC-2024-001 exceeded tolerance',
                '2 min ago',
                Colors.red,
                Icons.error,
              ),
              const Divider(height: 20),
              _buildActivityItem(
                'Delivery Completed',
                'Order #DEL-445 delivered successfully',
                '15 min ago',
                Colors.green,
                Icons.check_circle,
              ),
              const Divider(height: 20),
              _buildActivityItem(
                'Tool Maintenance Alert',
                'AMS-141 COLUMN requires attention',
                '32 min ago',
                Colors.orange,
                Icons.warning,
              ),
              const Divider(height: 20),
              _buildActivityItem(
                'Inspection Completed',
                'Batch #IN-2024-098 passed inspection',
                '1 hour ago',
                Colors.blue,
                Icons.done_all,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String title, String subtitle, String time, Color color, IconData icon) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 50, 0),
          child: Opacity(
            opacity: value,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Manage Users Button
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 800),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (value * 0.1),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageUsersScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  icon: const Icon(Icons.people_outline, size: 20),
                  label: const Text(
                    'Manage Users',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Download Reports Button
        SizedBox(
          width: double.infinity,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.9 + (value * 0.1),
                child: ElevatedButton.icon(
                  onPressed: () => _showReportsDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    side: BorderSide(color: Colors.grey[300]!, width: 1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: Colors.black.withOpacity(0.1),
                  ),
                  icon: const Icon(Icons.download, size: 20),
                  label: const Text(
                    'Download Monthly Reports',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _showReportsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.8 + (value * 0.2),
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Row(
                  children: [
                    Icon(Icons.analytics, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Monthly Reports',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select the type of report you want to download:',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 20),
                      _buildReportOption(
                        'Operations Summary',
                        'Complete overview of all operations',
                        Icons.summarize,
                        Colors.blue,
                        () => _downloadReport('operations'),
                      ),
                      const SizedBox(height: 12),
                      _buildReportOption(
                        'Quality Control Report',
                        'Detailed QC metrics and trends',
                        Icons.verified,
                        Colors.green,
                        () => _downloadReport('quality'),
                      ),
                      const SizedBox(height: 12),
                      _buildReportOption(
                        'Production Analytics',
                        'Manufacturing performance data',
                        Icons.trending_up,
                        Colors.orange,
                        () => _downloadReport('production'),
                      ),
                      const SizedBox(height: 12),
                      _buildReportOption(
                        'User Performance',
                        'Team productivity and task completion',
                        Icons.people,
                        Colors.purple,
                        () => _downloadReport('users'),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildReportOption(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.download, color: Colors.grey[400], size: 20),
          ],
        ),
      ),
    );
  }

  void _downloadReport(String reportType) {
    Navigator.of(context).pop(); // Close dialog
    
    // Show loading animation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                SizedBox(height: 16),
                Text(
                  'Generating Report...',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate download process
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.download_done, color: Colors.white),
              const SizedBox(width: 8),
              Text('${_getReportName(reportType)} downloaded successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View',
            textColor: Colors.white,
            onPressed: () {
              // In real app, this would open the downloaded file
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening ${_getReportName(reportType)}...'),
                  backgroundColor: Colors.blue,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }

  String _getReportName(String reportType) {
    switch (reportType) {
      case 'operations':
        return 'Operations Summary Report';
      case 'quality':
        return 'Quality Control Report';
      case 'production':
        return 'Production Analytics Report';
      case 'users':
        return 'User Performance Report';
      default:
        return 'Monthly Report';
    }
  }
}