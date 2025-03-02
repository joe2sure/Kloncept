import 'package:kloncept/model/zoom_meeting.dart';

class HomeModel {
  HomeModel({
    this.settings,
    this.currency,
    this.slider,
    this.sliderfacts,
    this.trusted,
    this.testimonial,
    this.category,
    this.subcategory,
    this.childcategory,
    this.featuredCate,
    this.zoomMeeting,
  });

  Settings? settings;
  Currency? currency;
  List<MySlider>? slider;
  List<SliderFact>? sliderfacts;
  List<Trusted>? trusted;
  List<Testimonial>? testimonial;
  List<MyCategory>? category;
  List<SubCategory>? subcategory;
  List<ChildCategory>? childcategory;
  List<MyCategory>? featuredCate;
  List<ZoomMeeting>? zoomMeeting;

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
      settings: Settings.fromJson(json["settings"]),
      currency: Currency.fromJson(json["currency"]),
      slider:
          List<MySlider>.from(json["slider"].map((x) => MySlider.fromJson(x))),
      sliderfacts: List<SliderFact>.from(
          json["sliderfacts"].map((x) => SliderFact.fromJson(x))),
      trusted:
          List<Trusted>.from(json["trusted"].map((x) => Trusted.fromJson(x))),
      testimonial: List<Testimonial>.from(
          json["testimonial"].map((x) => Testimonial.fromJson(x))),
      category: List<MyCategory>.from(
          json["category"].map((x) => MyCategory.fromJson(x))),
      subcategory: List<SubCategory>.from(
          json["subcategory"].map((x) => SubCategory.fromJson(x))),
      childcategory: List<ChildCategory>.from(
          json["childcategory"].map((x) => ChildCategory.fromJson(x))),
      featuredCate: List<MyCategory>.from(
          json["featured_cate"].map((x) => MyCategory.fromJson(x))),
      zoomMeeting: List<ZoomMeeting>.from(
          json["meeting"].map((x) => ZoomMeeting.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "settings": settings!.toJson(),
        "currency": currency!.toJson(),
        "slider": List<dynamic>.from(slider!.map((x) => x.toJson())),
        "sliderfacts": List<dynamic>.from(sliderfacts!.map((x) => x.toJson())),
        "trusted": List<dynamic>.from(trusted!.map((x) => x.toJson())),
        "testimonial": List<dynamic>.from(testimonial!.map((x) => x.toJson())),
        "category": List<dynamic>.from(category!.map((x) => x.toJson())),
        "subcategory": List<dynamic>.from(subcategory!.map((x) => x.toJson())),
        "childcategory":
            List<dynamic>.from(childcategory!.map((x) => x.toJson())),
        "featured_cate":
            List<dynamic>.from(featuredCate!.map((x) => x.toJson())),
      };
}

class MyCategory {
  MyCategory({
    this.id,
    this.title,
    this.icon,
    this.slug,
    this.featured,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.catImage,
  });

  int? id;
  String? title;
  String? icon;
  String? slug;
  String? featured;
  String? status;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? catImage;

