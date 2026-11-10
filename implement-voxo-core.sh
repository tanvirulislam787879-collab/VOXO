#!/data/data/com.termux/files/usr/bin/bash
set -e

# Writes only missing or empty files.
# Existing non-empty files are preserved.
write_file() {
  local file="$1"
  mkdir -p "$(dirname "$file")"

  if [ -s "$file" ]; then
    echo "KEEP   $file"
    cat > /dev/null
  else
    cat > "$file"
    echo "WRITE  $file"
  fi
}

# ==========================================
# APP ENTRY
# ==========================================

write_file apps/mobile/App.js <<'FILE'
import React from 'react';
import App from './src/app/App';

export default function MobileApp() {
  return <App />;
}
FILE

write_file apps/mobile/index.js <<'FILE'
import {AppRegistry} from 'react-native';
import MobileApp from './App';
import {name as appName} from './app.json';

AppRegistry.registerComponent(appName, () => MobileApp);
FILE

# ==========================================
# APP BOOTSTRAP AND PROVIDERS
# ==========================================

write_file apps/mobile/src/app/App.js <<'FILE'
import React from 'react';
import AppProviders from './AppProviders';

export default function App() {
  return <AppProviders />;
}
FILE

write_file apps/mobile/src/app/AppProviders.js <<'FILE'
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
FILE

write_file apps/mobile/src/app/AppBootstrap.js <<'FILE'
import React, {useEffect} from 'react';
import {authStore} from '../features/auth/store/authStore';

export default function AppBootstrap({children}) {
  useEffect(() => {
    authStore.getState().hydrate();
  }, []);

  return children;
}
FILE

write_file apps/mobile/src/app/RootNavigator.js <<'FILE'
import React from 'react';
import {ActivityIndicator, View} from 'react-native';
import {NavigationContainer} from '@react-navigation/native';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import {useAuthStore} from '../features/auth/store/authStore';
import OnboardingNavigator from '../features/onboarding/navigation/OnboardingNavigator';
import AuthNavigator from '../features/auth/navigation/AuthNavigator';
import MainTabNavigator from '../navigation/MainTabNavigator';
import {colors} from '../theme';

const Stack = createNativeStackNavigator();

export default function RootNavigator() {
  const hydrated = useAuthStore(state => state.hydrated);
  const accessToken = useAuthStore(state => state.accessToken);

  if (!hydrated) {
    return (
      <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
        <ActivityIndicator size="large" color={colors.primary} />
      </View>
    );
  }

  return (
    <NavigationContainer>
      <Stack.Navigator screenOptions={{headerShown: false}}>
        {accessToken ? (
          <Stack.Screen name="MainTabs" component={MainTabNavigator} />
        ) : (
          <>
            <Stack.Screen
              name="Onboarding"
              component={OnboardingNavigator}
            />
            <Stack.Screen name="Auth" component={AuthNavigator} />
          </>
        )}
      </Stack.Navigator>
    </NavigationContainer>
  );
}
FILE

# ==========================================
# GLOBAL THEME AND CONSTANTS
# ==========================================

write_file apps/mobile/src/theme/colors.js <<'FILE'
export const colors = {
  primary: '#6C4DFF',
  primaryDark: '#5135D9',
  secondary: '#FF4F91',
  background: '#F7F7FB',
  surface: '#FFFFFF',
  text: '#171725',
  textSecondary: '#77778A',
  border: '#E7E7EF',
  success: '#20A66B',
  danger: '#E5484D',
  warning: '#E9A23B',
  white: '#FFFFFF',
  black: '#000000',
};
FILE

write_file apps/mobile/src/theme/typography.js <<'FILE'
export const typography = {
  title: {fontSize: 28, fontWeight: '800'},
  heading: {fontSize: 22, fontWeight: '700'},
  subheading: {fontSize: 18, fontWeight: '600'},
  body: {fontSize: 15, fontWeight: '400'},
  caption: {fontSize: 12, fontWeight: '400'},
};
FILE

