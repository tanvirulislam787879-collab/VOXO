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
