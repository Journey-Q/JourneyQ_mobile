# Firebase Realtime Database Setup Guide

## Set Open Access Rules (REQUIRED)

### Quick Setup Steps:

1. **Go to Firebase Console**: https://console.firebase.google.com/
2. **Select Project**: journeyq-bfbbd
3. **Navigate to**: Build > Realtime Database > Rules
4. **Replace rules with**:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

5. **Click "Publish"** to save

## Your Current Configuration

- Project ID: `journeyq-bfbbd`
- Database URL: `https://journeyq-bfbbd-default-rtdb.firebaseio.com/`
- Status: ✅ Configured in `lib/core/config/firebase_config.dart`

## After Setting Rules

The Saved Plans feature will work immediately:
- Save travel plans to Firebase
- View all saved plans  
- Delete plans
- Real-time sync across devices

## Database Structure

```
saved_plans/
  └── {userId}/
      └── {planId}/
          ├── journeyTitle
          ├── numberOfDays
          ├── placesVisited
          ├── budgetInfo
          ├── savedAt (timestamp)
          └── ... (complete plan data)
```

## Testing

After setting rules, test by:
1. Create a trip in the app
2. Click "Save Plan" button
3. Check Firebase Console > Data tab
4. You should see: `saved_plans/{userId}/{planId}`

## Security Note

⚠️ Open access is for development only
📌 Change to secure rules before production:

```json
{
  "rules": {
    "saved_plans": {
      "$userId": {
        ".read": "$userId === auth.uid",
        ".write": "$userId === auth.uid"
      }
    }
  }
}
```

---

✅ **Status**: Ready for development
📍 **Console**: https://console.firebase.google.com/project/journeyq-bfbbd/database