write_file apps/mobile/src/theme/spacing.js <<'FILE'
export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
  xxl: 48,
};
FILE

write_file apps/mobile/src/theme/index.js <<'FILE'
export {colors} from './colors';
export {typography} from './typography';
export {spacing} from './spacing';
FILE

write_file apps/mobile/src/constants/api.js <<'FILE'
// For a backend running in Termux on the same Android device.
// Change this URL when the API is deployed or hosted elsewhere.
export const API_BASE_URL = 'http://127.0.0.1:3000/api';
export const API_TIMEOUT = 15000;
FILE

# ==========================================
# GLOBAL REUSABLE COMPONENTS
# ==========================================

write_file apps/mobile/src/components/common/ScreenContainer.js <<'FILE'
import React from 'react';
import {View, StyleSheet} from 'react-native';
import {SafeAreaView} from 'react-native-safe-area-context';
import {colors, spacing} from '../../theme';

export default function ScreenContainer({children, style}) {
  return (
    <SafeAreaView style={styles.safeArea}>
      <View style={[styles.container, style]}>{children}</View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: {flex: 1, backgroundColor: colors.background},
  container: {flex: 1, padding: spacing.lg},
});
FILE

write_file apps/mobile/src/components/buttons/PrimaryButton.js <<'FILE'
import React from 'react';
import {
  ActivityIndicator,
  Pressable,
  Text,
  StyleSheet,
} from 'react-native';
import {colors} from '../../theme';

export default function PrimaryButton({
  title,
  onPress,
  loading = false,
  disabled = false,
  variant = 'primary',
}) {
  const secondary = variant === 'secondary';

  return (
    <Pressable
      accessibilityRole="button"
      disabled={disabled || loading}
      onPress={onPress}
      style={({pressed}) => [
        styles.button,
        secondary && styles.secondary,
        (disabled || loading) && styles.disabled,
        pressed && styles.pressed,
      ]}>
      {loading ? (
        <ActivityIndicator color={secondary ? colors.primary : colors.white} />
      ) : (
        <Text style={[styles.label, secondary && styles.secondaryLabel]}>
          {title}
        </Text>
      )}
    </Pressable>
  );
}

const styles = StyleSheet.create({
  button: {
    minHeight: 52,
    borderRadius: 14,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 18,
  },
  secondary: {
    backgroundColor: colors.white,
    borderWidth: 1,
    borderColor: colors.border,
  },
  label: {color: colors.white, fontSize: 16, fontWeight: '700'},
  secondaryLabel: {color: colors.primary},
  disabled: {opacity: 0.55},
  pressed: {opacity: 0.85},
});
FILE

write_file apps/mobile/src/components/inputs/TextInput.js <<'FILE'
import React from 'react';
import {TextInput as RNTextInput, StyleSheet, View, Text} from 'react-native';
import {colors, spacing} from '../../theme';

export default function TextInput({
  label,
  error,
  style,
  ...props
}) {
  return (
    <View style={styles.wrapper}>
      {label ? <Text style={styles.label}>{label}</Text> : null}
      <RNTextInput
        placeholderTextColor={colors.textSecondary}
        style={[styles.input, style, error && styles.inputError]}
        {...props}
      />
      {error ? <Text style={styles.error}>{error}</Text> : null}
    </View>
  );
}

const styles = StyleSheet.create({
  wrapper: {marginBottom: spacing.md},
  label: {
    color: colors.text,
    fontSize: 14,
    fontWeight: '600',
    marginBottom: 8,
  },
  input: {
    minHeight: 52,
    borderWidth: 1,
    borderColor: colors.border,
    borderRadius: 12,
    backgroundColor: colors.white,
    paddingHorizontal: 15,
    color: colors.text,
    fontSize: 15,
  },
  inputError: {borderColor: colors.danger},
  error: {color: colors.danger, fontSize: 12, marginTop: 5},
});
FILE

# ==========================================
# AUTH STORE AND SERVICES
# ==========================================

