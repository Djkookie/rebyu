import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:rebyu/admin/models/items_model.dart';
import 'dart:html' as html;

class AdminController extends GetxController {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  User? get currentUser => _auth.currentUser;

  String? get userId => _auth.currentUser?.uid;

  final storageRef = FirebaseStorage.instance;

 final List<String> googleFonts = [
    "Abril Fatface",
    "Alegreya Sans",
    "Archivo Narrow",
    "Bebas Neue",
    "Bitter",
    "Cabin",
    "Coda",
    "Comfortaa",
    "Comic Neue",
    "Cousine",
    "Faster One",
    "Forum",
    "Inconsolata",
    "Josefin Slab",
    "Lato",
    "Lobster",
    "Lora",
    "Merriweather",
    "Mukta",
    "Nunito",
    "Offside",
    "Open Sans",
    "Oswald",
    "Overlock",
    "Pacifico",
    "Playfair Display",
    "Roboto",
    "Space Mono",
    "Sue Ellen Francisco",
    "Zilla Slab",
  ];

  var newDetails = ItemsModel(title: '').obs;

  RxList socialData = RxList();
  RxList socialDataFront = RxList();

  RxMap pagesData = RxMap();

  RxMap pageSettings = RxMap();

  RxList imageUpload = RxList();
  RxInt countItems = 0.obs;

  RxString newKey = UniqueKey().toString().obs;

