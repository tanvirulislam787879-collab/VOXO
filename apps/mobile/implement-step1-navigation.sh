#!/data/data/com.termux/files/usr/bin/bash

set -e

ROOT="$HOME/Node/Voxo/apps/mobile"
cd "$ROOT"

STAMP=$(date +%Y%m%d-%H%M%S)
BACKUP="$HOME/voxo-backup-step1-$STAMP"

mkdir -p "$BACKUP"

echo "======================================"
echo " VOXO STEP 1: NAVIGATION IMPLEMENTATION"
echo "======================================"

# Backup existing files before modifying them.
for FILE in \
  src/app/RootNavigator.js \
  src/navigation/AuthNavigator.js \
  src/navigation/OnboardingNavigator.js
do
  if [ -f "$FILE" ]; then
    mkdir -p "$BACKUP/$(dirname "$FILE")"
    cp "$FILE" "$BACKUP/$FILE"
  fi
done

echo "Backup: $BACKUP"

# 1. Root Navigator
mkdir -p src/app

cat > src/app/RootNavigator.js <<'JS'
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
JS

# 2. Onboarding Navigator
cat > src/navigation/OnboardingNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import WelcomeScreen from '../features/onboarding/screens/WelcomeScreen';

const Stack = createNativeStackNavigator();

export default function OnboardingNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: false}}>
      <Stack.Screen
        name="Welcome"
        component={WelcomeScreen}
      />
    </Stack.Navigator>
  );
}
JS

# 3. Authentication Navigator
cat > src/navigation/AuthNavigator.js <<'JS'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import LoginScreen from '../features/auth/screens/LoginScreen';
import RegisterScreen from '../features/auth/screens/RegisterScreen';
import ForgotPasswordScreen from '../features/auth/screens/ForgotPasswordScreen';

const Stack = createNativeStackNavigator();

export default function AuthNavigator() {
  return (
    <Stack.Navigator
      initialRouteName="Login"
      screenOptions={{
        headerShown: true,
        headerTitle: '',
        headerShadowVisible: false,
        headerBackTitle: 'Back',
        contentStyle: {
          backgroundColor: '#F7F7FB',
        },
      }}>
      <Stack.Screen
        name="Login"
        component={LoginScreen}
        options={{headerShown: false}}
      />

      <Stack.Screen
        name="Register"
        component={RegisterScreen}
        options={{title: 'Create account'}}
      />

      <Stack.Screen
        name="ForgotPassword"
        component={ForgotPasswordScreen}
        options={{title: 'Forgot password'}}
      />
    </Stack.Navigator>
  );
}
JS

echo
echo "Navigation files created successfully."
echo
echo "Checking required files..."

REQUIRED_FILES=(
  src/app/RootNavigator.js
  src/navigation/OnboardingNavigator.js
  src/navigation/AuthNavigator.js
  src/navigation/MainTabNavigator.js
  src/features/onboarding/screens/WelcomeScreen.js
  src/features/auth/screens/LoginScreen.js
  src/features/auth/screens/RegisterScreen.js
  src/features/auth/screens/ForgotPasswordScreen.js
  src/features/auth/store/authStore.js
)

FAILED=0

for FILE in "${REQUIRED_FILES[@]}"; do
  if [ -s "$FILE" ]; then
    echo "[OK] $FILE"
  else
    echo "[MISSING OR EMPTY] $FILE"
    FAILED=1
  fi
done

echo
if [ "$FAILED" -eq 0 ]; then
  echo "STEP 1 NAVIGATION FILE CHECK: PASSED"
else
  echo "STEP 1 NAVIGATION FILE CHECK: FAILED"
  echo "Restore from backup if necessary: $BACKUP"
  exit 1
fi

echo
echo "Backup directory: $BACKUP"
