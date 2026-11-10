import {useState} from 'react';
import {authService} from '../services/authService';

export default function useRegister() {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const submit = async ({name, email, password}) => {
    setError('');

    if (!name.trim() || !email.trim() || !password) {
      setError('Please complete all fields.');
      return false;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters.');
      return false;
    }

    setLoading(true);
    try {
      await authService.register({
        displayName: name.trim(),
        email: email.trim().toLowerCase(),
        password,
      });
      return true;
    } catch (err) {
      setError(err.message);
      return false;
    } finally {
      setLoading(false);
    }
  };

  return {submit, loading, error};
}
