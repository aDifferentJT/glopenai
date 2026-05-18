import gleam/dynamic.{type Dynamic}
import gleam/json
import gleam/list
import gleam/option.{type Option, None, Some}

/// Encode an optional field. Returns a single-element list with the key-value
/// pair when the value is `Some`, or an empty list when `None`. Designed to be
/// used with `list.flatten` when building JSON objects:
///
/// ```gleam
/// json.object(list.flatten([
///   [#("name", json.string(name))],
///   optional_field("description", description, json.string),
/// ]))
/// ```
pub fn optional_field(
  key: String,
  value: Option(a),
  encoder: fn(a) -> json.Json,
) -> List(#(String, json.Json)) {
  case value {
    Some(v) -> [#(key, encoder(v))]
    None -> []
  }
}

/// Encode an optional field as nullable (always present, null when None).
pub fn nullable_field(
  key: String,
  value: Option(a),
  encoder: fn(a) -> json.Json,
) -> #(String, json.Json) {
  #(key, json.nullable(value, encoder))
}

/// Encode a Dynamic value as JSON. The Dynamic must have originated from
/// JSON decoding (e.g. via `json.parse` with `decode.dynamic`). On the
/// Erlang target this re-encodes the native term through OTP's json module.
@external(erlang, "glopenai_codec_ffi", "dynamic_to_json")
@external(javascript, "../../glopenai_codec_ffi.mjs", "dynamic_to_json")
pub fn dynamic_to_json(value: Dynamic) -> json.Json

/// Build a JSON object from required fields and optional fields combined.
pub fn object_with_optional(
  required: List(#(String, json.Json)),
  optional: List(List(#(String, json.Json))),
) -> json.Json {
  json.object(list.flatten([required, ..optional]))
}
