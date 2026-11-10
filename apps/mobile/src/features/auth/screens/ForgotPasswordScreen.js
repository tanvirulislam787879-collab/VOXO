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
