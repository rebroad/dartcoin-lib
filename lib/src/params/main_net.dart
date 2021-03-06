part of dartcoin.core;

class _MainNetParams extends NetworkParameters {
  
  static Block _genesis;
  
  const _MainNetParams() : super._(
      addressHeader: 0, 
      p2shHeader: 5,
      magicValue: 0xD9B4BEF9,
      id: "org.bitcoin.production",
      port: 8333);
  
  Block get genesisBlock {
    if(_genesis == null) {
      Block genesis = NetworkParameters._createGenesis(this)
        .._timestamp = 1231006505
        .._nonce = 2083236893
        .._difficultyTarget = 0x1d00ffff;
      _genesis = genesis;
    }
    return _genesis;
  }
  
  BigInteger get proofOfWorkLimit => Utils.decodeCompactBits(0x1d00ffff);
}