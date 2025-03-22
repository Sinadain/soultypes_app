# SoulTypes Master Specification and Development Guide

## Project Overview

**Project Goal**: Create a Minimum Viable Product (MVP) for "SoulTypes," a personality aggregator app designed to help users discover their personality traits and connect with compatible people based on shared values, goals, and personality traits.

**Differentiators**:
- Deep personality integration with original Soul Languages and Big Five (OCEAN)
- Values and goals-based matching
- Guided exploration journeys for meaningful connection development
- Focus on compatibility through shared personal attributes

## Technology Stack

- **Frontend Framework**: Flutter (latest stable version)
- **Backend**: Firebase (Firestore, Authentication, Storage, Functions, Hosting, Emulators)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Development Environment**: VS Code with Flutter/Dart extensions

## Core App Architecture

### Project Structure
```
soultypes_app/
├── lib/
│   ├── core/             # Utilities, constants, theme, shared widgets
│   │   ├── config/       # Firebase options, theme configurations
│   │   ├── constants/    # App constants, question data
│   │   ├── errors/       # Error handling
│   │   └── utils/        # Helper functions, validators
│   ├── data/             # Data layer
│   │   ├── datasources/  # Firebase interfaces
│   │   ├── repositories/ # Repository implementations
│   │   └── models/       # Data models
│   ├── domain/           # Business logic layer
│   │   ├── entities/     # Core business entities
│   │   ├── repositories/ # Repository interfaces
│   │   └── usecases/     # Business logic use cases
│   ├── presentation/     # UI layer
│   │   ├── providers/    # State management
│   │   ├── screens/      # App screens
│   │   └── widgets/      # Reusable UI components
│   └── main.dart         # App entry point
├── test/                 # Test files
└── firebase/             # Firebase configurations
```

### Authentication Flow
- Welcome screen with sign-in/sign-up options
- Email/password and Google sign-in
- User onboarding with profile completion checks
- Progressive disclosure of features based on profile completion

### Profile System
- Comprehensive user profile including personality assessments
- Progressive onboarding with Soul Languages and Big Five tests
- Values selection and ranking
- Goals setting with categories and custom options
- Birth details for future astrological features

### Main Features
1. **Dashboard**: Overview of connections, community content, and personality insights
2. **Connections**: View, manage, and explore connections with other users
3. **Compatibility**: Detailed compatibility analysis between users
4. **Exploration Journeys**: Guided activities to deepen connections
5. **Messaging**: Real-time private messaging between users
6. **Community**: Discussions organized by personality frameworks

### Navigation Structure
- Bottom navigation bar for primary screens (Dashboard, Search, Connections, Profile, Menu)
- Hierarchical navigation for detailed screens
- Deep linking support for direct access to specific features

## Data Models

### User Model
```dart
class UserModel {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final String? location;
  
  // Profile
  final String? profilePicUrl;
  final String? tagline;
  final String? bio;
  final String? gender;
  final String? pronouns;
  final String? birthDate;  // Format: YYYY-MM-DD
  final String? birthTime;  // Format: HH:mm (24-hour)
  final String? birthLocation;
  final String? relationshipGoals;
  final String? exerciseHabits;
  final String? diet;
  final String? kids;
  final String? pets;
  final String? smokingHabits;
  final String? drinkingHabits;
  final String? educationLevel;
  final String? ethnicity;
  final String? religion;
  final String? politics;
  
  // Personality
  final Map<String, int>? bigFiveScores;  // e.g., {'Openness': 85, 'Conscientiousness': 60, ...}
  final Map<String, int>? soulLanguages;  // e.g., {'affirming_words': 70, 'supportive_actions': 30, ...}
  final Map<String, int>? valuesScores;   // e.g., {'altruism': 90, 'growth': 80, ...}
  final List<Map<String, dynamic>>? goals;  // List of goals, each with categoryId, text, isCustom
  
  // App-specific
  final String? soulTypeName;
  final bool profileComplete;
  final bool soultypeDiscovered;
  final bool locationSharing;
  final String profileVisibility;  // public, connections, private
  final DateTime createdAt;
  final DateTime lastActive;
  
  // Constructor and other methods...
}
```

### Connection Model
```dart
class ConnectionModel {
  final String connectionId;
  final List<String> users;  // [userId1, userId2] (always sorted)
  final String status;  // pending, accepted, rejected, blocked
  final double? compatibilityScore;
  final String requesterId;
  
  // Constructor and other methods...
}
```

