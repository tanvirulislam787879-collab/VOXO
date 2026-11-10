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
