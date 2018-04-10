class User {
  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userId = json['user_id'],
        username = json['username'],
        city = json['city'],
        registerTime = json['registe_time'],
        point = json['point'],
        mobile = json['mobile'],
        isMobileValid = json['is_mobile_valid'],
        isEmailValid = json['is_email_valid'],
        isActive = json['is_active'],
        giftAmount = json['gift_amount'],
        email = json['email'],
        deliveryCardExpireDays = json['delivery_card_expire_days'],
        currentInvoiceId = json['current_invoice_id'],
        currentAddressId = json['current_address_id'],
        brandMemberNew = json['brand_member_new'],
        balance = json['balance'],
        avatar = json['avatar'],
        version = json['__v'];

  int id;
  int userId;
  String username;
  String city;
  String registerTime;
  int point;
  String mobile;
  bool isMobileValid;
  bool isEmailValid;
  int isActive;
  int giftAmount;
  String email;
  int deliveryCardExpireDays;
  int currentInvoiceId;
  int currentAddressId;
  int brandMemberNew;
  int balance;
  String avatar;
  int version;

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'username': username,
    'city': city,
    'registe_time': registerTime,
    'point': point,
    'mobile': mobile,
    'is_mobile_valid': isMobileValid,
    'is_email_valid': isEmailValid,
    'is_active': isActive,
    'gift_amount': giftAmount,
    'email': email,
    'delivery_card_expire_days': deliveryCardExpireDays,
    'current_invoice_id': currentInvoiceId,
    'current_address_id': currentAddressId,
    'brand_member_new': brandMemberNew,
    'balance': balance,
    'avatar': avatar,
    '__v': version,
  };
}