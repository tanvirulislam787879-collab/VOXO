# VOXO Mobile Implementation Status

## Project decisions
- Project: VOXO
- Platform: React Native with JavaScript
- Architecture: Feature-based
- Development environment: Termux, project root `~/Node/Voxo`
- Implementation order: Onboarding -> Auth -> Home
- Backend and Admin Dashboard are not part of this implementation phase.

## Implemented in the core starter
- App entry point and provider composition
- Root navigation
- Onboarding welcome screen
- Login, registration and forgot-password screens
- Zustand authentication store
- AsyncStorage session persistence
- Axios authentication API service
- Authentication hooks
- Home screen and initial bottom-tab navigation
- Shared theme and basic UI components

## Not implemented yet
- Backend API endpoints
- OTP verification and email verification
- Real password reset delivery
- Social login
- Production token refresh and secure token storage
- Full design system
- Remaining feature screens and their business logic
- LiveKit, Socket.IO and push notifications

## API configuration
Edit `apps/mobile/src/constants/api.js` when the backend address is known.

The current address `http://127.0.0.1:3000/api` assumes the API runs on the same Android device.
