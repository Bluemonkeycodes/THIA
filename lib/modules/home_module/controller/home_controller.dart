import 'dart:math';

import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as g_apis;
import 'package:http/http.dart' as http;
import 'package:thia/modules/home_module/model/calender_task_list_model.dart';
import 'package:thia/utils/social_login.dart';

import '../../../services/api_service_call.dart';
import '../../../utils/utils.dart';
import '../../auth/model/login_model.dart';
import '../model/class_todo_model.dart';
import '../model/class_user_model.dart';
import '../model/get_priority_count.dart';
import '../model/other_user_task_model.dart';
import '../model/task_detail_model.dart';

class HomeController extends GetxController {
  // RxInt subTodoCount = 0.obs;
  RxList<TaskDetailModelDataSubTask> subTodoTaskList = <TaskDetailModelDataSubTask>[].obs;

  Rx<LoginModelDataData> userData = LoginModelDataData().obs;
  RxInt selectedTabIndex = 1.obs;

  RxInt selectedPeopleTabIndex = 0.obs;
  Rx<Course> selectedCourse = Course().obs;

  Rx<ListCoursesResponse> courseModel = ListCoursesResponse().obs;

  late g_apis.AccessCredentials credentials = getAuthJsonData();

  late g_apis.AuthClient httpClient = g_apis.authenticatedClient(http.Client(), credentials);

  late ClassroomApi classroomApi = ClassroomApi(httpClient);
  RxInt apiCallCount = 0.obs;
  RxList<String> classRoomIdList = <String>[].obs;
  RxBool classListLoading = false.obs;

  getClassList() async {
    // await googleSignIn.currentUser?.clearAuthCache();
    classListLoading.value = true;
    ListCoursesResponse response = await classroomApi.courses.list(pageSize: 500).onError((error, stackTrace) async {
      classListLoading.value = false;

      refreshToken(() async {
        apiCallCount.value++;
        if (apiCallCount.value < 2) {
          getClassList();
        }
      });
      showLog("ERROR :::: $error $stackTrace");
      return Future.error(error.toString());
    }).catchError((err) {
      showLog("ERROR2 :::: $err");
    });

    courseModel.value = response;
    classListLoading.value = false;

    if (courseModel.value.courses?.isNotEmpty ?? false) {
      apiCallCount.value = 0;
      classRoomIdList.clear();
      courseModel.value.courses?.forEach((element) {
        classRoomIdList.add(element.id ?? "");
      });
      List<Map<String, dynamic>> x = [];
      classRoomIdList.forEach((element) {
        x.add({"classID": element});
      });
      Map<String, dynamic> params = {"classList": x};
      setUserClass(params, () {});
    }

    if (courseModel.value.courses?.isNotEmpty == true) {
      selectedCourse.value = courseModel.value.courses?.first ?? Course();
    }
  }

  Rx<ListCourseWorkResponse> allAssignmentModel = ListCourseWorkResponse().obs;
  RxList<CourseWork> courseWorkList = <CourseWork>[].obs;
  RxInt courseWorkApiCallCount = 0.obs;

  RxBool courseLoading = false.obs;

  Future<void> getAllAssignmentList(String courseId) async {
    courseLoading.value = true;
    await classroomApi.courses.courseWork.list(courseId, pageSize: 500).then((value) {
      allAssignmentModel.value = value;
      // courseLoading.value = false;
      showLog("courseWork?.length ===> ${allAssignmentModel.value.courseWork?.length}");
    }).onError((error, stackTrace) async {
      courseLoading.value = false;
      showLog("getAllAssignmentList error ===> $error");
      refreshToken(() async {
        courseWorkApiCallCount.value++;
        if (courseWorkApiCallCount.value < 2) {
          getAllAssignmentList(courseId);
        }
      });
    });
    await getAllAssignmentListNew(courseId).then((value) {
      courseLoading.value = false;

      courseWorkList.clear();

      kHomeController.listStudentSubmissionResponse.value.studentSubmissions?.forEach((ele) {
        if ((ele.state == "SUBMISSION_STATE_UNSPECIFIED" || ele.state == "NEW" || ele.state == "CREATED")) {
          if (allAssignmentModel.value.courseWork?.where((element) => element.id == ele.courseWorkId).isNotEmpty ?? false) {
            courseWorkList.add(allAssignmentModel.value.courseWork?.firstWhere((element) => element.id == ele.courseWorkId) ?? CourseWork());
          }
        }
      });
      courseLoading.value = false;

      showLog("courseWorkList.length ===> ${courseWorkList.length}");
    });
  }

  Rx<ListStudentSubmissionsResponse> listStudentSubmissionResponse = ListStudentSubmissionsResponse().obs;
  RxInt studentSubmissionApiCallCount = 0.obs;

