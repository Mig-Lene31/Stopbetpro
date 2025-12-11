import React, {useState} from "react";
import {View, Text, TextInput, Button} from "react-native";

export default function Login({navigation}) {
  const [user, setUser] = useState("");
  const [pass, setPass] = useState("");
  function submit() {
    // placeholder: autenticação simples (trocar por real depois)
    navigation.replace("Home");
  }
  return (
    <View style={{flex:1,justifyContent:"center",padding:20}}>
      <Text style={{fontSize:22,marginBottom:20}}>Entrar - StopBet Pro</Text>
      <Text>Usuário</Text>
      <TextInput value={user} onChangeText={setUser} style={{borderWidth:1,padding:8,marginBottom:10}}/>
      <Text>Senha</Text>
      <TextInput value={pass} onChangeText={setPass} secureTextEntry style={{borderWidth:1,padding:8,marginBottom:20}}/>
      <Button title="Entrar" onPress={submit}/>
    </View>
  );
}
