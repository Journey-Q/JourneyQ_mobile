# Gemini AI Trip Planner Setup

This app uses Google's Gemini AI to generate personalized trip itineraries. Follow these steps to set up the integration:

## 1. Get Your Gemini API Key

1. Visit [Google AI Studio](https://makersuite.google.com/app/apikey)
2. Sign in with your Google account
3. Click "Create API Key"
4. Copy your API key

## 2. Configure the API Key

1. Open `lib/core/config/gemini_config.dart`
2. Replace `YOUR_ACTUAL_GEMINI_API_KEY_HERE` with your actual API key:

```dart
static const String apiKey = 'YOUR_ACTUAL_API_KEY_HERE';
```

## 3. How It Works

### Input
- **Destinations**: Enter multiple destinations separated by commas (e.g., "Kandy, Ella, Galle")
- **Duration**: Specify number of days (1-14 days)
- **Travelers**: Number of people traveling (1-10)
- **Budget**: Select budget range
- **Trip Moods**: Choose interests (Adventure, Cultural, Beach, etc.)
- **Description**: Optional additional preferences

### AI Generation Process
1. User fills the form with trip preferences
2. App validates input and checks API key configuration
3. Constructs detailed prompt for Gemini AI with:
   - Comma-separated destinations
   - Trip duration and group size
   - Budget constraints
   - Selected moods/interests
   - Additional preferences
4. Sends request to Gemini 2.0 Flash model
5. Parses AI response into structured itinerary
6. Displays day-by-day plan with activities, accommodations, and tips

### API Call Example

The app makes a POST request to:
```
https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent
```

With headers:
```
Content-Type: application/json
X-goog-api-key: YOUR_API_KEY
```

And request body:
```json
{
  "contents": [
    {
      "parts": [
        {
          "text": "Create a detailed day-by-day travel itinerary..."
        }
      ]
    }
  ]
}
```

### Output Format
The AI generates a JSON response with:
- **Day-by-day itinerary**: Activities, places, experiences
- **Accommodation suggestions**: Hotels with pricing
- **Cost estimates**: Total trip budget breakdown
- **Practical tips**: Transportation, cultural notes, budget advice
- **Activity recommendations**: Based on selected trip moods

## 4. Features

### Smart Destination Parsing
- Enter destinations with commas: "Tokyo, Kyoto, Osaka"
- Visual preview shows parsed destinations as chips
- Real-time parsing as you type

### AI-Powered Planning
- Considers all input parameters
- Creates realistic itineraries within budget
- Matches activities to selected trip moods
- Provides practical travel tips

### Fallback Support
- Uses sample itinerary if API key not configured
- Graceful error handling with user feedback
- Offline fallback ensures app always works

## 5. Troubleshooting

### API Key Issues
- Make sure API key is correctly pasted in `gemini_config.dart`
- Check that you have API quota available
- Verify the API key has proper permissions

### Network Issues
- Ensure device has internet connection
- Check if your network allows HTTPS requests to Google APIs

### Response Parsing
- The app expects JSON response from Gemini
- If parsing fails, it falls back to sample data
- Check console logs for detailed error messages

## 6. Customization

You can customize the AI prompts in `gemini_ai_service.dart`:
- Modify the `_buildTripPrompt` method
- Adjust the JSON structure requirements
- Add more specific instructions for your use case

## 7. Cost Considerations

- Gemini API has usage limits and pricing
- Each trip generation uses 1 API call
- Monitor your usage in Google AI Studio
- Consider implementing caching for repeated requests

## Example Usage

1. Enter destinations: "Kandy, Ella, Sigiriya"
2. Set 5 days, 2 travelers
3. Choose "Mid-range" budget
4. Select moods: "Cultural", "Adventure", "Nature"
5. Add description: "Love scenic train rides and tea plantations"
6. Tap "Generate AI Journey"
7. AI creates custom 5-day Sri Lanka itinerary

The system will generate a detailed plan with temple visits in Kandy, hiking in Ella, climbing Sigiriya, train journeys, and tea plantation tours - all matching your preferences and budget.