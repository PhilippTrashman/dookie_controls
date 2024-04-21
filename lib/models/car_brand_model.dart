class CarBrand {
  final int id;
  final String name;
  final String logo;

  CarBrand(this.id, this.name, this.logo);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
    };
  }

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      json['id'],
      json['name'],
      json['logo'],
    );
  }
}

final Map<int, CarBrand> carBrands = {
  1: CarBrand(1, 'Volkswagen', 'assets/brands/vw.svg'),
  2: CarBrand(2, 'BMW', 'assets/brands/bmw.svg'),
  3: CarBrand(3, 'Mercedes-Benz', 'assets/brands/mercedes.svg'),
  4: CarBrand(4, 'Lada', 'assets/brands/lada.svg'),
  5: CarBrand(5, '狗屎盒', 'assets/brands/gou_shi_he.svg')
};
