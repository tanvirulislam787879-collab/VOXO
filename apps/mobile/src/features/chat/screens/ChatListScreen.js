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
