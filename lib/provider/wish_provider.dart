import 'package:flutter/foundation.dart';
import 'package:myapp/provider/product_class.dart';

class Wish extends ChangeNotifier {
  final List<Product> _list = [];
  List<Product> get getWishItems {
    return _list;
  }

  double get totalPrice {
    var total = 0.0;
    for (var item in _list) {
      total += item.price * item.qty;
    }
    return total;
  }

  // ignore: body_might_complete_normally_nullable
  int? get count {
    _list.length;
  }

  Future<void> addWishItem(
    String name,
    double price,
    int qty,
    int qutty,
    List imagesUrl,
    String documentId,
    String suppId,
  ) async{
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

  void removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  void clearWishLish() {
    _list.clear();
    notifyListeners();
  }

  void removeThis(String id) {
    _list.removeWhere((element) => element.documentId == id);
    notifyListeners();
  }
}
