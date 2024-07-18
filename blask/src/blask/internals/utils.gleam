import sketch as s

pub fn scl(styles) {
  styles |> s.class |> s.memo |> s.to_lustre
}

pub fn scld(styles, name) {
  styles |> s.dynamic(name, _) |> s.memo |> s.to_lustre
}
