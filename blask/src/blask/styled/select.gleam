import blask/unstyled/select.{
  type SelectState as USelectState, select as unstyled_select,
}
import gleam/list
import gleroglero/solid
import sketch as s
import sketch/lustre/element
import sketch/lustre/element/html
import sketch/size

pub type SelectState(o) =
  USelectState(o)

pub const init_state = select.init_state

fn select_button_main_class() {
  [
    s.font_size_("1rem"),
    s.min_width_("150px"),
    s.padding_("0.6rem 0.8rem"),
    s.border_radius_("0.5rem"),
    s.border("1px solid #909092"),
    s.background("#111"),
    s.color("#eee"),
    s.transition("background 0.1s ease-in-out"),
    s.hover([
      s.cursor("pointer"),
      s.background("#222"),
      s.border("1px solid #eee"),
    ]),
    s.display("flex"),
    s.justify_content("space-between"),
    s.font_family("inherit"),
  ]
}

fn select_button_list_class() {
  [
    s.font_size_("1rem"),
    s.padding_("0.6rem 0.8rem"),
    s.width_("100%"),
    s.border_radius_("0.5rem"),
    s.border("none"),
    s.background("none"),
    s.transition("background 0.1s ease-in-out"),
    s.color("#eee"),
    s.hover([s.cursor("pointer"), s.background("#333")]),
  ]
}

fn select_list_class() {
  [
    s.min_width_("142px"),
    s.margin_top(size.px(6)),
    s.padding_("3px 3px"),
    s.background("#131313"),
    s.border("1px solid #ddd"),
    s.border_radius_("0.5rem"),
    s.overflow("hidden"),
  ]
}

fn slca_open() {
  [s.display("block"), s.animation("fade-in 0.4s ease-in forwards;")]
}

fn slca_closed() {
  [s.display("none"), s.animation("fade-out 0.4s ease-out forwards")]
}

fn icon_class() {
  [
    s.display("block"),
    s.width_("20px"),
    s.height_("20px"),
    s.transition("transform 0.3s ease-out"),
  ]
}

fn rotate180() {
  [s.transform("rotate(0.5turn)")]
}

pub fn select(
  state state: SelectState(option_type),
  on_state_change on_state_change: fn(SelectState(option_type)) -> msg,
  display option_to_str: fn(option_type) -> String,
) -> element.Element(msg) {
  let rotate_class = case state.open {
    True -> [rotate180()]
    False -> []
  }
  let slca = case state.open {
    True -> [slca_open()]
    False -> [slca_closed()]
  }
  unstyled_select(
    state: state,
    on_state_change: on_state_change,
    main_button: fn(option) {
      html.button(select_button_main_class() |> s.class, [], [
        html.text(option_to_str(option)),
        html.span(
          [icon_class(), ..rotate_class] |> list.flatten |> s.class,
          [],
          [solid.chevron_down() |> element.styled],
        ),
      ])
    },
    list_button: fn(option) {
      html.button(select_button_list_class() |> s.class, [], [
        html.text(option_to_str(option)),
      ])
    },
    list: html.div(
      [select_list_class(), ..slca] |> list.flatten |> s.class,
      [],
      _,
    ),
  )
}
