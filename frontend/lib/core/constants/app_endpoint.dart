class AppEndpoint {
  // APIのベースURL
  static const String baseUrl = "https://suanne-chapleted-dirtily.ngrok-free.dev";

  // ログイン認証APIのURL
  static const String login = "$baseUrl/api/login";

  // 製品一覧を取得するAPI
  static const String productGet = "$baseUrl/api/product/get";

  static String productGetById(int id) => "$baseUrl/api/product/$id/get";

  static const String productInsert = "$baseUrl/api/product/insert";

  static String productUpdate(int id) => "$baseUrl/api/product/$id/update";

  static const String category = "$baseUrl/api/category/get";

  static const String unit = "$baseUrl/api/unit/get";

  static String productDelete(int id) => "$baseUrl/api/product/$id/delete";
  
}