write_file apps/mobile/src/features/auth/store/authStore.js <<'FILE'
import {create} from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';

const STORAGE_KEY = '@voxo/auth-session';

export const authStore = create((set) => ({
  accessToken: null,
  user: null,
  hydrated: false,

  hydrate: async () => {
    try {
      const raw = await AsyncStorage.getItem(STORAGE_KEY);
      if (raw) {
        const session = JSON.parse(raw);
        set({
          accessToken: session.accessToken || null,
          user: session.user || null,
        });
      }
    } catch (error) {
      console.warn('Session hydration failed:', error.message);
    } finally {
      set({hydrated: true});
    }
  },

  setSession: async (session) => {
    const safeSession = {
      accessToken: session.accessToken,
      user: session.user || null,
    };
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(safeSession));
    set(safeSession);
  },

  logout: async () => {
    await AsyncStorage.removeItem(STORAGE_KEY);
    set({accessToken: null, user: null});
  },
}));

export const useAuthStore = authStore;
FILE

write_file apps/mobile/src/features/auth/services/authApi.js <<'FILE'
import axios from 'axios';
import {API_BASE_URL, API_TIMEOUT} from '../../../constants/api';

const client = axios.create({
  baseURL: API_BASE_URL,
  timeout: API_TIMEOUT,
  headers: {'Content-Type': 'application/json'},
});

function normalizeError(error) {
  return (
    error?.response?.data?.message ||
    error?.message ||
    'Something went wrong. Please try again.'
  );
}

export const authApi = {
  async login(payload) {
    try {
      const response = await client.post('/auth/login', payload);
      return response.data;
    } catch (error) {
      throw new Error(normalizeError(error));
    }
  },

  async register(payload) {
    try {
      const response = await client.post('/auth/register', payload);
      return response.data;
    } catch (error) {
      throw new Error(normalizeError(error));
    }
  },

  async requestPasswordReset(email) {
    try {
      const response = await client.post('/auth/forgot-password', {email});
      return response.data;
    } catch (error) {
      throw new Error(normalizeError(error));
    }
  },
};
FILE

write_file apps/mobile/src/features/auth/services/authService.js <<'FILE'
import {authApi} from './authApi';
import {authStore} from '../store/authStore';

function getSession(data) {
  const accessToken = data?.accessToken || data?.access_token;
  if (!accessToken) {
    throw new Error('API response did not contain an access token.');
  }
  return {
    accessToken,
    user: data.user || data.profile || null,
  };
}

export const authService = {
  async login(email, password) {
    const data = await authApi.login({email, password});
    await authStore.getState().setSession(getSession(data));
    return data;
  },

  async register(payload) {
    const data = await authApi.register(payload);
    if (data?.accessToken || data?.access_token) {
      await authStore.getState().setSession(getSession(data));
    }
    return data;
  },

  async requestPasswordReset(email) {
    return authApi.requestPasswordReset(email);
  },

  async logout() {
    await authStore.getState().logout();
  },
};
FILE

# ==========================================
# AUTH HOOKS
# ==========================================

write_file apps/mobile/src/features/auth/hooks/useLogin.js <<'FILE'
import {useState} from 'react';
import {authService} from '../services/authService';

export default function useLogin() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const submit = async ({email, password}) => {
    setError('');

    if (!email.trim() || !password) {
      setError('Email and password are required.');
      return false;
    }

    setLoading(true);
    try {
      await authService.login(email.trim().toLowerCase(), password);
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  return {submit, loading, error, clearError: () => setError('')};
}
FILE

write_file apps/mobile/src/features/auth/hooks/useRegister.js <<'FILE'
import {useState} from 'react';
import {authService} from '../services/authService';

export default function useRegister() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const submit = async ({name, email, password}) => {
    setError('');

    if (!name.trim() || !email.trim() || !password) {
      setError('Please complete all fields.');
      return false;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters.');
      return false;
    }

    setLoading(true);
    try {
      await authService.register({
        name: name.trim(),
        email: email.trim().toLowerCase(),
        password,
      });
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  return {submit, loading, error};
}
FILE

# ==========================================
# ONBOARDING NAVIGATION AND SCREEN
# ==========================================

write_file apps/mobile/src/features/onboarding/navigation/OnboardingNavigator.js <<'FILE'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import WelcomeScreen from '../screens/WelcomeScreen';

const Stack = createNativeStackNavigator();

export default function OnboardingNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: false}}>
      <Stack.Screen name="WelcomeScreen" component={WelcomeScreen} />
    </Stack.Navigator>
  );
}
FILE

