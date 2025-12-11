import React from "react";
import { NavigationContainer } from "@react-navigation/native";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import LoginScreen from "./src/screens/Login";
import HomeScreen from "./src/screens/Home";
import SettingsScreen from "./src/screens/Settings";
import BlockedScreen from "./src/screens/Blocked";

const Stack = createNativeStackNavigator();

export default function App() {
  return (
    <NavigationContainer>
      <Stack.Navigator initialRouteName="Login" screenOptions={{headerShown:false}}>
        <Stack.Screen name="Login" component={LoginScreen}/>
        <Stack.Screen name="Home" component={HomeScreen}/>
        <Stack.Screen name="Settings" component={SettingsScreen}/>
        <Stack.Screen name="Blocked" component={BlockedScreen}/>
      </Stack.Navigator>
    </NavigationContainer>
  );
}
