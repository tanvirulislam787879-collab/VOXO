#!/data/data/com.termux/files/usr/bin/bash

set -e

cd "$HOME/Node/Voxo/apps/mobile"

echo "======================================"
echo " VOXO STEP 3: FEATURE SCREEN FLOWS"
echo "======================================"

# Prerequisite checks
for f in \
  src/navigation/MainTabNavigator.js \
  src/features/discover/screens/DiscoverScreen.js \
  src/features/live/screens/LiveFeedScreen.js \
  src/features/chat/screens/ChatListScreen.js \
  src/features/profile/screens/ProfileScreen.js
do
  if [ ! -s "$f" ]; then
    echo "ERROR: Missing or empty prerequisite: $f"
    echo "Complete Step 2 before running Step 3."
    exit 1
  fi
done

STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/voxo-backup-step3-$STAMP"
mkdir -p "$BACKUP"

FILES=(
  src/navigation/MainTabNavigator.js
  src/features/discover/screens/DiscoverScreen.js
  src/features/live/screens/LiveFeedScreen.js
  src/features/chat/screens/ChatListScreen.js
  src/features/profile/screens/ProfileScreen.js
)

for f in "${FILES[@]}"; do
  mkdir -p "$BACKUP/$(dirname "$f")"
  cp "$f" "$BACKUP/$f"
done

echo "Backup: $BACKUP"

mkdir -p \
  src/features/discover/navigation \
  src/features/search/screens \
  src/features/live/navigation \
  src/features/live/screens \
  src/features/chat/navigation \
  src/features/chat/screens \
  src/features/profile/navigation \
  src/features/profile/screens

# ======================================
# 1. DISCOVER SCREEN
# ======================================

cat > src/features/discover/screens/DiscoverScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const categories = ['Music', 'Gaming', 'Lifestyle', 'Education', 'Talk Show'];
const creators = [
  {name: 'Creator One', category: 'Music'},
  {name: 'Creator Two', category: 'Gaming'},
  {name: 'Creator Three', category: 'Lifestyle'},
];

export default function DiscoverScreen({navigation}) {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Discover</Text>
        <Text style={styles.subtitle}>Find creators and communities.</Text>

        <Pressable
          style={styles.search}
          onPress={() => navigation.navigate('Search')}>
          <Text style={styles.searchText}>Search creators, topics and rooms</Text>
        </Pressable>

        <View style={styles.headingRow}>
          <Text style={styles.heading}>Trending</Text>
          <Pressable onPress={() => navigation.navigate('Trending')}>
            <Text style={styles.link}>See all</Text>
          </Pressable>
        </View>

        <View style={styles.trendingCard}>
          <Text style={styles.trendingLabel}>TRENDING ON VOXO</Text>
          <Text style={styles.trendingTitle}>Discover what's happening</Text>
          <Text style={styles.trendingText}>
            Explore popular conversations and live experiences.
          </Text>
        </View>

        <View style={styles.headingRow}>
          <Text style={styles.heading}>Popular Creators</Text>
          <Pressable onPress={() => navigation.navigate('PopularCreators')}>
            <Text style={styles.link}>See all</Text>
          </Pressable>
        </View>

        {creators.map((creator, index) => (
          <View key={creator.name} style={styles.creator}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{index + 1}</Text>
            </View>
            <View style={{flex: 1}}>
              <Text style={styles.creatorName}>{creator.name}</Text>
              <Text style={styles.creatorCategory}>{creator.category}</Text>
            </View>
            <Text style={styles.demo}>DEMO</Text>
          </View>
        ))}

        <Text style={styles.heading}>Explore Categories</Text>
        <View style={styles.categoryGrid}>
          {categories.map(category => (
            <Pressable
              key={category}
              style={styles.category}
              onPress={() => navigation.navigate('Category', {category})}>
              <Text style={styles.categoryText}>{category}</Text>
            </Pressable>
          ))}
        </View>

        <Text style={styles.note}>Sample content. Creator data will come from the API.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 5, marginBottom: 18},
  search: {padding: 16, backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, marginBottom: 24},
  searchText: {color: colors.textSecondary, fontSize: 14},
  headingRow: {flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 13, marginTop: 8},
  heading: {fontSize: 19, fontWeight: '800', color: colors.text, marginBottom: 13, marginTop: 8},
  link: {fontSize: 13, color: colors.primary, fontWeight: '700'},
  trendingCard: {padding: 20, borderRadius: 16, backgroundColor: colors.primary, marginBottom: 20},
  trendingLabel: {fontSize: 10, color: '#E5DEFF', fontWeight: '900', letterSpacing: 1},
  trendingTitle: {fontSize: 21, color: colors.white, fontWeight: '800', marginTop: 10},
  trendingText: {fontSize: 13, color: colors.white, marginTop: 7, lineHeight: 20},
  creator: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 13, marginBottom: 9},
  avatar: {width: 42, height: 42, borderRadius: 21, backgroundColor: '#EEE9FF', alignItems: 'center', justifyContent: 'center', marginRight: 12},
  avatarText: {color: colors.primary, fontWeight: '800'},
  creatorName: {fontSize: 14, color: colors.text, fontWeight: '700'},
  creatorCategory: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  demo: {fontSize: 9, color: colors.textSecondary, fontWeight: '800'},
  categoryGrid: {flexDirection: 'row', flexWrap: 'wrap', gap: 9},
  category: {width: '48%', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 15},
  categoryText: {fontSize: 13, fontWeight: '700', color: colors.text},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginVertical: 20},
});
JS

