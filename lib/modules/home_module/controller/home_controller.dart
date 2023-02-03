import 'package:get/get.dart';
import 'package:googleapis/classroom/v1.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as g_apis;
import 'package:http/http.dart' as http;
import 'package:thia/utils/social_login.dart';

import '../../../utils/utils.dart';

class HomeController extends GetxController {
  RxInt selectedTabIndex = 1.obs;

  RxInt selectedPeopleTabIndex = 0.obs;
  RxString selectedCourse = "".obs;

  Rx<ListCoursesResponse> courseModel = ListCoursesResponse().obs;

  static g_apis.AccessCredentials credentials = getAuthJsonData();

  static g_apis.AuthClient httpClient = g_apis.authenticatedClient(http.Client(), credentials);

  ClassroomApi classroomApi = ClassroomApi(httpClient);

  getClassList() async {
    // classroomApi.courses.list().then((value) {
    //   courseModel.value = value;
    //   // courseModel.value.courses?.forEach((element) {
    //   //   showLog("name ===> ${element.name}");
    //   //   showLog("description ===> ${element.descriptionHeading}");
    //   // });
    // });

    ListCoursesResponse response = await classroomApi.courses.list().onError((error, stackTrace) {
      showLog("ERROR :::: $error $stackTrace");
      return Future.error(error.toString());
    }).catchError((err) {
      showLog("ERROR2 :::: $err");
    });

    courseModel.value = response;

    if (courseModel.value.courses?.isNotEmpty == true) {
      selectedCourse.value = courseModel.value.courses?.first.name ?? "";
    }
  }

  Rx<ListCourseWorkResponse> allAssignmentModel = ListCourseWorkResponse().obs;
  RxList<CourseWork> courseWorkList = <CourseWork>[].obs;

  Future<void> getAllAssignmentList(String courseId) async {
    courseWorkList.clear();

    await classroomApi.courses.courseWork.list(courseId).then((value) {
      allAssignmentModel.value = value;
      showLog("courseWork?.length ===> ${allAssignmentModel.value.courseWork?.length}");
    });
    await getAllAssignmentListNew(courseId).then((value) {
      allAssignmentModel.value.courseWork?.forEach((element) {
        if (kHomeController.listStudioSubmissionResponse.value.studentSubmissions?.where((ele) => (ele.courseWorkId == element.id)).isEmpty == true) {
          courseWorkList.add(element);
        }
      });
      showLog("courseWorkList.length ===> ${courseWorkList.length}");
    });
  }

  Rx<ListStudentSubmissionsResponse> listStudioSubmissionResponse = ListStudentSubmissionsResponse().obs;

  Future<void> getAllAssignmentListNew(String courseId) async {
    await classroomApi.courses.courseWork.studentSubmissions.list(courseId, "-").then((value) {
      listStudioSubmissionResponse.value = value;
    });
    showLog("studentSubmissions.length ===> ${listStudioSubmissionResponse.value.studentSubmissions?.length}");
  }
}
