#!/data/data/com.termux/files/usr/bin/bash
set -e

ROOT="apps/mobile/src"

echo "======================================"
echo " VOXO - Complete Frontend Architecture"
echo "======================================"

# ==========================================
# 1. GLOBAL APPLICATION STRUCTURE
# ==========================================

mkdir -p "$ROOT"/{app,assets/{images,icons,animations,fonts,sounds},components/{common,buttons,inputs,cards,modals,loaders,empty-states},hooks,navigation,services,store,theme,utils,constants}

GLOBAL_FILES=(
  app/App.js
  app/RootNavigator.js
  app/AppProviders.js
  app/AppBootstrap.js
  navigation/index.js
  navigation/RootStack.js
  navigation/AuthNavigator.js
  navigation/MainTabNavigator.js
  navigation/NavigationService.js
  navigation/routeNames.js
  components/index.js
  components/common/Avatar.js
  components/common/Badge.js
  components/common/Divider.js
  components/common/ScreenContainer.js
  components/common/LoadingView.js
  components/common/ErrorView.js
  components/common/EmptyState.js
  components/buttons/PrimaryButton.js
  components/buttons/IconButton.js
  components/buttons/SecondaryButton.js
  components/inputs/TextInput.js
  components/inputs/SearchInput.js
  components/inputs/PasswordInput.js
  components/cards/UserCard.js
  components/cards/LiveCard.js
  components/modals/ConfirmModal.js
  components/modals/BottomSheet.js
  components/loaders/ScreenLoader.js
  components/empty-states/EmptyList.js
  hooks/index.js
  hooks/useAuth.js
  hooks/useDebounce.js
  hooks/useNetworkStatus.js
  hooks/useAppState.js
  services/index.js
  services/apiClient.js
  services/authService.js
  services/socketService.js
  services/storageService.js
  services/uploadService.js
  store/index.js
  store/authStore.js
  store/appStore.js
  store/networkStore.js
  theme/index.js
  theme/colors.js
  theme/typography.js
  theme/spacing.js
  theme/shadows.js
  theme/borders.js
  utils/index.js
  utils/helpers.js
  utils/formatters.js
  utils/validators.js
  utils/dateUtils.js
  utils/permissions.js
  constants/index.js
  constants/app.js
  constants/api.js
  constants/storage.js
  constants/routes.js
  constants/config.js
)

for file in "${GLOBAL_FILES[@]}"; do
  mkdir -p "$ROOT/$(dirname "$file")"
  touch "$ROOT/$file"
done

# ==========================================
# 2. FEATURE MANIFEST
# Format:
# feature|screens|components|hooks|services|stores|navigation|constants|utils
# ==========================================

