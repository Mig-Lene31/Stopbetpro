import React from "react";
import {View, Text, Button} from "react-native";

export default function Home({navigation}) {
  return (
    <View style={{flex:1,justifyContent:"center",alignItems:"center"}}>
      <Text style={{fontSize:20, marginBottom:20}}>StopBet Pro — Painel</Text>
      <Button title="Configurações" onPress={()=>navigation.navigate("Settings")} />
      <View style={{height:12}} />
      <Button title="Simular Bloqueio (teste)" onPress={()=>navigation.navigate("Blocked",{reason:"Teste manual"})} />
    </View>
  );
}
