import { NativeModules, StyleSheet, Text, View } from 'react-native';
import React from 'react';

export default class App extends React.Component {
  constructor() {
    super();

    //Alert.alert(JSON.stringify(NativeModules));
    var cm = NativeModules.CalendarManager;
    cm.addEvent("Hello", "4");
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