### Message Model
```dart
class MessageModel {
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime timestamp;
  final bool isRead;
  
  // Constructor and other methods...
}
```

### Exploration Models
```dart
class ExplorationTypeModel {
  final String typeId;
  final String title;
  final String description;
  final String relationshipStage;  // e.g., "spark", "kindred", "flame", "ember", "beacon"
  final String intensity; // low, medium, high
  final int estimatedTime;
  final List<String> tags;
  final String? coverImage;
  
  // Constructor and other methods...
}

class ExplorationStageModel {
  final String stageId;
  final int stageNumber;
  final String title;
  final String description;
  final String stageType;  // reflection, activity, conversation, creation, photoChallenge, quiz, thisOrThat, storyPrompt
  final String prompt;
  final List<String>? examples;
  final bool isShared;
  final String? mediaType; // text, image, audio, drawing, video
  final int? durationMinutes;
  
  // Additional fields based on stage type...
  
  // Constructor and other methods...
}
```

## Firebase Architecture

### Collections and Documents

1. `users/{userId}`
   - Contains all user information described in UserModel

2. `connections/{connectionId}`
   - Represents relationships between users
   - Status tracking, compatibility scores

3. `conversations/{conversationId}`
   - Metadata about conversations between two users
   - Sub-collection: `messages/{messageId}`

4. `explorations/{explorationId}`
   - Instances of exploration journeys
   - Participants, status, progress

5. `explorationTypes/{typeId}`
   - Templates for exploration journeys
   - Sub-collection: `stages/{stageId}`

### Security Rules Pattern

```
service cloud.firestore {
  match /databases/{database}/documents {
    // Base rules
    match /{document=**} {
      allow read, write: if false; // Default deny
    }
    
    // User rules
    match /users/{userId} {
      allow read: if isSignedIn() && (isOwner(userId) || resource.data.profileVisibility == 'public');
      allow write: if isSignedIn() && isOwner(userId);
    }
    
    // Connection rules
    match /connections/{connectionId} {
      allow read: if isSignedIn() && isConnectionParticipant(connectionId);
      allow create: if isSignedIn();
      allow update, delete: if isSignedIn() && isConnectionParticipant(connectionId);
    }
    
    // Conversation rules
    match /conversations/{conversationId} {
      allow read, write: if isSignedIn() && isConversationParticipant(conversationId);
      
      match /messages/{messageId} {
        allow read, write: if isSignedIn() && isConversationParticipant(conversationId);
      }
    }
    
    // Helper functions
    function isSignedIn() {
      return request.auth != null;
    }
    
    function isOwner(userId) {
      return request.auth.uid == userId;
    }
    
    function isConnectionParticipant(connectionId) {
      let connection = get(/databases/$(database)/documents/connections/$(connectionId)).data;
      return request.auth.uid in connection.users;
    }
    
    function isConversationParticipant(conversationId) {
      let conversation = get(/databases/$(database)/documents/conversations/$(conversationId)).data;
      return request.auth.uid == conversation.user1Id || request.auth.uid == conversation.user2Id;
    }
  }
}
```

## Personality Tests Implementation

### 1. Soul Languages Assessment (Legally Compliant)

**Legal Compliance:**
- Original "Soul Languages" assessment (replacing "Love Languages")
- Include clear disclaimer: "The Soul Languages assessment is an original concept developed by SoulTypes to help understand communication preferences in relationships. It is not affiliated with or derived from any trademarked personality framework."

**Implementation:**
- 30 original questions measuring preferences across five communication styles
- Question format: "I feel most appreciated when..." with 5-point agreement scale
- Five Soul Languages categories:
  1. **Affirming Words** - Verbal expression of appreciation and affection
  2. **Supportive Actions** - Practical help and assistance
  3. **Meaningful Tokens** - Thoughtful gifts and symbols
  4. **Quality Presence** - Focused, undivided attention
  5. **Physical Connection** - Appropriate physical expressions of care

