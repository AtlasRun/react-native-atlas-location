import { NativeModules, NativeEventEmitter } from 'react-native';

const man = NativeModules.LocationManager;

const locEmitter = new NativeEventEmitter(NativeModules.LocationManager);

// Returns {latitude, longitude}
export function getRoughLocation() {
  return man.getRoughLocation();
}

export function startTracking() {
  return man.startTracking();
}

export function stopTracking() {
  return man.startTracking();
}

