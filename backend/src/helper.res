let jsUnwrapVariant: 'a => 'b = %raw(`function unwrapVariant(v) {
  if (v._0 !== undefined) {
    return v._0;
  } else {
    return v;
  }
}`)

let jsFakeUnwrapVariant: 'a => 'b = %raw(`function unwrapVariant(v) {
  return v;
}`)
