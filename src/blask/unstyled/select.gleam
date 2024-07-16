import blask/internals/utils.{scl}
import gleam/list
import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import sketch as s

pub type SelectState(option_type) {
  SelectState(
    open: Bool,
    current_option: option_type,
    options: List(option_type),
  )
}

pub fn init_state(
  default: option_type,
  options: List(option_type),
) -> SelectState(option_type) {
  SelectState(open: False, current_option: default, options: options)
}

pub fn select(
  state state: SelectState(option_type),
  on_state_change state_change: fn(SelectState(option_type)) -> msg,
  main_button main_button: fn(option_type) -> Element(msg),
  list_button list_button: fn(option_type) -> Element(msg),
  list list_element: fn(List(Element(msg))) -> Element(msg),
) -> Element(msg) {
  html.div([], [
    html.div(
      [
        event.on_click(state_change(SelectState(..state, open: !state.open))),
        scl([s.width_("100%")]),
      ],
      [main_button(state.current_option)],
    ),
    selection_list(state, state_change, list_button, list_element),
  ])
}

fn selection_list_class() {
  [s.display("flex"), s.flex_direction("column"), s.position("absolute")]
  |> scl
}

fn selection_list(
  state: SelectState(option_type),
  state_change: fn(SelectState(option_type)) -> msg,
  list_button: fn(option_type) -> Element(msg),
  list_element: fn(List(Element(msg))) -> Element(msg),
) -> Element(msg) {
  html.div([selection_list_class()], [
    list_element(
      list.map(state.options, fn(o) {
        html.div(
          [
            event.on_click(state_change(
              SelectState(..state, open: !state.open, current_option: o),
            )),
          ],
          [list_button(o)],
        )
      }),
    ),
  ])
}
