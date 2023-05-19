import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;

import '../main.dart';
import '../utils/utils.dart';

const String somethingWrong = "Something Went Wrong";
const String responseMessage = "NO RESPONSE DATA FOUND";
const String interNetMessage = "NO INTERNET CONNECTION, PLEASE CHECK YOUR INTERNET CONNECTION AND TRY AGAIN LATTER.";
const String connectionTimeOutMessage = "Opps.. Server not working or might be in maintenance .Please Try Again Later";
const String authenticationMessage = "The session has been Expired. Please log in again.";
const String tryAgain = "Try Again";
const String logInAgain = "LogIn Again";

Map<String, dynamic>? tempParams;
FormData? tempFormData;
String? tempServiceUrl;
Function? tempSuccess;
Function? tempError;
bool? tempIsProgressShow;
bool? isTempFormData;
bool? tempIsLoading;
bool? tempIsFromLogout;
bool? tempIsHideLoader;
String? tempMethodType;

///Status Code with message type array or string
// 501 : sql related err
// 401: validation array
// 201 : string error
// 400 : string error
// 200: response, string/null
// 422: array

int serviceCallCount = 0;

class Api {
  get_x.RxBool isLoading = false.obs;

  call({
    required String url,
    required Map<String, dynamic> params,
    required Function success,
    required Function error,
    ErrorMessageType errorMessageType = ErrorMessageType.snackBarOnlyError,
    required MethodType methodType,
    bool? isHideLoader = true,
    required bool isProgressShow,
    FormData? formValues,
    get_x.RxBool? externalLoader,
    Color? loaderColor,
  }) async {
    if (await checkInternet()) {
      externalLoader?.value = true;
      // kHomeController.isInternetAvailable.value = true;
      if (isProgressShow) {
        showProgressDialog(isLoading: isProgressShow, loaderColor: loaderColor);
      }

      Map<String, dynamic> headerParameters;
      headerParameters = {
        "Authorization": "Bearer ${getPreference.read(PrefConstants.loginToken) ?? ""}",
        // "fcm_token": getPreference.read(PrefConstants.fcmTokenPref) ?? "",
        // "timeZoneOffset": DateTime.now().timeZoneOffset,
        // "deviceType": Platform.isAndroid
        //     ? "1"
        //     : Platform.isIOS
        //         ? "2"
        //         : "3",
      };

      try {
        Response response;
        if (methodType == MethodType.get) {
          response = await Dio().get(url, queryParameters: params, options: Options(headers: headerParameters, responseType: ResponseType.plain));
        } else if (methodType == MethodType.put) {
          response = await Dio().put(url, data: params, options: Options(headers: headerParameters, responseType: ResponseType.plain));
        } else if (methodType == MethodType.delete) {
          response = await Dio().delete(url, data: params, options: Options(headers: headerParameters, responseType: ResponseType.plain));
        } else {
          response = await Dio().post(url, data: formValues ?? params, options: Options(headers: headerParameters, responseType: ResponseType.plain));
        }
        showLog("status code ===> ${response.statusCode}");
        if (handleResponse(response)) {
          showLog("url ===> $url");
          showLog("params ===> $params");
          showLog("response ===> $response");

          Map<String, dynamic>? responseData;
          responseData = jsonDecode(response.data);

          if (isHideLoader!) {
            hideProgressDialog();
          }
          if (responseData?["success"] ?? false) {
            externalLoader?.value = false;
            success(responseData);
          } else {
            //region 401 = Session Expired  Manage Authentication/Session Expire
            if (response.statusCode == 401 || response.statusCode == 403) {
              unauthorizedDialog(responseData?["message"]);
            } else if (errorMessageType == ErrorMessageType.snackBarOnlyError || errorMessageType == ErrorMessageType.snackBarOnResponse) {
              get_x.Get.snackbar("Error", responseData?["message"]);
            } else if (errorMessageType == ErrorMessageType.dialogOnlyError || errorMessageType == ErrorMessageType.dialogOnResponse) {
              await apiAlertDialog(message: responseData?["message"], buttonTitle: "Okay");
            }
            //#endregion alert
            externalLoader?.value = false;
            error(responseData);

            //endregion
          }
          isLoading.value = false;
        } else {
          externalLoader?.value = false;
          if (isHideLoader!) {
            hideProgressDialog();
          }
          if (await checkInternet()) {
            // kHomeController.isInternetAvailable.value = true;
            externalLoader?.value = false;
            showErrorMessage(
                message: responseMessage,
                isRecall: true,
                callBack: () {
                  get_x.Get.back();
                  call(params: params, url: url, success: success, error: error, isProgressShow: isProgressShow, methodType: methodType, formValues: formValues, isHideLoader: isHideLoader);
                });
            error(response.toString());
            isLoading.value = false;
          } else {
            externalLoader?.value = false;
            // kHomeController.isInternetAvailable.value = false;
          }
        }
        isLoading.value = false;
      } on DioError catch (dioError) {
        if (await checkInternet()) {
          externalLoader?.value = false;
          dioErrorCall(
              dioError: dioError,
              onCallBack: (String message, bool isRecallError) {
                showLog(message);
                showLog(dioError.response?.statusCode);
                //   showErrorMessage(
                //       message: message,
                //       isRecall: isRecallError,
                //       callBack: () {
                //         if (serviceCallCount < 3) {
                //           serviceCallCount++;
                //
                //           if (isRecallError) {
                //             getX.Get.back();
                //             call(
                //               params: params,
                //               url: url,
                //               success: success,
                //               error: error,
                //               isProgressShow: isProgressShow,
                //               methodType: methodType,
                //               formValues: formValues,
                //               isHideLoader: isHideLoader,
                //             );
                //           } else {
                //             getX.Get.back(); // For redirecting to back screen
                //           }
                //         } else {
                //           getX.Get.back(); // For redirecting to back screen
                //           // GeneralController.to.selectedTab.value = 0;
                //           // getX.Get.offAll(() => DashboardTab());
                //         }
                //       });
              });
          isLoading.value = false;
        } else {
          // kHomeController.isInternetAvailable.value = false;
        }

        //#region dioError

        //#endregion dioError
      } catch (e) {
        //#region catch
        showLog(e);
        externalLoader?.value = false;
        hideProgressDialog();
        showErrorMessage(
          message: e.toString(),
          isRecall: true,
          callBack: () {
            get_x.Get.back();
            call(params: params, url: url, success: success, error: error, isProgressShow: isProgressShow, methodType: methodType, formValues: formValues, isHideLoader: isHideLoader);
          },
        );
        isLoading.value = false;
        //#endregion catch
      }
    } else {
      externalLoader?.value = false;
      // kHomeController.isInternetAvailable.value = false;
      error({"data": {}, "message": "No Internet Available", "success": false});
      //#region No Internet
      // showErrorMessage(
      //     message: interNetMessage,
      //     isRecall: true,
      //     callBack: () {
      //       getX.Get.back();
      //       call(
      //           params: params,
      //           url: url,
      //           success: success,
      //           error: error,
      //           isProgressShow: isProgressShow,
      //           methodType: methodType,
      //           formValues: formValues,
      //           isHideLoader: isHideLoader);
      //     });
      //#endregion No Internet
    }
  }
}

