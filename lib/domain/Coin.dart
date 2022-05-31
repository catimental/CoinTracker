class Coin {
  final String id;
  final String name;
  Coin(this.id, this.name);

  Coin.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
