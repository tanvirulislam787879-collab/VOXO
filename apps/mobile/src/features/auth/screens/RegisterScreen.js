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

  const handleRegister = async () => {
    await submit({name, email, password});
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
  footer: {flexDirection: 'row', justifyContent: 'center', marginTop: 'auto', paddingBottom: spacing.md},
  link: {color: colors.primary, fontWeight: '700', marginTop: 9},
});