showErrorMessage({required String message, required bool isRecall, required Function callBack}) {
  serviceCallCount = 0;
  // serviceCallCount++;
  hideProgressDialog();
  apiAlertDialog(
      buttonTitle: serviceCallCount < 3 ? tryAgain : "Restart App",
      message: message,
      buttonCallBack: () {
        callBack();
      });
}

void showProgressDialog({bool isLoading = true, Color? loaderColor}) {
  isLoading = true;
  if ((get_x.Get.isDialogOpen ?? false) || get_x.Get.isSnackbarOpen) {
    return;
  }
  get_x.Get.dialog(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: CircularProgressIndicator(color: loaderColor ?? AppColors.primaryColor)),
        ],
      ),
      barrierColor: Colors.black12,
      barrierDismissible: false);
}

void hideProgressDialog({bool isLoading = true, bool isProgressShow = true, bool isHideLoader = true}) {
  isLoading = false;
  if ((isProgressShow || isHideLoader) && get_x.Get.isDialogOpen!) {
    get_x.Get.back();
  }
}

dioErrorCall({required DioError dioError, required Function onCallBack}) {
  switch (dioError.type) {
    case DioErrorType.other:
    case DioErrorType.connectTimeout:
      // onCallBack(connectionTimeOutMessage, false);
      onCallBack(dioError.message, true);
      break;
    case DioErrorType.response:
    case DioErrorType.cancel:
    case DioErrorType.receiveTimeout:
    case DioErrorType.sendTimeout:
    default:
      onCallBack(dioError.message, true);
      break;
  }
}

Future<bool> checkInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

unauthorizedDialog(message) async {
  if (!get_x.Get.isDialogOpen!) {
    get_x.Get.dialog(
      WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: CupertinoAlertDialog(
          title: const Text(appName),
          content: Text(message ?? authenticationMessage),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Okay"),
              onPressed: () {
                //restart the application
                getPreference.erase();
                // get_x.Get.offAll(() => const SplashScreen());
              },
            ),
          ],
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInCubic,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

bool handleResponse(Response response) {
  try {
    if (isNotEmptyString(response.toString())) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

apiAlertDialog({required String message, String? buttonTitle, Function? buttonCallBack, bool isShowGoBack = true}) async {
  if (!get_x.Get.isDialogOpen!) {
    await get_x.Get.dialog(
      WillPopScope(
        onWillPop: () {
          return isShowGoBack ? Future.value(true) : Future.value(false);
        },
        child: CupertinoAlertDialog(
          title: const Text(appName),
          content: Text(message),
          actions: isShowGoBack
              ? [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : "Try again"),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        get_x.Get.back();
                      }
                    },
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: const Text("Go Back"),
                    onPressed: () {
                      get_x.Get.back();
                      get_x.Get.back();
                    },
                  )
                ]
              : [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(isNotEmptyString(buttonTitle) ? buttonTitle! : "Try again"),
                    onPressed: () {
                      if (buttonCallBack != null) {
                        buttonCallBack();
                      } else {
                        get_x.Get.back();
                      }
                    },
                  ),
                ],
        ),
      ),
      barrierDismissible: false,
      transitionCurve: Curves.easeInCubic,
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}

enum MethodType { get, post, put, delete }

enum ErrorMessageType { snackBarOnlyError, snackBarOnlySuccess, snackBarOnResponse, dialogOnlyError, dialogOnlySuccess, dialogOnResponse, none }

class BooleanResponseModel {
  BooleanResponseModel({
    this.success,
    this.show,
    this.message,
  });

  BooleanResponseModel.fromJson(dynamic json) {
    show = json['show'];
    success = json['success'];
    message = json['message'];
  }

  bool? success;
  String? message;
  bool? show;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['show'] = show;
    map['success'] = success;
    map['message'] = message;
    return map;
  }
}
