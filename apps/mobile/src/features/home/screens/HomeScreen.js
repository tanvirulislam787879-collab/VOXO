import React from 'react';
import {
  ScrollView,
  View,
  Text,
  StyleSheet,
} from 'react-native';

import ScreenContainer from '../../../components/common/ScreenContainer';
import {useAuthStore} from '../../auth/store/authStore';
import {colors, spacing} from '../../../theme';

const liveCreators = [
  {name: 'Creator One', category: 'Music', viewers: '1.2K'},
  {name: 'Creator Two', category: 'Talk Show', viewers: '850'},
  {name: 'Creator Three', category: 'Gaming', viewers: '620'},
];

const categories = ['Music', 'Gaming', 'Talk Show', 'Lifestyle', 'Education'];

function SectionTitle({title, subtitle}) {
  return (
    <View style={styles.sectionHeader}>
      <View>
        <Text style={styles.sectionTitle}>{title}</Text>
        {subtitle ? <Text style={styles.sectionSubtitle}>{subtitle}</Text> : null}
      </View>
    </View>
  );
}

export default function HomeScreen() {
  const user = useAuthStore(state => state.user);

  const displayName =
    user?.name || user?.displayName || user?.username || 'VOXO Member';

  return (
    <ScreenContainer style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        <View style={styles.header}>
          <View>
            <Text style={styles.brand}>VOXO</Text>
            <Text style={styles.greeting}>Hello, {displayName}</Text>
            <Text style={styles.subtitle}>Your world. Your community.</Text>
          </View>
          <View style={styles.avatar}>
            <Text style={styles.avatarText}>
              {displayName.charAt(0).toUpperCase()}
            </Text>
          </View>
        </View>

        <View style={styles.hero}>
          <Text style={styles.heroEyebrow}>WELCOME TO VOXO</Text>
          <Text style={styles.heroTitle}>Discover a world of live experiences</Text>
          <Text style={styles.heroDescription}>
            Watch creators, meet new people and share your moments.
          </Text>
        </View>

        <SectionTitle
          title="Live Now"
          subtitle="Creators who are streaming"
        />

        {liveCreators.map((creator, index) => (
          <View key={creator.name} style={styles.creatorCard}>
            <View style={styles.creatorAvatar}>
              <Text style={styles.creatorAvatarText}>
                {creator.name.charAt(0)}
              </Text>
            </View>
            <View style={styles.creatorInfo}>
              <Text style={styles.creatorName}>{creator.name}</Text>
              <Text style={styles.creatorCategory}>{creator.category}</Text>
            </View>
            <View style={styles.liveInfo}>
              <Text style={styles.liveBadge}>LIVE</Text>
              <Text style={styles.viewerCount}>{creator.viewers} viewers</Text>
            </View>
          </View>
        ))}

        <SectionTitle
          title="Explore Categories"
          subtitle="Find content you enjoy"
        />

        <View style={styles.categoryGrid}>
          {categories.map((category, index) => (
            <View key={category} style={styles.categoryCard}>
              <Text style={styles.categoryNumber}>0{index + 1}</Text>
              <Text style={styles.categoryName}>{category}</Text>
            </View>
          ))}
        </View>

        <SectionTitle title="For You" subtitle="Recommended for your feed" />

        <View style={styles.recommendationCard}>
          <Text style={styles.recommendationTitle}>Your next discovery starts here</Text>
          <Text style={styles.recommendationText}>
            Follow creators and explore live rooms to personalize your feed.
          </Text>
        </View>

        <Text style={styles.demoNote}>
          Preview content only. Live data will be connected in a later phase.
        </Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  container: {paddingTop: spacing.md},
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 22,
  },
  brand: {
    color: colors.primary,
    fontSize: 16,
    fontWeight: '900',
    letterSpacing: 3,
  },
  greeting: {
    color: colors.text,
    fontSize: 24,
    fontWeight: '800',
    marginTop: 10,
  },
  subtitle: {
    color: colors.textSecondary,
    fontSize: 13,
    marginTop: 5,
  },
  avatar: {
    width: 46,
    height: 46,
    borderRadius: 23,
    backgroundColor: colors.primary,
    justifyContent: 'center',
    alignItems: 'center',
  },
  avatarText: {color: colors.white, fontSize: 20, fontWeight: '800'},
  hero: {
    backgroundColor: colors.primary,
    borderRadius: 20,
    padding: 22,
    marginBottom: 26,
  },
  heroEyebrow: {
    color: '#E5DEFF',
    fontSize: 11,
    fontWeight: '800',
    letterSpacing: 1.5,
  },
  heroTitle: {
    color: colors.white,
    fontSize: 23,
    fontWeight: '800',
    marginTop: 12,
    lineHeight: 30,
  },
  heroDescription: {
    color: colors.white,
    opacity: 0.9,
    fontSize: 14,
    lineHeight: 21,
    marginTop: 9,
  },
  sectionHeader: {marginBottom: 13, marginTop: 5},
  sectionTitle: {fontSize: 19, fontWeight: '800', color: colors.text},
  sectionSubtitle: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  creatorCard: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 13,
    marginBottom: 10,
    borderRadius: 15,
    backgroundColor: colors.surface,
    borderWidth: 1,
    borderColor: colors.border,
  },
  creatorAvatar: {
    width: 44,
    height: 44,
    borderRadius: 22,
    backgroundColor: '#EEE9FF',
    alignItems: 'center',
    justifyContent: 'center',
  },
  creatorAvatarText: {fontSize: 18, color: colors.primary, fontWeight: '800'},
  creatorInfo: {flex: 1, marginLeft: 12},
  creatorName: {fontSize: 14, fontWeight: '700', color: colors.text},
  creatorCategory: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  liveInfo: {alignItems: 'flex-end'},
  liveBadge: {
    color: colors.white,
    backgroundColor: colors.danger,
    overflow: 'hidden',
    borderRadius: 5,
    paddingHorizontal: 7,
    paddingVertical: 3,
    fontSize: 10,
    fontWeight: '900',
  },
  viewerCount: {fontSize: 10, color: colors.textSecondary, marginTop: 5},
  categoryGrid: {flexDirection: 'row', flexWrap: 'wrap', gap: 9},
  categoryCard: {
    width: '48%',
    backgroundColor: colors.surface,
    borderColor: colors.border,
    borderWidth: 1,
    borderRadius: 13,
    padding: 14,
    marginBottom: 2,
  },
  categoryNumber: {fontSize: 10, color: colors.primary, fontWeight: '800'},
  categoryName: {fontSize: 14, color: colors.text, fontWeight: '700', marginTop: 7},
  recommendationCard: {
    backgroundColor: colors.surface,
    borderRadius: 15,
    padding: 18,
    borderWidth: 1,
    borderColor: colors.border,
  },
  recommendationTitle: {fontSize: 15, fontWeight: '800', color: colors.text},
  recommendationText: {
    fontSize: 13,
    color: colors.textSecondary,
    lineHeight: 20,
    marginTop: 7,
  },
  demoNote: {
    fontSize: 11,
    color: colors.textSecondary,
    textAlign: 'center',
    marginTop: 20,
    marginBottom: 20,
  },
});
