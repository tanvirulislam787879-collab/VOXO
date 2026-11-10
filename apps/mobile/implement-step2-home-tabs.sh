#!/data/data/com.termux/files/usr/bin/bash

set -e

ROOT="$HOME/Node/Voxo/apps/mobile"
cd "$ROOT"

echo "======================================"
echo " VOXO STEP 2: HOME + BOTTOM NAVIGATION"
echo "======================================"

# Step 1 prerequisite
if [ ! -s src/app/RootNavigator.js ]; then
  echo "ERROR: Step 1 RootNavigator.js is missing or empty."
  echo "Complete Step 1 first."
  exit 1
fi

STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/voxo-backup-step2-$STAMP"
mkdir -p "$BACKUP"

FILES=(
  src/navigation/MainTabNavigator.js
  src/features/home/screens/HomeScreen.js
  src/features/discover/screens/DiscoverScreen.js
  src/features/live/screens/LiveFeedScreen.js
  src/features/chat/screens/ChatListScreen.js
  src/features/profile/screens/ProfileScreen.js
)

for FILE in "${FILES[@]}"; do
  if [ -f "$FILE" ]; then
    mkdir -p "$BACKUP/$(dirname "$FILE")"
    cp "$FILE" "$BACKUP/$FILE"
  fi
done

echo "Backup created: $BACKUP"

mkdir -p \
  src/features/home/screens \
  src/features/discover/screens \
  src/features/live/screens \
  src/features/chat/screens \
  src/features/profile/screens \
  src/navigation

# 1. Main Bottom Tab Navigator
cat > src/navigation/MainTabNavigator.js <<'JS'
import React from 'react';
import {Text, StyleSheet} from 'react-native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';

import HomeScreen from '../features/home/screens/HomeScreen';
import DiscoverScreen from '../features/discover/screens/DiscoverScreen';
import LiveFeedScreen from '../features/live/screens/LiveFeedScreen';
import ChatListScreen from '../features/chat/screens/ChatListScreen';
import ProfileScreen from '../features/profile/screens/ProfileScreen';

import {colors} from '../theme';

const Tab = createBottomTabNavigator();

const tabIcons = {
  Home: '⌂',
  Discover: '⌕',
  Live: '●',
  Chat: '✉',
  Profile: '○',
};

export default function MainTabNavigator() {
  return (
    <Tab.Navigator
      initialRouteName="Home"
      screenOptions={({route}) => ({
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.textSecondary,
        tabBarLabelStyle: styles.label,
        tabBarIcon: ({color, size}) => (
          <Text style={{color, fontSize: size, fontWeight: '700'}}>
            {tabIcons[route.name]}
          </Text>
        ),
        tabBarStyle: styles.tabBar,
        tabBarHideOnKeyboard: true,
      })}>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Discover" component={DiscoverScreen} />
      <Tab.Screen name="Live" component={LiveFeedScreen} />
      <Tab.Screen name="Chat" component={ChatListScreen} />
      <Tab.Screen name="Profile" component={ProfileScreen} />
    </Tab.Navigator>
  );
}

const styles = StyleSheet.create({
  tabBar: {
    height: 64,
    paddingTop: 6,
    paddingBottom: 7,
    backgroundColor: colors.surface,
    borderTopColor: colors.border,
    elevation: 10,
  },
  label: {
    fontSize: 11,
    fontWeight: '600',
  },
});
JS

# 2. Home Feed
cat > src/features/home/screens/HomeScreen.js <<'JS'
import React from 'react';
import {
  ScrollView,
  View,
  Text,
  StyleSheet,
} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {useAuthStore} from '../../auth/store/authStore';
import {colors, spacing} from '../../../theme';

const liveCreators = [
  {name: 'Creator One', category: 'Music', viewers: '1.2K'},
  {name: 'Creator Two', category: 'Talk Show', viewers: '850'},
  {name: 'Creator Three', category: 'Gaming', viewers: '620'},
];

const categories = ['Music', 'Gaming', 'Talk Show', 'Lifestyle', 'Education'];