# ======================================
# 2. SEARCH SCREENS
# ======================================

cat > src/features/search/screens/SearchScreen.js <<'JS'
import React, {useState} from 'react';
import {View, Text, TextInput, Pressable, FlatList, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const sampleResults = [
  {id: '1', name: 'Creator One', type: 'Creator · Music'},
  {id: '2', name: 'Creator Two', type: 'Creator · Gaming'},
  {id: '3', name: 'Music Lounge', type: 'Live room · Music'},
  {id: '4', name: 'VOXO Community', type: 'Community'},
];

export default function SearchScreen({navigation}) {
  const [query, setQuery] = useState('');

  const results = sampleResults.filter(item =>
    `${item.name} ${item.type}`.toLowerCase().includes(query.trim().toLowerCase()),
  );

  return (
    <ScreenContainer>
      <Text style={styles.title}>Search</Text>
      <Text style={styles.subtitle}>Find creators, rooms and communities.</Text>

      <TextInput
        value={query}
        onChangeText={setQuery}
        placeholder="Search VOXO..."
        placeholderTextColor={colors.textSecondary}
        autoCapitalize="none"
        returnKeyType="search"
        style={styles.input}
      />

      <Text style={styles.heading}>
        {query.trim() ? 'Search Results' : 'Suggested'}
      </Text>

      {results.length === 0 ? (
        <Text style={styles.empty}>No matching demo results.</Text>
      ) : (
        <FlatList
          data={results}
          keyExtractor={item => item.id}
          keyboardShouldPersistTaps="handled"
          renderItem={({item}) => (
            <Pressable
              style={styles.result}
              onPress={() => navigation.navigate('SearchResult', {item})}>
              <View style={styles.avatar}>
                <Text style={styles.avatarText}>{item.name.charAt(0)}</Text>
              </View>
              <View style={{flex: 1}}>
                <Text style={styles.name}>{item.name}</Text>
                <Text style={styles.type}>{item.type}</Text>
              </View>
              <Text style={styles.arrow}>›</Text>
            </Pressable>
          )}
        />
      )}
      <Text style={styles.note}>Search currently uses local sample data, not a server.</Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 13, color: colors.textSecondary, marginTop: 5, marginBottom: 18},
  input: {height: 52, borderRadius: 13, borderWidth: 1, borderColor: colors.border, backgroundColor: colors.surface, paddingHorizontal: 15, color: colors.text, fontSize: 15},
  heading: {fontSize: 17, fontWeight: '800', color: colors.text, marginTop: 24, marginBottom: 12},
  result: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 13, marginBottom: 9},
  avatar: {width: 42, height: 42, borderRadius: 21, backgroundColor: '#EEE9FF', alignItems: 'center', justifyContent: 'center', marginRight: 12},
  avatarText: {color: colors.primary, fontWeight: '800'},
  name: {fontSize: 14, color: colors.text, fontWeight: '700'},
  type: {fontSize: 11, color: colors.textSecondary, marginTop: 4},
  arrow: {fontSize: 22, color: colors.textSecondary},
  empty: {color: colors.textSecondary, marginTop: 25, textAlign: 'center'},
  note: {fontSize: 11, color: colors.textSecondary, marginTop: 20},
});
JS

