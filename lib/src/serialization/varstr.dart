part of dartcoin.core;

class VarStr extends Object with BitcoinSerialization {
  
  String _content;
  
  VarStr(String content) {
    _content = content;
  }
  
  VarStr._newInstance();
  
  factory VarStr.deserialize(Uint8List bytes, {int length, bool lazy, bool retain, NetworkParameters params}) =>
      new BitcoinSerialization.deserialize(new VarStr._newInstance(), bytes, length: length, lazy: lazy, retain: retain, params: params);
  
  String get content {
    _needInstance();
    return _content;
  }
  
  /**
   * The size of the [VarStr] in bytes after serialization.
   */
  int get size {
    int byteLength = new Utf8Codec().encode(content).length;
    return VarInt.sizeOf(byteLength) + byteLength;
  }
  
  /**
   * The length of the string, not the length of the output bytes.
   */
  int get length => content.length;
  
  @override
  String toString() => content;
  
  @override
  bool operator ==(VarStr other) {
    if(other is! VarStr) return false;
    if(identical(this, other)) return true;
    _needInstance();
    other._needInstance();
    return _content == other._content;
  }
  
  @override
  int get hashCode {
    _needInstance();
    return _content.hashCode;
  }
  
  Uint8List _serialize() {
    List<int> contentBytes = new Utf8Encoder().convert(_content);
    return new Uint8List.fromList(new List<int>()
      ..addAll(new VarInt(contentBytes.length).serialize())
      ..addAll(contentBytes));
  }
  
  int _deserialize(Uint8List bytes, bool lazy, bool retain) {
    int offset = 0;
    VarInt size = new VarInt.deserialize(bytes, lazy: false);
    offset += size.serializationLength;
    _content = new Utf8Decoder().convert(bytes.sublist(offset, offset + size.value));
    offset += size.value;
    return offset;
  }
  
  int _lazySerializationLength(Uint8List bytes) {
    int offset = 0;
    VarInt size = new VarInt.deserialize(bytes, lazy: false);
    offset += size.serializationLength;
    offset += size.value;
    return offset;
  }
  
}