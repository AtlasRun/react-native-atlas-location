import { Alert, StyleSheet, Text, View } from 'react-native';
import { getRoughLocation } from 'react-native-atlas-location';
import React from 'react';

export default class App extends React.Component {
  constructor() {
    super();

    //Alert.alert(JSON.stringify(NativeModules));
    this.lol();
  }

  async lol() {
    //var cm = NativeModules.LocationManager;
    //const events = await cm.getRoughLocation();
    getRoughLocation().then((e) => {
      Alert.alert(e.latitude.toString())
    })
  }
  render() {
    return (
      <View style={styles.container}>
        <Text>Open up App.js to start working on your app!</Text>
        <Text>Changes you make will automatically reload.</Text>
        <Text>Shake your phone to open the developer menu.</Text>
      </View>
    );
  }
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
