class CarBrand {
  final String name;
  final String logo;

  CarBrand(this.name, this.logo);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'logo': logo,
    };
  }

  factory CarBrand.fromJson(Map<String, dynamic> json) {
    return CarBrand(
      json['name'],
      json['logo'],
    );
  }
}

final Map<int, CarBrand> carBrands = {
  1: CarBrand('Volkswagen', 'assets/brands/vw.svg'),
  2: CarBrand('BMW', 'assets/brands/bmw.svg'),
  3: CarBrand('Mercedes-Benz', 'assets/brands/mercedes.svg'),
  4: CarBrand('Lada', 'assets/brands/lada.svg'),
  5: CarBrand('狗屎盒', 'assets/brands/gou_shi_he.svg')
};
