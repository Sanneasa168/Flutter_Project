import 'package:flutter/foundation.dart';
import 'package:myapp/provider/product_class.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  int? get count {
    _list.length;
    return null;
  }

  void addItem(
    String name,
    double price,
    int qty,
    int qutty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) {
    final product = Product(
      name: name,
      price: price,
      qty: qty,
      qntty: qutty,
      imagesUrl: imagesUrl,
      documentId: documentId,
      suppId: suppId,
    );
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
  }

  void decrease(Product product) {
    product.decrease();
  }

  void reduceByOne(Product product) {
    product.increase();
    notifyListeners();
  }

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _list.clear();
    notifyListeners();
  }
}
