import React from 'react';
import {
  ActivityIndicator,
  StyleSheet,
  View,
} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import OnboardingNavigator from '../navigation/OnboardingNavigator';
import AuthNavigator from '../navigation/AuthNavigator';
import MainTabNavigator from '../navigation/MainTabNavigator';

import {useAuthStore} from '../features/auth/store/authStore';
import {colors} from '../theme';

const Stack = createNativeStackNavigator();

function LoadingScreen() {
  return (
    <View style={styles.loading}>
      <ActivityIndicator size="large" color={colors.primary} />
    </View>
  );
}

export default function RootNavigator() {
  const hydrated = useAuthStore(state => state.hydrated);
  const accessToken = useAuthStore(state => state.accessToken);

  if (!hydrated) {
    return <LoadingScreen />;
  }

  return (
    <NavigationContainer key={accessToken ? 'authenticated' : 'guest'}>
      <Stack.Navigator screenOptions={{headerShown: false}}>
        {accessToken ? (
          <Stack.Screen
            name="Main"
            component={MainTabNavigator}
          />
        ) : (
          <>
            <Stack.Screen
              name="Onboarding"
              component={OnboardingNavigator}
            />
            <Stack.Screen
              name="Auth"
              component={AuthNavigator}
            />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}

const styles = StyleSheet.create({
  loading: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: colors.background,
  },
});
