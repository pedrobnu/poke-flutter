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
      title: 'Poke',
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
  int i = 0;
  int page = 1;
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
        title: const Text('Pokemon'),
        backgroundColor: Colors.purple,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Text("Os Mais Pesquisados", style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
              Center(
                child:
                Container(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                      itemCount: itens.length,
                      onPageChanged: (value) {
                        setState(() {
                          i = value;
                        });
                      },
                      controller: PageController(viewportFraction: 0.7),
                      itemBuilder: (context, index) {
                        return Transform.scale(
                          scale: index == i ? 1 : 0.9,
                          child: Card(
                              shadowColor: Colors.black,
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SecondPage(id: itens[index].id!, name: itens[index].name!,),
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(itens[index].name!, style: const TextStyle(fontSize: 20,color: Colors.white),),
                                    Image.network(itens[index].sprites!.frontDefault!, width: 100, height: 100,),
                                  ],
                                ),
                              )
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text("Navegue por paginas", style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold)),
                )
              ),
              Center(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          if(page == 1) return;
                          setState(() {
                            page--;
                            getItens(page);
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_ios),
                        onPressed: () {
                          setState(() {
                            page++;
                            getItens(page);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )

            ],
          )
        ],
      )

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
        backgroundColor: Colors.purple,
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
