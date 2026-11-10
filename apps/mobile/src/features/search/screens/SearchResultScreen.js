import React from 'react';
import {View, Text, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function SearchResultScreen({route}) {
  const item = route.params?.item;

  return (
    <ScreenContainer>
      <View style={styles.card}>
        <Text style={styles.avatar}>{item?.name?.charAt(0) || '?'}</Text>
        <Text style={styles.title}>{item?.name || 'Search result'}</Text>
        <Text style={styles.subtitle}>{item?.type || 'VOXO item'}</Text>
        <Text style={styles.note}>
          This is a sample result. The real creator or room detail page will be connected to the backend.
        </Text>
      </View>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  card: {flex: 1, alignItems: 'center', justifyContent: 'center'},
  avatar: {fontSize: 34, color: colors.primary, fontWeight: '900', backgroundColor: '#EEE9FF', overflow: 'hidden', padding: 22, borderRadius: 60},
  title: {fontSize: 23, fontWeight: '800', color: colors.text, marginTop: 18},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 7},
  note: {fontSize: 13, color: colors.textSecondary, textAlign: 'center', lineHeight: 21, marginTop: 20},
});