cat > src/features/search/screens/SearchResultScreen.js <<'JS'
import React from 'react';
import {View, Text, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function SearchResultScreen({route}) {
  const item = route.params?.item;

  return (
    <ScreenContainer>
      <View style={styles.card}>
        <Text style={styles.avatar}>{item?.name?.charAt(0) || '?'}</Text>
        <Text style={styles.title}>{item?.name || 'Search result'}</Text>
        <Text style={styles.subtitle}>{item?.type || 'VOXO item'}</Text>
        <Text style={styles.note}>
          This is a sample result. The real creator or room detail page will be connected to the backend.
        </Text>
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  card: {flex: 1, alignItems: 'center', justifyContent: 'center'},
  avatar: {fontSize: 34, color: colors.primary, fontWeight: '900', backgroundColor: '#EEE9FF', overflow: 'hidden', padding: 22, borderRadius: 60},
  title: {fontSize: 23, fontWeight: '800', color: colors.text, marginTop: 18},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 7},
  note: {fontSize: 13, color: colors.textSecondary, textAlign: 'center', lineHeight: 21, marginTop: 20},
});
JS

# ======================================
# 3. DISCOVER NAVIGATOR + SUBSCREENS
# ======================================

cat > src/features/discover/navigation/DiscoverNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import DiscoverScreen from '../screens/DiscoverScreen';
import SearchScreen from '../../search/screens/SearchScreen';
import SearchResultScreen from '../../search/screens/SearchResultScreen';
import {colors} from '../../../theme';

const Stack = createNativeStackNavigator();

function CollectionScreen({route}) {
  const title = route.params?.title || route.name;
  const description = route.params?.description || 'Explore this VOXO collection.';

  return (
    <ScreenCollection title={title} description={description} />
  );
}

function ScreenCollection({title, description}) {
  const ReactNative = require('react-native');
  const View = ReactNative.View;
  const Text = ReactNative.Text;
  return (
    <View style={{flex: 1, backgroundColor: colors.background, padding: 22}}>
      <Text style={{fontSize: 24, fontWeight: '800', color: colors.text}}>{title}</Text>
      <Text style={{fontSize: 14, color: colors.textSecondary, marginTop: 9}}>{description}</Text>
      <Text style={{fontSize: 12, color: colors.textSecondary, marginTop: 20}}>
        Sample collection. API data will be connected later.
      </Text>
    </View>
  );
}

export default function DiscoverNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: true, headerTintColor: colors.primary}}>
      <Stack.Screen name="DiscoverHome" component={DiscoverScreen} options={{title: 'Discover'}} />
      <Stack.Screen name="Search" component={SearchScreen} options={{title: 'Search'}} />
      <Stack.Screen name="SearchResult" component={SearchResultScreen} options={{title: 'Result'}} />
      <Stack.Screen
        name="Trending"
        component={CollectionScreen}
        initialParams={{title: 'Trending', description: 'Popular topics and conversations.'}}
      />
      <Stack.Screen
        name="PopularCreators"
        component={CollectionScreen}
        initialParams={{title: 'Popular Creators', description: 'Creators people are exploring.'}}
      />
      <Stack.Screen
        name="Category"
        component={CollectionScreen}
        options={({route}) => ({title: route.params?.category || 'Category'})}
      />
    </Stack.Navigator>
  );
}
JS

# ======================================
# 4. LIVE ROOM + LIVE NAVIGATOR
# ======================================

