import 'package:flutter/material.dart';

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