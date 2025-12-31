class AppEndpoint {
  // Base URL
  static const String baseUrl = "https://suanne-chapleted-dirtily.ngrok-free.dev";

  // Authentication Endpoints
  static const String login = "$baseUrl/api/login";

  static const String productGet = "$baseUrl/api/product/get";

  static const String productInsert = "$baseUrl/api/product/insert";

  static const String category = "$baseUrl/api/category/get";

  static const String unit = "$baseUrl/api/unit/get";
}