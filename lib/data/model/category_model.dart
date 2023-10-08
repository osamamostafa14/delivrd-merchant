class CategoryModel {
  int? id;
  String? name;
  String? description;
  int? parentId;
  int? position;
  String? createdAt;
  String? updatedAt;
  String? image;

  CategoryModel({
    this.id,
    this.name,
    this.description,
    this.parentId,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.image,
  });



  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    parentId = json['parent_id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'description': description,
      'parent_id': parentId,
      'position': position,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'image': image,
    };
    return data;
  }
}
