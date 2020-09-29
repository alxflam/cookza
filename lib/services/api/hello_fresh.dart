// import 'dart:io';

// import 'package:cookza/model/entities/abstract/recipe_entity.dart';
// import 'package:http/http.dart' as http;

class HelloFresh {
  // static final String url = 'https://www.hellofresh.de/gw/api/recipes/';
  // static final String base = 'https://www.hellofresh.de/recipes';

  // Future<RecipeEntity> getRecipe(String id) async {
  // query api
  // var test = await http.get(base);

  // var setCookie = test.headers['set-cookie'];
  // if (setCookie == null) {
  //   return null;
  // }

  // var cookie = Cookie.fromSetCookieValue(setCookie);

  // var parts = cookie.split(";");

  // parts = parts[0].split("=");

  // var token = parts[1];

  // var result =
  //     await http.get('$url$id'); // headers: {'Authorization': 'Bearer '}

  // check http status code
  // if (result.statusCode != 200) {
  //   throw "Error contacting HelloFresh.de - pleasy try again later";
  // }

  // transform response into entity
  // print('${result.body}');

  // return result

  // return null;
  // }
}