**Scoring Algorithm:**
```dart
Map<String, int> calculateSoulLanguages(List<int> responses) {
  // Each index corresponds to a specific Soul Language
  Map<String, int> scores = {
    'affirming_words': 0,
    'supportive_actions': 0, 
    'meaningful_tokens': 0,
    'quality_presence': 0,
    'physical_connection': 0
  };
  
  // Map questions to Soul Languages categories
  for (int i = 0; i < responses.length; i++) {
    String category = questionCategoryMap[i];
    scores[category] += responses[i];
  }
  
  // Convert raw scores to percentages
  int totalPoints = scores.values.reduce((a, b) => a + b);
  Map<String, int> percentages = {};
  scores.forEach((key, value) {
    percentages[key] = ((value / totalPoints) * 100).round();
  });
  
  return percentages;
}
```

**Results Display:**
- Primary and secondary Soul Languages with percentages
- Original descriptions of each style and what it means for relationships
- Custom suggestions for communication based on results

### 2. Big Five (OCEAN) Personality Assessment

**Legal Compliance:**
- Use the BFI-2 (Big Five Inventory-2), which is in the public domain
- Include proper attribution: "Based on the Big Five Inventory-2 (BFI-2) by Soto & John (2017)"
- Add disclaimer: "This assessment is for informational and self-discovery purposes only and should not be considered a clinical evaluation"

**Implementation:**
- 60 questions (12 per trait)
- 5-point Likert scale (strongly disagree to strongly agree)
- Scoring system that accounts for reverse-scored items

```dart
Map<String, double> calculateBigFiveScores(List<int> responses) {
  // Create score counters for each trait
  Map<String, double> scores = {
    'openness': 0,
    'conscientiousness': 0,
    'extraversion': 0,
    'agreeableness': 0,
    'neuroticism': 0
  };
  
  // Map questions to traits and account for reverse scoring
  for (int i = 0; i < responses.length; i++) {
    String trait = questionTraitMap[i];
    bool isReversed = reversedQuestions.contains(i);
    
    // Handle reverse scoring (5 becomes 1, 4 becomes 2, etc.)
    int score = isReversed ? 6 - responses[i] : responses[i];
    scores[trait] += score;
  }
  
  // Convert to percentages (assuming max score of 60 per trait - 12 questions × 5 points)
  Map<String, double> percentages = {};
  scores.forEach((trait, score) {
    percentages[trait] = (score / 60) * 100;
  });
  
  return percentages;
}
```

**Results Display:**
- Percentage scores for each of the five dimensions
- Radar chart visualization of the five dimensions
- Descriptions of each trait and what high/low scores indicate
- Insights about personality based on combination of traits

### 3. Values Assessment

**Legal Compliance:**
- General concepts of values are not copyrightable
- Use general terms for values that are in common usage
- Include disclaimer: "The Values assessment helps identify your core personal values and is not based on any specific trademarked or copyrighted framework"

**Implementation:**
- Present users with a list of 20 personal values with original descriptions
- Allow selection and ranking of top 5 values

```dart
class ValuesData {
  final List<String> selectedValues; // Ordered by importance
  final DateTime selectionDate;
  
  // Constructor and methods
}
```

**Values List:**
```dart
final List<Map<String, dynamic>> personalValues = [
  {'id': 'authenticity', 'name': 'Authenticity', 'description': 'Being true to yourself and others'},
  {'id': 'compassion', 'name': 'Compassion', 'description': 'Caring for the well-being of others'},
  {'id': 'creativity', 'name': 'Creativity', 'description': 'Expressing original ideas and imagination'},
  // ... 17 more values with id, name, and description
];
```

### 4. Goals Assessment

**Legal Compliance:**
- General concept of goal-setting is not copyrightable
- Custom categories and implementation with original descriptions
- Include disclaimer: "The Goals framework is an original tool developed by SoulTypes to help identify and align important life objectives"

**Implementation:**
- Categories: Personal, Career, Relationships, Health, Financial, Spiritual, Creative, Community
- Each category has predefined goals plus custom option

```dart
class Goal {
  final String id;
  final String categoryId;
  final String text;
  final bool isCustom;
  final DateTime createdAt;
  
  // Constructor and methods
}
```

## Compatibility Algorithm

The compatibility algorithm calculates a score between two users based on multiple factors:

