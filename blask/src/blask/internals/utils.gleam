import gleam/list
import sketch as s

pub fn scl(styles) {
  styles |> s.class |> s.memo |> s.to_lustre
}

pub fn scld(styles, name) {
  styles |> s.dynamic(name, _) |> s.memo |> s.to_lustre
}

pub fn split_pairs(pairs: List(#(a, b))) -> #(List(a), List(b)) {
  use #(list_a, list_b), #(item_a, item_b) <- list.fold(pairs, #([], []))
  #(list.append(list_a, [item_a]), list.append(list_b, [item_b]))
}
