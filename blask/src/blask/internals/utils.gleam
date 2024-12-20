import gleam/list
import gleam/pair
import lustre/attribute
import lustre/internals/vdom
import sketch as s
import sketch/lustre/element.{type Element}

pub fn split_pairs(pairs: List(#(a, b))) -> #(List(a), List(b)) {
  use #(list_a, list_b), #(item_a, item_b) <- list.fold(pairs, #([], []))
  #(list.append(list_a, [item_a]), list.append(list_b, [item_b]))
}

pub fn append_attributes(
  element: Element(msg),
  attrs new_attrs: List(attribute.Attribute(msg)),
) -> Element(msg) {
  let assert Ok(cache) = s.cache(strategy: s.Ephemeral)
  case element |> element.unstyled(cache, _) |> pair.second {
    vdom.Element(k, n, t, attrs, c, s, v) ->
      vdom.Element(k, n, t, list.append(attrs, new_attrs), c, s, v)
      |> element.styled
    node -> node |> element.styled
  }
}

pub fn append_class(element: Element(msg), class: s.Class) {
  let assert Ok(cache) = s.cache(strategy: s.Ephemeral)
  case element |> element.unstyled(cache, _) |> pair.second {
    vdom.Element(_k, _n, t, attrs, c, _s, _v) ->
      element.element(t, class, attrs, c |> list.map(element.styled))

    node -> node |> element.styled
  }
}