function SectionTitle({title, subtitle}) {
  return (
    <View style={styles.sectionHeader}>
      <View>
        <Text style={styles.sectionTitle}>{title}</Text>
        {subtitle ? <Text style={styles.sectionSubtitle}>{subtitle}</Text> : null}
      </View>
    </View>
  );
}

export default function HomeScreen() {
  const user = useAuthStore(state => state.user);

  const displayName =
    user?.name || user?.displayName || user?.username || 'VOXO Member';

  return (
    <ScreenContainer style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <View>
            <Text style={styles.brand}>VOXO</Text>
            <Text style={styles.greeting}>Hello, {displayName}</Text>
            <Text style={styles.subtitle}>Your world. Your community.</Text>
          </View>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>
              {displayName.charAt(0).toUpperCase()}
            </Text>
          </View>
        </View>

        <View style={styles.hero}>
          <Text style={styles.heroEyebrow}>WELCOME TO VOXO</Text>
          <Text style={styles.heroTitle}>Discover a world of live experiences</Text>
          <Text style={styles.heroDescription}>
            Watch creators, meet new people and share your moments.
          </Text>
        </View>

        <SectionTitle
          title="Live Now"
          subtitle="Creators who are streaming"
        />

        {liveCreators.map((creator, index) => (
          <View key={creator.name} style={styles.creatorCard}>
            <View style={styles.creatorAvatar}>
              <Text style={styles.creatorAvatarText}>
                {creator.name.charAt(0)}
              </Text>
            </View>
            <View style={styles.creatorInfo}>
              <Text style={styles.creatorName}>{creator.name}</Text>
              <Text style={styles.creatorCategory}>{creator.category}</Text>
            </View>
            <View style={styles.liveInfo}>
              <Text style={styles.liveBadge}>LIVE</Text>
              <Text style={styles.viewerCount}>{creator.viewers} viewers</Text>
            </View>
          </View>
        ))}

        <SectionTitle
          title="Explore Categories"
          subtitle="Find content you enjoy"
        />

        <View style={styles.categoryGrid}>
          {categories.map((category, index) => (
            <View key={category} style={styles.categoryCard}>
              <Text style={styles.categoryNumber}>0{index + 1}</Text>
              <Text style={styles.categoryName}>{category}</Text>
            </View>
          ))}
        </View>

        <SectionTitle title="For You" subtitle="Recommended for your feed" />

        <View style={styles.recommendationCard}>
          <Text style={styles.recommendationTitle}>Your next discovery starts here</Text>
          <Text style={styles.recommendationText}>
            Follow creators and explore live rooms to personalize your feed.
          </Text>
        </View>

        <Text style={styles.demoNote}>
          Preview content only. Live data will be connected in a later phase.
        </Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {paddingTop: spacing.md},
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 22,
  },
  brand: {
    color: colors.primary,
    fontSize: 16,
    fontWeight: '900',
    letterSpacing: 3,
  },
  greeting: {
    color: colors.text,
    fontSize: 24,
    fontWeight: '800',
    marginTop: 10,
  },
  subtitle: {
    color: colors.textSecondary,
    fontSize: 13,
    marginTop: 5,
  },
  avatar: {
    width: 46,
    height: 46,
    borderRadius: 23,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {color: colors.white, fontSize: 20, fontWeight: '800'},
  hero: {
    backgroundColor: colors.primary,
    borderRadius: 20,
    padding: 22,
    marginBottom: 26,
  },
  heroEyebrow: {
    color: '#E5DEFF',
    fontSize: 11,
    fontWeight: '800',
    letterSpacing: 1.5,
  },
  heroTitle: {
    color: colors.white,
    fontSize: 23,
    fontWeight: '800',
    marginTop: 12,
    lineHeight: 30,
  },
  heroDescription: {
    color: colors.white,
    opacity: 0.9,
    fontSize: 14,
    lineHeight: 21,
    marginTop: 9,
  },
  sectionHeader: {marginBottom: 13, marginTop: 5},
  sectionTitle: {fontSize: 19, fontWeight: '800', color: colors.text},
  sectionSubtitle: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  creatorCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 13,
    marginBottom: 10,
    borderRadius: 15,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
  },
  creatorAvatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#EEE9FF',
    alignItems: 'center',
    justifyContent: 'center',
  },
  creatorAvatarText: {fontSize: 18, color: colors.primary, fontWeight: '800'},
  creatorInfo: {flex: 1, marginLeft: 12},
  creatorName: {fontSize: 14, fontWeight: '700', color: colors.text},
  creatorCategory: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  liveInfo: {alignItems: 'flex-end'},
  liveBadge: {
    color: colors.white,
    backgroundColor: colors.danger,
    overflow: 'hidden',
    borderRadius: 5,
    paddingHorizontal: 7,
    paddingVertical: 3,
    fontSize: 10,
    fontWeight: '900',
  },
  viewerCount: {fontSize: 10, color: colors.textSecondary, marginTop: 5},
  categoryGrid: {flexDirection: 'row', flexWrap: 'wrap', gap: 9},
  categoryCard: {
    width: '48%',
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderWidth: 1,
    borderRadius: 13,
    padding: 14,
    marginBottom: 2,
  },
  categoryNumber: {fontSize: 10, color: colors.primary, fontWeight: '800'},
  categoryName: {fontSize: 14, color: colors.text, fontWeight: '700', marginTop: 7},
  recommendationCard: {
    backgroundColor: colors.surface,
    borderRadius: 15,
    padding: 18,
    borderWidth: 1,
    borderColor: colors.border,
  },
  recommendationTitle: {fontSize: 15, fontWeight: '800', color: colors.text},
  recommendationText: {
    fontSize: 13,
    color: colors.textSecondary,
    lineHeight: 20,
    marginTop: 7,
  },
  demoNote: {
    fontSize: 11,
    color: colors.textSecondary,
    textAlign: 'center',
    marginTop: 20,
    marginBottom: 20,
  },
});
JS

