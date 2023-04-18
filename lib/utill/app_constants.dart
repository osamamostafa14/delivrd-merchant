class AppConstants {
  static const String APP_NAME = 'Delivrd Merchant';
  static const String BASE_URL = 'https://delivrd.osama-mostafa.com';
  static const String CONFIG_URI = '/api/v1/config';
  static const String ORDER_LIST_URI = '/api/v1/driver/orders/current-orders';
  static const String ACCEPTED_LIST_URI = '/api/v1/driver/orders/accepted-orders';
  static const String HISTORY_LIST_URI = '/api/v1/driver/orders/history';
  static const String LOGIN_URI = '/api/v1/auth/driver/login';
  static const String TOKEN_URI = '/api/v1/driver/update-fcm-token';
  static const String ACCEPT_REJECT_URI = '/api/v1/driver/accept-reject';
  static const String PROFILE_URI = '/api/v1/driver/profile?token=';
  static const String CHECK_EMAIL_URI = '/api/v1/driver/check-email';
  static const String REGISTER_URI = '/api/v1/driver/register';
  static const String UPDATE_PROFILE_URI = '/api/v1/driver/update-profile';
  static const String UPDATE_LOCATION_URI = '/api/v1/driver/update-location';
  static const String UPDATE_STATUS_URI = '/api/v1/driver/update-status';
  static const String DELETE_ACCOUNT = '/api/v1/driver/delete-account';
  static const String CHECK_PASSWORD_URI = '/api/v1/driver/check-password';


  // Bank Account Strings
  static const String ADD_CARD_URI = '/api/v1/driver/financials/add-card';
  static const String UPDATE_CARD_URI = '/api/v1/driver/financials/update-card';
  static const String ACCOUNTS_URI = '/api/v1/driver/financials/accounts';
  static const String REMOVE_BANK_ACCOUNT_URI = '/api/v1/driver/financials/remove-account';
  static const String WITHDRAW_URI = '/api/v1/driver/financials/withdraw';


  /// Financials
  static const String FILTER_DATE_STATS = '/api/v1/driver/financials/financials-stats';
  static const String DRIVER_WITHDRAWALS_URI = '/api/v1/driver/financials/withdrawals';

  static const String VERIFY_EMAIL_URI = '/api/v1/driver/verify-mechanic-email';
  static const String VERIFY_TOKEN_URI = '/api/v1/driver/verify-mechanic-token';
  static const String FORGET_PASSWORD_URI = '/api/v1/driver/forgot-mechanic-password';
  static const String RESET_PASSWORD_URI = '/api/v1/driver/reset-mechanic-password';
  // internal
  static const String TOKEN = 'token';
  static const String USER_PASSWORD = 'user_password';
  static const String USER_EMAIL = 'user_email';
  static const String API_KEY = 'AIzaSyDUWc3BbmZ-ApyHJskO4wp8WLffno9_U7U';
}