```dart
double calculateCompatibility(UserModel user1, UserModel user2) {
  // Default weights for each component
  const double soulLanguageWeight = 0.25;
  const double bigFiveWeight = 0.25;
  const double valuesWeight = 0.30;
  const double goalsWeight = 0.20;
  
  // Calculate individual component scores
  double soulLanguageScore = calculateSoulLanguageCompatibility(user1.soulLanguages, user2.soulLanguages);
  double bigFiveScore = calculateBigFiveCompatibility(user1.bigFiveScores, user2.bigFiveScores);
  double valuesScore = calculateValuesCompatibility(user1.values, user2.values);
  double goalsScore = calculateGoalsCompatibility(user1.goals, user2.goals);
  
  // Weighted average for final score (0-100%)
  double finalScore = (soulLanguageScore * soulLanguageWeight) +
                     (bigFiveScore * bigFiveWeight) +
                     (valuesScore * valuesWeight) +
                     (goalsScore * goalsWeight);
                     
  return finalScore;
}
```

### Component Calculation Details

1. **Soul Languages Compatibility**:
   ```dart
   double calculateSoulLanguageCompatibility(Map<String, int> language1, Map<String, int> language2) {
     // Higher compatibility when primary languages match
     // Also consider complementary giving/receiving patterns
     
     // Get primary languages
     String primary1 = language1.entries.reduce((a, b) => a.value > b.value ? a : b).key;
     String primary2 = language2.entries.reduce((a, b) => a.value > b.value ? a : b).key;
     
     // Calculate direct match score
     double directMatchScore = primary1 == primary2 ? 100.0 : 60.0;
     
     // Calculate complementary score (e.g., if one gives what the other values)
     double complementaryScore = calculateComplementaryScore(language1, language2);
     
     // Return weighted combination
     return (directMatchScore * 0.4) + (complementaryScore * 0.6);
   }
   ```

2. **Big Five Compatibility**:
   ```dart
   double calculateBigFiveCompatibility(Map<String, double> traits1, Map<String, double> traits2) {
     // Research-based compatibility factors:
     // - Similar conscientiousness is good for relationship satisfaction
     // - Moderate differences in extraversion can be complementary
     // - Similar emotional stability (low neuroticism) is beneficial
     // - Similar openness helps with shared activities and values
     // - Similar agreeableness helps with conflict resolution
     
     double conscientiousnessScore = 100 - (traits1['conscientiousness'] - traits2['conscientiousness']).abs();
     double extraversionScore = calculateExtraversionCompatibility(traits1['extraversion'], traits2['extraversion']);
     double neuroticismScore = calculateNeuroticismCompatibility(traits1['neuroticism'], traits2['neuroticism']);
     double opennessScore = 100 - (traits1['openness'] - traits2['openness']).abs();
     double agreeablenessScore = 100 - (traits1['agreeableness'] - traits2['agreeableness']).abs();
     
     return weightedAverage([conscientiousnessScore, extraversionScore, neuroticismScore, opennessScore, agreeablenessScore], 
                           [0.3, 0.15, 0.25, 0.15, 0.15]);
   }
   ```

3. **Values Compatibility**:
   ```dart
   double calculateValuesCompatibility(List<String> values1, List<String> values2) {
     // Count shared values, with higher ranking values worth more
     double score = 0;
     double maxPossibleScore = 15; // Sum of 5+4+3+2+1
     
     // For each value in user1's top 5
     for (int i = 0; i < values1.length; i++) {
       // Check if it appears in user2's top 5
       int matchIndex = values2.indexOf(values1[i]);
       if (matchIndex >= 0) {
         // Award points based on ranking (higher ranks = more points)
         score += (5 - i) * (5 - matchIndex) / 5;
       }
     }
     
     return (score / maxPossibleScore) * 100;
   }
   ```

4. **Goals Compatibility**:
   ```dart
   double calculateGoalsCompatibility(List<Goal> goals1, List<Goal> goals2) {
     // Group goals by category
     Map<String, List<Goal>> categories1 = groupByCategoryId(goals1);
     Map<String, List<Goal>> categories2 = groupByCategoryId(goals2);
     
     // Calculate alignment across categories
     double categoryAlignmentScore = calculateCategoryAlignment(categories1.keys.toList(), categories2.keys.toList());
     
     // Calculate text similarity within matching categories
     double textSimilarityScore = calculateGoalTextSimilarity(categories1, categories2);
     
     // Return weighted combination
     return (categoryAlignmentScore * 0.6) + (textSimilarityScore * 0.4);
   }
   ```

## SoulType Determination