# 3. Discover Screen
cat > src/features/discover/screens/DiscoverScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const sections = [
  {title: 'Trending Creators', description: 'Creators getting attention today.'},
  {title: 'Popular Live Rooms', description: 'Explore active community rooms.'},
  {title: 'New Creators', description: 'Meet new voices on VOXO.'},
  {title: 'Categories', description: 'Music, gaming, lifestyle and more.'},
];

export default function DiscoverScreen() {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Discover</Text>
        <Text style={styles.subtitle}>Explore creators and communities.</Text>

        <View style={styles.searchPreview}>
          <Text style={styles.searchText}>Search creators, topics and rooms</Text>
        </View>

        {sections.map((item, index) => (
          <View key={item.title} style={styles.card}>
            <Text style={styles.number}>0{index + 1}</Text>
            <Text style={styles.cardTitle}>{item.title}</Text>
            <Text style={styles.description}>{item.description}</Text>
            <Text style={styles.preview}>Content coming from the VOXO API</Text>
          </View>
        ))}
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 6, marginBottom: 20},
  searchPreview: {
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 13,
    padding: 16,
    marginBottom: 20,
  },
  searchText: {color: colors.textSecondary, fontSize: 14},
  card: {
    backgroundColor: colors.surface,
    borderRadius: 15,
    borderWidth: 1,
    borderColor: colors.border,
    padding: 18,
    marginBottom: 13,
  },
  number: {color: colors.primary, fontSize: 11, fontWeight: '900'},
  cardTitle: {fontSize: 17, fontWeight: '800', color: colors.text, marginTop: 8},
  description: {fontSize: 13, color: colors.textSecondary, marginTop: 5},
  preview: {fontSize: 11, color: colors.primary, marginTop: 12},
});
JS

# 4. Live Feed Screen
cat > src/features/live/screens/LiveFeedScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const rooms = [
  {title: 'Music Lounge', host: 'Creator One', viewers: '1.2K'},
  {title: 'Friendly Talk', host: 'Creator Two', viewers: '850'},
  {title: 'Gaming Arena', host: 'Creator Three', viewers: '620'},
];

