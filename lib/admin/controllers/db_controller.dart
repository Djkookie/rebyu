import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';


class UserDetails extends GetxController {

  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: 'https://timetosleepstories-b179c-default-rtdb.firebaseio.com'
  );

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final StoriesList stories = Get.find();

  Map<String, dynamic> userInfo = {};
  
  List userFavorites = [].obs;
  List userRecentlyPlayed = [].obs;
  List downloadItems = [].obs;
  RxMap receivedShared = RxMap();
  RxList allUsers = RxList();

  String? get user => _auth.currentUser?.email;
  String? get userId => _auth.currentUser?.uid;
  bool? get emailVerified => _auth.currentUser?.emailVerified;
  User? get currentUser => _auth.currentUser;

  bool? get isLoggedGuest => _auth.currentUser?.isAnonymous;

  Stream<User?> get userChanges => _auth.userChanges();

  String uid = '';
  String fullName = '';
  String phoneNumber = '';
  String email = '';
  String password = '';
  String otpCode = '';
  String type = 'Create';
  String signType = 'email';
  String planType = '';

  bool hasUserEmail = false;
  bool hasUserPhone = false;
  bool receiveUpdates = false;
  bool isSnackBarOpen = false;

  RxString userListKey = UniqueKey().toString().obs;

  Future<String> getDeviceIdentifier() async {

    String deviceIdentifier = "unknown";

    return deviceIdentifier;
  }

  Future sendEmailVerification() async {
    await currentUser?.sendEmailVerification();
  }

  Future sendPasswordReset(email) async {

    Map<String, String> status = {};

    try {
      await _auth.sendPasswordResetEmail(
        email: email,
      );

    } on FirebaseAuthException catch (e) {

      String eCode = e.code.replaceAll('-', ' ').capitalizeFirst.toString();
      status.putIfAbsent('status', () => eCode);
      status.putIfAbsent('message', () => e.message.toString());
    }

    return status;
  }

  Future updateUserPassword() async {
    await currentUser?.updatePassword(password);
    final ref = database.ref('users/$userId');
    final userPass = ref.child('password');
    final updated = ref.child('updated');
    userPass.set(password);
    updated.set(DateTime.now().toString());

  }

  Future signInWithCredential(credential) async {
    return await _auth.signInWithCredential(credential);
  }

  Future createUserDetails(type) async {

    DatabaseReference newUser = database.ref('users/$userId');

    var firstName = await getDeviceIdentifier();
    var lastName = '';

    if(type != 'guest') {

      String theName = (fullName.isNotEmpty) ? fullName : _auth.currentUser?.displayName ?? fullName.toString();

      List<String> names = theName.split(' ').toList();

      firstName = names.first;
      names.removeAt(0);
      lastName = names.join();
    }

    DateTime currentDate = DateTime.now();

    final user = {
      'id': userId,
      'first_name' : firstName,
      'last_name': lastName,
      'email' :( email.isNotEmpty ) ? email : _auth.currentUser?.email,
      'phone' : ( phoneNumber.isNotEmpty ) ? phoneNumber : _auth.currentUser?.phoneNumber,
      'password' : password,
      'sign_in_type' : type,
      'receive_updates': receiveUpdates,
      'current_plan': 'free',
      'plans': {
          'free': {
            'start_date' : currentDate.toString(),
            'end_date' : '',
          }
      },
      'favorites': '',
      'recently_played': '',
      'downloads': '',
      'created': currentDate.toString(),

    };

    await newUser.set(user);
  }

  Future<Map<String, dynamic>> signUpWithEmailPassword(String email, String password) async {

    Map<String, String> status = {};

    // var actionSettings = ActionCodeSettings(
    //   url: 'timetosleepstories-b179c.firebaseapp.com',
    // );

    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _auth.currentUser?.sendEmailVerification();

      status.putIfAbsent('status', () => 'success');
      status.putIfAbsent('message', () => 'Verification is sent to your \n $email');

    } on FirebaseAuthException catch (e) {

      if (e.code == 'weak-password') {
        status.putIfAbsent('status', () => 'weak');
        status.putIfAbsent('message', () => 'Password must be 6 digits');

      } else if (e.code == 'email-already-in-use') {
          status.putIfAbsent('status', () => 'invalid');
          status.putIfAbsent('message', () => 'Email address is already in used');
      }
    } catch (e) {
      
      status.putIfAbsent('status', () => 'error');
      status.putIfAbsent('message', () => 'Something went wrong');
    }

    return status;
  }

  Future signInWithEmailAndPassword(email, password) async {

    Map<String, String> status = {};

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password
      );
      // signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {

      String eCode = e.code.replaceAll('-', ' ').capitalizeFirst.toString();

      status.putIfAbsent('status', () => eCode);
      status.putIfAbsent('message', () => e.message.toString());

    }

    return status;
  }
 
  Future signInWithPhoneNumber () async {
    ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
    return confirmationResult;
  }

  Future confirmSignWIthOtpCode(confirmationResult) async {
    UserCredential userCredential = await confirmationResult.confirm(otpCode);
    signInWithCredential(userCredential.credential);
  }

  Future getUserDataOnce() async {
    final ref = database.ref('users/$userId');

    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map itemValue = event.snapshot.value as Map;

        var newMap = itemValue.map((key, value) {
          if (key == 'favorites') {
            userFavorites.assignAll((value.isNotEmpty) ? value.split(',') : []);
          }

          if (key == 'downloads') {
            downloadItems.assignAll((value.isNotEmpty) ? value.split(',') : []);
          }

          if (key == 'received_shared') {
            receivedShared.assignAll((value.isNotEmpty) ? value : {});
          }

          if (key == 'recently_played') {
            userRecentlyPlayed.assignAll((value.isNotEmpty) ? value.split(',') : []);
          }

          return MapEntry(key.toString(), value as dynamic);
        });

        planType = newMap['current_plan'] ?? 'free';

        userInfo.assignAll(newMap);

        stories.syncStoriesData();

        stories.homeKey.value = UniqueKey().toString();
      }
    });

    if (isLoggedGuest != null && isLoggedGuest == true) {
      ref.onDisconnect().remove();
    }
  }
    
  Future updateUserData(updates) async {

    // final user = database.ref('users/${updates['id']}');

    var date = {
      'start_date': updates['start_date'] ?? updates['plans']['free']['start_date'],
      'end_date': updates['end_date'] ?? updates['plans']['free']['end_date'],
    };

    updates['plans'].update(updates['current_plan'], (value) => date, ifAbsent: () => date );

    //user.set(UserModel(item: updates).toJson());
  }
  
  Future updateUserDownloads(newDownloads) async {
    final ref = database.ref('users/$userId');
    final snapshot = ref.child('downloads');
    final updated = ref.child('updated');
    snapshot.set(newDownloads.join(','));
    updated.set(DateTime.now().toString());
  }

  Future<bool> isExistingUserByPhone() async {
    final ref = database.ref();
    final snapshot = await ref.child('users').get();
    return snapshot.exists;
  }

  Future updateUserFavorites(List favorites) async {
    // updateBoxData('user','favorites', userId, favorites);
    final ref = database.ref('users/$userId');
    final snapshot = ref.child('favorites');
    final updated = ref.child('updated');
    snapshot.set(favorites.join(','));
    updated.set(DateTime.now().toString());
  }

  Future updateUserRecentlyPlayed(List played) async {
    // updateBoxData('user','recently_played', userId, played);
    final ref = database.ref('users/$userId');
    final snapshot = ref.child('recently_played');
    final updated = ref.child('updated');
    snapshot.set(played.join(','));
    updated.set(DateTime.now().toString());
  }

  Future updateUserPlan(String uid) async {
    // updateBoxData('user','recently_played', userId, played);
    final ref = database.ref('users/$userId');

    final currentPlan = ref.child('current_plan');
    final plans = ref.child('plans/$uid');
    final updated = ref.child('updated');

    DateTime currentDate = DateTime.now();

    var endDate = 'lifetime';

    switch(uid) {
      case 'timetosleepstories_track_id':
        endDate = Jiffy.now().add(months: 1).dateTime.toString();
        break;
      case 'timetosleepstories_track_id_yearly':
        endDate = Jiffy.now().add(years: 1).dateTime.toString();
      break;
    }

    planType = uid;

    currentPlan.set(uid);

    plans.set({
      'start_date' : currentDate.toString(),
      'end_date' : endDate,
    });

    updated.set(DateTime.now().toString());

  }

  Future userLogout() async {

    if(_auth.currentUser!.isAnonymous == true) {
      _auth.currentUser?.delete();
      userRemoveGuest();
    }
    await FirebaseAuth.instance.signOut();
   
    Get.reloadAll(force: true);
  }

  Future userLoginGuest() async {

    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    return  userCredential;
  }

  Future userRemoveGuest() async {
      final ref = database.ref('users/$userId');
      ref.remove();
  }

  Future userLoginByToken(token) async {
    final userCredential = await FirebaseAuth.instance.signInWithCustomToken(
        token);
    return userCredential;
  }

  Future getSharedStory(fromId) async {

    String storyTitle = '';

    final user = database.ref('users/$userId/received_shared');
    final storyShared = await database.ref('settings/shared').get();

    final sharedStoriesChildren = storyShared.children;

    if(sharedStoriesChildren.isNotEmpty) {

      List sharedKey = receivedShared.entries.map((e) => e.key).toList();

      bool added = false;

      if(sharedKey.isEmpty || sharedKey.length < sharedStoriesChildren.length) {
        sharedStoriesChildren.map((e) {
          if (fromId != e.key) {
            if (sharedKey.isEmpty || !sharedKey.contains(e.key)) {
              if(!added) {
                receivedShared.putIfAbsent(e.key, () => fromId);
                storyTitle = e.value.toString();
                added = true;
              }
            }
          }
        }).toList();

        user.set(receivedShared);
      }
    }
    return storyTitle;
  }
  Future syncUsersData() async {
    // final users = database.ref('users');
    var users = database.ref("users");

    users.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;

      if (data.isNotEmpty) {
        var newList = [];
        for (DataSnapshot item in data) {
          Map itemValue = item.value as Map;
          var newMap = itemValue.map((key, value) =>
              MapEntry(key.toString(), value as dynamic));
          if(newList.length < 10) {
            newList.add(newMap);
          }
        }

        allUsers.assignAll(newList);
      }
    });
  }
}