write_file apps/mobile/src/features/onboarding/screens/WelcomeScreen.js <<'FILE'
import React from 'react';
import {Text, View, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {colors, spacing} from '../../../theme';

export default function WelcomeScreen({navigation}) {
  return (
    <ScreenContainer style={styles.container}>
      <View style={styles.hero}>
        <View style={styles.logo}>
          <Text style={styles.logoText}>V</Text>
        </View>
        <Text style={styles.title}>Welcome to VOXO</Text>
        <Text style={styles.subtitle}>
          Connect with people, share moments and discover live experiences.
        </Text>
      </View>

      <View style={styles.actions}>
        <PrimaryButton
          title="Get Started"
          onPress={() => navigation.navigate('Auth')}
        />
        <Text style={styles.note}>
          By continuing, you agree to VOXO's Terms and Privacy Policy.
        </Text>
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {justifyContent: 'space-between', paddingTop: 70, paddingBottom: 25},
  hero: {alignItems: 'center', marginTop: 65},
  logo: {
    width: 92,
    height: 92,
    borderRadius: 28,
    backgroundColor: colors.primary,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: spacing.xl,
  },
  logoText: {color: colors.white, fontSize: 52, fontWeight: '900'},
  title: {fontSize: 30, fontWeight: '800', color: colors.text},
  subtitle: {
    color: colors.textSecondary,
    textAlign: 'center',
    fontSize: 16,
    lineHeight: 24,
    marginTop: 14,
    maxWidth: 300,
  },
  actions: {gap: 16},
  note: {
    color: colors.textSecondary,
    fontSize: 11,
    textAlign: 'center',
    lineHeight: 18,
  },
});
FILE

# ==========================================
# AUTH NAVIGATION AND SCREENS
# ==========================================

write_file apps/mobile/src/features/auth/navigation/AuthNavigator.js <<'FILE'
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import LoginScreen from '../screens/LoginScreen';
import RegisterScreen from '../screens/RegisterScreen';
import ForgotPasswordScreen from '../screens/ForgotPasswordScreen';

const Stack = createNativeStackNavigator();

export default function AuthNavigator() {
  return (
    <Stack.Navigator
      initialRouteName="Login"
      screenOptions={{
        headerShown: true,
        headerTitle: '',
        headerShadowVisible: false,
        headerStyle: {backgroundColor: '#F7F7FB'},
      }}>
      <Stack.Screen name="Login" component={LoginScreen} />
      <Stack.Screen name="Register" component={RegisterScreen} />
      <Stack.Screen
        name="ForgotPassword"
        component={ForgotPasswordScreen}
        options={{title: 'Reset password'}}
      />
    </Stack.Navigator>
  );
}
FILE

write_file apps/mobile/src/features/auth/screens/LoginScreen.js <<'FILE'
import React, {useState} from 'react';
import {Text, View, StyleSheet, Pressable, KeyboardAvoidingView, Platform} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import TextInput from '../../../components/inputs/TextInput';
import useLogin from '../hooks/useLogin';
import {colors, spacing} from '../../../theme';

export default function LoginScreen({navigation}) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const {submit, loading, error} = useLogin();

  const handleLogin = async () => {
    await submit({email, password});
  };

  return (
    <ScreenContainer>
      <KeyboardAvoidingView
        style={styles.wrapper}
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}>
        <View>
          <Text style={styles.title}>Welcome back</Text>
          <Text style={styles.subtitle}>Sign in to continue to VOXO.</Text>

          <View style={styles.form}>
            <TextInput
              label="Email address"
              placeholder="Enter your email"
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              autoCorrect={false}
            />
            <TextInput
              label="Password"
              placeholder="Enter your password"
              value={password}
              onChangeText={setPassword}
              secureTextEntry
            />

            <Pressable
              onPress={() => navigation.navigate('ForgotPassword')}
              style={styles.forgot}>
              <Text style={styles.link}>Forgot password?</Text>
            </Pressable>

            {error ? <Text style={styles.error}>{error}</Text> : null}

            <PrimaryButton
              title="Sign In"
              onPress={handleLogin}
              loading={loading}
            />
          </View>
        </View>

        <View style={styles.footer}>
          <Text style={styles.footerText}>Don't have an account?</Text>
          <Pressable onPress={() => navigation.navigate('Register')}>
            <Text style={styles.link}> Create account</Text>
          </Pressable>
        </View>
      </KeyboardAvoidingView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  wrapper: {flex: 1, justifyContent: 'space-between'},
  title: {fontSize: 29, fontWeight: '800', color: colors.text, marginTop: 28},
  subtitle: {fontSize: 15, color: colors.textSecondary, marginTop: 9},
  form: {marginTop: 35},
  forgot: {alignSelf: 'flex-end', marginBottom: spacing.lg},
  link: {color: colors.primary, fontWeight: '700'},
  error: {color: colors.danger, marginBottom: 14, fontSize: 13},
  footer: {flexDirection: 'row', justifyContent: 'center', paddingBottom: 15},
  footerText: {color: colors.textSecondary},
});
FILE

