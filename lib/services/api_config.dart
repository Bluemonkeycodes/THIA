class ApiConfig {
  // static const String baseUrl = "http://44.199.178.207/api/";
  static const String baseUrl = "https://api.thiaapp.com/api/";
  static const String localBaseUrl = "localhost:5001/api/";

  // static const String baseUrl = "https://proud-lab-coat-pike.cyclic.app/api/";
  static const String login = "${baseUrl}user/create";
  static const String getPriorityCount = "${baseUrl}task/count";
  static const String createTodo = "${baseUrl}task/create";
  static const String calenderTaskList = "${baseUrl}user/task?duedate=";
  static const String setUserClass = "${baseUrl}user/class";
  static const String getUserTaskWithClassId = "${baseUrl}user/task?classID=";
  static const String getUserTask = "${baseUrl}user/task";
  static const String getOtherUserTask = "${baseUrl}task/class/";
  static const String setTaskComplete = "${baseUrl}task/status/complete/";
  static const String setSubTaskComplete = "${baseUrl}task/subtask/complete/";
  static const String deleteTask = "${baseUrl}task/";
  static const String getTaskDetail = "${baseUrl}task/";
  static const String deleteSubTaskDetail = "${baseUrl}task/subtask/";
  static const String getAllUser = "${baseUrl}user/class/all";

  static const String methodPOST = "post";
  static const String methodGET = "get";
  static const String methodPUT = "put";
  static const String methodDELETE = "delete";
  static const String error = "Error";
  static const String success = "Success";
  static const String message = "Message";
  static const String loginPref = "loginPref";
  static const String warning = "Warning";
}