class StoriesList extends GetxController {


  final storageRef = FirebaseStorage.instanceFor(
      app: Firebase.app(),
      bucket: 'gs://timetosleepstories-b179c.appspot.com'
  );

  final FirebaseDatabase database = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://timetosleepstories-b179c-default-rtdb.firebaseio.com'
  );


  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, String> updatedItem = {};

  RxList imageUpload = RxList();
  RxList audioUpload = RxList();
  RxList previewUpload = RxList();
  RxList listMapItem = RxList();
  RxMap priorities = RxMap();
  RxMap allowedStories = RxMap();

  RxBool isUpload = false.obs;
  RxBool isPrimaryImage = false.obs;
  RxBool isRead = false.obs;
  RxBool isPublished = false.obs;
  RxBool isForceDate = false.obs;

  RxString customDate = ''.obs;
  RxString currentSearch = ''.obs;
  RxString storageToken = ''.obs;
  RxString homeKey = UniqueKey().toString().obs;
  RxString storyListKey = UniqueKey().toString().obs;

  Future getFileStoragePath(type, fileName) async {

    String? audioUrl;

    if(fileName != null && fileName.isNotEmpty) {
      audioUrl = 'https://firebasestorage.googleapis.com/v0/b/${storageRef
          .bucket}/o/$type%2F${fileName.toString().replaceAll(
          ' ', '%20')}?alt=media';
    }
    return audioUrl;
  }

  Future updateStoryData(dynamic item, bool isPriorities) async {

    bool isItemNew = false;

    if(updatedItem.isNotEmpty) {
      if(item['id'] != null) {
        final ref = database.ref('stories/${item['id']}');
        ref.update(updatedItem);

        if (updatedItem['condition'] != null) {
          String? condition = updatedItem['condition'] ?? item['condition'];
          String? group = updatedItem['group'] ?? item['group'];
          String id = item['id'] ?? Random().toString();
          String title = item['title'] ?? ' ';

          for (var type in ['free', 'display', 'shared']) {
            await database.ref('settings/$type/$id').remove();
          }

          if (condition != null) {
            await database.ref('settings/$condition/$group/$id').remove();

            if (condition != 'priorities') {
              final settings = database.ref('settings/$condition/$id');
              settings.set(title);
            } else {
              if (group != null) {
                final settings = database.ref('settings/$condition/$group/$id');
                settings.set(title);
              }
            }
          }
        }
      } else {
        isItemNew = true;
      }
    }

    if(isItemNew && !isPriorities){
      final newKey = database.ref().push().key;
      final ref = database.ref('stories/$newKey');
      Map newMap = Map.from(item)..addEntries(updatedItem.entries);
      newMap.putIfAbsent('id', () => newKey.toString());
      ref.set(newMap);
    }

  }

  Future getFileBytes(type, name) async {
    return await storageRef.ref().child('$type/$name').getData(10000000);
  }

  Future removeStoryItem(id) async {
    return await database.ref().child('stories/$id').remove();
  }

  Future uploadFileData(dir, filename, filebytes) async {

    Map<String, String> status = {
      'status': 'success',
      'message': 'Successfully Uploaded'
    };

    final mountainsRef = storageRef.ref().child("$dir/$filename");

    try {
      // final dataReturn = await mountainsRef.putString(fileDataSource, format: PutStringFormat.dataUrl);
      final dataReturn = mountainsRef.putData(filebytes);
      return dataReturn;
    } on FirebaseException catch (e) {
      String eCode =  e.code.replaceAll('-', ' ').capitalizeFirst.toString();
      status.update('status', (value) => eCode);
      status.update('message', (value) => e.message.toString());
    }
    return status;
  }

  Future updateDisplayStories(Map entries) async {

    final ref = database.ref('settings/display');
    ref.set(entries);


    final story = database.ref('stories');

    for(var id in entries.keys) {
      story.child(id).update({'condition': 'display'});
    }
  }
  
  Future removeDisplayItem(id) async {
    final ref = database.ref('settings/display/$id');
    ref.remove();

    final story = database.ref('stories/$id');
    story.update({'condition': ''});
  }

  Future addItemPriority(groupId, Map entry) async {
    final ref = database.ref('settings/priorities/$groupId');
    ref.set(entry);

    final story = database.ref('stories/${entry.keys.first}');

    story.child('group').set(groupId);
    story.child('condition').set('priorities');
  }

  Future removeItemPriority(groupId, id) async {
    final ref = database.ref('settings/priorities/$groupId/$id');
    ref.remove();

    final story = database.ref('stories/$id');
    story.update({'group': '', 'condition': ''});
  }
