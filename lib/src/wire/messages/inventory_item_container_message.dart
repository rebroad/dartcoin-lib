part of dartcoin.core;

abstract class InventoryItemContainerMessage extends Message {
  
  List<InventoryItem> _items;
  
  InventoryItemContainerMessage(String command, List<InventoryItem> items, [NetworkParameters params]) : super(command, params) {
    if(items.length > 50000) {
      throw new Exception("Maximum 50000 inventory items");
    }
    _items = items;
  }
  
  List<InventoryItem> get items {
    _needInstance();
    return new UnmodifiableListView(_items);
  }
  
  /**
   * Add a new item to this container message.
   * 
   * [item] can be either of type [InventoryItem], [Block] or [Transaction].
   */
  void addItem(dynamic item) {
    item = _castItem(item);
    _needInstance(true);
    _items.add(item);
  }
  
  /**
   * Remove an item from this container message.
   * 
   * [item] can be either of type [InventoryItem], [Block] or [Transaction].
   */
  void removeItem(dynamic item) {
    item = _castItem(item);
    _needInstance(true);
    _items.remove(item);
  }
  
  InventoryItem _castItem(dynamic item) {
    if(item is Block)
      item = new InventoryItem.fromBlock(item);
    else if(item is Transaction)
      item = new InventoryItem.fromTransaction(item);
    else if(item is InventoryItem)
      return item;
    throw new ArgumentError("Invalid parameter type. Read documentation.");
  }
  
  // required for serialization
  InventoryItemContainerMessage._newInstance(String command) : super(command, null);
  
  int _deserializePayload(Uint8List bytes, bool lazy, bool retain) {
    int offset = 0;
    VarInt nbItems = new VarInt.deserialize(bytes.sublist(offset), lazy: false);
    offset += nbItems.size;
    _items = new List<InventoryItem>();
    for(int i = 0 ; i < nbItems.value ; i++) {
      _items.add(new InventoryItem.deserialize(bytes.sublist(offset), lazy: lazy, retain: retain));
      offset += InventoryItem.SERIALIZATION_LENGTH;
    }
    return offset;
  }
  
  Uint8List _serialize_payload() {
    List<int> result = new List<int>()
      ..addAll(new VarInt(_items.length).serialize());
    for(InventoryItem item in _items) {
      result.addAll(item.serialize());
    }
    return new Uint8List.fromList(result);
  }
}