write_file apps/mobile/src/features/auth/screens/RegisterScreen.js <<'FILE'
import React, {useState} from 'react';
import {Text, StyleSheet, View, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import TextInput from '../../../components/inputs/TextInput';
import useRegister from '../hooks/useRegister';
import {colors, spacing} from '../../../theme';

export default function RegisterScreen({navigation}) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const {submit, loading, error} = useRegister();
  const [message, setMessage] = useState('');

  const handleRegister = async () => {
    setMessage('');
    const success = await submit({name, email, password});
    if (success) {
      setMessage('Account created. You can now sign in.');
    }
  };

  return (
    <ScreenContainer>
      <Text style={styles.title}>Create account</Text>
      <Text style={styles.subtitle}>Join the VOXO community.</Text>

      <View style={styles.form}>
        <TextInput label="Full name" placeholder="Your name" value={name} onChangeText={setName} />
        <TextInput
          label="Email address"
          placeholder="name@example.com"
          value={email}
          onChangeText={setEmail}
          keyboardType="email-address"
          autoCapitalize="none"
        />
        <TextInput
          label="Password"
          placeholder="At least 8 characters"
          value={password}
          onChangeText={setPassword}
          secureTextEntry
        />
        {error ? <Text style={styles.error}>{error}</Text> : null}
        {message ? <Text style={styles.success}>{message}</Text> : null}
        <PrimaryButton title="Create Account" onPress={handleRegister} loading={loading} />
      </View>

      <Pressable onPress={() => navigation.navigate('Login')} style={styles.footer}>
        <Text style={styles.subtitle}>Already have an account? </Text>
        <Text style={styles.link}>Sign in</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 29, fontWeight: '800', color: colors.text, marginTop: 28},
  subtitle: {fontSize: 15, color: colors.textSecondary, marginTop: 9},
  form: {marginTop: 32},
  error: {color: colors.danger, marginBottom: 12},
  success: {color: colors.success, marginBottom: 12},
  footer: {flexDirection: 'row', justifyContent: 'center', marginTop: 'auto', paddingBottom: spacing.md},
  link: {color: colors.primary, fontWeight: '700', marginTop: 9},
});
FILE

