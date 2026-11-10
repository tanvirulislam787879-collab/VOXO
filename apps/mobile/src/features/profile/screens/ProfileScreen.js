import React, {useState} from 'react';
import {ScrollView, View, Text, StyleSheet, Pressable, Alert} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import PrimaryButton from '../../../components/buttons/PrimaryButton';
import {useAuthStore} from '../../auth/store/authStore';
import {authService} from '../../auth/services/authService';
import {colors} from '../../../theme';

export default function ProfileScreen({navigation}) {
  const user = useAuthStore(state => state.user);
  const [loading, setLoading] = useState(false);

  const name = user?.name || user?.displayName || user?.username || 'VOXO Member';
  const email = user?.email || 'No email available';

  const handleLogout = async () => {
    if (loading) return;
    setLoading(true);
    try {
      await authService.logout();
    } catch (error) {
      Alert.alert('Sign out failed', error?.message || 'Please try again.');
    } finally {
      setLoading(false);
    }
  };

  const menu = [
    {label: 'Edit Profile', route: 'EditProfile'},
    {label: 'My Followers', route: null},
    {label: 'Following', route: null},
    {label: 'Settings', route: 'Settings'},
    {label: 'Help & Support', route: null},
  ];

  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>My Profile</Text>

        <View style={styles.profileCard}>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>{name.charAt(0).toUpperCase()}</Text>
          </View>
          <Text style={styles.name}>{name}</Text>
          <Text style={styles.email}>{email}</Text>
          <Text style={styles.member}>VOXO MEMBER</Text>
        </View>

        <Text style={styles.sectionTitle}>Account</Text>

        {menu.map(item => (
          <Pressable
            key={item.label}
            style={styles.menuItem}
            onPress={() => {
              if (item.route) {
                navigation.navigate(item.route);
              } else {
                Alert.alert('Coming soon', `${item.label} will be implemented in a later feature phase.`);
              }
            }}>
            <Text style={styles.menuText}>{item.label}</Text>
            <Text style={styles.arrow}>›</Text>
          </Pressable>
        ))}

        <View style={styles.logout}>
          <PrimaryButton
            title="Sign Out"
            variant="secondary"
            loading={loading}
            disabled={loading}
            onPress={handleLogout}
          />
        </View>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text, marginBottom: 20},
  profileCard: {alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 18, padding: 24},
  avatar: {width: 76, height: 76, borderRadius: 38, backgroundColor: colors.primary, alignItems: 'center', justifyContent: 'center'},
  avatarText: {fontSize: 30, fontWeight: '900', color: colors.white},
  name: {fontSize: 20, fontWeight: '800', color: colors.text, marginTop: 13},
  email: {fontSize: 13, color: colors.textSecondary, marginTop: 5},
  member: {fontSize: 10, fontWeight: '900', color: colors.primary, marginTop: 12, letterSpacing: 1.5},
  sectionTitle: {fontSize: 18, fontWeight: '800', color: colors.text, marginTop: 25, marginBottom: 10},
  menuItem: {flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 16, marginBottom: 9},
  menuText: {fontSize: 14, fontWeight: '600', color: colors.text},
  arrow: {fontSize: 22, color: colors.textSecondary},
  logout: {marginTop: 22, marginBottom: 20},
});
