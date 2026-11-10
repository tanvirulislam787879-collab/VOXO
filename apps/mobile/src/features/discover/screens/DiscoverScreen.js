import React from 'react';
import {ScrollView, View, Text, StyleSheet, Pressable} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const categories = ['Music', 'Gaming', 'Lifestyle', 'Education', 'Talk Show'];
const creators = [
  {name: 'Creator One', category: 'Music'},
  {name: 'Creator Two', category: 'Gaming'},
  {name: 'Creator Three', category: 'Lifestyle'},
];

export default function DiscoverScreen({navigation}) {
  return (
    <ScreenContainer>
      <ScrollView showsVerticalScrollIndicator={false}>
        <Text style={styles.title}>Discover</Text>
        <Text style={styles.subtitle}>Find creators and communities.</Text>

        <Pressable
          style={styles.search}
          onPress={() => navigation.navigate('Search')}>
          <Text style={styles.searchText}>Search creators, topics and rooms</Text>
        </Pressable>

        <View style={styles.headingRow}>
          <Text style={styles.heading}>Trending</Text>
          <Pressable onPress={() => navigation.navigate('Trending')}>
            <Text style={styles.link}>See all</Text>
          </Pressable>
        </View>

        <View style={styles.trendingCard}>
          <Text style={styles.trendingLabel}>TRENDING ON VOXO</Text>
          <Text style={styles.trendingTitle}>Discover what's happening</Text>
          <Text style={styles.trendingText}>
            Explore popular conversations and live experiences.
          </Text>
        </View>

        <View style={styles.headingRow}>
          <Text style={styles.heading}>Popular Creators</Text>
          <Pressable onPress={() => navigation.navigate('PopularCreators')}>
            <Text style={styles.link}>See all</Text>
          </Pressable>
        </View>

        {creators.map((creator, index) => (
          <View key={creator.name} style={styles.creator}>
            <View style={styles.avatar}>
              <Text style={styles.avatarText}>{index + 1}</Text>
            </View>
            <View style={{flex: 1}}>
              <Text style={styles.creatorName}>{creator.name}</Text>
              <Text style={styles.creatorCategory}>{creator.category}</Text>
            </View>
            <Text style={styles.demo}>DEMO</Text>
          </View>
        ))}

        <Text style={styles.heading}>Explore Categories</Text>
        <View style={styles.categoryGrid}>
          {categories.map(category => (
            <Pressable
              key={category}
              style={styles.category}
              onPress={() => navigation.navigate('Category', {category})}>
              <Text style={styles.categoryText}>{category}</Text>
            </Pressable>
          ))}
        </View>

        <Text style={styles.note}>Sample content. Creator data will come from the API.</Text>
      </ScrollView>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 14, color: colors.textSecondary, marginTop: 5, marginBottom: 18},
  search: {padding: 16, backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, marginBottom: 24},
  searchText: {color: colors.textSecondary, fontSize: 14},
  headingRow: {flexDirection: 'row', justifyContent: 'space-between', alignItems: 'center', marginBottom: 13, marginTop: 8},
  heading: {fontSize: 19, fontWeight: '800', color: colors.text, marginBottom: 13, marginTop: 8},
  link: {fontSize: 13, color: colors.primary, fontWeight: '700'},
  trendingCard: {padding: 20, borderRadius: 16, backgroundColor: colors.primary, marginBottom: 20},
  trendingLabel: {fontSize: 10, color: '#E5DEFF', fontWeight: '900', letterSpacing: 1},
  trendingTitle: {fontSize: 21, color: colors.white, fontWeight: '800', marginTop: 10},
  trendingText: {fontSize: 13, color: colors.white, marginTop: 7, lineHeight: 20},
  creator: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 13, marginBottom: 9},
  avatar: {width: 42, height: 42, borderRadius: 21, backgroundColor: '#EEE9FF', alignItems: 'center', justifyContent: 'center', marginRight: 12},
  avatarText: {color: colors.primary, fontWeight: '800'},
  creatorName: {fontSize: 14, color: colors.text, fontWeight: '700'},
  creatorCategory: {fontSize: 12, color: colors.textSecondary, marginTop: 4},
  demo: {fontSize: 9, color: colors.textSecondary, fontWeight: '800'},
  categoryGrid: {flexDirection: 'row', flexWrap: 'wrap', gap: 9},
  category: {width: '48%', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 12, padding: 15},
  categoryText: {fontSize: 13, fontWeight: '700', color: colors.text},
  note: {fontSize: 11, color: colors.textSecondary, textAlign: 'center', marginVertical: 20},
});