FEATURES=$(cat <<'MANIFEST'
onboarding|WelcomeScreen OnboardingScreen PermissionsScreen LanguageScreen InterestSelectionScreen|OnboardingSlide ProgressIndicator LanguageSelector InterestSelector PermissionCard|useOnboarding useOnboardingProgress usePermissions useLanguageSelection|onboardingService permissionService|onboardingStore onboardingSelectors|OnboardingNavigator|onboardingConfig onboardingSteps|onboardingHelpers
auth|LoginScreen RegisterScreen ForgotPasswordScreen OtpVerificationScreen ResetPasswordScreen ChangePasswordScreen AccountVerificationScreen|AuthHeader AuthFooter SocialLoginButtons PasswordField OtpInput AuthForm TermsCheckbox|useLogin useRegister useOtpVerification usePasswordReset useAuthValidation|authApi authTokenService otpService|authStore authSelectors|AuthNavigator|authConstants authValidationRules|authHelpers authValidators
home|HomeScreen FollowingScreen RecommendedScreen CategoryScreen|HomeHeader StoryList UserRecommendationCard CategoryChip LivePreviewSection|useHomeFeed useRecommendedUsers useFollowingFeed useHomeRefresh|homeService recommendationService|homeStore homeSelectors|HomeNavigator|homeConfig homeSections|homeHelpers
discover|DiscoverScreen TrendingScreen PopularUsersScreen NewCreatorsScreen CategoryExploreScreen|DiscoverHeader TrendingCard CreatorCard CategoryGrid PopularityBadge|useDiscover useTrending usePopularUsers useCategories|discoverService trendingService|discoverStore discoverSelectors|DiscoverNavigator|discoverCategories discoverConfig|discoverHelpers
search|SearchScreen SearchResultsScreen UserSearchScreen HashtagSearchScreen|SearchBar SearchHistory SearchSuggestion SearchResultItem SearchFilter|useSearch useSearchHistory useSearchResults useSearchFilters|searchService searchHistoryService|searchStore searchSelectors|SearchNavigator|searchConfig searchFilters|searchHelpers searchValidators
live|LiveFeedScreen LiveRoomScreen GoLiveScreen LivePreviewScreen LiveSettingsScreen GuestInvitationScreen GuestManagementScreen LiveBattleScreen LiveEndedScreen LiveReplayScreen|LiveCard LiveVideoView LiveHeader LiveChatList LiveChatInput ViewerCounter GiftOverlay GiftAnimation LiveControls GuestGrid HostBadge LiveTimer BattleScoreboard|useLiveRoom useLiveStream useLiveChat useLiveViewers useLiveGifts useLiveBattle useLiveParticipants useLiveControls|liveApi liveSocket liveKitService liveRecordingService liveGiftService|liveStore liveSelectors|LiveNavigator|liveEvents liveConfig livePermissions|liveHelpers liveValidators
video-call|VideoCallScreen IncomingCallScreen OutgoingCallScreen CallHistoryScreen CallSettingsScreen CallEndedScreen|CallVideoView CallControls CallTimer CallStatus IncomingCallBanner ParticipantView CameraSwitchButton|useVideoCall useCallControls useCallTimer useCallParticipants useCallPermissions|videoCallApi callSocket liveKitCallService|videoCallStore videoCallSelectors|VideoCallNavigator|callConfig callEvents callPermissions|callHelpers callValidators
audio-room|AudioRoomListScreen AudioRoomScreen CreateAudioRoomScreen EditAudioRoomScreen AudioRoomDetailsScreen|AudioRoomCard AudioRoomHeader SpeakerGrid SpeakerTile AudioRoomControls RaiseHandButton RoomTopic|useAudioRoom useAudioParticipants useAudioControls useRaisedHands|audioRoomApi audioRoomSocket audioRoomService|audioRoomStore audioRoomSelectors|AudioRoomNavigator|audioRoomConfig audioRoomRoles|audioRoomHelpers
social|SocialScreen FollowersScreen FollowingScreen FriendRequestsScreen BlockedUsersScreen|FollowButton FollowerCard FollowingList FriendRequestCard SocialStats|useFollow useFollowers useFollowing useFriendRequests useBlockedUsers|socialApi followService|socialStore socialSelectors|SocialNavigator|socialConfig socialEvents|socialHelpers
feed|FeedScreen CreatePostScreen PostDetailsScreen EditPostScreen HashtagFeedScreen SavedPostsScreen|PostCard PostMedia PostActions PostComments CommentInput HashtagChip|useFeed useCreatePost usePostDetails usePostComments usePostLikes useSavedPosts|feedApi postService commentService mediaUploadService|feedStore feedSelectors|FeedNavigator|feedConfig postLimits|feedHelpers postValidators
chat|ChatListScreen ChatScreen NewConversationScreen GroupChatScreen ChatMediaScreen MessageSearchScreen ArchivedChatsScreen|ConversationItem MessageBubble MessageInput MessageAttachment ChatHeader TypingIndicator ReadReceipt VoiceMessage|useConversations useMessages useSendMessage useTypingIndicator useMessageStatus useChatSocket|chatApi chatSocket messageService attachmentService|chatStore chatSelectors|ChatNavigator|chatConfig messageTypes|chatHelpers messageValidators
profile|ProfileScreen EditProfileScreen UserProfileScreen ProfileSettingsScreen UserMediaScreen ProfileVisitorsScreen|ProfileHeader ProfileStats ProfileBio ProfileActionButtons ProfileMediaGrid ProfileBadge|useProfile useEditProfile useUserProfile useProfileMedia useProfileStats|profileApi profileService profileMediaService|profileStore profileSelectors|ProfileNavigator|profileConfig profileFields|profileHelpers profileValidators
wallet|WalletScreen TransactionHistoryScreen TransactionDetailsScreen RechargeScreen PaymentMethodScreen RechargeResultScreen|WalletBalance TransactionItem TransactionList RechargePackage PaymentMethodCard PaymentStatus|useWallet useTransactions useRecharge usePaymentMethods useWalletBalance|walletApi paymentApi transactionService|walletStore walletSelectors|WalletNavigator|walletConfig paymentConfig|walletHelpers paymentValidators
gifts|GiftStoreScreen GiftHistoryScreen GiftDetailsScreen GiftCategoriesScreen|GiftCard GiftGrid GiftCategoryTab GiftPreview GiftPriceTag GiftSendButton|useGiftCatalog useGiftHistory useGiftSending useGiftCategories|giftApi giftService giftCatalogService|giftStore giftSelectors|GiftNavigator|giftConfig giftCategories|giftHelpers giftValidators
creator|CreatorDashboardScreen CreatorEarningsScreen CreatorAnalyticsScreen CreatorLevelScreen CreatorSettingsScreen|CreatorStats EarningsCard AnalyticsChart CreatorLevelBadge CreatorGoalCard|useCreatorDashboard useCreatorEarnings useCreatorAnalytics useCreatorLevel|creatorApi creatorEarningsService creatorAnalyticsService|creatorStore creatorSelectors|CreatorNavigator|creatorConfig creatorLevels|creatorHelpers
agency|AgencyDashboardScreen AgencyMembersScreen AgencyMemberDetailsScreen AgencyEarningsScreen|AgencyStats AgencyMemberCard AgencyCommissionCard AgencyInviteForm|useAgency useAgencyMembers useAgencyEarnings useAgencyCommission|agencyApi agencyService agencyMemberService|agencyStore agencySelectors|AgencyNavigator|agencyConfig agencyRoles|agencyHelpers agencyValidators
leaderboard|LeaderboardScreen WeeklyRankingScreen MonthlyRankingScreen|LeaderboardList LeaderboardItem RankingBadge RankingPeriodTabs|useLeaderboard useRankingPeriod useCurrentRanking|leaderboardApi rankingService|leaderboardStore leaderboardSelectors|LeaderboardNavigator|leaderboardConfig rankingPeriods|leaderboardHelpers
matchmaking|MatchmakingScreen MatchPreferencesScreen MatchSearchingScreen MatchResultScreen|MatchCard MatchPreferenceForm MatchSearchingAnimation MatchResultCard|useMatchmaking useMatchPreferences useMatchSearch useMatchResult|matchmakingApi matchmakingSocket matchService|matchmakingStore matchmakingSelectors|MatchmakingNavigator|matchConfig matchPreferences|matchHelpers matchValidators
notifications|NotificationsScreen NotificationSettingsScreen NotificationDetailsScreen|NotificationItem NotificationGroup NotificationBadge NotificationAction|useNotifications useNotificationSettings useUnreadCount|notificationApi notificationService pushNotificationService|notificationStore notificationSelectors|NotificationsNavigator|notificationConfig notificationTypes|notificationHelpers
settings|SettingsScreen AccountSettingsScreen PrivacySettingsScreen SecuritySettingsScreen LanguageSettingsScreen AppearanceSettingsScreen BlockedAccountsScreen|SettingsItem SettingsGroup ToggleSetting LanguagePicker ThemeSelector PrivacyOption|useSettings usePrivacySettings useSecuritySettings useAppearanceSettings|settingsApi settingsService|settingsStore settingsSelectors|SettingsNavigator|settingsConfig privacyOptions|settingsHelpers settingsValidators
support|HelpCenterScreen ContactSupportScreen CreateTicketScreen TicketDetailsScreen|HelpArticle SupportCategory SupportTicketCard SupportForm FAQItem|useHelpCenter useSupportTicket useContactSupport useFAQ|supportApi supportService faqService|supportStore supportSelectors|SupportNavigator|supportConfig supportCategories|supportHelpers supportValidators
MANIFEST
)

