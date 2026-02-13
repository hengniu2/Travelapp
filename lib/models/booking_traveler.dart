/// 出行人/旅客信息：姓名、身份证、手机号。用于旅行套餐、酒店等预订。
class BookingTraveler {
  final String name;
  final String idCard;
  final String phone;

  const BookingTraveler({
    required this.name,
    required this.idCard,
    required this.phone,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'id_card': idCard,
        'phone': phone,
      };

  static BookingTraveler? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final name = json['name']?.toString();
    final idCard = json['id_card']?.toString();
    final phone = json['phone']?.toString();
    if (name == null || name.isEmpty || idCard == null || idCard.isEmpty || phone == null || phone.isEmpty) {
      return null;
    }
    return BookingTraveler(name: name, idCard: idCard, phone: phone);
  }
}
