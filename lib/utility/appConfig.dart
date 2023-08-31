class AppConfig{
  static const String APP_NAME = "BindCash";
  static const String API_KEY = "93ba91db72b6cb5189d9e55f2a073ccf55a2073799dce287d512275c58f9eb25";

  static const String BASE_URL = "https://bidencash.bid";
  static const String API_VERSION = "$BASE_URL/api/v2";
  static const String CARD_LIST = "$API_VERSION/cards_db/?page=1&page_size=500";
  static const String CARD_BY = "$API_VERSION/cards_buy/";
  static const String BALANCE = "$API_VERSION/get_balance/";
  static const String PAYMENT_REQUEST = "$API_VERSION/payment_request/";
  static const String PAYMENT_STATUS_CHECK = "$API_VERSION/payment_status_check/";
  static const String CARD_BYE = "$API_VERSION/cards_buy/";
  static const String PURCHASE_LIST = "$API_VERSION/purchases_list/?page=1&page_size=500/";
}