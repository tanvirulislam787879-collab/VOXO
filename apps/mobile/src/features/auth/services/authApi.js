import apiClient from '../../../services/apiClient';

function normalizeError(error) {
  const message = error?.response?.data?.message;

  if (Array.isArray(message)) {
    return message.join(', ');
  }

  return (
    message ||
    error?.message ||
    'Something went wrong. Please try again.'
  );
}

async function request(method, url, payload) {
  try {
    const response = await apiClient.request({
      method,
      url,
      data: payload,
    });

    return response.data;
  } catch (error) {
    throw new Error(normalizeError(error));
  }
}

export const authApi = {
  login(payload) {
    return request('POST', '/auth/login', payload);
  },

  register(payload) {
    return request('POST', '/auth/register', payload);
  },

  async requestPasswordReset() {
    throw new Error(
      'Password reset is not available yet. Please contact support.',
    );
  },
};
