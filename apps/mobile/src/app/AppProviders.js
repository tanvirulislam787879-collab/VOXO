import React from 'react';
import {SafeAreaProvider} from 'react-native-safe-area-context';
import AppBootstrap from './AppBootstrap';
import RootNavigator from './RootNavigator';

export default function AppProviders() {
  return (
    <SafeAreaProvider>
      <AppBootstrap>
        <RootNavigator />
      </AppBootstrap>
    </SafeAreaProvider>
  );
}
