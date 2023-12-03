type t = string

@module("uuid") external uuidV4: unit => t = "v4"

let fromString = (value: string): t => value