cat > src/features/live/screens/LiveRoomScreen.js <<'JS'
import React from 'react';
import {View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function LiveRoomScreen({route, navigation}) {
  const room = route.params?.room || {title: 'Demo Live Room', host: 'VOXO Creator'};

  return (
    <ScreenContainer style={styles.container}>
      <View style={styles.stage}>
        <Text style={styles.live}>LIVE PREVIEW</Text>
        <Text style={styles.stageTitle}>{room.title}</Text>
        <Text style={styles.host}>Host: {room.host}</Text>
        <Text style={styles.videoNotice}>Video stream is not connected</Text>
      </View>

      <Text style={styles.info}>
        This is a navigation preview. Camera, microphone, viewer count and realtime chat will be implemented with LiveKit and the backend.
      </Text>

      <Pressable
        style={styles.button}
        onPress={() => navigation.replace('LiveEnded', {room})}>
        <Text style={styles.buttonText}>Leave Room</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {justifyContent: 'space-between'},
  stage: {flex: 1, backgroundColor: '#21164A', borderRadius: 20, alignItems: 'center', justifyContent: 'center', padding: 20},
  live: {color: '#FF8AAE', fontSize: 12, fontWeight: '900', letterSpacing: 1},
  stageTitle: {color: colors.white, fontSize: 25, fontWeight: '900', marginTop: 18, textAlign: 'center'},
  host: {color: colors.white, fontSize: 14, marginTop: 8},
  videoNotice: {color: '#D6CFFF', fontSize: 12, marginTop: 35},
  info: {fontSize: 12, color: colors.textSecondary, lineHeight: 19, marginVertical: 16},
  button: {height: 52, backgroundColor: colors.danger, borderRadius: 13, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontSize: 15, fontWeight: '800'},
});
JS

cat > src/features/live/screens/LiveEndedScreen.js <<'JS'
import React from 'react';
import {View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function LiveEndedScreen({navigation}) {
  return (
    <ScreenContainer style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.icon}>✓</Text>
        <Text style={styles.title}>You left the room</Text>
        <Text style={styles.subtitle}>This demo session has ended.</Text>
      </View>
      <Pressable style={styles.button} onPress={() => navigation.popToTop()}>
        <Text style={styles.buttonText}>Back to Live</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {justifyContent: 'space-between'},
  content: {flex: 1, alignItems: 'center', justifyContent: 'center'},
  icon: {fontSize: 34, color: colors.success, fontWeight: '900'},
  title: {fontSize: 23, fontWeight: '800', color: colors.text, marginTop: 15},
  subtitle: {fontSize: 13, color: colors.textSecondary, marginTop: 8},
  button: {height: 52, borderRadius: 13, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontWeight: '800'},
});
JS

cat > src/features/live/navigation/LiveNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import LiveFeedScreen from '../screens/LiveFeedScreen';
import LiveRoomScreen from '../screens/LiveRoomScreen';
import LiveEndedScreen from '../screens/LiveEndedScreen';
import {colors} from '../../../theme';

const Stack = createNativeStackNavigator();

export default function LiveNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: true, headerTintColor: colors.primary}}>
      <Stack.Screen name="LiveFeed" component={LiveFeedScreen} options={{title: 'Live'}} />
      <Stack.Screen name="LiveRoom" component={LiveRoomScreen} options={{title: 'Live Room'}} />
      <Stack.Screen name="LiveEnded" component={LiveEndedScreen} options={{title: 'Session Ended'}} />
    </Stack.Navigator>
  );
}
JS

# ======================================
# 5. CHAT CONVERSATION + NAVIGATOR
# ======================================

