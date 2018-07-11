import { NativeEventEmitter, NativeModules } from 'react-native';

const { AtlasLocationManager } = NativeModules;
const AtlasLocationMangerEventEmitter = new NativeEventEmitter(AtlasLocationManager);

const Event = {
  StateChange: 'state_change',
  TrackingPositionUpdated: 'tracking_position_updated',
};

const State = {
  Init: 'init',
  Tracking: 'tracking',
  Ready: 'ready',
};

// init - Haven't set up yet
// permissionsFailed - Couldn't get permissions
// permissionsSuccess - Permissions were ok
// ready
// tracking
let state = State.Init;
function setState(newState) {
  state = newState;
  emit(Event.StateChange, newState);
}

AtlasLocationMangerEventEmitter.addListener(
  'trackingStarted',
  () => setState(State.Tracking),
);

AtlasLocationMangerEventEmitter.addListener(
  'trackingStopped',
  () => {
    odometer = 0;
    setState(State.Ready);
  },
);

lastTrackingPosition = null;
AtlasLocationMangerEventEmitter.addListener(
  'trackingPositionUpdated',
  (e) => {
    if (lastTrackingPosition != null) {
      const meters = haversineDistance(
        [lastTrackingPosition.latitude, lastTrackingPosition.longitude],
        [e.latitude, e.longitude],
      );
      odometer += meters;
    }

    lastTrackingPosition = e;
    emit(Event.TrackingPositionUpdated, {
      ...e,
      accuracy: e.horizontalAccuracy,
      odometer,
    });
  },
);


function getRoughLocation() {
  return AtlasLocationManager.getRoughLocation();
}

function startTracking() {
  if (state == State.Init || state == State.Ready) {
    return AtlasLocationManager.startTracking(); 
  }
}

function stopTracking() {
  if (state == State.Tracking) {
    return AtlasLocationManager.stopTracking();
  }
}

odometer = 0;
function resetOdometer(val) {
  odometer = val;
}

function genId() {
  let text = '';
  const possible = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

  for (let i=0; i < 10; i++) { text += possible.charAt(Math.floor(Math.random() * possible.length)); }

  return text;
}

const eventHandlers = {};
function on(name, f) {
  const id = genId();
  eventHandlers[name] = eventHandlers[name] || {};
  eventHandlers[name][id] = f;
  return id;
}


function off(name, id) {
  const handlers = eventHandlers[name];
  if (handlers == null) { 
    console.log(`[RNAtlasLocation] - Couldn't deregister event named ${name}, it didn't exist`);
    return; 
  }

  if (handlers[id] == null) {
    console.log(`[RNAtlasLocation] - Couldn't deregister function for event ${name} with id ${id}. Id was not registered.`);
    return; 
  }

  delete handlers[id];
}

function emit(name, args) {
  const ev = eventHandlers[name] || {};
  for (const f of Object.values(ev)) { f(args); }
}

function haversineDistance(coords1, coords2) {
  function toRad(x) {
    return x * Math.PI / 180;
  }

  const lon1 = coords1[0];
  const lat1 = coords1[1];

  const lon2 = coords2[0];
  const lat2 = coords2[1];

  const R = 6371; // km

  const x1 = lat2 - lat1;
  const dLat = toRad(x1);
  const x2 = lon2 - lon1;
  const dLon = toRad(x2);
  const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const d = R * c;

  return d*1000;
}


export default {
  getRoughLocation,
  startTracking,
  stopTracking,
  on,
  off,
  Event,
  State,
};
