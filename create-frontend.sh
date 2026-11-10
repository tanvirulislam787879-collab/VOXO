#!/data/data/com.termux/files/usr/bin/bash

set -e

ROOT="apps/mobile/src"

echo "Creating VOXO Frontend structure..."

# Main application folders
mkdir -p "$ROOT"/{app,assets/{images,icons,animations,fonts,sounds},components/{common,buttons,inputs,cards,modals,loaders,empty-states},hooks,navigation,services,store,theme,utils,constants}

# App-level files
touch "$ROOT"/app/{App.js,RootNavigator.js,AppProviders.js,AppBootstrap.js}
touch "$ROOT"/navigation/{index.js,RootStack.js,AuthNavigator.js,MainTabNavigator.js,NavigationService.js,routeNames.js}
touch "$ROOT"/components/index.js
touch "$ROOT"/hooks/index.js
touch "$ROOT"/services/{apiClient.js,authService.js,socketService.js,storageService.js,index.js}
touch "$ROOT"/store/{index.js,authStore.js,appStore.js}
touch "$ROOT"/theme/{colors.js,typography.js,spacing.js,shadows.js,index.js}
touch "$ROOT"/utils/{helpers.js,formatters.js,validators.js,index.js}
touch "$ROOT"/constants/{app.js,api.js,storage.js,index.js}

# Feature list
FEATURES=(
  onboarding
  auth
  home
  discover
  search
  live
  video-call
  audio-room
  social
  feed
  chat
  profile
  wallet
  gifts
  creator
  agency
  leaderboard
  matchmaking
  notifications
  settings
  support
)

# Create standard folders for every feature
for feature in "${FEATURES[@]}"; do
  FEATURE_PATH="$ROOT/features/$feature"

  mkdir -p "$FEATURE_PATH"/{screens,components,hooks,services,store,navigation,constants,utils}

  touch "$FEATURE_PATH"/index.js
  touch "$FEATURE_PATH"/screens/index.js
  touch "$FEATURE_PATH"/components/index.js
  touch "$FEATURE_PATH"/hooks/index.js
  touch "$FEATURE_PATH"/services/index.js
  touch "$FEATURE_PATH"/store/index.js
  touch "$FEATURE_PATH"/navigation/index.js
  touch "$FEATURE_PATH"/constants/index.js
  touch "$FEATURE_PATH"/utils/index.js
done

# Create useful starter screen files
declare -A SCREENS

SCREENS[onboarding]="WelcomeScreen.js OnboardingScreen.js PermissionsScreen.js"
SCREENS[auth]="LoginScreen.js RegisterScreen.js ForgotPasswordScreen.js OtpVerificationScreen.js ResetPasswordScreen.js"
SCREENS[home]="HomeScreen.js"
SCREENS[discover]="DiscoverScreen.js TrendingScreen.js"
SCREENS[search]="SearchScreen.js SearchResultsScreen.js"
SCREENS[live]="LiveFeedScreen.js LiveRoomScreen.js GoLiveScreen.js LivePreviewScreen.js LiveSettingsScreen.js GuestInvitationScreen.js GuestManagementScreen.js LiveBattleScreen.js LiveEndedScreen.js LiveReplayScreen.js"
SCREENS[video-call]="VideoCallScreen.js IncomingCallScreen.js CallHistoryScreen.js"
SCREENS[audio-room]="AudioRoomListScreen.js AudioRoomScreen.js CreateAudioRoomScreen.js"
SCREENS[social]="SocialScreen.js FollowersScreen.js FollowingScreen.js"
SCREENS[feed]="FeedScreen.js CreatePostScreen.js PostDetailsScreen.js"
SCREENS[chat]="ChatListScreen.js ChatScreen.js NewConversationScreen.js"
SCREENS[profile]="ProfileScreen.js EditProfileScreen.js UserProfileScreen.js"
SCREENS[wallet]="WalletScreen.js TransactionHistoryScreen.js RechargeScreen.js"
SCREENS[gifts]="GiftStoreScreen.js GiftHistoryScreen.js"
SCREENS[creator]="CreatorDashboardScreen.js CreatorEarningsScreen.js"
SCREENS[agency]="AgencyDashboardScreen.js AgencyMembersScreen.js"
SCREENS[leaderboard]="LeaderboardScreen.js"
SCREENS[matchmaking]="MatchmakingScreen.js MatchResultScreen.js"
SCREENS[notifications]="NotificationsScreen.js"
SCREENS[settings]="SettingsScreen.js PrivacySettingsScreen.js SecuritySettingsScreen.js"
SCREENS[support]="HelpCenterScreen.js ContactSupportScreen.js"

for feature in "${FEATURES[@]}"; do
  FEATURE_PATH="$ROOT/features/$feature"

  for screen in ${SCREENS[$feature]}; do
    touch "$FEATURE_PATH/screens/$screen"
  done
done

# Mobile app root files
mkdir -p apps/mobile
touch apps/mobile/{App.js,index.js}

# Documentation
mkdir -p docs/mobile
touch docs/mobile/{frontend-architecture.md,feature-folder-convention.md,navigation-map.md}

echo ""
echo "VOXO Frontend structure created successfully!"
echo "Location: apps/mobile/src"