After users complete personality assessments, the app processes the results to generate insights:

```dart
String determineSoulType(UserModel user) {
  // Create a SoulType name based on personality traits
  
  // Analyze primary personality patterns
  String bigFivePattern = determineBigFivePattern(user.bigFiveScores);
  String soulLanguagePattern = determineSoulLanguagePattern(user.soulLanguages);
  
  // Find core values pattern
  String valueTheme = determineValueTheme(user.values);
  
  // Determine nature or concept-based name component
  String nameComponent = user.bigFiveScores['openness'] > 70 
      ? selectNatureElement(user) 
      : selectConceptElement(user);
  
  // Combine components into a unique SoulType
  return "$nameComponent $valueTheme";
}
```

## Exploration System

The Exploration system is designed to help users deepen connections through structured activities:

### Journey Types
- **Spark**: For new connections, lighthearted, get-to-know-you activities
- **Kindred**: Deeper exploration of values, beliefs, and perspectives
- **Flame**: For romantic connections, focuses on intimacy and relationship building
- **Ember**: Relationship maintenance and growth for established connections
- **Beacon**: Personal growth journey that can be done alone or with connections

### Stage Types
1. **Reflection**: Guided prompts for personal reflection
2. **Activity**: Real-world actions with digital check-in
3. **Conversation**: Guided discussion topics
4. **Creation**: Creative challenges with media sharing
5. **PhotoChallenge**: Specific photo-taking prompts
6. **Quiz**: Multiple-choice questions with no "correct" answers
7. **ThisOrThat**: Binary choice questions revealing preferences
8. **StoryPrompt**: Collaborative story building

### Exploration Integration with Dashboard

```dart
Widget buildExplorationSection(BuildContext context, UserModel user) {
  return Consumer(
    builder: (context, ref, child) {
      final activeExplorationsProvider = ref.watch(userActiveExplorationsProvider(user.id));
      
      return activeExplorationsProvider.when(
        loading: () => const ExplorationLoadingCard(),
        error: (error, stackTrace) => ExplorationErrorCard(message: error.toString()),
        data: (explorations) {
          if (explorations.isEmpty) {
            return const NoActiveExplorationsCard();
          }
          
          // Show the most recent active exploration
          final latestExploration = explorations.first;
          
          return ExplorationCard(
            exploration: latestExploration,
            onTap: () => context.push('/exploration/stage/${latestExploration.currentStage}'),
          );
        }
      );
    }
  );
}
```

### Notification System

```dart
enum NotificationType {
  newMessage,
  connectionRequest,
  connectionAccepted,
  explorationRequest,
  explorationStageCompleted,
  explorationCompleted,
  communityActivity
}

class NotificationModel {
  final String id;
  final String userId;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final String navigateTo;
  final DateTime createdAt;
  final bool isRead;
  
  // Constructor and methods
}

class NotificationService {
  // Methods for creating and managing notifications
  Future<void> createNotification({
    required String userId,
    required NotificationType type,
    required String title,
    required String body,
    required Map<String, dynamic> data,
    required String navigateTo
  }) async {
    // Create in-app notification
    await firestore.collection('users').doc(userId).collection('notifications').add({
      'userId': userId,
      'type': type.toString(),
      'title': title,
      'body': body,
      'data': data,
      'navigateTo': navigateTo,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false
    });
    
    // Trigger push notification if user has push enabled
    final userDoc = await firestore.collection('users').doc(userId).get();
    final pushEnabled = userDoc.data()?['pushNotificationsEnabled'] ?? false;
    
    if (pushEnabled) {
      // Send push notification using Firebase Cloud Messaging
      sendPushNotification(userId, title, body, data);
    }
  }
}
```

## Key Screens Implementation

### Authentication Screens

1. **WelcomeScreen**
   - App logo and tagline
   - Sign-in and Sign-up buttons
   - Brief app description

2. **SignInScreen**
   - Email and password fields
   - Google sign-in button
   - Forgot password link
   - Link to sign up

3. **SignUpScreen**
   - Email, password, confirm password fields
   - Password strength indicator
   - Google sign-up button
   - Terms and privacy policy links

### Profile and Discover Screens

4. **DiscoverSoultypeScreen**
   - Introduction to Discover SoulType process
   - Cards for each assessment with descriptions (SoulLanguagesTestScreen,BigFiveTestScreen,BirthDetailsScreen,ValuesScreen,GoalsScreen)
   - Progress tracking (Cards turn green once completed)

