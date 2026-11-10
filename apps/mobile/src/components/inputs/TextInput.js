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