cat > src/features/chat/screens/ConversationScreen.js <<'JS'
import React, {useState} from 'react';
import {View, Text, TextInput, Pressable, FlatList, StyleSheet, KeyboardAvoidingView, Platform} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function ConversationScreen({route}) {
  const name = route.params?.name || 'Conversation';
  const [message, setMessage] = useState('');
  const [messages, setMessages] = useState([
    {id: '1', text: 'Welcome to this demo conversation.', mine: false},
  ]);

  const send = () => {
    const value = message.trim();
    if (!value) {
      return;
    }

    setMessages(previous => [
      ...previous,
      {id: String(Date.now()), text: value, mine: true},
    ]);
    setMessage('');
  };

  return (
    <ScreenContainer style={styles.container}>
      <KeyboardAvoidingView
        style={styles.flex}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
        <Text style={styles.name}>{name}</Text>
        <Text style={styles.demo}>LOCAL DEMO CHAT — NOT SENT TO SERVER</Text>

        <FlatList
          style={styles.list}
          data={messages}
          keyExtractor={item => item.id}
          contentContainerStyle={{paddingVertical: 15}}
          renderItem={({item}) => (
            <View style={[styles.bubble, item.mine ? styles.mine : styles.theirs]}>
              <Text style={[styles.message, item.mine && styles.mineText]}>{item.text}</Text>
            </View>
          )}
        />

        <View style={styles.composer}>
          <TextInput
            value={message}
            onChangeText={setMessage}
            placeholder="Write a message..."
            placeholderTextColor={colors.textSecondary}
            style={styles.input}
            multiline
          />
          <Pressable style={styles.send} onPress={send}>
            <Text style={styles.sendText}>Send</Text>
          </Pressable>
        </View>
      </KeyboardAvoidingView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {paddingBottom: 8},
  flex: {flex: 1},
  name: {fontSize: 20, fontWeight: '800', color: colors.text},
  demo: {fontSize: 9, color: colors.warning, fontWeight: '800', marginTop: 5},
  list: {flex: 1, marginTop: 10},
  bubble: {maxWidth: '82%', borderRadius: 14, padding: 12, marginBottom: 9},
  mine: {alignSelf: 'flex-end', backgroundColor: colors.primary},
  theirs: {alignSelf: 'flex-start', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border},
  message: {fontSize: 14, color: colors.text, lineHeight: 20},
  mineText: {color: colors.white},
  composer: {flexDirection: 'row', alignItems: 'center', gap: 8},
  input: {flex: 1, minHeight: 48, maxHeight: 100, borderRadius: 13, borderWidth: 1, borderColor: colors.border, backgroundColor: colors.surface, paddingHorizontal: 13, paddingVertical: 10, color: colors.text},
  send: {height: 46, paddingHorizontal: 17, borderRadius: 12, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center'},
  sendText: {color: colors.white, fontWeight: '800'},
});
JS

cat > src/features/chat/navigation/ChatNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import ChatListScreen from '../screens/ChatListScreen';
import ConversationScreen from '../screens/ConversationScreen';
import {colors} from '../../../theme';

const Stack = createNativeStackNavigator();

export default function ChatNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: true, headerTintColor: colors.primary}}>
      <Stack.Screen name="ChatInbox" component={ChatListScreen} options={{title: 'Messages'}} />
      <Stack.Screen name="Conversation" component={ConversationScreen} options={({route}) => ({title: route.params?.name || 'Chat'})} />
    </Stack.Navigator>
  );
}
JS

# ======================================
# 6. PROFILE EDIT + SETTINGS + NAVIGATOR
# ======================================

cat > src/features/profile/screens/EditProfileScreen.js <<'JS'
import React, {useState} from 'react';
import {View, Text, TextInput, Pressable, StyleSheet, Alert} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {useAuthStore} from '../../auth/store/authStore';
import {colors} from '../../../theme';

export default function EditProfileScreen() {
  const user = useAuthStore(state => state.user);
  const [name, setName] = useState(user?.name || user?.displayName || '');
  const [bio, setBio] = useState(user?.bio || '');

  return (
    <ScreenContainer>
      <Text style={styles.title}>Edit Profile</Text>
      <Text style={styles.label}>Display Name</Text>
      <TextInput value={name} onChangeText={setName} style={styles.input} placeholder="Your name" placeholderTextColor={colors.textSecondary} />
      <Text style={styles.label}>Bio</Text>
      <TextInput value={bio} onChangeText={setBio} style={[styles.input, styles.bio]} multiline placeholder="Tell people about yourself" placeholderTextColor={colors.textSecondary} />
      <Pressable
        style={styles.button}
        onPress={() => Alert.alert('Preview only', 'Profile saving will be connected to the backend API.')}>
        <Text style={styles.buttonText}>Save Changes</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 25, fontWeight: '800', color: colors.text, marginBottom: 24},
  label: {fontSize: 13, fontWeight: '700', color: colors.text, marginBottom: 8},
  input: {height: 52, borderWidth: 1, borderColor: colors.border, borderRadius: 12, backgroundColor: colors.surface, paddingHorizontal: 14, color: colors.text, marginBottom: 18},
  bio: {height: 110, textAlignVertical: 'top', paddingTop: 13},
  button: {height: 52, backgroundColor: colors.primary, borderRadius: 13, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontWeight: '800'},
});
JS