# ==========================================
# 3. CREATE EVERY FEATURE
# ==========================================

while IFS='|' read -r feature screens components hooks services stores navigation constants utils; do
  [ -z "$feature" ] && continue

  BASE="$ROOT/features/$feature"

  mkdir -p "$BASE"/{screens,components,hooks,services,store,navigation,constants,utils,__tests__}

  # Standard index files
  touch "$BASE/index.js"
  touch "$BASE/screens/index.js"
  touch "$BASE/components/index.js"
  touch "$BASE/hooks/index.js"
  touch "$BASE/services/index.js"
  touch "$BASE/store/index.js"
  touch "$BASE/navigation/index.js"
  touch "$BASE/constants/index.js"
  touch "$BASE/utils/index.js"
  touch "$BASE/__tests__/${feature}.test.js"

  # Feature screens
  for name in $screens; do
    touch "$BASE/screens/$name"
  done

  # Feature components
  for name in $components; do
    touch "$BASE/components/$name.js"
  done

  # Custom React hooks
  for name in $hooks; do
    touch "$BASE/hooks/$name.js"
  done

  # Feature services
  for name in $services; do
    touch "$BASE/services/$name.js"
  done

  # Zustand stores and selectors
  for name in $stores; do
    touch "$BASE/store/$name.js"
  done

  # Feature navigation
  touch "$BASE/navigation/$navigation.js"

  # Constants
  for name in $constants; do
    touch "$BASE/constants/$name.js"
  done

  # Utilities
  for name in $utils; do
    touch "$BASE/utils/$name.js"
  done

  echo "Created: $feature"
