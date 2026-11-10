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
