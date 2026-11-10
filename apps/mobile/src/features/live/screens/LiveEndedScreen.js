import React from 'react';
import {View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function LiveEndedScreen({navigation}) {
  return (
    <ScreenContainer style={styles.container}>
      <View style={styles.content}>
        <Text style={styles.icon}>✓</Text>
        <Text style={styles.title}>You left the room</Text>
        <Text style={styles.subtitle}>This demo session has ended.</Text>
      </View>
      <Pressable style={styles.button} onPress={() => navigation.popToTop()}>
        <Text style={styles.buttonText}>Back to Live</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {justifyContent: 'space-between'},
  content: {flex: 1, alignItems: 'center', justifyContent: 'center'},
  icon: {fontSize: 34, color: colors.success, fontWeight: '900'},
  title: {fontSize: 23, fontWeight: '800', color: colors.text, marginTop: 15},
  subtitle: {fontSize: 13, color: colors.textSecondary, marginTop: 8},
  button: {height: 52, borderRadius: 13, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontWeight: '800'},
});
