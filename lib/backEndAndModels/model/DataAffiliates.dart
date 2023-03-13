

class DataAffiliates {
  List<AffiliatesOffers>? affiliatesOffers;

  DataAffiliates({this.affiliatesOffers});

  DataAffiliates.fromJson(Map<String, dynamic> json) {
    if (json['affiliates_offers'] != null) {
      affiliatesOffers = [];
      json['affiliates_offers'].forEach((v) {
        affiliatesOffers!.add(new AffiliatesOffers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.affiliatesOffers != null) {
      data['affiliates_offers'] =
          this.affiliatesOffers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AffiliatesOffers {
  String? offer_id;
  String? offerImg;
  String? favorite;
  String? offerName;
  String? offerDescription;
  String? offerSmallIcon;
  String? offerType;
  String? offerActive;
  String? offerUrl;
  String? offerWebview;

  AffiliatesOffers(
      {this.offerImg,
        this.offer_id,
        this.favorite,
        this.offerName,
        this.offerDescription,
        this.offerSmallIcon,
        this.offerType,
        this.offerActive,
        this.offerUrl,
        this.offerWebview});

  AffiliatesOffers.fromJson(Map<String, dynamic> json) {
    offer_id = json['offer_id'];
    offerImg = json['offer_img'];
    favorite = json['favorite'];
    offerName = json['offer_name'];
    offerDescription = json['offer_description'];
    offerSmallIcon = json['offer_small_icon'];
    offerType = json['offer_type'];
    offerActive = json['offer_active'];
    offerUrl = json['offer_url'];
    offerWebview = json['offer_webview'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offer_img'] = this.offerImg;
    data['offer_name'] = this.offerName;
    data['offer_description'] = this.offerDescription;
    data['offer_small_icon'] = this.offerSmallIcon;
    data['offer_type'] = this.offerType;
    data['offer_active'] = this.offerActive;
    data['offer_url'] = this.offerUrl;
    data['offer_webview'] = this.offerWebview;
    return data;
  }
}