done <<< "$FEATURES"

# ==========================================
# 4. MOBILE APP ROOT FILES
# ==========================================

mkdir -p apps/mobile
touch apps/mobile/App.js
touch apps/mobile/index.js
touch apps/mobile/package.json

# ==========================================
# 5. FRONTEND DOCUMENTATION
# ==========================================

mkdir -p docs/mobile

touch docs/mobile/frontend-architecture.md
touch docs/mobile/feature-folder-convention.md
touch docs/mobile/navigation-map.md
touch docs/mobile/screen-inventory.md
touch docs/mobile/component-inventory.md
touch docs/mobile/state-management.md
touch docs/mobile/api-integration.md

# ==========================================
# 6. SUMMARY
# ==========================================

echo ""
echo "======================================"
echo " VOXO FRONTEND STRUCTURE CREATED"
echo "======================================"

echo "Feature count:"
find "$ROOT/features" -mindepth 1 -maxdepth 1 -type d | wc -l

echo "Screen count:"
find "$ROOT/features" -path "*/screens/*.js" -type f | wc -l

echo "Component count:"
find "$ROOT/features" -path "*/components/*.js" -type f | wc -l

echo "Hook count:"
find "$ROOT/features" -path "*/hooks/*.js" -type f | wc -l

echo "Service count:"
find "$ROOT/features" -path "*/services/*.js" -type f | wc -l

echo "Total frontend files:"
find apps/mobile -type f | wc -l

echo ""
echo "Frontend architecture scaffold completed."
