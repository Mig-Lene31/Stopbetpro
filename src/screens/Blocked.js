import React, {useEffect, useState} from "react";
import {View, Text, Button} from "react-native";
import AsyncStorage from "@react-native-async-storage/async-storage";

export default function Blocked({route, navigation}) {
  const [remaining, setRemaining] = useState(null);
  const [reason,setReason] = useState(route?.params?.reason || "Motivo não informado");

  useEffect(()=>{
    let mounted=true;
    (async ()=>{
      const prefs = JSON.parse(await AsyncStorage.getItem("stopbet_prefs_v1")||'{}');
      const until = prefs.block_until || Date.now()+12*60*60*1000;
      const tick = setInterval(()=>{
        const rem = until - Date.now();
        if (!mounted) return;
        if (rem <= 0) { setRemaining(0); clearInterval(tick); } else setRemaining(rem);
      }, 1000);
    })();
    return ()=> mounted=false;
  },[]);

  function toHome(){ navigation.navigate("Home"); }

  return (
    <View style={{flex:1,justifyContent:"center",alignItems:"center",padding:20}}>
      <Text style={{fontSize:22}}>Bloqueado</Text>
      <Text style={{marginVertical:12}}>Motivo: {reason}</Text>
      <Text>{remaining !== null ? Math.max(0, Math.floor(remaining/1000)) + "s restantes" : "calculando..."}</Text>
      <View style={{height:12}}/>
      <Button title="Home" onPress={toHome}/>
    </View>
  );
}
