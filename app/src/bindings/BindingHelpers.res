@unboxed
type rec number = Num('a): number

external intOfNum: number => int = "%identity"
external floatOfNum: number => float = "%identity"
