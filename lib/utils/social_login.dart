import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:thia/services/api_service_call.dart';
import 'package:thia/utils/utils.dart';

import '../modules/home_module/views/home_screen.dart';

f_auth.User? user;
final GoogleSignIn googleSignIn = GoogleSignIn();
f_auth.FirebaseAuth auth = f_auth.FirebaseAuth.instance;

googleAuth() async {
  try {
    await googleSignIn.signOut();
    await auth.signOut();
  } catch (e) {
    showLog(e);
  }
  final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

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
        showProgressDialog();
        setIsLogin(isLogin: true);
        Get.offAll(() => const HomeScreen());

        //TODO: call api here...
        // Api().call(
        //   params: {
        //     "firstName": user!.displayName,
        //     "lastName": "",
        //     "email": user!.email ?? "",
        //     "social_login_token": googleSignInAuthentication.accessToken,
        //     "role": 1,
        //     "social_type": "Google",
        //     "mobile": user!.phoneNumber ?? "",
        //     "profileimageurl": user!.photoURL ?? "",
        //     "social_id": user!.uid,
        //   },
        //   url: ApiConfig.socialMediaLogin,
        //   success: (dio.Response<dynamic> response) {
        //     // SocialLoginModel loginResponseModel = SocialLoginModel.fromJson(response.data);
        //     // kAuthController.userData.value = LoginModelDataUser.fromJson(loginResponseModel.data?.toJson() ?? {});
        //     // getPreference.write(PrefConstants.isLogin, true);
        //     // getPreference.write(PrefConstants.isSocialLogin, true);
        //     // setObject(PrefConstants.userDetails, loginResponseModel.data?.user ?? "");
        //     // getPreference.write(PrefConstants.loginToken, loginResponseModel.data?.token ?? "");
        //     // getPreference.write(PrefConstants.id, loginResponseModel.data?.user?.Id ?? 0);
        //     // getPreference.write(PrefConstants.userPreference, loginResponseModel.data?.user?.role.toString() ?? "1");
        //     success(loginResponseModel);
        //     hideProgressDialog();
        //   },
        //   error: (dio.Response<dynamic> response) {
        //     hideProgressDialog();
        //     showSnackBar(title: ApiConfig.error, message: response.data["message"] ?? "");
        //   },
        //   isProgressShow: true,
        //   methodType: ApiConfig.methodPOST,
        // );
        hideProgressDialog();
      }
    } on f_auth.FirebaseAuthException catch (e) {
      if (e.code == 'account-exists-with-different-credential') {
      } else if (e.code == 'invalid-credential') {}
    } catch (e) {
      e.toString();
    }
  }
}