  Future<void> getAllAssignmentListNew(String courseId) async {
    await classroomApi.courses.courseWork.studentSubmissions.list(courseId, "-", pageSize: 500).then((value) {
      listStudentSubmissionResponse.value = value;
    }).onError((error, stackTrace) async {
      showLog("getAllAssignmentListNew error ===> $error");
      refreshToken(() async {
        studentSubmissionApiCallCount.value++;
        if (studentSubmissionApiCallCount.value < 2) {
          getAllAssignmentListNew(courseId);
        }
      });
      // return Future.error(error);
    });
    showLog("studentSubmissions.length ===> ${listStudentSubmissionResponse.value.studentSubmissions?.length}");
  }

  Rx<GetPriorityCount> getPriorityCountModel = GetPriorityCount().obs;

  getPriorityCount({bool? showLoader}) {
    Api().call(
      params: {},
      url: ApiConfig.getPriorityCount,
      success: (Map<String, dynamic> response) async {
        getPriorityCountModel.value = GetPriorityCount.fromJson(response);
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showLoader ?? true,
      methodType: MethodType.get,
    );
  }

  setUserClass(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.setUserClass,
      success: (Map<String, dynamic> response) async {
        // getPriorityCountModel.value = GetPriorityCount.fromJson(response);
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: false,
      methodType: MethodType.post,
    );
  }

  Rx<ClassUserModel> classUserModel = ClassUserModel().obs;
  RxList<ClassUserModelData> classUserList = <ClassUserModelData>[].obs;
  RxBool classUserProgress = false.obs;

  getUsersOfClass(String classID, Function() callBack, {bool? showProgress}) {
    classUserProgress.value = true;
    Api().call(
      params: {},
      url: ApiConfig.setUserClass + "/$classID",
      success: (Map<String, dynamic> response) async {
        classUserProgress.value = false;

        classUserModel.value = ClassUserModel.fromJson(response);
        if (classUserModel.value.data?.isNotEmpty ?? false) {
          classUserList.clear();
          classUserModel.value.data?.forEach((element) {
            if ((element?.userID ?? "").toString() != (userData.value.userId ?? "").toString()) {
              classUserList.add(element ?? ClassUserModelData());
            }
          });
        }
        callBack();
      },
      error: (Map<String, dynamic> response) {
        classUserProgress.value = false;

        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showProgress ?? true,
      methodType: MethodType.get,
    );
  }

  RxList<String> priorityList = ["High", "Mid", "Low"].obs;
  RxString selectedPriority = "High".obs;

  createTodo(Map<String, dynamic> params, Function() callBack) {
    Api().call(
      params: params,
      url: ApiConfig.createTodo,
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  Rx<CalenderTaskListModel> getCalenderTaskListModel = CalenderTaskListModel().obs;
  RxBool calenderTodoProgress = false.obs;

  getCalenderTaskList({required String date, bool? showLoader}) {
    calenderTodoProgress.value = true;
    Api().call(
      params: {},
      url: ApiConfig.calenderTaskList + date,
      success: (Map<String, dynamic> response) async {
        calenderTodoProgress.value = false;
        getCalenderTaskListModel.value = CalenderTaskListModel.fromJson(response);
      },
      error: (Map<String, dynamic> response) {
        calenderTodoProgress.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showLoader ?? true,
      methodType: MethodType.get,
    );
  }

  Rx<ClassTodoModel> userTodoModel = ClassTodoModel().obs;
  RxList<TodoModel> userTodoList = <TodoModel>[].obs;
  RxBool userTodoProgress = false.obs;

  getClassTaskList({required String classID, bool? showProgress}) {
    userTodoProgress.value = true;
    Api().call(
      params: {},
      url: ApiConfig.getUserTaskWithClassId + classID,
      success: (Map<String, dynamic> response) async {
        userTodoProgress.value = false;
        userTodoModel.value = ClassTodoModel.fromJson(response);

        if (userTodoModel.value.data?.isNotEmpty ?? false) {
          userTodoList.clear();
          userTodoModel.value.data?.forEach((element) {
            userTodoList.add(element ?? TodoModel());
          });
        }
      },
      error: (Map<String, dynamic> response) {
        userTodoProgress.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showProgress ?? true,
      methodType: MethodType.get,
    );
  }

  Rx<OtherUserTaskModel> otherUserTaskModel = OtherUserTaskModel().obs;
  RxList<TodoModel> otherUserTaskList = <TodoModel>[].obs;
  RxBool otherUserProgress = false.obs;

  getOtherTaskList({required String classID, bool? showProgress}) {
    otherUserProgress.value = true;
    Api().call(
      params: {},
      url: ApiConfig.getOtherUserTask + classID,
      success: (Map<String, dynamic> response) async {
        otherUserProgress.value = false;
        otherUserTaskModel.value = OtherUserTaskModel.fromJson(response);

        if (otherUserTaskModel.value.data?.isNotEmpty ?? false) {
          otherUserTaskList.clear();
          otherUserTaskModel.value.data?.forEach((element) {
            otherUserTaskList.add(element ?? TodoModel());
          });
        }
      },
      error: (Map<String, dynamic> response) {
        otherUserProgress.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showProgress ?? true,
      methodType: MethodType.get,
    );
  }

  setTaskComplete(String id, Function() callBack) {
    Api().call(
      params: {},
      url: ApiConfig.setTaskComplete + id,
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.post,
    );
  }

  setSubTaskComplete(String id, int trueOrFalse, Function() callBack, {bool? showLoader}) {
    Api().call(
      params: {},
      url: ApiConfig.setSubTaskComplete + id + "/" + (trueOrFalse.toString()),
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showLoader ?? true,
      methodType: MethodType.post,
    );
  }

  deleteTask(String id, Function() callBack) {
    Api().call(
      params: {},
      url: ApiConfig.deleteTask + id,
      success: (Map<String, dynamic> response) async {
        callBack();
      },
      error: (Map<String, dynamic> response) {
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.delete,
    );
  }

  /// GET ALL TODO LIST OF USER TASK
  Rx<ClassTodoModel> userTasTodoModel = ClassTodoModel().obs;
  RxList<TodoModel> userTaskTodoList = <TodoModel>[].obs;
  RxBool userTaskTodoProgress = false.obs;

  getUsesTaskList({bool? showProgress}) {
    userTaskTodoProgress.value = true;
    Api().call(
      params: {},
      url: ApiConfig.getUserTask,
      success: (Map<String, dynamic> response) async {
        userTaskTodoProgress.value = false;
        userTasTodoModel.value = ClassTodoModel.fromJson(response);

        if (userTasTodoModel.value.data?.isNotEmpty ?? false) {
          userTaskTodoList.clear();
          userTasTodoModel.value.data?.forEach((element) {
            if (element != null) {
              userTaskTodoList.add(element);
            }
          });
        }
      },
      error: (Map<String, dynamic> response) {
        userTaskTodoProgress.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: showProgress ?? true,
      methodType: MethodType.get,
    );
  }

  /// TASK DETAIL API CALL
  Rx<TaskDetailModel> taskDetailModel = TaskDetailModel().obs;
  RxBool taskDetailLoader = false.obs;

  callTaskDetailApi(String id, Function() callBack) {
    taskDetailLoader.value = true;
    Api().call(
      params: {},
      url: ApiConfig.getTaskDetail + id,
      success: (Map<String, dynamic> response) async {
        taskDetailLoader.value = false;
        taskDetailModel.value = TaskDetailModel.fromJson(response);
        callBack();
      },
      error: (Map<String, dynamic> response) {
        taskDetailLoader.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: false,
      methodType: MethodType.get,
    );
  }

  /// DELETE SUB TODO API
  callDeleteSubTodoApi(String id, Function() callBack) {
    taskDetailLoader.value = true;
    Api().call(
      params: {},
      url: ApiConfig.deleteSubTaskDetail + id,
      success: (Map<String, dynamic> response) async {
        // taskDetailLoader.value = false;
        // taskDetailModel.value = TaskDetailModel.fromJson(response);
        callBack();
      },
      error: (Map<String, dynamic> response) {
        // taskDetailLoader.value = false;
        showSnackBar(title: ApiConfig.error, message: response["message"] ?? "");
      },
      isProgressShow: true,
      methodType: MethodType.delete,
    );
  }

  List<String> groupPlaceholderImageList = [
    "https://i.imgur.com/rJoCrHP.png",
    "https://i.imgur.com/JYxDAVB.png",
    "https://i.imgur.com/30L5oye.png",
    "https://i.imgur.com/LOXrlDd.png",
    "https://i.imgur.com/ReSxSJU.png",
    "https://i.imgur.com/v44m8FQ.png",
    "https://i.imgur.com/75ZAkmV.png",
    "https://i.imgur.com/9P6MkaZ.png",
    "https://i.imgur.com/V19x17E.png",
    "https://i.imgur.com/iX6vU0Y.png",
    "https://i.imgur.com/5qHoXCr.png",
    "https://i.imgur.com/soxkWsT.png",
    "https://i.imgur.com/Vv56v4q.png",
    "https://i.imgur.com/grk0qrl.png",
    "https://i.imgur.com/NxOIwIh.png",
    "https://i.imgur.com/Iswd2Cf.png",
    "https://i.imgur.com/zbxJ2gj.png",
    "https://i.imgur.com/0hZuUCB.png",
    "https://i.imgur.com/jwtqHAo.png",
    "https://i.imgur.com/2jGMCBY.png",
    "https://i.imgur.com/tlZ028Y.png",
  ];

  String getGroupPlaceHolder() {
    final random = Random();
    showLog("random image ===> ${groupPlaceholderImageList[random.nextInt(groupPlaceholderImageList.length)]}");
    return groupPlaceholderImageList[random.nextInt(groupPlaceholderImageList.length)];
  }
}
