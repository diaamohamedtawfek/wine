

class DataFavoritAffilet {
  DataFavoritAffilet({
    required this.myfavorite,
  });
  late final List<Myfavorite> myfavorite;

  DataFavoritAffilet.fromJson(Map<String, dynamic> json){
    myfavorite = List.from(json['myfavorite']).map((e)=>Myfavorite.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['myfavorite'] = myfavorite.map((e)=>e.toJson()).toList();
    return _data;
  }
}

class Myfavorite {
  Myfavorite({
    required this.offerId,
    required this.offerImg,
    required this.offerName,
    required this.offerDescription,
    required this.offerSmallIcon,
    required this.offerType,
    required this.offerActive,
    required this.offerUrl,
    required this.offerWebview,
    required this.favorite,
  });
  late final String offerId;
  late final String offerImg;
  late final String offerName;
  late final String offerDescription;
  late final String offerSmallIcon;
  late final String offerType;
  late final String offerActive;
  late final String offerUrl;
  late final String offerWebview;
  late final String favorite;

  Myfavorite.fromJson(Map<String, dynamic> json){
    offerId = json['offer_id'];
    offerImg = json['offer_img'];
    offerName = json['offer_name'];
    offerDescription = json['offer_description'];
    offerSmallIcon = json['offer_small_icon'];
    offerType = json['offer_type'];
    offerActive = json['offer_active'];
    offerUrl = json['offer_url'];
    offerWebview = json['offer_webview'];
    favorite = json['favorite'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['offer_id'] = offerId;
    _data['offer_img'] = offerImg;
    _data['offer_name'] = offerName;
    _data['offer_description'] = offerDescription;
    _data['offer_small_icon'] = offerSmallIcon;
    _data['offer_type'] = offerType;
    _data['offer_active'] = offerActive;
    _data['offer_url'] = offerUrl;
    _data['offer_webview'] = offerWebview;
    _data['favorite'] = favorite;
    return _data;
  }
}