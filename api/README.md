# PicPic API

Laravel PHP API for the PicPic Flutter application.

## Features

- **SSO Authentication**: Users can only register via Single Sign-On
- **Image Management**: Upload, view, and manage images
- **User Interactions**: Like/unlike images, add comments
- **Admin Management**: Admin users managed via command line only
- **RESTful API**: Clean API endpoints for Flutter integration

## Installation

1. Clone the repository and navigate to the `api` directory
2. Install dependencies:
   ```bash
   composer install
   ```

3. Copy environment file:
   ```bash
   cp .env.example .env
   ```

4. Generate application key:
   ```bash
   php artisan key:generate
   ```

5. Configure your `.env` file with database and SSO settings

6. Run migrations:
   ```bash
   php artisan migrate
   ```

## Environment Configuration

Update your `.env` file with:

```env
# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=picpic
DB_USERNAME=your_username
DB_PASSWORD=your_password

# SSO Configuration
SSO_PROVIDER=google
SSO_CLIENT_ID=your_google_client_id
SSO_CLIENT_SECRET=your_google_client_secret
SSO_REDIRECT_URI=http://localhost/auth/callback

# Admin Configuration
ADMIN_EMAIL=admin@picpic.com
```

## Admin Commands

### Create Admin User
```bash
php artisan admin:create admin@picpic.com "Admin User" --password=secure_password
```

### List All Users
```bash
php artisan admin:users
```

### List Only Admin Users
```bash
php artisan admin:users --admin-only
```

### List Only Inactive Users
```bash
php artisan admin:users --inactive
```

### Manage User Status
```bash
# Activate a user
php artisan admin:manage-user user@example.com --activate

# Deactivate a user
php artisan admin:manage-user user@example.com --deactivate

# Make user admin
php artisan admin:manage-user user@example.com --make-admin

# Remove admin status
php artisan admin:manage-user user@example.com --remove-admin
```

## API Endpoints

### Public Endpoints
- `GET /api/images` - Get paginated list of images
- `GET /api/images/{id}` - Get single image with details
- `GET /api/images/{imageId}/comments` - Get image comments
- `GET /api/users/{userId}/images` - Get user's images
- `GET /api/auth/redirect` - Redirect to SSO provider
- `GET /api/auth/callback` - Handle SSO callback

### Protected Endpoints (Require Authentication)
- `GET /api/user` - Get current user info
- `POST /api/logout` - Logout user
- `POST /api/images` - Upload new image
- `POST /api/images/{id}/like` - Like an image
- `DELETE /api/images/{id}/like` - Unlike an image
- `POST /api/images/{imageId}/comments` - Add comment
- `DELETE /api/comments/{id}` - Delete comment

### Admin Endpoints (Require Admin Access)
- `GET /api/admin/users` - List all users
- `DELETE /api/admin/users/{id}` - Delete user

## Authentication Flow

1. Flutter app redirects to `/api/auth/redirect`
2. User authenticates with SSO provider (Google, etc.)
3. Provider redirects to `/api/auth/callback`
4. API creates/updates user and returns JWT token
5. Flutter app uses token for authenticated requests

## Database Schema

### Users
- id, name, email, password (nullable)
- sso_provider, sso_id, avatar_url
- is_admin, is_active, timestamps

### Images
- id, user_id, title, description
- url, thumbnail_url, width, height
- like_count, comment_count, is_active, timestamps

### Likes
- id, user_id, image_id, timestamps
- Unique constraint on (user_id, image_id)

### Comments
- id, user_id, image_id, content
- is_active, timestamps

## Security Features

- SSO-only authentication (no password registration)
- Admin-only user management
- Sanctum token-based API authentication
- Request validation and sanitization
- Soft relationships with proper foreign keys

## Development

Start development server:
```bash
php artisan serve
```

Run tests:
```bash
php artisan test
```
