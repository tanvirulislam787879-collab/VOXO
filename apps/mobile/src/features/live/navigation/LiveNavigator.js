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