write_file apps/mobile/src/features/auth/screens/ForgotPasswordScreen.js <<'FILE'
import React, {useState} from 'react';
import {Text, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import TextInput from '../../../components/inputs/TextInput';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {authService} from '../services/authService';
import {colors} from '../../../theme';

export default function ForgotPasswordScreen() {
  const [email, setEmail] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [message, setMessage] = useState('');

  const handleSubmit = async () => {
    setError('');
    setMessage('');

    if (!email.trim()) {
      setError('Enter your email address.');
      return;
    }

    setLoading(true);
    try {
      await authService.requestPasswordReset(email.trim().toLowerCase());
      setMessage('If the account exists, reset instructions will be sent.');
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <ScreenContainer>
      <Text style={styles.title}>Forgot password?</Text>
      <Text style={styles.subtitle}>
        Enter your email address to request password reset instructions.
      </Text>
      <TextInput
        label="Email address"
        placeholder="name@example.com"
        value={email}
        onChangeText={setEmail}
        keyboardType="email-address"
        autoCapitalize="none"
        style={styles.input}
      />
      {error ? <Text style={styles.error}>{error}</Text> : null}
      {message ? <Text style={styles.success}>{message}</Text> : null}
      <PrimaryButton title="Send reset instructions" onPress={handleSubmit} loading={loading} />
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text, marginTop: 28},
  subtitle: {fontSize: 15, lineHeight: 23, color: colors.textSecondary, marginVertical: 15},
  input: {marginTop: 12},
  error: {color: colors.danger, marginBottom: 12},
  success: {color: colors.success, marginBottom: 12},
});
FILE

# ==========================================
# HOME SCREEN AND MAIN NAVIGATION
# ==========================================

write_file apps/mobile/src/features/home/screens/HomeScreen.js <<'FILE'
import React from 'react';
import {Text, View, StyleSheet, ScrollView} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {useAuthStore} from '../../auth/store/authStore';
import {authService} from '../../auth/services/authService';
import {colors, spacing} from '../../../theme';

export default function HomeScreen() {
  const user = useAuthStore(state => state.user);

  const displayName =
    user?.name || user?.displayName || user?.username || 'VOXO Member';

  const handleLogout = async () => {
    await authService.logout();
  };

  return (
    <ScreenContainer style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.brand}>VOXO</Text>
        <Text style={styles.greeting}>Hello, {displayName}</Text>
        <Text style={styles.subtitle}>Your community starts here.</Text>

        <View style={styles.heroCard}>
          <Text style={styles.heroTitle}>Discover live experiences</Text>
          <Text style={styles.heroText}>
            Find creators, join live rooms and connect with people.
          </Text>
        </View>

        <Text style={styles.sectionTitle}>Explore VOXO</Text>
        <View style={styles.featureCard}>
          <Text style={styles.featureTitle}>Live streaming</Text>
          <Text style={styles.featureText}>Watch and host live sessions.</Text>
        </View>
        <View style={styles.featureCard}>
          <Text style={styles.featureTitle}>Messages</Text>
          <Text style={styles.featureText}>Chat with your community.</Text>
        </View>
        <View style={styles.featureCard}>
          <Text style={styles.featureTitle}>Your profile</Text>
          <Text style={styles.featureText}>Build your creator identity.</Text>
        </View>

        <View style={styles.logout}>
          <PrimaryButton
            title="Sign Out"
            variant="secondary"
            onPress={handleLogout}
          />
        </View>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {paddingTop: spacing.xl},
  brand: {fontSize: 16, fontWeight: '900', color: colors.primary, letterSpacing: 3},
  greeting: {fontSize: 27, fontWeight: '800', color: colors.text, marginTop: 18},
  subtitle: {fontSize: 15, color: colors.textSecondary, marginTop: 7},
  heroCard: {
    backgroundColor: colors.primary,
    borderRadius: 20,
    padding: 22,
    marginTop: 28,
  },
  heroTitle: {fontSize: 21, fontWeight: '800', color: colors.white},
  heroText: {fontSize: 14, lineHeight: 21, color: colors.white, marginTop: 9},
  sectionTitle: {fontSize: 19, fontWeight: '800', color: colors.text, marginTop: 28, marginBottom: 12},
  featureCard: {
    backgroundColor: colors.surface,
    borderRadius: 15,
    padding: 18,
    marginBottom: 12,
    borderWidth: 1,
    borderColor: colors.border,
  },
  featureTitle: {fontSize: 16, fontWeight: '700', color: colors.text},
  featureText: {fontSize: 13, color: colors.textSecondary, marginTop: 5},
  logout: {marginTop: 20, marginBottom: 30},
});
FILE

