class AppEndpoint {
  // APIのベースURL
  static const String baseUrl = "https://suanne-chapleted-dirtily.ngrok-free.dev";

  // ログイン認証APIのURL
  static const String login = "$baseUrl/api/login";

  static const String userGet = "$baseUrl/api/user/get";

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

  // Transaction 
  static String transactionGet(int page, int? limit, String? startDate, String? endDate, int? userId, {String? query}) => "$baseUrl/api/transaction/get?page=$page&limit=$limit&user_id=$userId&start_date=$startDate&end_date=$endDate&query=${query ?? ''}";

  static String stockGet(int page, int? limit) => "$baseUrl/api/product/get/paginate?page=$page&limit=$limit";
  
  static String auditGet(int page, int? limit) => "$baseUrl/api/audit/get/paginate?page=$page&limit=$limit";
  
  static String transactionGetByid(int id) => "$baseUrl/api/transaction/$id/get";

  static const String transactionSummey = "$baseUrl/api/transaction/get/summery";

  static const String transactionMonthlySummary = "$baseUrl/api/transaction/monthly-summary";

  static const String transactionSummaryByCashier = "$baseUrl/api/transaction/get/summery-by-cashier";

  static const String productBestSeller = "$baseUrl/api/product/best-seller";
  
  static String productSearch(String query) => "$baseUrl/api/product/search?query=$query";
}