import {useState} from 'react';
import {authService} from '../services/authService';

export default function useLogin() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const submit = async ({email, password}) => {
    setError('');

    if (!email.trim() || !password) {
      setError('Email and password are required.');
      return false;
    }

    setLoading(true);
    try {
      await authService.login(email.trim().toLowerCase(), password);
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  return {submit, loading, error, clearError: () => setError('')};
}
