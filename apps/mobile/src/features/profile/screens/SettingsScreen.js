import React, {useState} from 'react';
import {View, Text, Switch, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function SettingsScreen() {
  const [notifications, setNotifications] = useState(true);
  const [sound, setSound] = useState(true);

  return (
    <ScreenContainer>
      <Text style={styles.title}>Settings</Text>

      <View style={styles.row}>
        <View style={{flex: 1}}>
          <Text style={styles.label}>Notifications</Text>
          <Text style={styles.description}>Local preview setting</Text>
        </View>
        <Switch value={notifications} onValueChange={setNotifications} />
      </View>

      <View style={styles.row}>
        <View style={{flex: 1}}>
          <Text style={styles.label}>App sounds</Text>
          <Text style={styles.description}>Local preview setting</Text>
        </View>
        <Switch value={sound} onValueChange={setSound} />
      </View>

      <Text style={styles.note}>
        These settings are temporary and are not saved to the server or device storage yet.
      </Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 26, fontWeight: '800', color: colors.text, marginBottom: 20},
  row: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 16, marginBottom: 12},
  label: {fontSize: 14, color: colors.text, fontWeight: '700'},
  description: {fontSize: 11, color: colors.textSecondary, marginTop: 5},
  note: {fontSize: 12, color: colors.textSecondary, lineHeight: 19, marginTop: 15},
});