export default function LiveFeedScreen() {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Live</Text>
        <Text style={styles.subtitle}>Watch live experiences from creators.</Text>

        <View style={styles.hostCard}>
          <Text style={styles.hostTitle}>Ready to go live?</Text>
          <Text style={styles.hostDescription}>
            Live broadcasting will be enabled after LiveKit integration.
          </Text>
          <Text style={styles.hostStatus}>BROADCASTING: NOT CONNECTED</Text>
        </View>

        <Text style={styles.sectionTitle}>Live Rooms</Text>

        {rooms.map(room => (
          <View key={room.title} style={styles.roomCard}>
            <View style={styles.roomCover}>
              <Text style={styles.liveBadge}>LIVE</Text>
              <Text style={styles.coverText}>VOXO LIVE</Text>
            </View>
            <View style={styles.roomDetails}>
              <View style={styles.roomText}>
                <Text style={styles.roomTitle}>{room.title}</Text>
                <Text style={styles.hostName}>Host: {room.host}</Text>
              </View>
              <Text style={styles.viewers}>{room.viewers} viewers</Text>
            </View>
          </View>
        ))}

        <Text style={styles.note}>Demo rooms only. No real video stream is connected yet.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 6, marginBottom: 20},
  hostCard: {backgroundColor: colors.primary, padding: 20, borderRadius: 17, marginBottom: 25},
  hostTitle: {fontSize: 20, fontWeight: '800', color: colors.white},
  hostDescription: {fontSize: 13, lineHeight: 20, color: colors.white, marginTop: 8},
  hostStatus: {fontSize: 10, color: '#E5DEFF', fontWeight: '800', marginTop: 14},
  sectionTitle: {fontSize: 19, fontWeight: '800', color: colors.text, marginBottom: 13},
  roomCard: {
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 15,
    overflow: 'hidden',
    marginBottom: 15,
  },
  roomCover: {
    height: 125,
    backgroundColor: '#33236D',
    alignItems: 'center',
    justifyContent: 'center',
  },
  liveBadge: {
    position: 'absolute',
    top: 12,
    left: 12,
    backgroundColor: colors.danger,
    color: colors.white,
    overflow: 'hidden',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 5,
    fontSize: 10,
    fontWeight: '900',
  },
  coverText: {fontSize: 22, color: colors.white, fontWeight: '900', letterSpacing: 3},
  roomDetails: {padding: 14, flexDirection: 'row', alignItems: 'center'},
  roomText: {flex: 1},
  roomTitle: {fontSize: 15, fontWeight: '800', color: colors.text},
  hostName: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  viewers: {fontSize: 11, color: colors.textSecondary},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginVertical: 18},
});
JS

# 5. Chat Inbox Screen
cat > src/features/chat/screens/ChatListScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const conversations = [
  {name: 'VOXO Community', message: 'Welcome to VOXO!', time: 'Now', unread: '2'},
  {name: 'Creator One', message: 'Thanks for joining the live.', time: '10:30'},
  {name: 'Creator Two', message: 'See you soon!', time: 'Yesterday'},
];

export default function ChatListScreen() {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Messages</Text>
        <Text style={styles.subtitle}>Your conversations in one place.</Text>

        {conversations.map((item, index) => (
          <View key={item.name} style={styles.row}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.name.charAt(0)}</Text>
            </View>
            <View style={styles.messageContent}>
              <Text style={styles.name}>{item.name}</Text>
              <Text style={styles.message} numberOfLines={1}>{item.message}</Text>
            </View>
            <View style={styles.meta}>
              <Text style={styles.time}>{item.time}</Text>
              {item.unread ? <Text style={styles.unread}>{item.unread}</Text> : null}
            </View>
          </View>
        ))}

        <Text style={styles.note}>
          These are sample conversations. Real messaging will be connected with the chat API and Socket.IO.
        </Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 6, marginBottom: 22},
  row: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: colors.surface,
    padding: 13,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: colors.border,
    marginBottom: 10,
  },
  avatar: {
    width: 46,
    height: 46,
    borderRadius: 23,
    backgroundColor: '#EEE9FF',
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {fontSize: 18, color: colors.primary, fontWeight: '800'},
  messageContent: {flex: 1, marginLeft: 12},
  name: {fontSize: 14, fontWeight: '800', color: colors.text},
  message: {fontSize: 12, color: colors.textSecondary, marginTop: 5},
  meta: {alignItems: 'flex-end', marginLeft: 5},
  time: {fontSize: 10, color: colors.textSecondary},
  unread: {
    backgroundColor: colors.primary,
    color: colors.white,
    fontSize: 10,
    fontWeight: '800',
    overflow: 'hidden',
    borderRadius: 10,
    paddingHorizontal: 7,
    paddingVertical: 3,
    marginTop: 7,
  },
  note: {fontSize: 11, lineHeight: 17, color: colors.textSecondary, marginTop: 18},
});
JS

