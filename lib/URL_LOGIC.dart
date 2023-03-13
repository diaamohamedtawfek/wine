


class URL_LOGIC {

  /*

# add the Firebase pod for Google Analytics
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Messaging'
# add pods for any other desired Firebase products
# https://firebase.google.com/docs/ios/setup#available-pods
   */

  // use when use firebase
  // pod 'FirebaseFirestore', :git => 'https://github.com/invertase/firestore-ios-sdk-frameworks.git', :tag => '6.26.0'
  //in pod file under target 'Runner' do

  static String? api = "http://wainsale.com/apps_api/";
  static String? delete = api!+"settings/delete.php";

  static String? main_offer_ads = api!+"home/main_offer.php";
  static String? login_fb_google = api!+"login/login_fb_google.php";
  static String? favorit_unfavorit = api!+"offers/favorite.php";

  static String? firebase_sendlocation = api!+"firebase.php?";

  static String? myfavorite = api!+"offers/myfavorite.php";

  static String? Nationality = api!+"signup/nationalities.php";
  static String? age_group = api!+"signup/age_group.php";
  static String? country_code = api!+"signup/country_code.php";

  static String? new_Sign_Up = api!+"signup/signup.php";
  static String? login = api!+"login/login.php";
  static String? loginforget1 = api!+"login/forget.php";


  static String? sliderHome = api!+"home/trending_offers.php";
  static String? defultLocationHome = api!+"home/get_city_loations_defullt.php";
  static String? get_cityHome = api!+"home/get_city.php";
  static String? get_cityHome_new = api!+"home/get_city_loc.php";
  static String? get_locations_MAlFromCityHome = api!+"home/get_locations.php";

  static String? filterHome = api!+"home/filter.php";
  static String? mainCAtegryHome = api!+"home/get_categories.php";
  static String? offersHome = api!+"home/offers.php";
  static String? offersHome_FromFiltter = api!+"home/filter.php";

  static String? itemDetales = api!+"offers/details.php";
  static String? itemDetales2 = api!+"offers/details2.php";

  static String? get_events_servicesHome = api!+"events/events_services.php";
  static String? click_event = api!+"home/get_events.php";


  static String? aboutApp = api!+"pages/aboutus.php";
  static String? terms = api!+"pages/terms.php";
  static String? joinus = api!+"pages/joinus.php";

  static String? updateCity = api!+"settings/edit_city.php";
  static String? updateNotification = api!+"settings/edit_notification.php";
  static String? accountInfo_Setting = api!+"settings/settings.php";

  static String? edit_accountinfo = api!+"settings/edit_accountinfo.php";
  static String? accountInfo = api!+"settings/get_accountinfo.php";
  static String? resetPssword = api!+"settings/editpassword.php";

  static String? notificationApi = api!+"notifications.php";

}