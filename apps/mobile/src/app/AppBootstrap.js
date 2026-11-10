import React, {useEffect} from 'react';
import {authStore} from '../features/auth/store/authStore';

export default function AppBootstrap({children}) {
  useEffect(() => {
    authStore.getState().hydrate();
  }, []);

  return children;
}
