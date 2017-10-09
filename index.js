import { NativeModules } from 'react-native';

const man = NativeModules.LocationManager;

// Returns {latitude, longitude}
export function getRoughLocation() {
  return man.getRoughLocation();
}