  String get currentSite => loadCurrentSite();

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      syncItemsData();
      syncPagesData();
      syncSettingsData();
    });
  }

  @override
  void refresh() {
    socialData.clear();
    socialDataFront.clear();
    pagesData.clear();
    pageSettings.clear();

    super.refresh();
  }

  loadCurrentSite()  {
    String urlString = html.window.location.href;
    int index = urlString.indexOf('=');
    String newSite = urlString.substring(index+1, urlString.length).trim();
    String? siteName = (userId != null) ? Get.parameters['site'] : newSite;
    return (siteName == null) ?'asdigital' : siteName;
  }

  Stream connectDatabaseVAlue() {
    final items = _database.ref('$currentSite/items');
    return items.onValue;
  }

  Future signInWithEmailAndPassword(email, password) async {

    Map<String, String> status = {};

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );

    } on FirebaseAuthException catch (e) {

      String eCode = e.code.replaceAll('-', ' ').capitalizeFirst.toString();

      status.putIfAbsent('status', () => eCode);
      status.putIfAbsent('message', () => e.message.toString());

    }

    return status;
  }

  Stream getItemData(id) {
      final items = _database.ref('$currentSite/items').child(id).onValue;
      return items;
  }

  Future userLogout() async {
    await _auth.signOut();
    // Get.reloadAll(force: true);
  }
  

  Future syncItemsData() async {
    final items = _database.ref('$currentSite/items');

    items.onValue.listen((DatabaseEvent event) {

      if(event.snapshot.exists) {
        final data = event.snapshot.children;

        countItems.value = data.length;

        if(data.isNotEmpty) {
          var newList = [];
          for (DataSnapshot item in data) {
        
            Map itemValue = item.value as Map;
      
            var newMap = itemValue.map((key, value) => MapEntry(key.toString(), value as dynamic));
            newList.add(newMap);
            
          }
          socialDataFront.assignAll(newList.reversed);
          socialData.assignAll(newList.reversed);
        }
      }
    }).onError((e) {
      // ignore: avoid_print
      print('ERROR this Error $e');
    });

  }

  Future syncPagesData() async {

    print('pages $currentSite');
    final items = _database.ref('$currentSite/pages');

    items.onValue.listen((DatabaseEvent event) {

      if(event.snapshot.exists) {
        final data = event.snapshot.children;

        if(data.isNotEmpty) {
          for (DataSnapshot item in data) {
            pagesData.putIfAbsent(item.key, () => item.value);
          }
        }
      }
    }).onError((e) {
      // ignore: avoid_print
      print('ERROR this Error $e');
    });

    final dataget = await items.get();

    if(dataget.children.isNotEmpty) {
      for (DataSnapshot item in dataget.children) {
        pagesData.putIfAbsent(item.key, () => item.value);
      }
    }
  }

  Future syncSettingsData() async {
    final items = _database.ref('$currentSite/settings');

    items.onValue.listen((DatabaseEvent event) {

      if(event.snapshot.exists) {
        final data = event.snapshot.children;

        // ignore: avoid_print
        print('item VALUE $data');

        if(data.isNotEmpty) {
          for (DataSnapshot item in data) {
            pageSettings.putIfAbsent(item.key, () => item.value);
          }
        }
      }
    }).onError((e) {
      // ignore: avoid_print
      print('ERROR this Error $e');
    });

  }

  Future setNewItem(title, link) async {

    try {
      final newKey = _database.ref().push().key;
      final ref = _database.ref('$currentSite/items/$newKey');

      final newData = {
        'id': newKey,
        'title': title,
        'link': link,
      };


      // ignore: avoid_print
      print(' NEW DATA $newData');
      await ref.set(newData);
    } on FirebaseAuthException catch(e) {
      // ignore: avoid_print
      print('ERROR $e');
    } catch (e) {
          // ignore: avoid_print
      print('ERROR Catch $e');
    }
  }
  Future updateSocialData(List datas) async {

    DatabaseReference item = _database.ref('$currentSite/items');
    Map newMap = {};

    for(Map data in datas) {
      newMap.putIfAbsent(data['id'], () => data);
    }

    try {
      if(newMap.isNotEmpty) {
        await item.set(newMap);
      }
    } catch (e) {
      // ignore: avoid_print
      print('ERROR $e');
    }
  }

  Future updatePagesData(Map data) async {

    DatabaseReference item = _database.ref('$currentSite/pages');

    try {
      await item.set(data);
  
    } catch (e) {
      // ignore: avoid_print
      print('ERROR $e');
    }
  }

  Future updatePageSettings() async {

    DatabaseReference item = _database.ref('$currentSite/settings');

    try {
      // Map newMapData = data.toMap();
      await item.set(pageSettings);
    } catch (e) {
      // ignore: avoid_print
      print('ERROR $e');
    }
  }

  Future removeItemData(id) async {
    final ref = _database.ref('$currentSite/items/$id');
    ref.remove();
  }
  // Future updateSocialData(ItemsModel data, id) async {

  //   DatabaseReference item = _database.ref('items/$id');

  //   try {
  //     Map newMapData = data.toMap();
  //     await item.update(newMapData.map((e, val) => MapEntry(e.toString(), val)));
  //   } catch (e) {
  //     // ignore: avoid_print
  //     print('ERROR $e');
  //   }
  // }

  Future signInWithCredential(credential) async {
    return await _auth.signInWithCredential(credential);
  }


  Future uploadFileData(dir, filename, filebytes) async {

    Map<String, String> status = {
      'status': 'success',
      'message': 'Successfully Uploaded'
    };

    final mountainsRef = storageRef.ref().child("$dir/$filename");

    try {
      // final dataReturn = await mountainsRef.putString(filebytes, format: PutStringFormat.dataUrl);
      final dataReturn = mountainsRef.putData(filebytes);
      return dataReturn;
    } on FirebaseException catch (e) {
      String eCode =  e.code.replaceAll('-', ' ').capitalizeFirst.toString();
      status.update('status', (value) => eCode);
      status.update('message', (value) => e.message.toString());
    }
    return status;
  }

  Future getFileStoragePath(type, fileName) async {

    String? fileUrl;
    
    if(fileName != null && fileName.isNotEmpty) {
      fileUrl = 'https://firebasestorage.googleapis.com/v0/b/${storageRef
          .bucket}/o/$type%2F${fileName.toString().replaceAll(
          ' ', '%20')}?alt=media';
    }
    return fileUrl;
  }

  Future getFileBytes(type, name) async {

    Uint8List? bytes;

    try{
      bytes = await storageRef.ref().child('$type/$name').getData(10000000);
    } catch (e) {
      //ignore: avoid_print
      print('ERROR ERROR $e');
    }

    return bytes;
  }

  Future getFileDownloadPath(type, name) async {

    String? url;

    try{
      final ref = storageRef.ref().child('$type/$name');

      url = await ref.getDownloadURL();
      //ignore: avoid_print
      print('ERROR ERROR $url');
    } catch (e) {
      //ignore: avoid_print
      print('ERROR ERROR $e');
    }

    return url;
  }
}