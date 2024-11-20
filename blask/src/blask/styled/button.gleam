import gleam/list
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html
import lustre/event
import sketch as s

fn base_class() {
  [
    s.cursor("pointer"),
    s.padding_("0.5rem 0.7rem"),
    s.margin_("0.2rem"),
    s.border_radius_("0.5rem"),
    s.font_family("inherit"),
    s.transition("all 0.1s ease-in-out"),
    s.font_size_("1rem"),
  ]
}

fn primary_class() {
  [
    s.border("none"),
    s.color("#222"),
    s.background("#eee"),
    s.font_weight("650"),
    s.hover([s.background("#cccccc")]),
    s.active([s.background("#ffffff")]),
  ]
}

pub fn primary(on_click on_click: msg, text text: String) -> Element(msg) {
  html.button([base_class(), primary_class()] |> list.flatten |>
  s.class,[event.on_click(on_click)], [ html.text(text), ])
}

fn secondary_class() {
  [
    s.border("none"),
    s.color("#eee"),
    s.background("#252525"),
    s.font_weight("600"),
    s.hover([s.background("#444")]),
    s.active([s.background("#777")]),
  ]
}

pub fn secondary(on_click on_click: msg, text text: String) -> Element(msg) {
  html.button([base_class(), secondary_class()] |> list.flatten |>
  s.class,[event.on_click(on_click)], [ html.text(text), ])
}

fn outlined_class() {
  [
    s.border("1px solid #555"),
    s.color("#eee"),
    s.background("#151515"),
    s.font_weight("600"),
    s.hover([s.background("#555")]),
    s.active([s.background("#666")]),
  ]
}

pub fn outlined(on_click on_click: msg, text text: String) -> Element(msg) {
  html.button([base_class(), outlined_class()] |> list.flatten |>
  s.class,[event.on_click(on_click)], [ html.text(text), ])
}
