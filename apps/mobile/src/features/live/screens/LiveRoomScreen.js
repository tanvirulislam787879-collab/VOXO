import React from 'react';
import {View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

export default function LiveRoomScreen({route, navigation}) {
  const room = route.params?.room || {title: 'Demo Live Room', host: 'VOXO Creator'};

  return (
    <ScreenContainer style={styles.container}>
      <View style={styles.stage}>
        <Text style={styles.live}>LIVE PREVIEW</Text>
        <Text style={styles.stageTitle}>{room.title}</Text>
        <Text style={styles.host}>Host: {room.host}</Text>
        <Text style={styles.videoNotice}>Video stream is not connected</Text>
      </View>

      <Text style={styles.info}>
        This is a navigation preview. Camera, microphone, viewer count and realtime chat will be implemented with LiveKit and the backend.
      </Text>

      <Pressable
        style={styles.button}
        onPress={() => navigation.replace('LiveEnded', {room})}>
        <Text style={styles.buttonText}>Leave Room</Text>
      </Pressable>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {justifyContent: 'space-between'},
  stage: {flex: 1, backgroundColor: '#21164A', borderRadius: 20, alignItems: 'center', justifyContent: 'center', padding: 20},
  live: {color: '#FF8AAE', fontSize: 12, fontWeight: '900', letterSpacing: 1},
  stageTitle: {color: colors.white, fontSize: 25, fontWeight: '900', marginTop: 18, textAlign: 'center'},
  host: {color: colors.white, fontSize: 14, marginTop: 8},
  videoNotice: {color: '#D6CFFF', fontSize: 12, marginTop: 35},
  info: {fontSize: 12, color: colors.textSecondary, lineHeight: 19, marginVertical: 16},
  button: {height: 52, backgroundColor: colors.danger, borderRadius: 13, alignItems: 'center', justifyContent: 'center'},
  buttonText: {color: colors.white, fontSize: 15, fontWeight: '800'},
});
