

class DataHomeAlefent {
  List<Update>? update;
  List<Bar>? bar;
  List<HomeIcons>? homeIcons;

  DataHomeAlefent({this.update, this.bar, this.homeIcons});

  DataHomeAlefent.fromJson(Map<String, dynamic> json) {
    if (json['update'] != null) {
      update =  [];
      json['update'].forEach((v) {
        update!.add(new Update.fromJson(v));
      });
    }
    if (json['bar'] != null) {
      bar =  [];
      json['bar'].forEach((v) {
        bar!.add(new Bar.fromJson(v));
      });
    }
    if (json['home_icons'] != null) {
      homeIcons = [];
      json['home_icons'].forEach((v) {
        homeIcons!.add(new HomeIcons.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.update != null) {
      data['update'] = this.update!.map((v) => v.toJson()).toList();
    }
    if (this.homeIcons != null) {
      data['home_icons'] = this.homeIcons!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Update {
  int? activeMsg;

  Update({this.activeMsg});

  Update.fromJson(Map<String, dynamic> json) {
    activeMsg = json['active_msg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active_msg'] = this.activeMsg;
    return data;
  }
}
class Bar {
  String? active;

  Bar({this.active});

  Bar.fromJson(Map<String, dynamic> json) {
    active = json['active'].toString();
  }


}

class HomeIcons {
  String? img;

  HomeIcons({this.img});

  HomeIcons.fromJson(Map<String, dynamic> json) {
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    return data;
  }
}
