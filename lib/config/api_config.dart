class ApiConfig {
  // Production API URL (for Tailscale)
  static const String _baseUrl = 'http://100.87.34.72:8000/api'; // Replace with your Tailscale IP
  
  // Development API URL (for local testing)
  static const String _localBaseUrl = 'http://100.87.34.72:8000/api';
  
  // Simulator API URL (for iOS Simulator)
  static const String _simulatorBaseUrl = 'http://127.0.0.1:8000/api';
  
  // Get the appropriate base URL based on the current environment
  static String get baseUrl {
    // Check if we're running on a simulator/emulator
    if (isRunningOnSimulator()) {
      return _simulatorBaseUrl;
    }
    
    // Check if we're connected to Tailscale
    if (isConnectedToTailscale()) {
      return _baseUrl;
    }
    
    // Default to local development
    return _localBaseUrl;
  }
  
  // Check if the app is running on a simulator/emulator
  static bool isRunningOnSimulator() {
    // This is a simplified check - you may need to adjust based on your specific setup
    try {
      return const String.fromEnvironment('FLUTTER_TEST') == 'true' ||
             // Add additional checks for simulator/emulator detection
             false;
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
