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

  static const String unit = "$baseUrl/api/unit/get";

  static String productDelete(int id) => "$baseUrl/api/product/$id/delete";

  static const String updateStock = "$baseUrl/api/product/update-stock";

  static const String insertTransaction = "$baseUrl/api/transaction/insert";


  // Category
  static const String category = "$baseUrl/api/category/get";

  static String categoryById(int id) => "$baseUrl/api/category/$id/get";

  static const String categoryInsert = "$baseUrl/api/category/insert";

  static String categoryUpdate(int id) => "$baseUrl/api/category/$id/update";

  static String categoryDelete(int id) => "$baseUrl/api/category/$id/delete";
}