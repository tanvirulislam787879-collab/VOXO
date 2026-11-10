import {create} from 'zustand';
import AsyncStorage from '@react-native-async-storage/async-storage';

const STORAGE_KEY = '@voxo/auth-session';

export const authStore = create((set) => ({
  accessToken: null,
  user: null,
  hydrated: false,

  hydrate: async () => {
    try {
      const raw = await AsyncStorage.getItem(STORAGE_KEY);
      if (raw) {
        const session = JSON.parse(raw);
        set({
          accessToken: session.accessToken || null,
          user: session.user || null,
        });
      }
    } catch (error) {
      console.warn('Session hydration failed:', error.message);
    } finally {
      set({hydrated: true});
    }
  },

  setSession: async (session) => {
    const safeSession = {
      accessToken: session.accessToken,
      user: session.user || null,
    };
    await AsyncStorage.setItem(STORAGE_KEY, JSON.stringify(safeSession));
    set(safeSession);
  },

  logout: async () => {
    await AsyncStorage.removeItem(STORAGE_KEY);
    set({accessToken: null, user: null});
  },
}));

export const useAuthStore = authStore;
