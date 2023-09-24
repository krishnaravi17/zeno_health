class Inventory {
  late final int id;
  late final String item_name;
  late final String path;
  late final int qty;
  late final int item_id;
  late final int user_id;

  Inventory({
    required this.id,
    required this.item_name,
    required this.path,
    required this.qty,
  });

  Inventory.fromMap(Map<String, dynamic> result)
      : id = result["id"],
        item_name = result["item_name"],
        path = result["path"],
        qty = result["qty"];
  Map<String, Object> toMap() {
    return {'id': id, 'item_name': item_name, 'path': path, 'qty': qty};
  }
}
