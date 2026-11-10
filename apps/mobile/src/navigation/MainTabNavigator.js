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
