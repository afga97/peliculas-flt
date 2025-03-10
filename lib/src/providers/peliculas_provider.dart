import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/models/actores_model.dart';

class PeliculasProvider {

  String _apikey      = '';
  String _url         = '';
  String _language    = 'es-CO';

  int _popularesPage  = 0;
  bool _cargando      = false;

  List<Pelicula> _populares = new List();

  //broadcast sirve para que muchos widgets lo esten escuchando
  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri url) async {
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getEncines() async {

    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language'  : _language
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async {

    if ( _cargando ) return [];
    
    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'  : _apikey,
      'language' : _language,
      'page'     : _popularesPage.toString()
    });

    final resp = await _procesarRespuesta(url);

    _cargando = false;

    _populares.addAll(resp);
    popularesSink( _populares );
    return resp;
  }

  Future<List<Actor>> getCast( String peliId ) async { 

    final url = Uri.https(_url, '3/movie/$peliId/credits',{
      'api_key'  : _apikey,
      'language' : _language
    });

    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final casts = new Actores.fromJsonList(decodedData['cast']);
    return casts.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String pelicula) async {

    final url = Uri.https(_url, '3/search/movie', {
      'api_key'   : _apikey,
      'language'  : _language,
      'query'     : pelicula
    });
    return await _procesarRespuesta(url);
  }

}
