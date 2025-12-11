import React, {useState, useEffect} from "react";
import {View, Text, TextInput, Button, Alert} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";

const KEY = "stopbet_prefs_v1";

export default function Settings() {
  const [deposit, setDeposit] = useState("");
  const [stopWin, setStopWin] = useState("");
  const [stopLoss, setStopLoss] = useState("");
  const [dailySeconds, setDailySeconds] = useState("");

  useEffect(()=>{ (async ()=>{
    const s = await AsyncStorage.getItem(KEY);
    if (s) {
      try {
        const obj = JSON.parse(s);
        setDeposit(String(obj.rules?.deposit ?? ""));
        setStopWin(String(obj.rules?.stopWin ?? ""));
        setStopLoss(String(obj.rules?.stopLoss ?? ""));
        setDailySeconds(String(obj.rules?.dailySeconds ?? ""));
      }catch(e){}
    }
  })(); },[]);

  async function save() {
    const prefsRaw = await AsyncStorage.getItem(KEY);
    const prefs = prefsRaw ? JSON.parse(prefsRaw) : {};
    prefs.rules = {
      deposit: Number(deposit)||null,
      stopWin: Number(stopWin)||null,
      stopLoss: Number(stopLoss)||null,
      dailySeconds: Number(dailySeconds)||null
    };
    await AsyncStorage.setItem(KEY, JSON.stringify(prefs));
    Alert.alert("Salvo","Configurações salvas");
  }

  return (
    <View style={{flex:1,padding:20}}>
      <Text style={{fontSize:18}}>Configurações</Text>
      <Text>Depósito (R$)</Text>
      <TextInput keyboardType="numeric" value={deposit} onChangeText={setDeposit} style={{borderWidth:1,padding:8}}/>
      <Text>Stop Win (R$)</Text>
      <TextInput keyboardType="numeric" value={stopWin} onChangeText={setStopWin} style={{borderWidth:1,padding:8}}/>
      <Text>Stop Loss (R$)</Text>
      <TextInput keyboardType="numeric" value={stopLoss} onChangeText={setStopLoss} style={{borderWidth:1,padding:8}}/>
      <Text>Tempo diário permitido (segundos)</Text>
      <TextInput keyboardType="numeric" value={dailySeconds} onChangeText={setDailySeconds} style={{borderWidth:1,padding:8}}/>
      <View style={{height:12}}/>
      <Button title="Salvar" onPress={save}/>
    </View>
  );
}
