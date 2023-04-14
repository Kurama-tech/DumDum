class UserProfile {
  final String location;
  final String company;
  final String businessCategory;
  final String businessType;
  final String proprietor;
  final String status;
  final String phone;
  final String userId;
  final String name;
  final String id;
  final String avatar;
  final List<String> images;

  UserProfile({
    required this.location,
    required this.company,
    required this.businessCategory,
    required this.businessType,
    required this.proprietor,
    required this.status,
    required this.phone,
    required this.userId,
    required this.name,
    required this.id,
    required this.avatar,
    required this.images,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final List<dynamic> imagesJson = json['images'] ?? [];
    final List<String> images = List<String>.from(imagesJson.map((e) => e.toString()));
    return UserProfile(
      location: json['location'] ?? '',
      company: json['company'] ?? '',
      businessCategory: json['business_category'] ?? '',
      businessType: json['business_type'] ?? '',
      proprietor: json['proprietor'] ?? '',
      status: json['status'] ?? '',
      phone: json['contact'] ?? '',
      userId: json['userid'] ?? '',
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      avatar: json['avatar'] ?? '',
      images: images,
    );
  }
}