cat > src/features/profile/screens/SettingsScreen.js <<'JS'
import React, {useState} from 'react';
import {View, Text, Switch, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function SettingsScreen() {
  const [notifications, setNotifications] = useState(true);
  const [sound, setSound] = useState(true);

  return (
    <ScreenContainer>
      <Text style={styles.title}>Settings</Text>

      <View style={styles.row}>
        <View style={{flex: 1}}>
          <Text style={styles.label}>Notifications</Text>
          <Text style={styles.description}>Local preview setting</Text>
        </View>
        <Switch value={notifications} onValueChange={setNotifications} />
      </View>

      <View style={styles.row}>
        <View style={{flex: 1}}>
          <Text style={styles.label}>App sounds</Text>
          <Text style={styles.description}>Local preview setting</Text>
        </View>
        <Switch value={sound} onValueChange={setSound} />
      </View>

      <Text style={styles.note}>
        These settings are temporary and are not saved to the server or device storage yet.
      </Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 26, fontWeight: '800', color: colors.text, marginBottom: 20},
  row: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 16, marginBottom: 12},
  label: {fontSize: 14, color: colors.text, fontWeight: '700'},
  description: {fontSize: 11, color: colors.textSecondary, marginTop: 5},
  note: {fontSize: 12, color: colors.textSecondary, lineHeight: 19, marginTop: 15},
});
JS

cat > src/features/profile/navigation/ProfileNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import ProfileScreen from '../screens/ProfileScreen';
import EditProfileScreen from '../screens/EditProfileScreen';
import SettingsScreen from '../screens/SettingsScreen';
import {colors} from '../../../theme';

const Stack = createNativeStackNavigator();

export default function ProfileNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: true, headerTintColor: colors.primary}}>
      <Stack.Screen name="ProfileHome" component={ProfileScreen} options={{title: 'Profile'}} />
      <Stack.Screen name="EditProfile" component={EditProfileScreen} options={{title: 'Edit Profile'}} />
      <Stack.Screen name="Settings" component={SettingsScreen} />
    </Stack.Navigator>
  );
}
JS

# ======================================
# 7. UPDATE CHAT LIST
# ======================================

cat > src/features/chat/screens/ChatListScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, Pressable, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const conversations = [
  {name: 'VOXO Community', message: 'Welcome to VOXO!', time: 'Now', unread: '2'},
  {name: 'Creator One', message: 'Thanks for joining the live.', time: '10:30'},
  {name: 'Creator Two', message: 'See you soon!', time: 'Yesterday'},
];

export default function ChatListScreen({navigation}) {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Messages</Text>
        <Text style={styles.subtitle}>Your conversations in one place.</Text>

        {conversations.map(item => (
          <Pressable
            key={item.name}
            style={styles.row}
            onPress={() => navigation.navigate('Conversation', {name: item.name})}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{item.name.charAt(0)}</Text>
            </View>
            <View style={styles.content}>
              <Text style={styles.name}>{item.name}</Text>
              <Text style={styles.message} numberOfLines={1}>{item.message}</Text>
            </View>
            <View style={styles.meta}>
              <Text style={styles.time}>{item.time}</Text>
              {item.unread ? <Text style={styles.unread}>{item.unread}</Text> : null}
            </View>
          </Pressable>
        ))}

        <Text style={styles.note}>Sample conversations. Messages are not synced.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 6, marginBottom: 22},
  row: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, padding: 13, borderRadius: 14, borderWidth: 1, borderColor: colors.border, marginBottom: 10},
  avatar: {width: 46, height: 46, borderRadius: 23, backgroundColor: '#EEE9FF', alignItems: 'center', justifyContent: 'center'},
  avatarText: {fontSize: 18, color: colors.primary, fontWeight: '800'},
  content: {flex: 1, marginLeft: 12},
  name: {fontSize: 14, fontWeight: '800', color: colors.text},
  message: {fontSize: 12, color: colors.textSecondary, marginTop: 5},
  meta: {alignItems: 'flex-end', marginLeft: 5},
  time: {fontSize: 10, color: colors.textSecondary},
  unread: {backgroundColor: colors.primary, color: colors.white, fontSize: 10, fontWeight: '800', overflow: 'hidden', borderRadius: 10, paddingHorizontal: 7, paddingVertical: 3, marginTop: 7},
  note: {fontSize: 11, color: colors.textSecondary, marginTop: 18},
});
JS

