open BindingHelpers

type cluster = [#devnet | #testnet | #"mainnet-beta"]
type finality = [#confirmed | #finalized | #processed]

module PublicKey = {
  type t

  // number | string | Uint8Array | Array<number> | PublicKeyData;
  @unboxed
  type rec publicKeyInitData = PublicKeyInitData('a): publicKeyInitData

  @module("@solana/web3.js") @new
  external make: publicKeyInitData => t = "PublicKey"

  @module("@solana/web3.js") @scope("PublicKey")
  external unique: unit => t = "unique"

  @module("@solana/web3.js") @scope("PublicKey")
  external default: unit => t = "default"

  @module("@solana/web3.js") @scope("PublicKey")
  external equals: (t, t) => bool = "equals"

  @send
  external toBase58: t => string = "toBase58"

  @send
  external toJSON: t => string = "toJSON"

  @send
  external toBytes: t => array<int> = "toBytes"

  @send
  external toBuffer: t => Buffer.t = "toBuffer"

  @send
  external toString: t => string = "toString"

  @module("@solana/web3.js") @scope("PublicKey")
  external createWithSeed: (t, string, t) => Js.Promise.t<t> = "createWithSeed"

  @module("@solana/web3.js") @scope("PublicKey")
  external createProgramAddressSync: (array<Buffer.t>, t) => t = "createProgramAddressSync"

  @module("@solana/web3.js") @scope("PublicKey")
  external createProgramAddress: (array<Buffer.t>, t) => Js.Promise.t<t> = "createProgramAddress"

  @module("@solana/web3.js") @scope("PublicKey")
  external findProgramAddressSync: (array<Buffer.t>, t) => (t, int) = "findProgramAddressSync"

  @module("@solana/web3.js") @scope("PublicKey")
  external findProgramAddress: (array<Buffer.t>, t) => Js.Promise.t<(t, int)> = "findProgramAddress"

  @module("@solana/web3.js") @scope("PublicKey")
  external isOnCurve: unit => bool = "isOnCurve"
}

type blockhash = string

module Connection = {
  type blockhashWithExpiryBlockHeight = {
    blockhash: blockhash,
    lastValidBlockHeight: number,
  }

  type config = {commitment: finality}

  type t = {
    latestBlockhash: Js.Null.t<blockhashWithExpiryBlockHeight>,
    lastFetch: number,
    simulatedSignatures: array<string>,
    transactionSignatures: array<string>,
  }

  @module("@solana/web3.js") @new
  external make: (string, config) => t = "Connection"

  @send
  external getBalance: (t, PublicKey.t, ~config: config=?, unit) => Js.Promise.t<int> = "getBalance"
}

@module("@solana/web3.js")
external clusterApiUrl: (~cluster: cluster, ~tls: bool=?, unit) => string = "clusterApiUrl"
