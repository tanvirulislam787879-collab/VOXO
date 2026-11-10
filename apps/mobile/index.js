import { AppRegistry } from 'react-native';
import { name as appName } from './app.json';
import { registerGlobals } from '@livekit/react-native';

// Initialize WebRTC and LiveKit polyfills
// before loading the application.
registerGlobals();

// Load application after LiveKit initialization.
const MobileApp = require('./App').default;

AppRegistry.registerComponent(appName, () => MobileApp);
