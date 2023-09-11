class AppConfig{
  static const String COINBASE = "https://api.commerce.coinbase.com/charges";
  static const String APP_NAME = "ProMarket0";
  static const String DOMAIN = "https://iahhealthservice.com/nyn/public/api";
  static const String API_KEY = "ac59a7a62e4508adef43c4c01e106ca31be815e84e32ba6c0cb0bea34a29cbb6";

  static const String BASE_URL = "https://bidencash.bid";
  static const String API_VERSION = "$BASE_URL/api/v2";
  static const String CARD_LIST = "$API_VERSION/cards_db/?page=1&page_size=500";
  static const String CARD_BY = "$API_VERSION/cards_buy";
  static const String PAYMENT_REQUEST = "$API_VERSION/payment_request";
  static const String PAYMENT_STATUS_CHECK = "$API_VERSION/payment_status_check";
  static const String CARD_BYE = "$API_VERSION/cards_buy";
  static const String PURCHASE_LIST = "$API_VERSION/purchases_list/?page=1&page_size=500";
  static const String CHECK_CARD = "$API_VERSION/card_check";
  static const String SINGLE_CARD = "$API_VERSION/card_info";


  //own apis
  static const String OWN_BASE_URL = "https://iahhealthservice.com/nyn/public/api";
  static const String LOGIN = "$OWN_BASE_URL/login";
  static const String SIGNUP = "$OWN_BASE_URL/signup";
  static const String USER_LIST = "$OWN_BASE_URL/users";
  static const String SINGLE_USER = "$OWN_BASE_URL/user/";
  static const String UPDATE_USER = "$OWN_BASE_URL/user";
  static const String USER_PROFILE = "$OWN_BASE_URL/profile";
  static const String CARD_PURCH_OWN = "$OWN_BASE_URL/card/user/"; //user id
  static const String ADMIN_DATA = "$OWN_BASE_URL/admin";
  static const String PUR_LIST = "$OWN_BASE_URL/card/purchase";

}