class PlaceData {
  String imgsrc;
  String text;
  String title;

  PlaceData({this.imgsrc, this.text, this.title});

  PlaceData.fromJson(Map<String, dynamic> json) {
    imgsrc = json['imgsrc'];
    text = json['text'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imgsrc'] = this.imgsrc;
    data['text'] = this.text;
    data['title'] = this.title;
    return data;
  }
}