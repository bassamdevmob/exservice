class Links {
  static const BASE = 'http://localhost:3000/api/exservice/';


  ///auth
  static const LOGIN_URL = 'login';
  static const signUpURL = 'register';
  static const verifyUserURL = 'verifyUser';
  static const resendVerificationCodeURL = 'resendVerificationCode';
  static const checkAccountURL = 'checkAccount';
  static const forgetPasswordURL = 'forgetPassword';
  static const resetPasswordURL = 'resetPassword';

  ///payment
  static const adPricesListURL = "adPricesList";
  static const userTypesListURL = "userTypesList";

  ///user
  static const completeUpdateEmailPhoneURL = "completeUpdateEmailPhone";
  static const updateEmailPhoneURL = "updateEmailPhone";
  static const updateUserPictureURL = 'media/updateUserPicture';
  static const updateFirebaseTokenURL = 'updateFirebaseToken';
  static const switchToBusinessURL = 'switchToBusiness';
  static const getUserProfileURL = 'getUserProfile';
  static const updatePasswordURL = 'updatePassword';
  static const notificationsURL = 'notifications';
  static const editProfileURL = 'editProfile';

  ///user ads
  static const getUserAdsURL = 'getUserAds';
  static const deleteAdURL = "deletePropertyAd";
  static const editAdURL = 'editAd';

  /// user interest
  static const deleteInterestURL = "deleteInterest";
  static const addInterestURL = "addInterest";
  static const getInterestURL = 'getInterest';

  ///external users
  static const getUsersInfoURL = "getUsersInfo";
  static const getUserAccountURL = "getUserAccount";

  ///categories
  static const furnitureTypesListURL = 'furnitureTypesList';
  static const garagesNumberListURL = 'garagesNumberList';
  static const balconyNumberListURL = 'balconyNumberList';
  static const priceOptionsListURL = 'priceOptionsList';
  static const roomsNumberListURL = 'roomsNumberList';
  static const bathsNumberListURL = 'bathsNumberList';
  static const sizeUnitesListURL = 'sizeUnitesList';
  static const optionsListURL = 'optionsList';
  static const categoriesListURL = "categoriesList";
  static const countriesListURL = "countriesList";
  static const townsListURL = "townsList";

  ///ads propertyAdsList
  static const adsListURL = 'propertyAdsList';
  static const saveAdURL = 'saveAd';
  static const getSavedAdsURL = 'getSavedAds';
  static const pauseAdURL = 'pauseAd';
  static const paymentURL = "payment";
  static const storeMediaAdURL = "storeMedia";
  static const adDetailsURL = "propertyAdDetails";
  static const storeAdURL = "propertyStoreAd";
}
