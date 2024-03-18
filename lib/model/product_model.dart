class Product {
  int? id;
  String? title;
  String? description;
  num? price;
  num? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;
  int? quantity;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,
    this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        price: json["price"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        rating: json["rating"]?.toDouble(),
        stock: json["stock"],
        brand: json["brand"],
        category: json["category"],
        thumbnail: json["thumbnail"],
        images: List<String>.from(json["images"].map((x) => x)),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "quantity": quantity,
      };
}

extension ProductExtension on Product {
  String getProductNameOrLoading(Product ProductById, int id) {
    return ProductById.id == id
        ? ProductById.title ?? 'Loading..'
        : 'Loading..';
  }
}

class ProductQuantity {
  int? id;
  int? quantity;

  ProductQuantity({
    this.id,
    this.quantity,
  });

  factory ProductQuantity.fromJson(Map<String, dynamic> json) =>
      ProductQuantity(
        id: json["id"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "quantity": quantity,
      };
}
