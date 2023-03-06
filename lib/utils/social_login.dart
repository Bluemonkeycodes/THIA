import 'dart:convert';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as g_apis;
import 'package:http/http.dart' as http;
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/main.dart';
import 'package:thia/modules/auth/model/login_model.dart';
import 'package:thia/services/api_service_call.dart';
import 'package:thia/utils/utils.dart';

import '../modules/home_module/views/home_screen.dart';

f_auth.User? user;
final GoogleSignIn googleSignIn = GoogleSignIn(
  scopes: [
    'https://www.googleapis.com/auth/classroom.courses.readonly',
    // 'https://www.googleapis.com/auth/classroom.courses',
    "https://www.googleapis.com/auth/classroom.course-work.readonly",
    "https://www.googleapis.com/auth/classroom.student-submissions.students.readonly",
    "https://www.googleapis.com/auth/classroom.coursework.students.readonly",
    "https://www.googleapis.com/auth/classroom.student-submissions.me.readonly",
    "https://www.googleapis.com/auth/classroom.coursework.me.readonly",
    "https://www.googleapis.com/auth/classroom.coursework.students",
    " https://www.googleapis.com/auth/classroom.coursework.me",
  ],
  // clientId: "295288564239-8q8f0kkfo5tktd8o105le9bhrhr6ivur.apps.googleusercontent.com",
);
f_auth.FirebaseAuth auth = f_auth.FirebaseAuth.instance;

AccessCredentials getAuthJsonData() {
  return AccessCredentials.fromJson(jsonDecode(getPreference.read(PrefConstants.httpClientData)));
}

setAuthJsonData(AccessCredentials val) {
  getPreference.write(PrefConstants.httpClientData, jsonEncode(val));
}

Future<String> refreshToken(Function() callback) async {
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signInSilently();
  final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

  final f_auth.AuthCredential credential = f_auth.GoogleAuthProvider.credential(
    accessToken: googleSignInAuthentication?.accessToken,
    idToken: googleSignInAuthentication?.idToken,
  );
  await auth.signInWithCredential(credential);

  await auth.currentUser?.getIdToken(true).then((value) {
    // showLog("token ===> $value");
    // showLog("authTime ===> ${value.authTime}");
    // showLog("expirationTime ===> ${value.expirationTime}");
    // showLog("signInProvider ===> ${value.signInProvider}");
  });
  kHomeController.credentials = getAuthJsonData();

  kHomeController.httpClient = g_apis.authenticatedClient(http.Client(), kHomeController.credentials);

  kHomeController.classroomApi = ClassroomApi(kHomeController.httpClient);
  await googleSignIn.authenticatedClient().then((value) {
    // AccessCredentials accessCredentials = AccessCredentials(
    //   AccessToken(
    //     value?.credentials.accessToken.type ?? "",
    //     value?.credentials.accessToken.data ?? "",
    //     DateTime.now().add(const Duration(days: 1000)).toUtc(),
    //   ),
    //   value?.credentials.refreshToken,
    //   value?.credentials.scopes ?? [],
    //   idToken: value?.credentials.idToken,
    // );
    AccessCredentials accessCredentials = value?.credentials ?? AccessCredentials(AccessToken("", "", DateTime.now()), "refreshToken", []);
    setAuthJsonData(accessCredentials);
  });
  callback();
  return googleSignInAuthentication?.accessToken ?? ""; //new token
}

// void getEventsPastAuth() async {
//   var client = http.Client();
//   g_apis.AccessCredentials credentials = getAuthJsonData();
//   g_apis.AccessCredentials refreshedCred = await refreshCredentials(_credentialsID, credentials, client);
//
//   client = autoRefreshingClient(_credentialsID, credentials, client);
// var calendar = CalendarApi(client);
// var now = DateTime.now();
// var calEvents = calendar.events.list('primary', maxResults: 100, timeMin: now, timeMax: DateTime(now.year, now.month + 1, now.day));
// calEvents.then((Events events) {
//   events.items!.forEach((Event event) {
//     debugPrint(event.summary);
//   });
// });
// }

googleAuth(BuildContext context) async {
  try {
    // await googleSignIn.currentUser?.clearAuthCache();
    await googleSignIn.signOut();
    await auth.signOut();
    await StreamChat.of(context).client.disconnectUser();
  } catch (e) {
    showLog(e);
  }
  if (await checkInternet()) {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn().onError((error, stackTrace) {
      showLog(error);
    });
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final f_auth.AuthCredential credential = f_auth.GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final f_auth.UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user;

        if (user != null) {
          showProgressDialog(loaderColor: AppColors.white);
          // loginSuccess();
          Api().call(
            params: {
              "firstname": user?.displayName ?? "",
              "lastname": "",
              "email": user?.email ?? "",
              "phonenumber": user?.phoneNumber ?? "",
              "profileUrl": user?.photoURL ?? "",
              "usertypeid": 1,
              "googleID": user?.uid ?? "",
              "active": 1
            },
            loaderColor: AppColors.white,
            url: ApiConfig.login,
            success: (Map<String, dynamic> response) async {
              hideProgressDialog();
              LoginModel loginModel = LoginModel.fromJson(response);
              kHomeController.userData.value = LoginModelDataData.fromJson(loginModel.data?.data?.toJson() ?? {});
              setObject(PrefConstants.userDetails, loginModel.data?.data ?? {});
              getPreference.write(PrefConstants.loginToken, loginModel.data?.token ?? "");

              // String name = "name-1";
              // String userId = "id1";
              // String otherUserId = "id2";
              await googleSignIn.authenticatedClient().then((value) {
                AccessCredentials accessCredentials = value?.credentials ?? AccessCredentials(AccessToken("", "", DateTime.now()), "refreshToken", []);
                setAuthJsonData(accessCredentials);
                showLog("1111 ===> ${getPreference.read(PrefConstants.httpClient)}");
                setIsLogin(isLogin: true);
                refreshToken(() {});
                Get.offAll(() => const HomeScreen());
              });
            },
            error: (Map<String, dynamic> response) {
              hideProgressDialog();
              showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
            },
            isProgressShow: true,
            methodType: MethodType.post,
          );
          hideProgressDialog();
        }
      } on f_auth.FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
        } else if (e.code == 'invalid-credential') {}
      } catch (e) {
        e.toString();
      }
    } else {
      if (await checkInternet()) {
        showSnackBar(title: appName, message: somethingWrong);
      } else {
        showSnackBar(title: appName, message: "No Internet Available");
      }
    }
  } else {
    showSnackBar(title: appName, message: "No Internet Available");
  }
}

loginSuccess() async {
  hideProgressDialog();
  setIsLogin(isLogin: true);

  await googleSignIn.authenticatedClient().then((value) {
    // AccessCredentials accessCredentials = AccessCredentials(
    //   AccessToken(
    //     value?.credentials.accessToken.type ?? "",
    //     value?.credentials.accessToken.data ?? "",
    //     DateTime.now().add(const Duration(days: 1000)).toUtc(),
    //   ),
    //   value?.credentials.refreshToken,
    //   value?.credentials.scopes ?? [],
    //   idToken: value?.credentials.idToken,
    // );
    AccessCredentials accessCredentials = value?.credentials ?? AccessCredentials(AccessToken("", "", DateTime.now()), "refreshToken", []);
    setAuthJsonData(accessCredentials);
    // setAuthJsonData(value?.credentials ?? AccessCredentials(AccessToken("", "", DateTime.now()), "refreshToken", []));
    showLog("1111 ===> ${getPreference.read(PrefConstants.httpClient)}");
    Get.offAll(() => const HomeScreen());
  });
}
