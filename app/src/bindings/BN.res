open BindingHelpers

type t

type endianness = [#le | #be]
type iPrimeName = [#k256 | #p224 | #p192 | #p25519]

@unboxed
type rec tStr = TStr('a): tStr

@unboxed
type rec strFloat = StrFloat('a): strFloat

@unboxed
type rec strFloatInt = StrFloatInt('a): strFloatInt

module ReductionContext = {
  type mPrime = {
    name: string,
    p: t,
    n: number,
    k: t,
  }

  type t = {
    m: int,
    prime: mPrime,
    // If needed, this binding should be adjusted for this. Refer to this: https://forum.rescript-lang.org/t/how-to-type-object-with-unknown-properties/1316/4
    // [key: string]: any,
  }
}

@module("bn.js")
external makeWithEndian: (strFloatInt, string) => t = "BN"

@module("bn.js")
external red: tStr => ReductionContext.t = "red"

@module("bn.js")
external mont: t => ReductionContext.t = "mont"

@module("bn.js")
external isBN: 'a => bool = "isBN"

@module("bn.js")
external max: (t, t) => t = "max"

@module("bn.js")
external min: (t, t) => t = "min"

@module("bn.js")
external clone: t => t = "clone"

@module("bn.js")
external toString: (tStr, option<int>, option<int>) => string = "toString"

@module("bn.js")
external toNumber: t => int = "toNumber"

@module("bn.js")
external toJSON: t => string = "toJSON"

@module("bn.js")
external toArray: (t, option<string>, option<int>) => array<int> = "toArray"

@module("bn.js")
external toArrayLike: (t, 'a, option<string>, option<int>) => 'a = "toArrayLike"

@module("bn.js")
external toBuffer: (t, option<string>, option<int>) => Buffer.t = "toBuffer"

@module("bn.js")
external bitLength: t => int = "bitLength"

@module("bn.js")
external zeroBits: t => int = "zeroBits"

@module("bn.js")
external byteLength: t => int = "byteLength"

@module("bn.js")
external isNeg: t => bool = "isNeg"

@module("bn.js")
external isEven: t => bool = "isEven"

@module("bn.js")
external isOdd: t => bool = "isOdd"

@module("bn.js")
external isZero: t => bool = "isZero"

@module("bn.js")
external cmp: (t, t) => int = "cmp"

@module("bn.js")
external ucmp: (t, t) => int = "ucmp"

@module("bn.js")
external cmpn: (t, int) => int = "cmpn"

@module("bn.js")
external lt: (t, t) => bool = "lt"

@module("bn.js")
external ltn: (t, int) => bool = "ltn"

@module("bn.js")
external lte: (t, t) => bool = "lte"

@module("bn.js")
external lten: (t, int) => bool = "lten"

@module("bn.js")
external gt: (t, t) => bool = "gt"

@module("bn.js")
external gtn: (t, int) => bool = "gtn"

@module("bn.js")
external gte: (t, t) => bool = "gte"

@module("bn.js")
external gten: (t, int) => bool = "gten"

@module("bn.js")
external eq: (t, t) => bool = "eq"

@module("bn.js")
external eqn: (t, int) => bool = "eqn"

@module("bn.js")
external toTwos: (t, int) => t = "toTwos"

@module("bn.js")
external fromTwos: (t, int) => t = "fromTwos"

@module("bn.js")
external neg: t => t = "neg"

@module("bn.js")
external ineg: t => t = "ineg"

@module("bn.js")
external abs: t => t = "abs"

@module("bn.js")
external iabs: t => t = "iabs"

@module("bn.js")
external add: (t, t) => t = "add"

@module("bn.js")
external iadd: (t, t) => t = "iadd"

@module("bn.js")
external addn: (t, int) => t = "addn"

@module("bn.js")
external iaddn: (t, int) => t = "iaddn"

@module("bn.js")
external sub: (t, t) => t = "sub"

@module("bn.js")
external isub: (t, t) => t = "isub"

@module("bn.js")
external subn: (t, int) => t = "subn"

@module("bn.js")
external isubn: (t, int) => t = "isubn"

@module("bn.js")
external mul: (t, t) => t = "mul"

@module("bn.js")
external imul: (t, t) => t = "imul"

@module("bn.js")
external muln: (t, int) => t = "muln"

@module("bn.js")
external imuln: (t, int) => t = "imuln"

@module("bn.js")
external sqr: t => t = "sqr"

@module("bn.js")
external isqr: t => t = "isqr"

@module("bn.js")
external pow: (t, t) => t = "pow"

@module("bn.js")
external div: (t, t) => t = "div"

@module("bn.js")
external divn: (t, int) => t = "divn"

@module("bn.js")
external idivn: (t, int) => t = "idivn"

@module("bn.js")
external divmod: (t, t, option<string>, option<bool>) => {"div": t, "mod": t} = "divmod"

@module("bn.js")
external mod: (t, t) => t = "mod"

@module("bn.js")
external umod: (t, t) => t = "umod"

@module("bn.js")
external modn: (t, int) => int = "modn"

@module("bn.js")
external modrn: (t, int) => int = "modrn"

@module("bn.js")
external divRound: (t, t) => t = "divRound"

@module("bn.js")
external or: (t, t) => t = "or"

@module("bn.js")
external ior: (t, t) => t = "ior"

@module("bn.js")
external uor: (t, t) => t = "uor"

@module("bn.js")
external iuor: (t, t) => t = "iuor"

@module("bn.js")
external and_: (t, t) => t = "and"

@module("bn.js")
external iand: (t, t) => t = "iand"

@module("bn.js")
external uand: (t, t) => t = "uand"

@module("bn.js")
external iuand: (t, t) => t = "iuand"

@module("bn.js")
external andln: (t, int) => t = "andln"

@module("bn.js")
external xor: (t, t) => t = "xor"

@module("bn.js")
external ixor: (t, t) => t = "ixor"

@module("bn.js")
external uxor: (t, t) => t = "uxor"

@module("bn.js")
external iuxor: (t, t) => t = "iuxor"

@module("bn.js")
external setn: (t, int) => t = "setn"

@module("bn.js")
external shln: (t, int) => t = "shln"

@module("bn.js")
external ishln: (t, int) => t = "ishln"

@module("bn.js")
external ushln: (t, int) => t = "ushln"

@module("bn.js")
external iushln: (t, int) => t = "iushln"

@module("bn.js")
external shrn: (t, int) => t = "shrn"

@module("bn.js")
external ishrn: (t, int) => t = "ishrn"

@module("bn.js")
external ushrn: (t, int) => t = "ushrn"

@module("bn.js")
external iushrn: (t, int) => t = "iushrn"
