# Delete Post - Debugging & Testing Guide

## Issue
Delete post endpoint not working correctly. Expected endpoint: `http://localhost:8081/posts/4`

## Current Configuration

### API Service Base URL
**File**: `lib/core/services/api_service.dart` (Line 18)

**Current**:
```dart
baseUrl: 'https://socialmediaservice-production-2b10.up.railway.app'
```

**For Local Testing**: Change to:
```dart
baseUrl: 'http://localhost:8081'
// OR for Android emulator:
baseUrl: 'http://10.0.2.2:8081'
```

## Step-by-Step Debugging

### 1. Change Base URL for Local Testing

Edit `lib/core/services/api_service.dart`:

```dart
static Future<void> initialize(AuthProvider authProvider) async {
  _authProvider = authProvider;

  _dio = Dio(
    BaseOptions(
      // For local testing - CHOOSE ONE:
      baseUrl: 'http://localhost:8081',        // For iOS simulator or web
      // baseUrl: 'http://10.0.2.2:8081',      // For Android emulator
      // baseUrl: 'http://YOUR_IP:8081',       // For physical device (replace YOUR_IP)

      // For production:
      // baseUrl: 'https://socialmediaservice-production-2b10.up.railway.app',

      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  // ... rest of code
}
```

### 2. Verify Your Spring Boot Controller Response

Your controller should return:
```java
@DeleteMapping("/{postId}")
public ResponseEntity<?> deletePost(@PathVariable Long postId) {
    // ... authentication and deletion logic

    Map<String, Object> responseData = new HashMap<>();
    if (deleted) {
        responseData.put("success", true);
        responseData.put("message", "Post deleted successfully");
        return ResponseEntity.ok(responseData);
    } else {
        responseData.put("success", false);
        responseData.put("message", "Failed to delete post");
        return ResponseEntity.badRequest().body(responseData);
    }
}
```

### 3. Test the Backend First

Use curl or Postman to verify backend works:

```bash
# Get your JWT token first (from login)
TOKEN="your_jwt_token_here"

# Test delete endpoint
curl -X DELETE http://localhost:8081/posts/4 \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json"
```

Expected response:
```json
{
  "success": true,
  "message": "Post deleted successfully"
}
```

### 4. Check Console Logs

When you try to delete a post, check the console for these logs:

#### Success Path:
```
🗑️ Starting post deletion for ID: 4
   Endpoint: /posts/4

🗑️ DELETE Request:
   URL: http://localhost:8081/posts/4
   Headers: {Authorization: Bearer eyJ..., Content-Type: application/json, Accept: application/json}

✅ DELETE Response:
   Status Code: 200
   Response Data: {success: true, message: Post deleted successfully}

📦 Delete Post API Response:
   Status Code: 200
   Response Data Type: _InternalLinkedHashMap<String, dynamic>
   Response Data: {success: true, message: Post deleted successfully}

✅ Post deleted: Post deleted successfully
```

#### Error Path (look for these):
```
❌ DELETE Error:
   Status Code: 401    ← Authentication failed (bad token)
   Status Code: 403    ← Forbidden (not your post)
   Status Code: 404    ← Post not found
   Status Code: 500    ← Server error
```

### 5. Common Issues & Solutions

#### Issue 1: Network Error / Connection Refused
**Symptoms**:
- `DioException: Connection refused`
- `Error Type: DioExceptionType.connectionError`

**Solutions**:
- ✅ Verify Spring Boot is running on `localhost:8081`
- ✅ Check firewall settings
- ✅ For Android emulator, use `http://10.0.2.2:8081`
- ✅ For physical device, use your computer's IP address

#### Issue 2: 401 Unauthorized
**Symptoms**:
- Status Code: 401
- Response: `Unauthorized` or `Invalid token`

**Solutions**:
- ✅ Check if user is logged in (`authProvider.isAuthenticated`)
- ✅ Verify JWT token is valid and not expired
- ✅ Check if token is being sent in Authorization header

#### Issue 3: 403 Forbidden
**Symptoms**:
- Status Code: 403
- Response: `You don't have permission to delete this post`

