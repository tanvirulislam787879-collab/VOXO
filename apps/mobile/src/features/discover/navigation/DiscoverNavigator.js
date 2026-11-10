import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';

import DiscoverScreen from '../screens/DiscoverScreen';
import SearchScreen from '../../search/screens/SearchScreen';
import SearchResultScreen from '../../search/screens/SearchResultScreen';
import {colors} from '../../../theme';

const Stack = createNativeStackNavigator();

function CollectionScreen({route}) {
  const title = route.params?.title || route.name;
  const description = route.params?.description || 'Explore this VOXO collection.';

  return (
    <ScreenCollection title={title} description={description} />
  );
}

function ScreenCollection({title, description}) {
  const ReactNative = require('react-native');
  const View = ReactNative.View;
  const Text = ReactNative.Text;
  return (
    <View style={{flex: 1, backgroundColor: colors.background, padding: 22}}>
      <Text style={{fontSize: 24, fontWeight: '800', color: colors.text}}>{title}</Text>
      <Text style={{fontSize: 14, color: colors.textSecondary, marginTop: 9}}>{description}</Text>
      <Text style={{fontSize: 12, color: colors.textSecondary, marginTop: 20}}>
        Sample collection. API data will be connected later.
      </Text>
    </View>
  );
}

export default function DiscoverNavigator() {
  return (
    <Stack.Navigator screenOptions={{headerShown: true, headerTintColor: colors.primary}}>
      <Stack.Screen name="DiscoverHome" component={DiscoverScreen} options={{title: 'Discover'}} />
      <Stack.Screen name="Search" component={SearchScreen} options={{title: 'Search'}} />
      <Stack.Screen name="SearchResult" component={SearchResultScreen} options={{title: 'Result'}} />
      <Stack.Screen
        name="Trending"
        component={CollectionScreen}
        initialParams={{title: 'Trending', description: 'Popular topics and conversations.'}}
      />
      <Stack.Screen
        name="PopularCreators"
        component={CollectionScreen}
        initialParams={{title: 'Popular Creators', description: 'Creators people are exploring.'}}
      />
      <Stack.Screen
        name="Category"
        component={CollectionScreen}
        options={({route}) => ({title: route.params?.category || 'Category'})}
      />
    </Stack.Navigator>
  );
}
