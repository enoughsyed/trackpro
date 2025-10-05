// File: lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'simple_admin_dashboard.dart';
import 'supervisor_dashboard.dart';
import 'user_dashboard.dart';
import 'no_task_screen.dart';
import 'incoming_inspection_screen.dart';
import 'finishing_screen.dart';
import 'quality_control_screen.dart';
import 'delivery_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _navigateBasedOnTask(Map<String, dynamic> user) {
    final assignedTask = user['assignedTask'];
    Widget targetScreen;
    
    if (assignedTask == null) {
      targetScreen = NoTaskScreen();
    } else {
      switch (assignedTask) {
        case 'Incoming Inspection':
          targetScreen = IncomingInspectionScreen();
          break;
        case 'Finishing':
          targetScreen = FinishingScreen();
          break;
        case 'Quality Control':
          targetScreen = QualityControlScreen();
          break;
        case 'Delivery':
          targetScreen = DeliveryScreen();
          break;
        default:
          targetScreen = NoTaskScreen();
      }
    }
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => targetScreen),
    );
  }

  void _login() async {
    final result = await ApiService.login(
      _usernameController.text,
      _passwordController.text,
    );
    
    if (result['success']) {
      final user = result['user'];
      Widget dashboard;
      switch (user['role']) {
        case 'Admin':
          dashboard = SimpleAdminDashboard(adminName: user['name']);
          break;
        case 'Supervisor':
          dashboard = SupervisorDashboard(supervisorName: user['name']);
          break;
        case 'User':
          _navigateBasedOnTask(user);
          return;
          break;
        default:
          dashboard = SimpleAdminDashboard(adminName: user['name']);
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => dashboard),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Welcome Back',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 50),
              
              // Username Field
              Text(
                'Username',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Password Field
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // Login Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
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