write_file apps/mobile/src/navigation/MainTabNavigator.js <<'FILE'
import React from 'react';
import {createBottomTabNavigator} from '@react-navigation/bottom-tabs';
import {Text, View} from 'react-native';
import HomeScreen from '../features/home/screens/HomeScreen';
import {colors} from '../theme';

const Tab = createBottomTabNavigator();

function ComingSoonScreen({route}) {
  return (
    <View style={{flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: colors.background}}>
      <Text style={{fontSize: 22, fontWeight: '700', color: colors.text}}>
        {route.name}
      </Text>
      <Text style={{marginTop: 8, color: colors.textSecondary}}>
        This feature is under development.
      </Text>
    </View>
  );
}

export default function MainTabNavigator() {
  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarActiveTintColor: colors.primary,
        tabBarInactiveTintColor: colors.textSecondary,
      }}>
      <Tab.Screen name="Home" component={HomeScreen} />
      <Tab.Screen name="Discover" component={ComingSoonScreen} />
      <Tab.Screen name="Live" component={ComingSoonScreen} />
      <Tab.Screen name="Chat" component={ComingSoonScreen} />
      <Tab.Screen name="Profile" component={ComingSoonScreen} />
    </Tab.Navigator>
  );
}
FILE

# ==========================================
# FEATURE EXPORTS
# ==========================================

write_file apps/mobile/src/features/auth/index.js <<'FILE'
export {default as AuthNavigator} from './navigation/AuthNavigator';
export {authService} from './services/authService';
export {useAuthStore, authStore} from './store/authStore';
FILE

write_file apps/mobile/src/features/onboarding/index.js <<'FILE'
export {default as OnboardingNavigator} from './navigation/OnboardingNavigator';
FILE

write_file apps/mobile/src/features/home/index.js <<'FILE'
export {default as HomeScreen} from './screens/HomeScreen';
FILE

# ==========================================
# STATUS DOCUMENTATION
# ==========================================

write_file docs/mobile/implementation-status.md <<'FILE'
# VOXO Mobile Implementation Status

## Project decisions
- Project: VOXO
- Platform: React Native with JavaScript
- Architecture: Feature-based
- Development environment: Termux, project root `~/Node/Voxo`
- Implementation order: Onboarding -> Auth -> Home
- Backend and Admin Dashboard are not part of this implementation phase.

## Implemented in the core starter
- App entry point and provider composition
- Root navigation
- Onboarding welcome screen
- Login, registration and forgot-password screens
- Zustand authentication store
- AsyncStorage session persistence
- Axios authentication API service
- Authentication hooks
- Home screen and initial bottom-tab navigation
- Shared theme and basic UI components

## Not implemented yet
- Backend API endpoints
- OTP verification and email verification
- Real password reset delivery
- Social login
- Production token refresh and secure token storage
- Full design system
- Remaining feature screens and their business logic
- LiveKit, Socket.IO and push notifications

## API configuration
Edit `apps/mobile/src/constants/api.js` when the backend address is known.

The current address `http://127.0.0.1:3000/api` assumes the API runs on the same Android device.
FILE

echo ""
echo "======================================"
echo " VOXO CORE IMPLEMENTATION FILES READY"
echo "======================================"
echo "Existing non-empty files were preserved."