5. **SoulLanguagesTestScreen**
   - 30 questions with multiple-choice format
   - Progress indicator
   - Clear instructions with attribution

6. **BigFiveTestScreen**
   - 60 questions with Likert scale (1-5)
   - Progress indicator
   - Scientific description

7. **BirthDetailsScreen**
   - User demographic information
   - Birth date, time, and location inputs
   - Privacy assurances

8. **ValuesScreen**
   - Selectable list of core values (~20)
   - Ability to rank top 5 values
   - Description of importance

9. **GoalsScreen**
   - Category selection dropdown
   - Goal selection or custom input
   - Add/remove functionality

### Main App Screens

10. **MainScreen**
    - Container with BottomNavigationBar
    - IndexedStack for state preservation
    - Navigation between primary screens

11. **DashboardScreen**
    - Recent connections section
    - Community highlights section
    - Active exploration journeys
    - Featured discussions
    - Quick actions menu

12. **SearchScreen**
    - Search bar with debouncing
    - Toggle between people and discussions
    - Results list with preview information
    - Filters for personality traits and values
    - Recent searches history

13. **ConnectionsScreen**
    - Tabs for pending and established connections
    - Connection cards with compatibility scores
    - Action buttons (accept, reject, view)
    - Connection suggestions based on compatibility
    - Connection activity feed

14. **CompatibilityScreen**
    - Overall compatibility score visualization
    - Breakdown by personality dimensions
    - Shared values and aligned goals sections
    - Communication tips based on soul languages
    - Relationship potential insights
    - Compatibility improvement suggestions

15.1 **MyProfileScreen**
    - Username
    - Edit profile button
    - Profile photo
    - User's SoulType name
    - Relationship goals
    - Location
    - Age
    - About SoulType description
    - About Username description
    - Discover SoulType button
    - Soul Languages Test Results
    - Big Five Test Results
    - Birth Details/Astrological Insights visualization
    - Values visualization
    - Goals visualization
    - Edited profile info not already displayed
    - Profile visibility settings
    - Activity status

15.2 **ProfileScreen** (Viewing Other Users)
    - Username and profile photo
    - SoulType name and description
    - Basic info (age, location, relationship goals)
    - Compatibility score with current user
    - Soul Languages Test Results (if shared)
    - Big Five Test Results (if shared)
    - Values visualization (if shared)
    - Goals visualization (if shared)
    - Connection status and actions
    - Share profile option
    - Report user option
    - Block user option
    - View shared connections
    - View shared discussions
    - Send message button
    - Start exploration journey button
    - View compatibility details button

16. **ConversationsScreen**
    - List of conversations with recent message preview
    - Unread indicators
    - Last activity timestamp
    - Search conversations
    - Filter by unread/archived
    - Conversation categories

17. **ConversationScreen**
    - Real-time message display
    - Message input field
    - Profile preview of other user
    - Message reactions
    - File/image sharing
    - Typing indicators
    - Message status (sent, delivered, read)

### Community and Discussion Screens

18. **DiscussionThreadsScreen**
    - List of active discussion threads
    - Categories and tags
    - Popular threads section
    - Search and filter options
    - Create new thread button
    - Thread preview cards with engagement metrics

19. **DiscussionScreen**
    - Thread content and details
    - Author information
    - Reply section
    - Like and bookmark options
    - Share thread functionality
    - Related threads suggestions

20. **ThreadPostReplyScreen**
    - Reply composition interface
    - Formatting options
    - Media attachment support
    - Preview mode
    - Draft saving
    - Reply threading

### Settings and Information Screens

21. **SettingsScreen**
    - Account settings
    - Privacy settings
    - Notification preferences
    - Theme selection
    - Language selection
    - Data management
    - Help and support
    - About section
    - Logout option

22. **AboutScreen**
    - App information
    - Version details
    - Team information
    - FAQ section
    - Contact support
    - Social media links
    - App store ratings
    - Feature highlights

### Legal Screens

23. **PrivacyPolicyScreen**
    - Privacy policy content
    - Data collection details
    - User rights information
    - Cookie policy
    - Data retention policy
    - Contact information

