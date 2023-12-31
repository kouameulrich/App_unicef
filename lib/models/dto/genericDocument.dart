class GenericDocument {
  String? releaseOrSaleDocument;
  String? waybillOrPurchasing;
  String? material;
  String? material_description;
  String? quantity;
  String? consignee;
  String? consigneeName;

  GenericDocument({
    required this.releaseOrSaleDocument,
    required this.waybillOrPurchasing,
    required this.material,
    required this.material_description,
    required this.quantity,
    required this.consignee,
    required this.consigneeName,
  });

  factory GenericDocument.fromJson(Map<String, dynamic> json) {
    return GenericDocument(
      releaseOrSaleDocument: json['releaseOrSaleDocument'],
      waybillOrPurchasing: json['waybillOrPurchasing'],
      material: json['material'],
      material_description: json['material_description'],
      quantity: json['quantity'],
      consignee: json['consignee'],
      consigneeName: json['consigneeName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['releaseOrSaleDocument'] = releaseOrSaleDocument;
    data['waybillOrPurchasing'] = waybillOrPurchasing;
    data['material'] = material;
    data['material_description'] = material_description;
    data['quantity'] = quantity;
    data['consignee'] = consignee;
    data['consigneeName'] = consigneeName;
    return data;
  }
}
