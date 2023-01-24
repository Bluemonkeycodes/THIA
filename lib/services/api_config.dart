class ApiConfig {
  static const String baseUrl = "http://65.0.159.57:5001/api/";
  // static const String baseUrl = "https://proud-lab-coat-pike.cyclic.app/api/";
  static const String allNews = "${baseUrl}news/all";
  static const String getCategories = "${baseUrl}news/categories";
  static const String getHomeData = "${baseUrl}news/home";
  static const String getCategoryDetails = "${baseUrl}news";

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
