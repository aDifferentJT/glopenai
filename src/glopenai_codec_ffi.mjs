// On the JavaScript target, gleam_json represents `json.Json` as a plain
// JS value that gets passed straight to `JSON.stringify`. A `Dynamic` is
// likewise just the underlying JS value, so re-encoding is the identity
// function.
export function dynamic_to_json(value) {
  return value;
}
