import { NativeEventEmitter, NativeModules } from 'react-native';

const { AtlasLocationManager } = NativeModules;
const AtlasLocationMangerEventEmitter = new NativeEventEmitter(AtlasLocationManager);

const Event = {
  StateChange: 'state_change',
  TrackingPositionUpdated: 'tracking_position_updated'
}

const State = {
  Init: 'init',
  Tracking: 'tracking',
  Ready: 'ready',
}

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
  () => setState(State.Tracking)
);

AtlasLocationMangerEventEmitter.addListener(
  'trackingStopped',
  () => {
    odometer = 0;
    setState(State.Ready)
  }
);

lastTrackingPosition = null;
AtlasLocationMangerEventEmitter.addListener(
  'trackingPositionUpdated',
  (e) => {
    if (lastTrackingPosition != null) {
      const meters = haversineDistance(
        [lastTrackingPosition.latitude, lastTrackingPosition.longitude],
        [e.latitude, e.longitude]
      )
      odometer += meters;
    }

    lastTrackingPosition = e;
    emit(Event.TrackingPositionUpdated, {
      ...e,
      accuracy: e.horizontalAccuracy,
      odometer
    })
  }
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

const eventHandlers = {};
function on(name, f) {
  eventHandlers[name] = eventHandlers[name] || [];
  eventHandlers[name].push(f);
}

function emit(name, args) {
  const ev = eventHandlers[name] || [];
  for (var f of ev) { f(args); }
}

function haversineDistance(coords1, coords2) {
  function toRad(x) {
    return x * Math.PI / 180;
  }

  var lon1 = coords1[0];
  var lat1 = coords1[1];

  var lon2 = coords2[0];
  var lat2 = coords2[1];

  var R = 6371; // km

  var x1 = lat2 - lat1;
  var dLat = toRad(x1);
  var x2 = lon2 - lon1;
  var dLon = toRad(x2)
  var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRad(lat1)) * Math.cos(toRad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  var d = R * c;

  return d*1000;
}


export default {
  getRoughLocation,
  startTracking,
  stopTracking,
  on,
  Event,
  State,
}
