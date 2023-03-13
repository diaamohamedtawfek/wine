

class DataDetilesItem {
  List<Main>? main;

  DataDetilesItem({this.main});

  DataDetilesItem.fromJson(Map<String, dynamic> json) {
    if (json['main'] != null) {
      main = [];
      json['main'].forEach((v) {
        main!.add(new Main.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.main != null) {
      data['main'] = this.main!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Main {
  List<Images>? images;
  List<Info>? info;
  List<Menus> ?menus;
  List<RelatedOffers>? relatedOffers;
  List<LocationsOffers> ?locationsOffers;
  List<CategoriesOffers>? categoriesOffers;
  List<ShopOnline>? shopOnline;

  Main(
      {this.images,
        this.info,
        this.menus,
        this.relatedOffers,
        this.locationsOffers,
        this.categoriesOffers,
        this.shopOnline});

  Main.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = [];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
    if (json['info'] != null) {
      info = [];
      json['info'].forEach((v) {
        info!.add(new Info.fromJson(v));
      });
    }
    if (json['menus'] != null) {
      menus = [];
      json['menus'].forEach((v) {
        menus!.add(new Menus.fromJson(v));
      });
    }
    if (json['related_offers'] != null) {
      relatedOffers =[];
      json['related_offers'].forEach((v) {
        relatedOffers!.add(new RelatedOffers.fromJson(v));
      });
    }
    if (json['locations_offers'] != null) {
      locationsOffers = [];
      json['locations_offers'].forEach((v) {
        locationsOffers!.add(new LocationsOffers.fromJson(v));
      });
    }
    if (json['categories_offers'] != null) {
      categoriesOffers = [];
      json['categories_offers'].forEach((v) {
        categoriesOffers!.add(new CategoriesOffers.fromJson(v));
      });
    }
    if (json['shop_online'] != null) {
      shopOnline = [];
      json['shop_online'].forEach((v) {
        shopOnline!.add(new ShopOnline.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    if (this.info != null) {
      data['info'] = this.info!.map((v) => v.toJson()).toList();
    }
    if (this.menus != null) {
      data['menus'] = this.menus!.map((v) => v.toJson()).toList();
    }
    if (this.relatedOffers != null) {
      data['related_offers'] =
          this.relatedOffers!.map((v) => v.toJson()).toList();
    }
    if (this.locationsOffers != null) {
      data['locations_offers'] =
          this.locationsOffers!.map((v) => v.toJson()).toList();
    }
    if (this.categoriesOffers != null) {
      data['categories_offers'] =
          this.categoriesOffers!.map((v) => v.toJson()).toList();
    }
    if (this.shopOnline != null) {
      data['shop_online'] = this.shopOnline!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  List<String>? imageUrl;
  List<SmallIcon>? smallIcon;

  Images({this.imageUrl, this.smallIcon});

  Images.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'].cast<String>();
    if (json['small_icon'] != null) {
      smallIcon = [];
      json['small_icon'].forEach((v) {
        smallIcon!.add( SmallIcon.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    if (this.smallIcon != null) {
      data['small_icon'] = this.smallIcon!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SmallIcon {
  String ?name;
  String? iconUrl;

  SmallIcon({this.name, this.iconUrl});

  SmallIcon.fromJson(Map<String, dynamic> json) {
    name = json['name'].toString();
    iconUrl = json['icon_url'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['icon_url'] = this.iconUrl;
    return data;
  }
}

class Info {
  String? offerName;
  String? offerDescription;
  String? longitude;
  String? latitude;
  String? offerImg;
  String? openingHours;
  String? phone;
  String? email;
  String? favorite;
  String? active;
  String? showInfo;

  Info(
      {this.offerName,
        this.offerDescription,
        this.longitude,
        this.latitude,
        this.offerImg,
        this.openingHours,
        this.phone,
        this.email,
        this.favorite,
        this.active,
        this.showInfo});

  Info.fromJson(Map<String, dynamic> json) {
    offerName = json['offer_name'].toString();
    offerDescription = json['offer_description'].toString();
    longitude = json['longitude'].toString();
    latitude = json['latitude'].toString();
    offerImg = json['offer_img'].toString();
    openingHours = json['opening hours'].toString();
    phone = json['phone'].toString();
    email = json['email'].toString();
    favorite = json['favorite'].toString();
    active = json['active'].toString();
    showInfo = json['show_info'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_name'] = this.offerName;
    data['offer_description'] = this.offerDescription;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['offer_img'] = this.offerImg;
    data['opening hours'] = this.openingHours;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['favorite'] = this.favorite;
    data['active'] = this.active;
    data['show_info'] = this.showInfo;
    return data;
  }
}

class Menus {
  String? offerMenus;

  Menus({this.offerMenus});

  Menus.fromJson(Map<String, dynamic> json) {
    offerMenus = json['offer_menus'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_menus'] = this.offerMenus;
    return data;
  }
}

class RelatedOffers {
  String? relatedId;
  String? offerId;
  String? offerName;
  String? offerDescription;
  String? offerImg;

  RelatedOffers(
      {this.relatedId,
        this.offerId,
        this.offerName,
        this.offerDescription,
        this.offerImg});

  RelatedOffers.fromJson(Map<String, dynamic> json) {
    relatedId = json['related_id'].toString();
    offerId = json['offer_id'].toString();
    offerName = json['offer_name'].toString();
    offerDescription = json['offer_description'].toString();
    offerImg = json['offer_img'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['related_id'] = this.relatedId;
    data['offer_id'] = this.offerId;
    data['offer_name'] = this.offerName;
    data['offer_description'] = this.offerDescription;
    data['offer_img'] = this.offerImg;
    return data;
  }
}

class LocationsOffers {
  String? locationId;
  String? locationName;

  LocationsOffers({this.locationId, this.locationName});

  LocationsOffers.fromJson(Map<String, dynamic> json) {
    locationId = json['location_id'].toString();
    locationName = json['location_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location_id'] = this.locationId;
    data['location_name'] = this.locationName;
    return data;
  }
}

class CategoriesOffers {
  String? catId;
  String? categoryName;

  CategoriesOffers({this.catId, this.categoryName});

  CategoriesOffers.fromJson(Map<String, dynamic> json) {
    catId = json['cat_id'].toString();
    categoryName = json['category_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cat_id'] = this.catId;
    data['category_name'] = this.categoryName;
    return data;
  }
}

class ShopOnline {
  String? shopType;
  String? shopCode;
  String? shopUrl;
  String? shopDescription;
  String? shopActive;
  String? shopIcon;

  ShopOnline(
      {this.shopType,
        this.shopCode,
        this.shopUrl,
        this.shopDescription,
        this.shopActive,
        this.shopIcon});

  ShopOnline.fromJson(Map<String, dynamic> json) {
    shopType = json['shop_type'].toString();
    shopCode = json['shop_code'].toString();
    shopUrl = json['shop_url'].toString();
    shopDescription = json['shop_description'].toString();
    shopActive = json['shop_active'].toString();
    shopIcon = json['shop_icon'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shop_type'] = this.shopType;
    data['shop_code'] = this.shopCode;
    data['shop_url'] = this.shopUrl;
    data['shop_description'] = this.shopDescription;
    data['shop_active'] = this.shopActive;
    data['shop_icon'] = this.shopIcon;
    return data;
  }
}
