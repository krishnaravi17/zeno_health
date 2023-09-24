class UserInventory {
  late final int id;
  late final String item_name;
  late final int qty;
  late final int item_id;
  late final int user_id;
  late final String path;

  UserInventory({
    required this.id,
    required this.item_id,
    required this.user_id,
    required this.item_name,
    required this.path,
    required this.qty,
  });

  UserInventory.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        item_name = result["item_name"],
        item_id = result["item_id"],
        user_id = result["user_id"],
        path = result["path"],
        qty = result["qty"];
  Map<String, Object> toMap() {
    return {
      'id': id,
      'item_name': item_name,
      'qty': qty,
      'user_id': user_id,
      'path': path,
      'item_id': item_id
    };
  }
}