# 6. Profile Screen
cat > src/features/profile/screens/ProfileScreen.js <<'JS'
import React, {useState} from 'react';
import {ScrollView, View, Text, StyleSheet, Alert} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {useAuthStore} from '../../auth/store/authStore';
import {authService} from '../../auth/services/authService';
import {colors} from '../../../theme';

export default function ProfileScreen() {
  const user = useAuthStore(state => state.user);
  const [loading, setLoading] = useState(false);

  const name = user?.name || user?.displayName || user?.username || 'VOXO Member';
  const email = user?.email || 'No email available';

  const handleLogout = async () => {
    if (loading) {
      return;
    }

    setLoading(true);
    try {
      await authService.logout();
    } catch (error) {
      Alert.alert('Sign out failed', error?.message || 'Please try again.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>My Profile</Text>

        <View style={styles.profileCard}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{name.charAt(0).toUpperCase()}</Text>
          </View>
          <Text style={styles.name}>{name}</Text>
          <Text style={styles.email}>{email}</Text>
          <Text style={styles.member}>VOXO MEMBER</Text>
        </View>

        <Text style={styles.sectionTitle}>Account</Text>

        {['Edit Profile', 'My Followers', 'Following', 'Settings', 'Help & Support'].map(item => (
          <View key={item} style={styles.menuItem}>
            <Text style={styles.menuText}>{item}</Text>
            <Text style={styles.arrow}>›</Text>
          </View>
        ))}

        <View style={styles.logout}>
          <PrimaryButton
            title="Sign Out"
            variant="secondary"
            loading={loading}
            disabled={loading}
            onPress={handleLogout}
          />
        </View>

        <Text style={styles.note}>Profile management features will be connected in later phases.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text, marginBottom: 20},
  profileCard: {
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 18,
    padding: 24,
  },
  avatar: {
    width: 76,
    height: 76,
    borderRadius: 38,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
  },
  avatarText: {fontSize: 30, fontWeight: '900', color: colors.white},
  name: {fontSize: 20, fontWeight: '800', color: colors.text, marginTop: 13},
  email: {fontSize: 13, color: colors.textSecondary, marginTop: 5},
  member: {fontSize: 10, fontWeight: '900', color: colors.primary, marginTop: 12, letterSpacing: 1.5},
  sectionTitle: {fontSize: 18, fontWeight: '800', color: colors.text, marginTop: 25, marginBottom: 10},
  menuItem: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 12,
    padding: 16,
    marginBottom: 9,
  },
  menuText: {fontSize: 14, fontWeight: '600', color: colors.text},
  arrow: {fontSize: 22, color: colors.textSecondary},
  logout: {marginTop: 22},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginTop: 15, marginBottom: 20},
});
JS

echo
echo "========== FILE VALIDATION =========="

FAILED=0

for FILE in "${FILES[@]}"; do
  if [ -s "$FILE" ]; then
    echo "[OK] $FILE"
  else
    echo "[FAILED] $FILE"
    FAILED=1
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo "Implementation check failed."
  echo "Backup: $BACKUP"
  exit 1
fi

echo
echo "STEP 2 FILE IMPLEMENTATION: PASSED"
echo "Backup location: $BACKUP"
