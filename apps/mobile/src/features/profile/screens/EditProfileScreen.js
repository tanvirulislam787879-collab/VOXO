import React, {useState} from 'react';
import {View, Text, TextInput, Pressable, StyleSheet, Alert} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {useAuthStore} from '../../auth/store/authStore';
import {colors} from '../../../theme';

export default function EditProfileScreen() {
  const user = useAuthStore(state => state.user);
  const [name, setName] = useState(user?.name || user?.displayName || '');
  const [bio, setBio] = useState(user?.bio || '');

  return (
    <ScreenContainer>
      <Text style={styles.title}>Edit Profile</Text>
      <Text style={styles.label}>Display Name</Text>
      <TextInput value={name} onChangeText={setName} style={styles.input} placeholder="Your name" placeholderTextColor={colors.textSecondary} />
      <Text style={styles.label}>Bio</Text>
      <TextInput value={bio} onChangeText={setBio} style={[styles.input, styles.bio]} multiline placeholder="Tell people about yourself" placeholderTextColor={colors.textSecondary} />
      <Pressable
        style={styles.button}
        onPress={() => Alert.alert('Preview only', 'Profile saving will be connected to the backend API.')}>
        <Text style={styles.buttonText}>Save Changes</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 25, fontWeight: '800', color: colors.text, marginBottom: 24},
  label: {fontSize: 13, fontWeight: '700', color: colors.text, marginBottom: 8},
  input: {height: 52, borderWidth: 1, borderColor: colors.border, borderRadius: 12, backgroundColor: colors.surface, paddingHorizontal: 14, color: colors.text, marginBottom: 18},
  bio: {height: 110, textAlignVertical: 'top', paddingTop: 13},
  button: {height: 52, backgroundColor: colors.primary, borderRadius: 13, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontWeight: '800'},
});
