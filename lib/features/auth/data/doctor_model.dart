class DoctorModel {
  String? name;
  String? image;
  String? specialization;
  int? rating;
  String? email;
  String? phone1;
  String? phone2;
  String? bio;
  String? openHour;
  String? closeHour;
  String? address;
  String? uid;

  DoctorModel({
    this.name,
    this.image,
    this.specialization,
    this.rating,
    this.email,
    this.phone1,
    this.phone2,
    this.bio,
    this.openHour,
    this.closeHour,
    this.address,
    this.uid,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      name: json['name'],
      image: json['image'],
      specialization: json['specialization'],
      rating: json['rating'],
      email: json['email'],
      phone1: json['phone1'],
      phone2: json['phone2'],
      bio: json['bio'],
      openHour: json['openHour'],
      closeHour: json['closeHour'],
      address: json['address'],
      uid: json['uid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (image != null) 'image': image,
      if (specialization != null) 'specialization': specialization,
      if (rating != null) 'rating': rating,
      if (email != null) 'email': email,
      if (phone1 != null) 'phone1': phone1,
      if (phone2 != null) 'phone2': phone2,
      if (bio != null) 'bio': bio,
      if (openHour != null) 'openHour': openHour,
      if (closeHour != null) 'closeHour': closeHour,
      if (address != null) 'address': address,
      if (uid != null) 'uid': uid,
    };
  }
}