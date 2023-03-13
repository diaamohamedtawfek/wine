class DataSearchApp {
  List<Offers>? offers;
  List<Other>? other;

  DataSearchApp({this.offers, this.other});

  DataSearchApp.fromJson(Map<String, dynamic> json) {
    if (json['offers'] != null) {
      offers =  [];
      json['offers'].forEach((v) {
        offers!.add(new Offers.fromJson(v));
      });
    }
    // total = json['total'];
    if (json['other'] != null) {
      other = [];
      json['other'].forEach((v) {
        other!.add(new Other.fromJson(v));
      });
    }
  }
}

class Offers {
  String? id;
  String? name;
  String? offerDescription;
  String? offerImg;
  String? active;
  String? favorite;
  List<String>? smallIcon;

  Offers(
      {this.id,
        this.name,
        this.offerDescription,
        this.offerImg,
        this.active,
        this.favorite,
        this.smallIcon});

  Offers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    offerDescription = json['offer_description'].toString();
    offerImg = json['offer_img'].toString();
    active = json['active'].toString();
    favorite = json['favorite'].toString();
    smallIcon = json['small_icon'].cast<String>();
  }

}

class Other {
  String? id;
  String? name;
  String ?locationName;
  String? offerDescription;
  String? offerImg;
  String? active;
  String? favorite;
  List<String>? smallIcon;

  Other(
      {this.id,
        this.name,
        this.locationName,
        this.offerDescription,
        this.offerImg,
        this.active,
        this.favorite,
        this.smallIcon});

  Other.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'].toString();
    locationName = json['location_name'].toString();
    offerDescription = json['offer_description'].toString();
    offerImg = json['offer_img'].toString();
    active = json['active'].toString();
    favorite = json['favorite'].toString();
    smallIcon = json['small_icon'].cast<String>();
  }
}