# ======================================
# 8. UPDATE LIVE FEED
# ======================================

cat > src/features/live/screens/LiveFeedScreen.js <<'JS'
import React from 'react';
import {ScrollView, View, Text, Pressable, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const rooms = [
  {id: '1', title: 'Music Lounge', host: 'Creator One', viewers: '1.2K'},
  {id: '2', title: 'Friendly Talk', host: 'Creator Two', viewers: '850'},
  {id: '3', title: 'Gaming Arena', host: 'Creator Three', viewers: '620'},
];

export default function LiveFeedScreen({navigation}) {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Live</Text>
        <Text style={styles.subtitle}>Watch live experiences from creators.</Text>

        <View style={styles.hostCard}>
          <Text style={styles.hostTitle}>Ready to go live?</Text>
          <Text style={styles.hostDescription}>
            Broadcasting will be enabled after LiveKit integration.
          </Text>
          <Text style={styles.hostStatus}>BROADCASTING: NOT CONNECTED</Text>
        </View>

        <Text style={styles.sectionTitle}>Live Rooms</Text>

        {rooms.map(room => (
          <Pressable
            key={room.id}
            style={styles.roomCard}
            onPress={() => navigation.navigate('LiveRoom', {room})}>
            <View style={styles.roomCover}>
              <Text style={styles.liveBadge}>LIVE DEMO</Text>
              <Text style={styles.coverText}>VOXO LIVE</Text>
            </View>
            <View style={styles.roomDetails}>
              <View style={{flex: 1}}>
                <Text style={styles.roomTitle}>{room.title}</Text>
                <Text style={styles.hostName}>Host: {room.host}</Text>
              </View>
              <Text style={styles.viewers}>{room.viewers} viewers</Text>
            </View>
          </Pressable>
        ))}

        <Text style={styles.note}>Demo rooms only. No real video stream is connected.</Text>
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
  roomCard: {backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 15, overflow: 'hidden', marginBottom: 15},
  roomCover: {height: 125, backgroundColor: '#33236D', alignItems: 'center', justifyContent: 'center'},
  liveBadge: {position: 'absolute', top: 12, left: 12, backgroundColor: colors.danger, color: colors.white, overflow: 'hidden', paddingHorizontal: 8, paddingVertical: 4, borderRadius: 5, fontSize: 10, fontWeight: '900'},
  coverText: {fontSize: 22, color: colors.white, fontWeight: '900', letterSpacing: 3},
  roomDetails: {padding: 14, flexDirection: 'row', alignItems: 'center'},
  roomTitle: {fontSize: 15, fontWeight: '800', color: colors.text},
  hostName: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  viewers: {fontSize: 11, color: colors.textSecondary},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginVertical: 18},
});
JS

# ======================================
# 9. UPDATE PROFILE SCREEN
# ======================================

cat > src/features/profile/screens/ProfileScreen.js <<'JS'
import React, {useState} from 'react';
import {ScrollView, View, Text, StyleSheet, Pressable, Alert} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {useAuthStore} from '../../auth/store/authStore';
import {authService} from '../../auth/services/authService';
import {colors} from '../../../theme';

