

class DataUpdateApp {

 bool? update;
  DataUpdateApp({this.update});

  DataUpdateApp.fromJson(Map<String, dynamic> json) {
    if (json['update'] != null) {
     this.update=json['update'];
    }
  }

}


