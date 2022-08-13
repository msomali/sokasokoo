import 'package:dio/dio.dart';
import 'package:sokasokoo/models/advert.dart';
import 'package:sokasokoo/models/cv.dart';
import 'package:sokasokoo/models/media.dart';
import 'package:sokasokoo/models/playlist.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/utils.dart';

class Api {
  // static var url = 'http://192.168.43.228:5000';
  static var url = 'https://sokasoka-api.herokuapp.com';
  static var options = BaseOptions(
      // baseUrl: ,
      baseUrl: url);

  static var dio = Dio(options);

  Future getAdverts() async {
    List<Advert> adverts = [];
    try {
      var response = await dio.get('/v1/adverts');
      var values = response.data['data'];

      for (var p in values) {
        adverts.add(Advert.fromJson(p));
      }
      return Future.value(adverts);
    } on DioError catch (e) {
      Future.error(e);
    }
  }

  Future getUser(filter) async {
    List<User> items = [];

    try {
      items.clear();

      var response =
          await dio.get('/v1/users', queryParameters: {'query': filter});

      for (var data in response.data['data']) {
        items.add(User.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<User> currentUser({String? userId}) async {
    var id = userId ?? await SharedPrefs.getUser();

    try {
      var response = await dio.get('/v1/users/$id');

      return Future.value(User.fromJson(response.data));
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getUsersOfGuardian(creator) async {
    var items = [];

    try {
      items.clear();

      var response = await dio.get(
        '/v1/users',
        queryParameters: {
          'query': {'createdBy': creator}
        },
      );

      for (var data in response.data['data']) {
        items.add(User.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future searchUsers(payload) async {
    List<User> items = [];

    try {
      items.clear();

      var response = await dio.get(
        '/v1/users/search',
        queryParameters: {
          'query': {'text': payload}
        },
      );

      for (var data in response.data['data']) {
        print('Data $data');
        items.add(User.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future createUser(payload) async {
    try {
      Response response = await dio.post('/v1/users', data: payload);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future addToAcademy(User player, User academy, String level) async {
    try {
      Response response = await dio.post('/v1/academys',
          data: {'player': player.sId, 'addedBy': academy.sId, 'level': level});

      return Future.value(response.data);
    } on DioError catch (e) {
      print(e.response);
      return Future.error(e);
    }
  }

  Future addToAgent(User player, User agent) async {
    try {
      Response response = await dio
          .patch('/v1/users/${player.sId}', data: {'agent': agent.sId});

      return Future.value(response.data);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future removeAgent(User player) async {
    try {
      Response response = await dio.post('/v1/users/agent/${player.sId}');

      return Future.value(response.data);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future getAcademy(String age, String id) async {
    try {
      var response = await dio.get('/v1/academys', queryParameters: {
        'query': {'addedBy': id, 'level': age}
      });
      return Future.value(response.data['data']);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future getAgentPlayers(String id) async {
    try {
      var response = await dio.get('/v1/users', queryParameters: {
        'query': {'agent': id}
      });
      return Future.value(response.data['data']);
    } on DioError catch (e) {
      return Future.error(e);
    }
  }

  Future createAgent(payload) async {
    try {
      Response response = await dio.post('/v1/agents', data: payload);
      print(response.data);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<User>> fetchUsers() async {
    List<User> items = [];

    try {
      items.clear();

      var response = await dio.get('/v1/users');

      for (var data in response.data['data']) {
        items.add(User.fromJson(data));
      }

      return Future.value(items);
    } on DioError catch (error) {
      return Future.error(error);
    }
  }

  Future createCv(payload) async {
    try {
      Response response = await dio.post('/v1/cvs', data: payload);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future deleteCv(payload) async {
    try {
      Response response = await dio.delete('/v1/cvs/$payload');
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future deleteAcademy(payload) async {
    try {
      Response response = await dio.delete('/v1/academys/$payload');
      return Future.value(response.data);
    } on DioError catch (e) {
      print(e.message);
      return Future.error(e);
    }
  }

  Future deleteMedia(payload) async {
    try {
      Response response = await dio.delete('/v1/medias/$payload');
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future editCv(payload, data) async {
    try {
      Response response = await dio.patch('/v1/cvs/$payload', data: data);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future editProfile(payload, data) async {
    try {
      Response response = await dio.patch('/v1/users/$payload', data: data);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future updateUser(id, payload) async {
    try {
      var response = await dio.put('/v1/users/${id.toString()}', data: payload);
      return Future.value(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future loginUser(payload) async {
    try {
      var response = await dio.post('/v1/users/login', data: payload);
      return Future.value(response);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future uploadImage(id, payload) async {
    try {
      var response = await dio.patch('/v1/users/$id', data: payload);

      return Future.value(response);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future uploadFile(payload) async {
    try {
      var response = await dio.post('/v1/medias', data: payload);

      return Future.value(response);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getUserMedia(creator) async {
    var items = [];

    try {
      items.clear();

      var response = await dio.get('/v1/medias', queryParameters: {
        'query': {
          'createdBy': creator,
        },
        'populate': [
          {
            'path': 'createdBy',
            'select': {'firstName': 1, 'profileImage': 1}
          },
        ],
      });

      for (var data in response.data['data']) {
        items.add(Media.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getAllMedia() async {
    List<Media> items = [];

    try {
      items.clear();

      var response = await dio.get('/v1/medias', queryParameters: {
        'query': {'type': 'Link'},
        'populate': [
          {
            'path': 'createdBy',
            'select': {'firstName': 1, 'profileImage': 1}
          },
        ],
      });

      for (var data in response.data['data']) {
        items.add(Media.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getPlayList() async {
    try {
      var response = await dio.get('/v1/playlists', queryParameters: {
        'query': {'isActive': 'true'}
      });

      var values = PlayList.fromJson(response.data['data'][0]);

      return Future.value(values);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getUserCvs(creator) async {
    var items = [];

    try {
      items.clear();

      var response = await dio.get('/v1/cvs', queryParameters: {
        'query': {
          'createdBy': creator,
        },
      });

      for (var data in response.data['data']) {
        items.add(Cv.fromJson(data));
      }

      return Future.value(items);
    } catch (error) {
      return Future.error(error);
    }
  }

  // Get User Current Cv
  Future getUserCurrentCvs(creator) async {
    try {
      var response = await dio.get('/v1/cvs', queryParameters: {
        'query': {'createdBy': creator, 'isCurrent': true},
      });
      return Future.value(response.data['data']);
    } catch (error) {
      return Future.error(error);
    }
  }

  // Get User Current Media File
  Future getUserCurrentMedia(creator) async {
    print('This was invoked');
    try {
      var response = await dio.get('/v1/medias', queryParameters: {
        'query': {'createdBy': creator, 'type': 'Link'},
      });

      return Future.value(response.data['data']);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future getYTVideo() async {
    try {
      var response = await dio.get('/v1/videos', queryParameters: {
        'query': {'active': 'true'},
      });

      return Future.value(response.data['data']);
    } catch (error) {
      return Future.error(error);
    }
  }

  Future<List<String>> getAllCvs() async {
    var items = [];

    try {
      items.clear();

      var response = await dio.get('/v1/cvs');

      for (var data in response.data['data']) {
        items.add(Cv.fromJson(data));
      }

      List<String> values =
          items.map((e) => e.name.toString()).toSet().toList();

      return Future.value(values);
    } catch (error) {
      return Future.error(error);
    }
  }
}
