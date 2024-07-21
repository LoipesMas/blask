import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/internals/vdom
import sketch as s

pub fn scl(styles) {
  styles |> s.class |> s.memo |> s.to_lustre
}

pub fn scld(styles, name) {
  styles |> s.dynamic("blask-" <> name, _) |> s.memo |> s.to_lustre
}

pub fn split_pairs(pairs: List(#(a, b))) -> #(List(a), List(b)) {
  use #(list_a, list_b), #(item_a, item_b) <- list.fold(pairs, #([], []))
  #(list.append(list_a, [item_a]), list.append(list_b, [item_b]))
}

pub fn append_attributes(
  element: Element(msg),
  attrs new_attrs: List(attribute.Attribute(msg)),
) -> Element(msg) {
  case element {
    vdom.Element(k, n, t, attrs, c, s, v) ->
      vdom.Element(k, n, t, list.append(attrs, new_attrs), c, s, v)
    node -> node
  }
}
