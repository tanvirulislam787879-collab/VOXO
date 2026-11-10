import React, {useState} from 'react';
import {View, Text, TextInput, Pressable, FlatList, StyleSheet} from 'react-native';
import ScreenContainer from '../../../components/common/ScreenContainer';
import {colors} from '../../../theme';

const sampleResults = [
  {id: '1', name: 'Creator One', type: 'Creator · Music'},
  {id: '2', name: 'Creator Two', type: 'Creator · Gaming'},
  {id: '3', name: 'Music Lounge', type: 'Live room · Music'},
  {id: '4', name: 'VOXO Community', type: 'Community'},
];

export default function SearchScreen({navigation}) {
  const [query, setQuery] = useState('');

  const results = sampleResults.filter(item =>
    `${item.name} ${item.type}`.toLowerCase().includes(query.trim().toLowerCase()),
  );

  return (
    <ScreenContainer>
      <Text style={styles.title}>Search</Text>
      <Text style={styles.subtitle}>Find creators, rooms and communities.</Text>

      <TextInput
        value={query}
        onChangeText={setQuery}
        placeholder="Search VOXO..."
        placeholderTextColor={colors.textSecondary}
        autoCapitalize="none"
        returnKeyType="search"
        style={styles.input}
      />

      <Text style={styles.heading}>
        {query.trim() ? 'Search Results' : 'Suggested'}
      </Text>

      {results.length === 0 ? (
        <Text style={styles.empty}>No matching demo results.</Text>
      ) : (
        <FlatList
          data={results}
          keyExtractor={item => item.id}
          keyboardShouldPersistTaps="handled"
          renderItem={({item}) => (
            <Pressable
              style={styles.result}
              onPress={() => navigation.navigate('SearchResult', {item})}>
              <View style={styles.avatar}>
                <Text style={styles.avatarText}>{item.name.charAt(0)}</Text>
              </View>
              <View style={{flex: 1}}>
                <Text style={styles.name}>{item.name}</Text>
                <Text style={styles.type}>{item.type}</Text>
              </View>
              <Text style={styles.arrow}>›</Text>
            </Pressable>
          )}
        />
      )}
      <Text style={styles.note}>Search currently uses local sample data, not a server.</Text>
    </ScreenContainer>
  );
}

const styles = StyleSheet.create({
  title: {fontSize: 27, fontWeight: '800', color: colors.text},
  subtitle: {fontSize: 13, color: colors.textSecondary, marginTop: 5, marginBottom: 18},
  input: {height: 52, borderRadius: 13, borderWidth: 1, borderColor: colors.border, backgroundColor: colors.surface, paddingHorizontal: 15, color: colors.text, fontSize: 15},
  heading: {fontSize: 17, fontWeight: '800', color: colors.text, marginTop: 24, marginBottom: 12},
  result: {flexDirection: 'row', alignItems: 'center', backgroundColor: colors.surface, borderWidth: 1, borderColor: colors.border, borderRadius: 13, padding: 13, marginBottom: 9},
  avatar: {width: 42, height: 42, borderRadius: 21, backgroundColor: '#EEE9FF', alignItems: 'center', justifyContent: 'center', marginRight: 12},
  avatarText: {color: colors.primary, fontWeight: '800'},
  name: {fontSize: 14, color: colors.text, fontWeight: '700'},
  type: {fontSize: 11, color: colors.textSecondary, marginTop: 4},
  arrow: {fontSize: 22, color: colors.textSecondary},
  empty: {color: colors.textSecondary, marginTop: 25, textAlign: 'center'},
  note: {fontSize: 11, color: colors.textSecondary, marginTop: 20},
});
