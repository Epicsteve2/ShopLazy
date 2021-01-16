import "Item.dart";

class ShoppingList {
  static List<Item> shoppingList = [new Item("Milk Chocolate", 12, "choco")];

  ShoppingList();

  void addItem(Item item) {
    if (!shoppingList.contains(item)) {
      shoppingList.add(item);
    }
  }

  void removeItem(Item item) {
    if (shoppingList.contains(item)) {
      shoppingList.remove(item);
    }
  }

  bool editItemQuant(Item item, int newQuant) {
    if (shoppingList.contains(item)) {
      shoppingList[shoppingList.indexOf(item)].setQuant(newQuant);
      return true;
    }

    return false;
  }

  static Iterator<Item> getShoppingList() {
    return ShoppingList.shoppingList.iterator;
  }
}