export default function ProfileScreen({navigation}) {
  const user = useAuthStore(state => state.user);
  const [loading, setLoading] = useState(false);

  const name = user?.name || user?.displayName || user?.username || 'VOXO Member';
  const email = user?.email || 'No email available';

  const handleLogout = async () => {
    if (loading) return;
    setLoading(true);
    try {
      await authService.logout();
    } catch (error) {
      Alert.alert('Sign out failed', error?.message || 'Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const menu = [
    {label: 'Edit Profile', route: 'EditProfile'},
    {label: 'My Followers', route: null},
    {label: 'Following', route: null},
    {label: 'Settings', route: 'Settings'},
    {label: 'Help & Support', route: null},
  ];

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

        {menu.map(item => (
          <Pressable
            key={item.label}
            style={styles.menuItem}
            onPress={() => {
              if (item.route) {
                navigation.navigate(item.route);
              } else {
                Alert.alert('Coming soon', `${item.label} will be implemented in a later feature phase.`);
              }
            }}>
            <Text style={styles.menuText}>{item.label}</Text>
            <Text style={styles.arrow}>›</Text>
          </Pressable>
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
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text, marginBottom: 20},
  profileCard: {alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 18, padding: 24},
  avatar: {width: 76, height: 76, borderRadius: 38, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center'},
  avatarText: {fontSize: 30, fontWeight: '900', color: colors.white},
  name: {fontSize: 20, fontWeight: '800', color: colors.text, marginTop: 13},
  email: {fontSize: 13, color: colors.textSecondary, marginTop: 5},
  member: {fontSize: 10, fontWeight: '900', color: colors.primary, marginTop: 12, letterSpacing: 1.5},
  sectionTitle: {fontSize: 18, fontWeight: '800', color: colors.text, marginTop: 25, marginBottom: 10},
  menuItem: {flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 16, marginBottom: 9},
  menuText: {fontSize: 14, fontWeight: '600', color: colors.text},
  arrow: {fontSize: 22, color: colors.textSecondary},
  logout: {marginTop: 22, marginBottom: 20},
});
JS

# ======================================
# 10. UPDATE MAIN TAB NAVIGATOR
# ======================================

cat > src/navigation/MainTabNavigator.js <<'JS'
import React from 'react';
import {Text, StyleSheet} from 'react-native';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';

import HomeScreen from '../features/home/screens/HomeScreen';
import DiscoverNavigator from '../features/discover/navigation/DiscoverNavigator';
import LiveNavigator from '../features/live/navigation/LiveNavigator';
import ChatNavigator from '../features/chat/navigation/ChatNavigator';
import ProfileNavigator from '../features/profile/navigation/ProfileNavigator';

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
      <Tab.Screen name="Discover" component={DiscoverNavigator} />
      <Tab.Screen name="Live" component={LiveNavigator} />
      <Tab.Screen name="Chat" component={ChatNavigator} />
      <Tab.Screen name="Profile" component={ProfileNavigator} />
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
  label: {fontSize: 11, fontWeight: '600'},
});
JS

echo
echo "========== STEP 3 FILE VALIDATION =========="

FAILED=0

FILES=(
  src/navigation/MainTabNavigator.js
  src/features/discover/navigation/DiscoverNavigator.js
  src/features/search/screens/SearchScreen.js
  src/features/search/screens/SearchResultScreen.js
  src/features/live/navigation/LiveNavigator.js
  src/features/live/screens/LiveRoomScreen.js
  src/features/live/screens/LiveEndedScreen.js
  src/features/chat/navigation/ChatNavigator.js
  src/features/chat/screens/ConversationScreen.js
  src/features/profile/navigation/ProfileNavigator.js
  src/features/profile/screens/EditProfileScreen.js
  src/features/profile/screens/SettingsScreen.js
)

for f in "${FILES[@]}"; do
  if [ -s "$f" ]; then
    echo "[OK] $f"
  else
    echo "[FAILED] $f"
    FAILED=1
  fi
done

if [ "$FAILED" -ne 0 ]; then
  echo "STEP 3 VALIDATION FAILED"
  echo "Backup: $BACKUP"
  exit 1
fi

echo
echo "STEP 3 FILE VALIDATION PASSED"
echo "Backup: $BACKUP"