24. **TermsOfServiceScreen**
    - Terms of service content
    - User responsibilities
    - Content guidelines
    - Intellectual property
    - Dispute resolution
    - Changes to terms

### Exploration Screens

25. **ExplorationDashboardScreen**
    - Active journeys list
    - Completed journeys
    - Start new journey button
    - Pending requests section

26. **ExplorationSelectionScreen**
    - Journey type cards with descriptions
    - Intensity and time indicators
    - Connection selection

27. **ExplorationRequestsScreen**
    - Incoming requests list with actions
    - Outgoing requests status
    - Profile links

28. **StartExplorationPathScreen**
    - Journey overview
    - Stages preview
    - Privacy notice
    - Start button

29. **ExplorationStageScreen**
    - Dynamic content based on stage type
    - Progress indicator
    - Navigation between stages
    - Partner response section when applicable

30. **ExplorationPathCompletedScreen**
    - Journey summary
    - Insights generated from responses
    - Option to view all responses
    - Next steps suggestions

## Development Process

### Phase 1: Project Setup
1. Initialize Flutter project with Firebase
2. Configure state management (Riverpod)
3. Set up authentication services
4. Implement basic theme and design system

### Phase 2: Core Authentication
1. Implement auth screens and user creation
2. Set up profile creation flow
3. Add authentication state management

### Phase 3: User Profile
1. Create profile editing functionality
2. Implement personality tests with legal compliance
3. Add profile completion tracking

### Phase 4: Main Functionality
1. Develop connections system
2. Implement real-time messaging
3. Build compatibility algorithm
4. Create exploration journeys system

### Phase 5: UI Polish and Testing
1. Refine transitions and animations
2. Optimize for performance
3. Implement comprehensive testing
4. Add error handling and edge cases

## Testing Strategy

1. **Unit Tests**
   - Repository logic
   - Utilities and helpers
   - Business logic and algorithms

2. **Widget Tests**
   - UI components
   - Form validation
   - Screen workflows

3. **Integration Tests**
   - Full authentication flow
   - Profile creation process
   - Connection and messaging features

4. **Firebase Tests**
   - Security rules verification
   - Database query performance
   - Authentication edge cases

## Legal Compliance Guidelines

1. **General Disclaimers**
   - Include in app: "SoulTypes is an app for self-discovery and connection. The assessments and insights provided are for informational and entertainment purposes only and should not be considered clinical or diagnostic tools."

2. **Soul Languages Assessment**
   - Use original "Soul Languages" terminology throughout
   - Include disclaimer: "The Soul Languages assessment is an original concept developed by SoulTypes to help understand communication preferences in relationships. It is not affiliated with or derived from any trademarked personality framework."

3. **Big Five Assessment**
   - Include attribution: "Based on the Big Five Inventory-2 (BFI-2) by Soto & John (2017), which is in the public domain"
   - Add disclaimer: "This assessment is for informational and self-discovery purposes only"

4. **Values and Goals Assessments**
   - Use general concepts and original descriptions
   - Include disclaimer: "The Values and Goals frameworks are original tools developed by SoulTypes"

5. **SoulType Naming**
   - Use original naming conventions
   - Conduct trademark searches for generated names
   - Include disclaimer about uniqueness of the system

6. **Data Privacy**
   - Implement GDPR and CCPA compliance features
   - Allow users to export and delete their data
   - Include comprehensive privacy policy

## Implementation Guidelines for GitHub Copilot

When implementing the SoulTypes app, follow these best practices:

1. **Incremental Development**
   - Build one feature at a time with thorough testing
   - Complete each component before moving to the next
   - Use TDD approach where appropriate

2. **Clean Architecture**
   - Follow the repository pattern
   - Use Riverpod for state management
   - Keep business logic separate from UI

3. **Error Handling**
   - Implement comprehensive error handling
   - Provide user-friendly error messages
   - Add retry mechanisms for network operations

4. **UI Implementation**
   - Follow Material 3 design principles
   - Create responsive layouts for different screen sizes
   - Add proper loading indicators and error messages

5. **Testing**
   - Write unit tests for all business logic
   - Create widget tests for UI components
   - Implement integration tests for critical flows

6. **Documentation**
   - Add clear comments for complex logic
   - Document architecture decisions
   - Maintain a development log

Begin by setting up the project foundation and implementing the authentication system. Focus on creating a legally compliant, well-tested application with a methodical development approach.