**Solutions**:
- ✅ Verify the post belongs to the logged-in user
- ✅ Check backend validates `userId` matches post owner
- ✅ Ensure SecurityContext has correct user information

#### Issue 4: Wrong Post ID
**Symptoms**:
- Status Code: 404
- Response: `Post not found`

**Solutions**:
- ✅ Check post ID is correct (check console logs)
- ✅ Verify post exists in database
- ✅ Ensure post ID is Long type in backend (not String)

#### Issue 5: Response Format Mismatch
**Symptoms**:
- Delete seems to work but shows "Failed to delete"
- Status 200 but `success: false` in UI

**Solutions**:
- ✅ Check backend returns `{"success": true, "message": "..."}`
- ✅ Verify response format matches Spring Boot controller
- ✅ Check console logs for actual response data

### 6. Testing Checklist

Run through these steps:

1. **Backend Ready**
   - [ ] Spring Boot running on `http://localhost:8081`
   - [ ] Can access `http://localhost:8081/posts` endpoints
   - [ ] JWT authentication working

2. **App Configuration**
   - [ ] Changed baseUrl to `http://localhost:8081` (or appropriate URL)
   - [ ] Restarted the app (hot restart)
   - [ ] User is logged in with valid token

3. **Test Delete**
   - [ ] Go to profile page
   - [ ] See delete button on posts
   - [ ] Click delete button
   - [ ] See confirmation dialog
   - [ ] Click "Delete"
   - [ ] Check console logs for request/response
   - [ ] Verify post disappears
   - [ ] Check database to confirm deletion

### 7. Quick Test Script

Add this to test delete directly:

```dart
// Temporary test function - add to profile page
Future<void> _testDeletePost() async {
  try {
    print('=== TESTING DELETE POST ===');
    final testPostId = '4'; // Your test post ID

    final success = await PostRepository.deletePost(testPostId);

    print('=== DELETE TEST RESULT ===');
    print('Success: $success');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete test: ${success ? "SUCCESS" : "FAILED"}')),
    );
  } catch (e) {
    print('=== DELETE TEST ERROR ===');
    print('Error: $e');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Delete test error: $e')),
    );
  }
}
```

Call this function from a test button to verify the endpoint works.

### 8. Production vs Development

For easier switching between environments:

```dart
// Add at top of api_service.dart
static const bool isDevelopment = true; // Change to false for production

static Future<void> initialize(AuthProvider authProvider) async {
  _authProvider = authProvider;

  final baseUrl = isDevelopment
      ? 'http://localhost:8081'  // Development
      : 'https://socialmediaservice-production-2b10.up.railway.app'; // Production

  _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
  // ... rest
}
```

### 9. Expected Flow

```
User clicks delete
    ↓
Confirmation dialog shows
    ↓
User confirms
    ↓
Loading dialog shows
    ↓
DELETE /posts/4
    ↓
Backend checks:
  - JWT token valid? ✓
  - User authenticated? ✓
  - Post exists? ✓
  - User owns post? ✓
    ↓
Backend deletes post from DB
    ↓
Backend returns: {"success": true, "message": "Post deleted successfully"}
    ↓
App receives 200 response
    ↓
App removes post from local list
    ↓
App refreshes stats
    ↓
Loading dialog closes
    ↓
Success snackbar shows
    ↓
Done ✓
```

### 10. If Still Not Working

1. **Share Console Logs**: Copy all logs from when you click delete
2. **Check Backend Logs**: Look at Spring Boot console for errors
3. **Use Network Inspector**: Use Flutter DevTools to see actual HTTP requests
4. **Test with Postman**: Verify endpoint works outside of app
5. **Check Database**: Verify post ID exists and belongs to user

## Final Notes

- The print statements I added will help you see exactly what's happening
- Make sure to restart the app after changing baseUrl
- For production, remove or comment out the print statements
- Always test with a post that belongs to the logged-in user

---

**Need Help?**
Share these details:
1. Console logs when clicking delete
2. Spring Boot backend logs
3. Postman/curl test results
4. Which baseUrl you're using
