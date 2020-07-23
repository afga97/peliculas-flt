import 'package:flutter/material.dart';



class DataSearch extends SearchDelegate {

  String seleccion = '';

  final peliculas = [
    'Spiderman',
    'Acuaman',
    'Jumanji',
    'American assains',
    'Nemo',
    'Chambeibe'
  ];

  final peliculasRecientes = [
    'Spiderman',
    'Capitan america'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Acciones de nuestro AppBar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del AppBar

    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: (){
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Son las sugerencias cuando la persona escribe


    final listBusqueda = ( query.isEmpty ) 
                            ? peliculasRecientes 
                            :  peliculas.where( 
                              (p) => p.toLowerCase().startsWith(query.toLowerCase())
                            ).toList();


    return ListView.builder(
      itemCount: listBusqueda.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: Icon(Icons.movie),
          title: Text(listBusqueda[index]),
          onTap: (){
            seleccion = listBusqueda[index].toString();
            showResults(context);
          },
        );
      },
    );
  }
  
  

}