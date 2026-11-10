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
