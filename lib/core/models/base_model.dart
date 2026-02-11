abstract class BaseModel {
  const BaseModel();

  Map<String, dynamic> toMap();
  String toJson();

  @override
  bool operator ==(Object other);

  @override
  int get hashCode;
}