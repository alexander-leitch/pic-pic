import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class ApiConfig {
  // Production API URL (for Tailscale or public server)
  static const String _baseUrl = 'http://100.87.34.72:8000/api'; 
  
  // Development API URL (for local testing on physical devices)
  static const String _localBaseUrl = 'http://localhost:8000/api';
  
  // Simulator/Emulator API URLs
  static const String _iosSimulatorBaseUrl = 'http://127.0.0.1:8000/api';
  static const String _androidEmulatorBaseUrl = 'http://10.0.2.2:8000/api';
  
  // Get the appropriate base URL based on the current environment
  static const String _flyBaseUrl = 'https://picpic-api.fly.dev/api';

  static String get baseUrl {
    if (kIsWeb) {
      return _flyBaseUrl;
    }
    return _flyBaseUrl;
  }
  
  // Check if the app is running on a simulator/emulator
  static bool isRunningOnSimulator() {
    // Basic detection logic
    // In a real app, you might use device_info_plus package
    try {
      if (kIsWeb) return false;
      
      // Often, developers set this environment variable
      if (const String.fromEnvironment('IS_EMULATOR') == 'true') return true;
      
      // Fallback for common cases
      return true; // Assume true for now to favor localhost/10.0.2.2 during local dev
    } catch (e) {
      return false;
    }
  }
  
  // Check if Tailscale is available (you can implement this check)
  static bool isConnectedToTailscale() {
    // You can implement a check to see if Tailscale is available
    // For now, return false and let users manually configure
    return false;
  }
  
  // Manual override for Tailscale URL
  static String? _tailscaleUrl;
  
  static void setTailscaleUrl(String url) {
    _tailscaleUrl = url;
  }
  
  static String get effectiveBaseUrl {
    if (_tailscaleUrl != null && _tailscaleUrl!.isNotEmpty) {
      return _tailscaleUrl!;
    }
    return baseUrl;
  }
}
