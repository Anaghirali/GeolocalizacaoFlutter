import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart'; 

String lblMsg = "Usando o GPS";
String MsgCordenada = "Sem Valor";
String MsgCoordenadaAtualizada = "Sem valor";

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
 var location = new Location();
 late LocationData _locationData;

 bool _serviceEnabled = false;
 PermissionStatus _permissionGranted = PermissionStatus.denied;

 void serviceStatus() async{
  _serviceEnabled =await location.serviceEnabled();
  if(!_serviceEnabled){
    _serviceEnabled =  await location.requestService();
    if(!_serviceEnabled){
      return;
    }
  }
 }


  void obterPermissao() async{

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied){
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != _permissionGranted){
        return;
      }
    }
  }

  Future obterLocalizacao() async{
    _locationData = await location.getLocation();
    return _locationData;
  }

  @override
  void initState(){
    super.initState();
    location.changeSettings(interval: 300);
    location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        MsgCoordenadaAtualizada = currentLocation.latitude.toString() + "\n" +
        currentLocation.longitude.toString();
        print(currentLocation);
      });
      
    });
  }




 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Localização")
                            ,backgroundColor: Colors.blueGrey,),
      body: Container(padding: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(lblMsg),
          ElevatedButton(onPressed: (() {
            serviceStatus();
            if(_permissionGranted == PermissionStatus.denied){
              obterPermissao();
            }else{
              obterLocalizacao().then((value) {
                setState(() {
                  MsgCoordenada = _locationData.latitude.toString()+"\n"+
                  _locationData.longitude.toString();
                });
              });
            }
          }) , child: Text("Click para obeter coordenada")),
          Text(MsgCordenada),
          Text("Atualizada"),
          Text(MsgCoordenadaAtualizada),

        ]),),

    );
  }
}