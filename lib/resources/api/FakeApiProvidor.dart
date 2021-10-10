import 'dart:async';
import 'dart:math';

import 'package:exservice/models/GetChatUsersModel.dart';
import 'package:exservice/models/GetUserProfileModel.dart';
import 'package:exservice/models/NotificationsModel.dart';
import 'package:exservice/models/PostAdModel.dart';
import 'package:exservice/models/UploadMediaModel.dart';
import 'package:exservice/models/common/AdModel.dart';
import 'package:exservice/models/common/Media.dart';
import 'package:exservice/models/common/SimpleResponseModel.dart';
import 'package:exservice/models/common/Town.dart';
import 'package:exservice/models/common/User.dart';
import 'package:exservice/models/options/AdPricesListModel.dart';
import 'package:exservice/models/options/GetCountriesListModel.dart';
import 'package:exservice/models/options/GetOptionsModel.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'package:exservice/renovation/models/category.dart';
import 'package:exservice/renovation/utils/enums.dart';
import 'package:exservice/resources/api/ApiProviderDelegate.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class FakeApiProvider extends ApiProviderDelegate {
  int expiredAdsNumber = 10;
  int activeAdsNumber = 10;
  int inactiveAdsNumber = 10;

  final random = Random();
  final video =
      "https://mazwai.com/videvo_files/video/free/2016-04/small_watermarked/the_valley-graham_uheslki_preview.webm";
  final keys = [
    "real estate",
    "property",
    "villa",
    "house",
    "garage",
    "furniture",
  ];

  DateTime getFakeDate() {
    return faker.date.dateTime(maxYear: 2021, minYear: 2010);
  }

  Duration getDelayDuration() {
    return Duration(seconds: random.nextInt(2) + 1);
  }

  Town getRandomTown({int id}) {
    return Town(
      id: id ?? faker.randomGenerator.integer(100),
      country: faker.address.country(),
      name: faker.address.country(),
      longitude: faker.randomGenerator.integer(90),
      latitude: faker.randomGenerator.integer(90),
      image: faker.image.image(
        keywords: keys,
        width: 100,
        height: 100,
        random: true,
      ),
    );
  }

  AdModel getRandomAdModel({int id}) {
    return AdModel(
      id: id ?? faker.randomGenerator.integer(100),
      appId: faker.randomGenerator.integer(10),
      title: faker.company.name(),
      description: faker.lorem.sentences(3).join(" "),
      isFree: faker.randomGenerator.integer(1),
      thumbnail: faker.image.image(
        keywords: keys,
        width: 100,
        height: 100,
        random: true,
      ),
      latitude: faker.randomGenerator.decimal(scale: 90),
      longitude: faker.randomGenerator.decimal(scale: 90),
      ownerId: faker.randomGenerator.integer(100),
      detailedLocation: faker.lorem.sentence(),
      saved: faker.randomGenerator.boolean(),
      status: faker.randomGenerator.integer(2),
      totalViews: faker.randomGenerator.integer(100),
      townId: faker.randomGenerator.integer(100),
      town: getRandomTown(),
      attr: Attributes(
        id: id ?? faker.randomGenerator.integer(100),
        adId: id ?? faker.randomGenerator.integer(100),
        balcony: getRandomOption(),
        bath: getRandomOption(numeric: true),
        category: getRandomOption(),
        furniture: getRandomOption(),
        garage: getRandomOption(),
        option: getRandomOption(),
        priceOption: getRandomOption(),
        rooms: getRandomOption(numeric: true),
        sizeUnit: getRandomOption(numeric: true),
        gym: getRandomOption(),
        price: faker.randomGenerator.integer(1000) * 1000,
        security: getRandomOption(),
        terrace: getRandomOption(),
        size: faker.randomGenerator.integer(100),
      ),
      media: List.generate(random.nextInt(4) + 1, (index) => getRandomMedia()),
      owner: getRandomUser(id: id),
      validtyDate: getFakeDate(),
    );
  }

  User getRandomUser({int id, int type}) {
    return User(
      id: id ?? faker.randomGenerator.integer(100),
      username: faker.person.name(),
      town: getRandomTown(),
      logo: faker.image.image(
        keywords: keys,
        height: 100,
        width: 100,
        random: true,
      ),
      firebaseToken: faker.guid.guid(),
      email: faker.internet.email(),
      status: faker.randomGenerator.integer(1),
      website: faker.internet.domainName(),
      apiToken: faker.guid.guid(),
      bio: faker.lorem.sentence(),
      companyName: faker.person.firstName(),
      phoneNumber: faker.randomGenerator.integer(100000000).toString(),
      profilePic: faker.image.image(
        keywords: keys,
        width: 100,
        height: 100,
        random: true,
      ),
      publicPhone: faker.randomGenerator.integer(1000000).toString(),
      profileVideo: video,
      type: UserType(
        id: type ?? AccountType.normal.id,
        title: faker.food.restaurant(),
      ),
    );
  }

  UserProfile getRandomUserProfile({int type}) {
    return UserProfile(
      user: getRandomUser(type: type),
      ads: List.generate(activeAdsNumber, (index) => getRandomAdModel()),
      activeCount: activeAdsNumber,
      inactiveCount: inactiveAdsNumber,
      expiredCount: expiredAdsNumber,
    );
  }

  Media getRandomMedia() {
    var num = faker.randomGenerator.integer(10, min: 0);
    if (num == 0) {
      return Media(
        id: faker.randomGenerator.integer(100),
        adId: faker.randomGenerator.integer(100),
        link: video,
        type: 2,
      );
    } else {
      return Media(
        id: faker.randomGenerator.integer(100),
        adId: faker.randomGenerator.integer(100),
        link: faker.image.image(
          keywords: keys,
          width: 500,
          height: 500,
          random: true,
        ),
        type: 1,
      );
    }
  }

  Option getRandomOption({int id, numeric = false}) {
    return Option(
      id: id ?? faker.randomGenerator.integer(100),
      title:
          numeric ? "${faker.randomGenerator.integer(20)}" : faker.lorem.word(),
      image: faker.image.image(
        keywords: keys,
        width: 100,
        height: 100,
        random: true,
      ),
      parentId: faker.randomGenerator.integer(100),
    );
  }

  AdPrice getRandomAdPrice() {
    return AdPrice(
      id: faker.randomGenerator.integer(1000),
      appId: faker.randomGenerator.integer(10),
      name: faker.currency.name(),
      currency: faker.currency.code(),
      value: 2,
      updatedAt: getFakeDate(),
      createdAt: getFakeDate(),
    );
  }

  @override
  Future<List<AdPrice>> fetchAdPricesList(BuildContext context) {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(random.nextInt(9) + 1, (index) {
        return getRandomAdPrice();
      }),
    );
  }

  @override
  Future<bool> fetchCheckAccount(account) {
    return Future.delayed(
      getDelayDuration(),
      () => faker.randomGenerator.boolean(),
    );
  }

  @override
  Future<void> fetchCompleteUpdateEmailPhone(
      BuildContext context, code, account, type) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<List<Choice>> fetchCountriesList(BuildContext context) {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(random.nextInt(9) + 1, (index) {
        return Choice(
            id: faker.randomGenerator.integer(100),
            name: faker.address.country());
      }),
    );
  }

  @override
  Future<void> fetchDeleteAd(int adId) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchEditAd(adId, title, description) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchEditProfile({
    name,
    email,
    townId,
    bio,
    website,
    phoneNumber,
    publicPhone,
    companyName,
    typeId,
  }) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchForgetPassword(account) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<AdModel> fetchGetAdDetails(id) {
    return Future.delayed(
      getDelayDuration(),
      () => getRandomAdModel(id: id),
    );
  }

  @override
  Future<List<AdModel>> fetchGetAdsList(
    offset, {
    townId,
    ownerId,
    status,
    option,
    type,
    furniture,
    rooms,
    balcony,
    bath,
    terrace,
    fromPrice,
    toPrice,
    garage,
    fromSize,
    toSize,
  }) {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(10, (index) => getRandomAdModel()),
    );
  }

  @override
  Future<List<Category>> fetchCategories() {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(
        10,
        (index) => Category(
          id: faker.randomGenerator.integer(100),
          title: faker.lorem.word(),
          image: faker.image.image(
            keywords: keys,
            height: 100,
            width: 100,
            random: true,
          ),
        ),
      ),
    );
  }

  @override
  Future<UserProfile> fetchGetUserAccount(int id) {
    return Future.delayed(
      getDelayDuration(),
      () => getRandomUserProfile(type: AccountType.company.id),
    );
  }

  int _id;

  @override
  Future<List<AdModel>> fetchGetUserAds(offset, status) {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(10, (index) => getRandomAdModel(id: _id)),
    );
  }

  @override
  Future<UserProfile> fetchGetUserProfile() {
    return Future.delayed(getDelayDuration(), () {
      var profile = getRandomUserProfile();
      _id = profile.user.id;
      return profile;
    });
  }

  @override
  Future<List<Chatter>> fetchGetChatUsers() async {
    // var chats =
    //     await FirebaseFirestore.instance
    //         .collectionGroup(CHAT_COLLECTION)
    //         .get();
    // print("===> ${chats.size}");
    return Future.delayed(getDelayDuration(), () {
      // return chats.docs.map<Chatter>((doc) {
      //   var ids = doc.id.split("-");
      //   var chatterId = ids.firstWhere((element) => element != "$_id");
      //   var user = getRandomUser(id: int.parse(chatterId));
      //   return Chatter(
      //     user,
      //     message: MessageModel(
      //       content: faker.lorem.sentence(),
      //       senderId: 123,
      //       senderName: user.name,
      //       timestamp: faker.date
      //           .dateTime(minYear: 1999, maxYear: 2021)
      //           .millisecondsSinceEpoch,
      //     ),
      //   );
      // }).toList();
      return List.generate(10, (index) {
        var user = getRandomUser();
        return Chatter(
          user,
          message: MessageModel(
            content: faker.lorem.sentence(),
            senderId: 123,
            senderName: user.username,
            timestamp: faker.date
                .dateTime(minYear: 1999, maxYear: 2021)
                .millisecondsSinceEpoch,
          ),
        );
      })
        ..sort(
          (c1, c2) => c2.message.timestamp.compareTo(c1.message.timestamp),
        );
    });
  }

  @override
  Future<User> login(account, password) {
    return Future.delayed(getDelayDuration(), () async {
      return getRandomUser();
    });
  }

  @override
  Future<List<NotificationModel>> fetchNotifications() {
    return Future.delayed(getDelayDuration(), () {
      return List.generate(10, (index) {
        return NotificationModel(
          id: faker.randomGenerator.integer(1000),
          adId: faker.randomGenerator.integer(1000),
          userId: faker.randomGenerator.integer(1000),
          ad: getRandomAdModel(),
          user: getRandomUser(),
          createdAt: getFakeDate(),
          updatedAt: getFakeDate(),
        );
      });
    });
  }

  @override
  Future<void> fetchChangeAdStatus(int adId, int status) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<String> fetchPayment(
      BuildContext context, int adId, int priceId, int days) {
    return Future.delayed(getDelayDuration(), () {
      return faker.internet.httpsUrl();
    });
  }

  @override
  Future<void> fetchResendVerificationCode(account) async {
    DataStore.instance.user = getRandomUser();
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchResetPassword(code, password, confirm) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchSaveAd(int id, bool value) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<List<AdModel>> getFavoritesAds(int offset) {
    return Future.delayed(
      getDelayDuration(),
      () => List.generate(10, (index) => getRandomAdModel()),
    );
  }

  @override
  Future<void> fetchSignUp(name, account, password) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<PostAdModel> fetchStoreAd(BuildContext context, bool isFree) {
    return Future.delayed(getDelayDuration(), () {
      return PostAdModel(
        code: 200,
        message: "success",
        data: PostResult(
          id: faker.randomGenerator.integer(100),
        ),
      );
    });
  }

  @override
  Future<void> fetchSwitchToBusiness(username, website, bio) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<List<Town>> fetchTownsList(BuildContext context, int countryId) {
    return Future.delayed(getDelayDuration(), () {
      return List.generate(10, (index) {
        return getRandomTown();
      });
    });
  }

  @override
  Future<void> fetchUpdateEmailPhone(BuildContext context, account, type) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchUpdateFirebaseToken(token) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<void> fetchUpdatePassword(oldWord, newWord, confirm) {
    return Future.delayed(getDelayDuration());
  }

  @override
  Future<UploadData> fetchUpdateUserPicture({String image, String video}) {
    return Future.delayed(getDelayDuration(), () {
      return UploadData(
        imagePath: faker.image.image(
          keywords: keys,
          width: 100,
          height: 100,
          random: true,
        ),
        videoPath: video,
      );
    });
  }

  @override
  Future<SimpleResponseModel> fetchUploadAdMedia(int adId, progressCallback) {
    int _current = 0;
    int _total = 100000;
    const oneSec = const Duration(milliseconds: 100);
    Timer.periodic(oneSec, (Timer timer) {
      if (_current >= _total) {
        timer.cancel();
      } else {
        _current += 10000;
        progressCallback(_current, _total);
      }
    });
    return Future.delayed(getDelayDuration(), () {
      return SimpleResponseModel(data: null, message: "success", code: 200);
    });
  }

  @override
  Future<List<UserType>> fetchUserTypesList(BuildContext context) {
    return Future.delayed(getDelayDuration(), () {
      return List.generate(10, (index) {
        return UserType(
          id: faker.randomGenerator.integer(4),
          title: faker.company.position(),
        );
      });
    });
  }

  @override
  Future<User> fetchVerifyUser(account, code) {
    return Future.delayed(getDelayDuration(), () {
      return getRandomUser();
    });
  }
}
