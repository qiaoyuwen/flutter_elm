class DeliveryMode {
  DeliveryMode.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        text = json['text'],
        color = json['color'],
        iconColor = json['icon_color'],
        isSolid = json['is_solid'];

  int id;
  String text;
  String color;
  String iconColor;
  bool isSolid;

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'color': color,
    'is_solid': isSolid,
  };
}