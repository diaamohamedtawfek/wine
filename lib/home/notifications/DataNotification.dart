

class DataNotification {
  late List<Notifications> notifications;

  DataNotification({required this.notifications});

   DataNotification.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notifications =  List as List<Notifications>;
      json['notifications'].forEach((v) {
        notifications.add(new Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  String? id;
  String? message;
  String? dateadd;
  String? offer;
  String? offer_name;
  int? code;
  // String offer;

  Notifications({this.id, this.message, this.offer, this.code, this.offer_name, this.dateadd});

  Notifications.fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) {
      print("id ! = null");
      id = json['id'];
      message = json['message'];
      offer = json['offer'];
      offer_name = json['offer_name'];
      dateadd = json['dateadd'];
    }else if(json['code'] != null){
      print("code ! = null");
      message = json['message'];
      code = json['code'];
    }

    print("code ! = ${json.toString()}");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['offer'] = this.offer;
    return data;
  }
}

