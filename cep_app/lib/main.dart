import 'package:flutter/material.dart';
import 'models/endereco.dart';
import 'services/via_cep_service.dart'

void main() {
runApp(const CepApp());
}
class CepApp extends StatelessWidget {
const CepApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Consulta CEP',
debugShowCheckedModeBanner: false,
theme: ThemeData(
primarySwatch: Colors.indigo,
useMaterial3: true,
),
home: const HomeScreen(),
);
}
}
class HomeScreen extends StatefulWidget {
const HomeScrenn({super.key});
@override
State<HomeScreen>createState()=>_HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen>{
final _cepController=TextEditingController();
Endereco? _enderecoResult;
bool _isLoading=false;
String? _erroMesage;
Future<void>_consultarCep() async{
setState(() {
_isLoading=true;
_erroMessage=null;
_enderecoResult=null;
});
try{
final resultado=await ViaCepService.buscarCep(_cepController.text);
setState((){
_enderecoResult=resultado;
});
} catch (e){
setState((){
_erroMessage=e.toString().replaceAll('Exception: ', '');
});
}finally{
setState((){
_isLoading=false;
});
}
}
@override
void dispose(){
_cepController.dispose();
super.dispose();
}
@override
Widget build(BuildContext context){
return Scaffold(
appBar:AppBar(
title:const Text('Consulta CEP (ViaCEP API)'),
backgroundColor: Colors.indigo,
foregroundColor: Colors.white,
centerTitle: true,
),
body:Padding(
padding:const EdgeInsets.all(16.0),
child:Column(
crossAxisAlignment: CrossAxisAlignment.stretch,
children:[
  TextField(autocorrect: _cepController,
  keyboardType: TextInputType.number,
  decoration: const InputDecoration(
    labelText: 'Digite o CEP (somente números)',
  hintText: 'Ex: 01001000'
  border: OutlineInputBorder(),
  prefixIcon: Icon(Icons.location_on)
  ),
  ),
  const SizedBox(height: 12),
  ElevatedButton.icon(
    onPressed: _isLoading ? null : _consultarCep,
    icon: const Icon(Icons.search),
    label: const Text('Buscar Endereço'),
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 1),
    ),
  ),
  const SizedBox(height: 24),
  if (_isLoading)
  const Center(child: CircularProgressIndicator()),
  if (_erroMessage != null)
  Card(
    color: Colors.red.shade50,
    child: Padding(
      padding: const EdgeInsets.all(16.0)
      chid: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 16),
      ),
    ),
  ),
  if (_enderecoResult != null)
  Card(
    elevation: 4,
    child: Padding(
      padding:const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${_enderecoResult!.logradouro}, ${_enderecoResult!.bairro}',
            style: const TextStyle(
              fontSize: 
          )

      )
    )
  )





  
  
  
  ),
)

  ),)
