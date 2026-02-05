# Tailscale Setup for PicPic Development

This guide explains how to configure Tailscale so your Flutter simulator can connect to the Docker Compose API.

## 🐳 Docker Configuration

The Docker Compose files have been updated to bind to all interfaces (`0.0.0.0`) for Tailscale compatibility:

### Updated Ports:
- **API**: `0.0.0.0:8000:8000` (accessible via Tailscale)
- **MySQL**: `3306:3306`
- **Redis**: `6379:6379`
- **PHPMyAdmin**: `8080:80`

## 🌐 Tailscale Configuration

### 1. Install Tailscale
```bash
# macOS
brew install tailscale

# Linux
curl -fsSL https://tailscale.com/install.sh | sh

# Windows
# Download from https://tailscale.com/download/
```

### 2. Start Tailscale
```bash
sudo tailscale up
```

### 3. Get Your Tailscale IP
```bash
tailscale ip -4
```
This will show your Tailscale IP (e.g., `100.x.x.x`)

## 📱 Flutter Configuration

### 1. Update API Configuration
Edit `lib/config/api_config.dart` and update the Tailscale IP:

```dart
static const String _baseUrl = 'http://100.x.x.x:8000/api'; // Replace with your Tailscale IP
```

### 2. Manual Override (Optional)
You can also set the Tailscale URL programmatically:

```dart
import 'package:picpic/config/api_config.dart';

// Set your Tailscale IP
ApiConfig.setTailscaleUrl('http://100.x.x.x:8000/api');
```

## 🚀 Quick Start

### 1. Start Docker Services
```bash
make up
```

### 2. Populate Database
```bash
make artisan COMMAND="db:populate --fresh"
```

### 3. Configure Tailscale URL in Flutter
```dart
// In your main.dart or before API calls
ApiConfig.setTailscaleUrl('http://YOUR_TAILSCALE_IP:8000/api');
```

### 4. Run Flutter App
```bash
flutter pub get
flutter run
```

## 🔧 Troubleshooting

### Connection Issues
1. **Check Tailscale Status**:
   ```bash
   tailscale status
   ```

2. **Verify Docker Port Binding**:
   ```bash
   docker ps | grep picpic_api
   ```

3. **Test API Connection**:
   ```bash
   curl http://YOUR_TAILSCALE_IP:8000/api/images
   ```

### iOS Simulator
- iOS Simulator uses a special network namespace
- Use `127.0.0.1` instead of `localhost`
- The app automatically detects simulator environment

### Android Emulator
- Android Emulator uses `10.0.2.2` for host machine
- Update API config if needed for Android testing

## 🌍 Network Architecture

```
Flutter Simulator
       ↓
   Tailscale Network
       ↓
Docker Host (0.0.0.0:8000)
       ↓
Laravel API Container
```

## 📋 Environment Variables

The Docker containers use these environment variables:
- `APP_URL=http://0.0.0.0:8000`
- `DB_HOST=mysql`
- `REDIS_HOST=redis`

## 🔒 Security Notes

- Tailscale provides encrypted peer-to-peer connections
- Only devices on your Tailnet can access the API
- Consider using Tailscale ACLs for additional security

## 📱 Testing the Connection

1. **Start the app** with Tailscale configured
2. **Check network requests** in Flutter dev tools
3. **Verify API responses** in the console
4. **Test image loading** and interactions

## 🆘 Getting Help

If you encounter issues:

1. **Check Docker logs**: `make logs`
2. **Verify Tailscale**: `tailscale status`
3. **Test API directly**: `curl http://YOUR_IP:8000/api/images`
4. **Check Flutter logs**: Use `flutter logs` command

The setup should now allow your Flutter simulator to connect to the Docker API through Tailscale's secure network!
