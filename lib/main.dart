import 'package:flutter/material.dart';
import 'package:pokeapi/model/pokemon/pokemon.dart';
import 'package:pokeapi/pokeapi.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Flutter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getItens(1);
  }

  List<dynamic> itens = [];

  Future<void> getItens(page) async {
    EasyLoading.show(status: 'Carregando...');
    var response = await PokeAPI.getObjectList<Pokemon>(page, 10);
    setState(() {
      itens = response ;
    });
    EasyLoading.dismiss();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokemons'),
      ),
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              var id = itens[index].id;
              var name = itens[index].name;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SecondPage(id: id,name: name)),
              );
            },
            child: Card(

              child: ListTile(
                leading: Image.network(itens[index].sprites!.frontDefault!),
                title: Text(itens[index].name),
              ),
            )
          );
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  final int id;
  final String name;

  const SecondPage({super.key, required this.id, required this.name});

  @override
  _SecondRoute createState() => _SecondRoute();
}



class _SecondRoute extends State<SecondPage> {

  var pokemon = Pokemon();
  var abilities = [Abilities()];

  @override
  void initState() {
    super.initState();
    getPokemon(widget.id);
  }

  void getPokemon(id) async {
    EasyLoading.show(status: 'Carregando...');
    var response = await PokeAPI.getObject<Pokemon>(id);
    setState(() {
      pokemon = response!;
      abilities = pokemon.abilities!;
    });
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    if(pokemon.sprites == null) return const Scaffold(body: Center(child: CircularProgressIndicator(),),);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network(pokemon.sprites!.frontDefault!, width: 200, height: 200,),
            const Text('Habilidades'),
            ListView.builder(
              shrinkWrap: true,
              itemCount: abilities.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(abilities[index].ability!.name!, style: const TextStyle(fontSize: 20),),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

}
