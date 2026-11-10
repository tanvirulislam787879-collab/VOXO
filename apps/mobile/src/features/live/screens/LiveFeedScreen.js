import React from 'react';
import {ScrollView, View, Text, Pressable, StyleSheet} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const rooms = [
  {id: '1', title: 'Music Lounge', host: 'Creator One', viewers: '1.2K'},
  {id: '2', title: 'Friendly Talk', host: 'Creator Two', viewers: '850'},
  {id: '3', title: 'Gaming Arena', host: 'Creator Three', viewers: '620'},
];

export default function LiveFeedScreen({navigation}) {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Live</Text>
        <Text style={styles.subtitle}>Watch live experiences from creators.</Text>

        <View style={styles.hostCard}>
          <Text style={styles.hostTitle}>Ready to go live?</Text>
          <Text style={styles.hostDescription}>
            Broadcasting will be enabled after LiveKit integration.
          </Text>
          <Text style={styles.hostStatus}>BROADCASTING: NOT CONNECTED</Text>
        </View>

        <Text style={styles.sectionTitle}>Live Rooms</Text>

        {rooms.map(room => (
          <Pressable
            key={room.id}
            style={styles.roomCard}
            onPress={() => navigation.navigate('LiveRoom', {room})}>
            <View style={styles.roomCover}>
              <Text style={styles.liveBadge}>LIVE DEMO</Text>
              <Text style={styles.coverText}>VOXO LIVE</Text>
            </View>
            <View style={styles.roomDetails}>
              <View style={{flex: 1}}>
                <Text style={styles.roomTitle}>{room.title}</Text>
                <Text style={styles.hostName}>Host: {room.host}</Text>
              </View>
              <Text style={styles.viewers}>{room.viewers} viewers</Text>
            </View>
          </Pressable>
        ))}

        <Text style={styles.note}>Demo rooms only. No real video stream is connected.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 6, marginBottom: 20},
  hostCard: {backgroundColor: colors.primary, padding: 20, borderRadius: 17, marginBottom: 25},
  hostTitle: {fontSize: 20, fontWeight: '800', color: colors.white},
  hostDescription: {fontSize: 13, lineHeight: 20, color: colors.white, marginTop: 8},
  hostStatus: {fontSize: 10, color: '#E5DEFF', fontWeight: '800', marginTop: 14},
  sectionTitle: {fontSize: 19, fontWeight: '800', color: colors.text, marginBottom: 13},
  roomCard: {backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 15, overflow: 'hidden', marginBottom: 15},
  roomCover: {height: 125, backgroundColor: '#33236D', alignItems: 'center', justifyContent: 'center'},
  liveBadge: {position: 'absolute', top: 12, left: 12, backgroundColor: colors.danger, color: colors.white, overflow: 'hidden', paddingHorizontal: 8, paddingVertical: 4, borderRadius: 5, fontSize: 10, fontWeight: '900'},
  coverText: {fontSize: 22, color: colors.white, fontWeight: '900', letterSpacing: 3},
  roomDetails: {padding: 14, flexDirection: 'row', alignItems: 'center'},
  roomTitle: {fontSize: 15, fontWeight: '800', color: colors.text},
  hostName: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  viewers: {fontSize: 11, color: colors.textSecondary},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginVertical: 18},
});
