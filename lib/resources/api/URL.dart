class URL {
  static final baseURL = 'http://exservice.4000.global/api/';

  ///payment
  String adPricesListURL = "${baseURL}adPricesList";
  String userTypesListURL = "${baseURL}userTypesList";

  ///auth
  String loginURL = '${baseURL}login';
  String signUpURL = '${baseURL}register';
  String verifyUserURL = '${baseURL}verifyUser';
  String resendVerificationCodeURL = '${baseURL}resendVerificationCode';
  String checkAccountURL = '${baseURL}checkAccount';
  String forgetPasswordURL = '${baseURL}forgetPassword';
  String resetPasswordURL = '${baseURL}resetPassword';

  ///user
  String completeUpdateEmailPhoneURL = "${baseURL}completeUpdateEmailPhone";
  String updateEmailPhoneURL = "${baseURL}updateEmailPhone";
  String updateUserPictureURL = '${baseURL}media/updateUserPicture';
  String updateFirebaseTokenURL = '${baseURL}updateFirebaseToken';
  String switchToBusinessURL = '${baseURL}switchToBusiness';
  String getUserProfileURL = '${baseURL}getUserProfile';
  String updatePasswordURL = '${baseURL}updatePassword';
  String notificationsURL = '${baseURL}notifications';
  String editProfileURL = '${baseURL}editProfile';

  ///user ads
  String getUserAdsURL = '${baseURL}getUserAds';
  String deleteAdURL = "${baseURL}deletePropertyAd";
  String editAdURL = '${baseURL}editAd';

  /// user interest
  String deleteInterestURL = "${baseURL}deleteInterest";
  String addInterestURL = "${baseURL}addInterest";
  String getInterestURL = '${baseURL}getInterest';

  ///external users
  String getUsersInfoURL = "${baseURL}getUsersInfo";
  String getUserAccountURL = "${baseURL}getUserAccount";

  ///categories
  String furnitureTypesListURL = '${baseURL}furnitureTypesList';
  String garagesNumberListURL = '${baseURL}garagesNumberList';
  String balconyNumberListURL = '${baseURL}balconyNumberList';
  String priceOptionsListURL = '${baseURL}priceOptionsList';
  String roomsNumberListURL = '${baseURL}roomsNumberList';
  String bathsNumberListURL = '${baseURL}bathsNumberList';
  String sizeUnitesListURL = '${baseURL}sizeUnitesList';
  String optionsListURL = '${baseURL}optionsList';
  String categoriesListURL = "${baseURL}categoriesList";
  String countriesListURL = "${baseURL}countriesList";
  String townsListURL = "${baseURL}townsList";

  ///ads propertyAdsList
  String adsListURL = '${baseURL}propertyAdsList';
  String saveAdURL = '${baseURL}saveAd';
  String getSavedAdsURL = '${baseURL}getSavedAds';
  String pauseAdURL = '${baseURL}pauseAd';
  String paymentURL = "${baseURL}payment";
  String storeMediaAdURL = "${baseURL}storeMedia";
  String adDetailsURL = "${baseURL}propertyAdDetails";
  String storeAdURL = "${baseURL}propertyStoreAd";
}