  factory MyCategory.fromJson(Map<String, dynamic> json) => MyCategory(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        featured: json["featured"],
        status: json["status"],
        position: json["position"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        catImage: json["cat_image"] == null ? null : json["cat_image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
        "slug": slug,
        "featured": featured,
        "status": status,
        "position": position,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "cat_image": catImage == null ? null : catImage,
      };
}

class Currency {
  Currency({
    this.id,
    this.icon,
    this.currency,
    this.currencyDefault,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? icon;
  dynamic currency;
  dynamic currencyDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        id: json["id"],
        icon: json["icon"],
        currency: json["currency"],
        currencyDefault: json["default"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "currency": currency,
        "default": currencyDefault,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Settings {
  int? id;
  String? projectTitle;
  String? logo;
  String? favicon;
  String? cpyTxt;
  String? logoType;
  String? rightclick;
  String? inspect;
  String? metaDataDesc;
  String? metaDataKeyword;
  String? googleAna;
  dynamic fbPixel;
  String? fbLoginEnable;
  String? googleLoginEnable;
  String? gitlabLoginEnable;
  String? stripeEnable;
  String? instamojoEnable;
  String? paypalEnable;
  String? paytmEnable;
  String? braintreeEnable;
  String? razorpayEnable;
  String? paystackEnable;
  String? wEmailEnable;
  String? verifyEnable;
  String? welEmail;
  String? defaultAddress;
  String? defaultPhone;
  String? instructorEnable;
  String? debugEnable;
  String? catEnable;
  String? featureAmount;
  String? preloaderEnable;
  String? zoomEnable;
  String? amazonEnable;
  String? captchaEnable;
  String? bblEnable;
  String? mapLat;
  String? mapLong;
  String? mapEnable;
  String? contactImage;
  String? mobileEnable;
  String? promoEnable;
  String? promoText;
  dynamic promoLink;
  String? linkedinEnable;
  String? mapApi;
  String? twitterEnable;
  String? awsEnable;
  String? certificateEnable;
  String? deviceControl;
  String? ipblockEnable;
  dynamic ipblock;
  String? assignmentEnable;
  String? appointmentEnable;
  String? hideIdentity;
  String? footerLogo;
  dynamic createdAt;
  String? updatedAt;
  String? enableOmise;
  String? enablePayu;
  String? enableMoli;
  String? enableCashfree;
  String? enableSkrill;
  String? enableRave;
  dynamic preloaderLogo;
  dynamic chatBubble;
  String? wappPhone;
  String? wappPopupMsg;
  String? wappTitle;
  String? wappPosition;
  String? wappColor;
  String? wappEnable;
  String? enablePayhere;
  String? appDownload;
  dynamic appLink;
  String? playDownload;
  dynamic playLink;
  String? iyzicoEnable;
  String? courseHover;
  String? sslEnable;
  String? currencySwipe;
  String? attandanceEnable;
  String? youtubeEnable;
  String? vimeoEnable;
  String? aamarpayEnable;
  String? activityEnable;
  String? twilioEnable;
  String? planEnable;
  String? googlemeetEnable;
  String? cookieEnable;
  String? jitsimeetEnable;
  String? payflexiEnable;
  String? esewaEnable;
  String? donationEnable;
  dynamic donationLink;
  String? smanagerEnable;
  String? googlepayEnable;
  String? forumEnable;
  dynamic adminUrl;
  String? guestEnable;

  Settings(
      {this.id,
      this.projectTitle,
      this.logo,
      this.favicon,
      this.cpyTxt,
      this.logoType,
      this.rightclick,
      this.inspect,
      this.metaDataDesc,
      this.metaDataKeyword,
      this.googleAna,
      this.fbPixel,
      this.fbLoginEnable,
      this.googleLoginEnable,
      this.gitlabLoginEnable,
      this.stripeEnable,
      this.instamojoEnable,
      this.paypalEnable,
      this.paytmEnable,
      this.braintreeEnable,
      this.razorpayEnable,
      this.paystackEnable,
      this.wEmailEnable,
      this.verifyEnable,
      this.welEmail,
      this.defaultAddress,
      this.defaultPhone,
      this.instructorEnable,
      this.debugEnable,
      this.catEnable,
      this.featureAmount,
      this.preloaderEnable,
      this.zoomEnable,
      this.amazonEnable,
      this.captchaEnable,
      this.bblEnable,
      this.mapLat,
      this.mapLong,
      this.mapEnable,
      this.contactImage,
      this.mobileEnable,
      this.promoEnable,
      this.promoText,
      this.promoLink,
      this.linkedinEnable,
      this.mapApi,
      this.twitterEnable,
      this.awsEnable,
      this.certificateEnable,
      this.deviceControl,
      this.ipblockEnable,
      this.ipblock,
      this.assignmentEnable,
      this.appointmentEnable,
      this.hideIdentity,
      this.footerLogo,
      this.createdAt,
      this.updatedAt,
      this.enableOmise,
      this.enablePayu,
      this.enableMoli,
      this.enableCashfree,
      this.enableSkrill,
      this.enableRave,
      this.preloaderLogo,
      this.chatBubble,
      this.wappPhone,
      this.wappPopupMsg,
      this.wappTitle,
      this.wappPosition,
      this.wappColor,
      this.wappEnable,
      this.enablePayhere,
      this.appDownload,
      this.appLink,
      this.playDownload,
      this.playLink,
      this.iyzicoEnable,
      this.courseHover,
      this.sslEnable,
      this.currencySwipe,
      this.attandanceEnable,
      this.youtubeEnable,
      this.vimeoEnable,
      this.aamarpayEnable,
      this.activityEnable,
      this.twilioEnable,
      this.planEnable,
      this.googlemeetEnable,
      this.cookieEnable,
      this.jitsimeetEnable,
      this.payflexiEnable,
      this.esewaEnable,
      this.donationEnable,
      this.donationLink,
      this.smanagerEnable,
      this.googlepayEnable,
      this.forumEnable,
      this.adminUrl,
      this.guestEnable});

  Settings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    projectTitle = json['project_title'];
    logo = json['logo'];
    favicon = json['favicon'];
    cpyTxt = json['cpy_txt'];
    logoType = json['logo_type'];
    rightclick = json['rightclick'].toString();
    inspect = json['inspect'].toString();
    metaDataDesc = json['meta_data_desc'].toString();
    metaDataKeyword = json['meta_data_keyword'].toString();
    googleAna = json['google_ana'].toString();
    fbPixel = json['fb_pixel'];
    fbLoginEnable = json['fb_login_enable'].toString();
    googleLoginEnable = json['google_login_enable'].toString();
    gitlabLoginEnable = json['gitlab_login_enable'].toString();
    stripeEnable = json['stripe_enable'].toString();
    instamojoEnable = json['instamojo_enable'].toString();
    paypalEnable = json['paypal_enable'].toString();
    paytmEnable = json['paytm_enable'].toString();
    braintreeEnable = json['braintree_enable'].toString();
    razorpayEnable = json['razorpay_enable'].toString();
    paystackEnable = json['paystack_enable'].toString();
    wEmailEnable = json['w_email_enable'].toString();
    verifyEnable = json['verify_enable'].toString();
    welEmail = json['wel_email'];
    defaultAddress = json['default_address'];
    defaultPhone = json['default_phone'];
    instructorEnable = json['instructor_enable'].toString();
    debugEnable = json['debug_enable'].toString();
    catEnable = json['cat_enable'].toString();
    featureAmount = json['feature_amount'].toString();
    preloaderEnable = json['preloader_enable'].toString();
    zoomEnable = json['zoom_enable'].toString();
    amazonEnable = json['amazon_enable'].toString();
    captchaEnable = json['captcha_enable'].toString();
    bblEnable = json['bbl_enable'].toString();
    mapLat = json['map_lat'].toString();
    mapLong = json['map_long'].toString();
    mapEnable = json['map_enable'].toString();
    contactImage = json['contact_image'];
    mobileEnable = json['mobile_enable'].toString();
    promoEnable = json['promo_enable'].toString();
    promoText = json['promo_text'];
    promoLink = json['promo_link'];
    linkedinEnable = json['linkedin_enable'].toString();
    mapApi = json['map_api'];
    twitterEnable = json['twitter_enable'].toString();
    awsEnable = json['aws_enable'].toString();
    certificateEnable = json['certificate_enable'].toString();
    deviceControl = json['device_control'].toString();
    ipblockEnable = json['ipblock_enable'].toString();
    ipblock = json['ipblock'];
    assignmentEnable = json['assignment_enable'].toString();
    appointmentEnable = json['appointment_enable'].toString();
    hideIdentity = json['hide_identity'].toString();
    footerLogo = json['footer_logo'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    enableOmise = json['enable_omise'].toString();
    enablePayu = json['enable_payu'].toString();
    enableMoli = json['enable_moli'].toString();
    enableCashfree = json['enable_cashfree'].toString();
    enableSkrill = json['enable_skrill'].toString();
    enableRave = json['enable_rave'].toString();
    preloaderLogo = json['preloader_logo'];
    chatBubble = json['chat_bubble'];
    wappPhone = json['wapp_phone'];
    wappPopupMsg = json['wapp_popup_msg'].toString();
    wappTitle = json['wapp_title'];
    wappPosition = json['wapp_position'].toString();
    wappColor = json['wapp_color'];
    wappEnable = json['wapp_enable'].toString();
    enablePayhere = json['enable_payhere'].toString();
    appDownload = json['app_download'].toString();
    appLink = json['app_link'];
    playDownload = json['play_download'].toString();
    playLink = json['play_link'];
    iyzicoEnable = json['iyzico_enable'].toString();
    courseHover = json['course_hover'].toString();
    sslEnable = json['ssl_enable'].toString();
    currencySwipe = json['currency_swipe'].toString();
    attandanceEnable = json['attandance_enable'].toString();
    youtubeEnable = json['youtube_enable'].toString();
    vimeoEnable = json['vimeo_enable'].toString();
    aamarpayEnable = json['aamarpay_enable'].toString();
    activityEnable = json['activity_enable'].toString();
    twilioEnable = json['twilio_enable'].toString();
    planEnable = json['plan_enable'].toString();
    googlemeetEnable = json['googlemeet_enable'].toString();
    cookieEnable = json['cookie_enable'].toString();
    jitsimeetEnable = json['jitsimeet_enable'].toString();
    payflexiEnable = json['payflexi_enable'].toString();
    esewaEnable = json['esewa_enable'].toString();
    donationEnable = json['donation_enable'].toString();
    donationLink = json['donation_link'];
    smanagerEnable = json['smanager_enable'].toString();
    googlepayEnable = json['googlepay_enable'].toString();
    forumEnable = json['forum_enable'].toString();
    adminUrl = json['admin_url'];
    guestEnable = json['guest_enable'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['project_title'] = this.projectTitle;
    data['logo'] = this.logo;
    data['favicon'] = this.favicon;
    data['cpy_txt'] = this.cpyTxt;
    data['logo_type'] = this.logoType;
    data['rightclick'] = this.rightclick;
    data['inspect'] = this.inspect;
    data['meta_data_desc'] = this.metaDataDesc;
    data['meta_data_keyword'] = this.metaDataKeyword;
    data['google_ana'] = this.googleAna;
    data['fb_pixel'] = this.fbPixel;
    data['fb_login_enable'] = this.fbLoginEnable;
    data['google_login_enable'] = this.googleLoginEnable;
    data['gitlab_login_enable'] = this.gitlabLoginEnable;
    data['stripe_enable'] = this.stripeEnable;
    data['instamojo_enable'] = this.instamojoEnable;
    data['paypal_enable'] = this.paypalEnable;
    data['paytm_enable'] = this.paytmEnable;
    data['braintree_enable'] = this.braintreeEnable;
    data['razorpay_enable'] = this.razorpayEnable;
    data['paystack_enable'] = this.paystackEnable;
    data['w_email_enable'] = this.wEmailEnable;
    data['verify_enable'] = this.verifyEnable;
    data['wel_email'] = this.welEmail;
    data['default_address'] = this.defaultAddress;
    data['default_phone'] = this.defaultPhone;
    data['instructor_enable'] = this.instructorEnable;
    data['debug_enable'] = this.debugEnable;
    data['cat_enable'] = this.catEnable;
    data['feature_amount'] = this.featureAmount;
    data['preloader_enable'] = this.preloaderEnable;
    data['zoom_enable'] = this.zoomEnable;
    data['amazon_enable'] = this.amazonEnable;
    data['captcha_enable'] = this.captchaEnable;
    data['bbl_enable'] = this.bblEnable;
    data['map_lat'] = this.mapLat;
    data['map_long'] = this.mapLong;
    data['map_enable'] = this.mapEnable;
    data['contact_image'] = this.contactImage;
    data['mobile_enable'] = this.mobileEnable;
    data['promo_enable'] = this.promoEnable;
    data['promo_text'] = this.promoText;
    data['promo_link'] = this.promoLink;
    data['linkedin_enable'] = this.linkedinEnable;
    data['map_api'] = this.mapApi;
    data['twitter_enable'] = this.twitterEnable;
    data['aws_enable'] = this.awsEnable;
    data['certificate_enable'] = this.certificateEnable;
    data['device_control'] = this.deviceControl;
    data['ipblock_enable'] = this.ipblockEnable;
    data['ipblock'] = this.ipblock;
    data['assignment_enable'] = this.assignmentEnable;
    data['appointment_enable'] = this.appointmentEnable;
    data['hide_identity'] = this.hideIdentity;
    data['footer_logo'] = this.footerLogo;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['enable_omise'] = this.enableOmise;
    data['enable_payu'] = this.enablePayu;
    data['enable_moli'] = this.enableMoli;
    data['enable_cashfree'] = this.enableCashfree;
    data['enable_skrill'] = this.enableSkrill;
    data['enable_rave'] = this.enableRave;
    data['preloader_logo'] = this.preloaderLogo;
    data['chat_bubble'] = this.chatBubble;
    data['wapp_phone'] = this.wappPhone;
    data['wapp_popup_msg'] = this.wappPopupMsg;
    data['wapp_title'] = this.wappTitle;
    data['wapp_position'] = this.wappPosition;
    data['wapp_color'] = this.wappColor;
    data['wapp_enable'] = this.wappEnable;
    data['enable_payhere'] = this.enablePayhere;
    data['app_download'] = this.appDownload;
    data['app_link'] = this.appLink;
    data['play_download'] = this.playDownload;
    data['play_link'] = this.playLink;
    data['iyzico_enable'] = this.iyzicoEnable;
    data['course_hover'] = this.courseHover;
    data['ssl_enable'] = this.sslEnable;
    data['currency_swipe'] = this.currencySwipe;
    data['attandance_enable'] = this.attandanceEnable;
    data['youtube_enable'] = this.youtubeEnable;
    data['vimeo_enable'] = this.vimeoEnable;
    data['aamarpay_enable'] = this.aamarpayEnable;
    data['activity_enable'] = this.activityEnable;
    data['twilio_enable'] = this.twilioEnable;
    data['plan_enable'] = this.planEnable;
    data['googlemeet_enable'] = this.googlemeetEnable;
    data['cookie_enable'] = this.cookieEnable;
    data['jitsimeet_enable'] = this.jitsimeetEnable;
    data['payflexi_enable'] = this.payflexiEnable;
    data['esewa_enable'] = this.esewaEnable;
    data['donation_enable'] = this.donationEnable;
    data['donation_link'] = this.donationLink;
    data['smanager_enable'] = this.smanagerEnable;
    data['googlepay_enable'] = this.googlepayEnable;
    data['forum_enable'] = this.forumEnable;
    data['admin_url'] = this.adminUrl;
    data['guest_enable'] = this.guestEnable;
    return data;
  }
}

class MySlider {
  MySlider({
    this.id,
    this.heading,
    this.subHeading,
    this.searchText,
    this.detail,
    this.status,
    this.image,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? heading;
  String? subHeading;
  String? searchText;
  String? detail;
  String? status;
  String? image;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory MySlider.fromJson(Map<String, dynamic> json) => MySlider(
        id: json["id"],
        heading: json["heading"],
        subHeading: json["sub_heading"],
        searchText: json["search_text"],
        detail: json["detail"],
        status: json["status"],
        image: json["image"],
        position: json["position"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "heading": heading,
        "sub_heading": subHeading,
        "search_text": searchText,
        "detail": detail,
        "status": status,
        "image": image,
        "position": position,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class SliderFact {
  SliderFact({
    this.id,
    this.icon,
    this.heading,
    this.subHeading,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? icon;
  String? heading;
  String? subHeading;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SliderFact.fromJson(Map<String, dynamic> json) => SliderFact(
        id: json["id"],
        icon: json["icon"],
        heading: json["heading"],
        subHeading: json["sub_heading"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "icon": icon,
        "heading": heading,
        "sub_heading": subHeading,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Testimonial {
  Testimonial({
    this.id,
    this.clientName,
    this.details,
    this.status,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? clientName;
  String? details;
  dynamic status;
  String? image;
  dynamic createdAt;
  dynamic updatedAt;

  factory Testimonial.fromJson(Map<String, dynamic> json) => Testimonial(
        id: json["id"],
        clientName: json["client_name"],
        details: json["details"],
        status: json["status"],
        image: json["image"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "client_name": clientName,
        "details": details,
        "status": status,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class Trusted {
  Trusted({
    this.id,
    this.url,
    this.image,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? url;
  String? image;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Trusted.fromJson(Map<String, dynamic> json) => Trusted(
        id: json["id"],
        url: json["url"],
        image: json["image"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "image": image,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class FeaturedCate {
  FeaturedCate({
    this.id,
    this.title,
    this.icon,
    this.slug,
    this.featured,
    this.status,
    this.position,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? title;
  String? icon;
  String? slug;
  String? featured;
  String? status;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FeaturedCate.fromJson(Map<String, dynamic> json) => FeaturedCate(
        id: json["id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        featured: json["featured"],
        status: json["status"],
        position: json["position"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "icon": icon,
        "slug": slug,
        "featured": featured,
        "status": status,
        "position": position,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ChildCategory {
  ChildCategory({
    this.id,
    this.categoryId,
    this.subcategoryId,
    this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  dynamic categoryId;
  dynamic subcategoryId;
  String? title;
  String? icon;
  String? slug;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ChildCategory.fromJson(Map<String, dynamic> json) => ChildCategory(
        id: json["id"],
        categoryId: json["category_id"],
        subcategoryId: json["subcategory_id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "subcategory_id": subcategoryId,
        "title": title,
        "icon": icon,
        "slug": slug,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class SubCategory {
  SubCategory({
    this.id,
    this.categoryId,
    this.title,
    this.icon,
    this.slug,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? categoryId;
  String? title;
  String? icon;
  String? slug;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        categoryId: json["category_id"],
        title: json["title"],
        icon: json["icon"],
        slug: json["slug"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "title": title,
        "icon": icon,
        "slug": slug,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