/*

  Future updateUserPriorities(data, type) async {
    final ref = database.ref('settings/$type');
    ref.set(data);
  }
*/

  Future updateAllPriorities() async {
    final ref = database.ref('settings/priorities');
    ref.set(priorities);
  }

  Future updateCustomDate() async {
    final settings = database.ref('settings');
    final cDate = settings.child('custom_date');
    final cEnabled = settings.child('custom_enabled');
    final sToken = settings.child('storage_token');
    cDate.set(customDate.value);
    cEnabled.set((isForceDate.value) ? 'on' : 'false');
    sToken.set(storageToken.value);
  }

  Future syncStoriesData() async {

    final stories = database.ref('stories');

    final settings = database.ref('settings');
    final currentUserData = database.ref('users/${_auth.currentUser?.uid}');

    final receivedStories = currentUserData.child('received_stories/${DateTime.now().year}');

    final created =  await currentUserData.child('created').get();
    final receivedShared = await currentUserData.child('received_shared').get();

    final entries = await receivedStories.get();

    dynamic entriesMap = (entries.exists) ? entries.value : {};

    DateTime dateTimeNow = DateTime.now();
    DateTime userDateCreated = (created.value != null && created.value != '') ? DateTime.parse(created.value.toString()) : dateTimeNow;

    stories.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;

      if(data.isNotEmpty) {
        var newList = [];
        for (DataSnapshot item in data) {
          Map itemValue = item.value as Map;
          var newMap = itemValue.map((key, value) => MapEntry(key.toString(), value as dynamic));
          newList.add(newMap);
        }
    
        storyListKey.value = UniqueKey().toString();
      }
    }).onError((e) {
      // ignore: avoid_print
      print('ERROR $e');
    });

    settings.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.children;
      var allItems = {};
      if(data.isNotEmpty) {
        List ids = [];
        for (DataSnapshot item in data) {

          if(item.key == 'custom_date') {
            customDate.value = item.value.toString();
          }

          if(item.key == 'custom_enabled') {
            isForceDate.value = (item.value == 'on') ? true : false;
          }

          if(item.key == 'storage_token') {
            storageToken.value = item.value.toString();
          }

          if(item.key == 'free') {
            Map itemValue = item.value as Map;
            itemValue.entries.map((e) {
              if(!ids.contains(e.key)) {
                ids.add(e.key);
              }
              return e.key;
            }).toList();
          }

          if(item.key == 'display') {
            Map itemValue = item.value as Map;
            itemValue.entries.map((e) {
              if(!ids.contains(e.key)) {
                ids.add(e.key);
              }
              allItems.putIfAbsent(e.key, () => e.value);
              return e.key;
            }).toList();
          }

          if(item.key == 'shared') {
            Map itemValue = item.value as Map;
            if(receivedShared.children.isNotEmpty) {

              List idsShared = receivedShared.children.map((e) {
                if(!ids.contains(e.key)) {
                  ids.add(e.key);
                }
                return e.key;
              }).toList();

              itemValue.entries.map((e) {
                if(!ids.contains(e.key) && idsShared.contains(e.key.toString().trim())) {
                  ids.add(e.key);
                }
                return e.key;
              }).toList();
            }
          }

          if(item.key == 'priorities') {
            Map itemValue = item.value as Map;
            priorities.assignAll(itemValue);
            List months = [];

            if(userDateCreated.month > dateTimeNow.month) {
              if(entriesMap.isNotEmpty) {

                List mKeys = entriesMap.entries.map((e) => e.key.toString()).toList();
                List mValues = entriesMap.entries.map((e) => e.value.toString()).toList();

                String dateNow =  (customDate.value.isNotEmpty && isForceDate.isTrue) ? customDate.value : dateTimeNow.toString();

                String todayId = Jiffy.parse(dateNow).yM.numericOnly().toString();
                int monthNum = DateTime.parse(dateNow).month.toInt();

                itemValue.entries.map((e) {
                  int index = (months.indexOf(e.key) + 1).toInt();
                  Map eValue = e.value;
                  try {
                    var isNotExisting = eValue.entries.any((e) =>
                    !mValues.contains(e.key));
                    var entriesKey = eValue.entries.singleWhere((e) =>
                    !mValues.contains(e.key));

                    if (monthNum == index) {
                      if (!mKeys.contains(todayId) && isNotExisting) {
                        ids.add(entriesKey.key);
                        mKeys.add(todayId);
                        entriesMap.putIfAbsent(todayId, () => entriesKey.key);
                      }
                    } else {
                      if (mValues.length <= index && index < monthNum) {
                        if (!mKeys.contains(todayId) && isNotExisting) {
                          ids.add(entriesKey.key);
                          mKeys.add(todayId);
                          entriesMap.putIfAbsent(todayId, () => entriesKey.key);
                        }

                      }
                    }
                  } catch (e) {
                    // ignore: avoid_print
                    print('Error $e');
                  }


                }).toList();
              } else {
                itemValue.entries.map((e) {

                  Map eValue = e.value;

                  if(e.key == 'January') {
                    if(eValue.isNotEmpty) {
                      ids.add(eValue.entries.first.key);
                      entriesMap.putIfAbsent(Jiffy.parse(dateTimeNow.toString()).yM.toString().numericOnly(), () => eValue.entries.first.key);
                    }
                  }
                return e.value;
                }).toList();
              }
            }
          }
        }

        var newList = [];

        List prioritiesIds = entriesMap.entries.map((e) => e.value).toList();

        for(var story in []) {
          if ((ids.contains(story['id']) || prioritiesIds.contains(story['id'])) && story['status'] == 'published') {
            newList.add(story);
          }
        }

        allowedStories.assignAll(allItems);
        listMapItem.assignAll(newList);

        /*listMapItem.sort((a, b) {
          return num(a) < num(b) ? num(a) : num(b);
        });*/

        listMapItem.sort((a, b) {
          return num(a).compareTo(num(b));
        });

        if(entries.children.length < entriesMap.entries.length) {
          if(_auth.currentUser?.uid != null) {
            receivedStories.set(entriesMap);
          }
        }
      }
    });

  }
}

int num(i) {
  int num = 10;
  if(i['condition'] != null && i['condition'].isNotEmpty) {
    switch(i['condition']) {
      case 'free':
        num = 0;
        break;
      case 'shared':
        num = 1;
        break;
      case 'priorities':
        num = 5;
        break;
      default:
    }
  }
  return num;
}

initServices() async {
  // UserDetails();
  // await StoriesList().setBundleStories();
}


