import 'dart:convert';

class Customer {
  String name;
  String phone;
  String email;
  String address;
  String post_code;
  Customer({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    required this.post_code,
  });
  

  bool isEmpty() {
    return name.isEmpty || phone.isEmpty || email.isEmpty || address.isEmpty||post_code.isEmpty;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'post_code': post_code,
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      address: map['address'] ?? '',
      post_code: map['post_code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) => Customer.fromMap(json.decode(source));
}
