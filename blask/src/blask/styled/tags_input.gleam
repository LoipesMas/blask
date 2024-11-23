import blask/styled/input
import blask/styled/pill
import gleam/list
import gleam/set.{type Set}
import gleam/string
import lustre/event
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html
import sketch/size

pub type TagsInputState {
  TagsInputState(
    open: Bool,
    current_input: String,
    current_values: Set(String),
    suggestions: List(String),
  )
}

pub fn init_state(
  current_values current_values: List(String),
  suggestions suggestions: List(String),
) -> TagsInputState {
  TagsInputState(
    open: False,
    current_input: "",
    current_values: current_values
      |> set.from_list,
    suggestions: suggestions,
  )
}

fn handle_input_change(state: TagsInputState, new_input: String) {
  case string.ends_with(new_input, " ") {
    False -> TagsInputState(..state, current_input: new_input)
    True ->
      TagsInputState(
        ..state,
        current_values: state.current_values
          |> set.insert(new_input |> string.trim_end),
        current_input: "",
      )
  }
}

fn tag_pill(
  state: TagsInputState,
  state_change: fn(TagsInputState) -> msg,
  value: String,
) -> Element(msg) {
  pill.new()
  |> pill.with_text(value)
  |> pill.with_close_button(state_change(
    TagsInputState(
      ..state,
      current_values: state.current_values |> set.delete(value),
    ),
  ))
  |> pill.build
}

pub fn tags_input(
  state state: TagsInputState,
  on_state_change state_change: fn(TagsInputState) -> msg,
) -> Element(msg) {
  let filtered_suggestions =
    state.suggestions
    |> list.filter(string.contains(_, state.current_input))
    |> list.filter(fn(v) {
      !list.contains(state.current_values |> set.to_list, v)
    })
  html.div(s.class([]), [], [
    html.div(
      s.class([s.display("flex"), s.gap_("0.1em"), s.margin_bottom_("0.2em")]),
      [],
      list.map(
        state.current_values
          |> set.to_list
          |> list.sort(by: string.compare),
        tag_pill(state, state_change, _),
      ),
    ),
    html.div(
      s.class([]),
      [
        event.on("focusin", fn(_) {
          Ok(state_change(TagsInputState(..state, open: True)))
        }),
        event.on("focusout", fn(_) {
          Ok(state_change(TagsInputState(..state, open: False)))
        }),
      ],
      [
        input.text()
          |> input.with_placeholder("TODO")
          |> input.with_value(state.current_input)
          |> input.on_input(fn(v) {
            state_change(handle_input_change(state, v))
          })
          |> input.build,
        selection_list(state, state_change, filtered_suggestions),
      ],
    ),
  ])
}

fn selection_list_class() {
  [
    s.display("flex"),
    s.flex_direction("column"),
    s.position("absolute"),
    s.z_index(10),
  ]
  |> s.class
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

fn list_open_styles() {
  [s.display("block"), s.animation("fade-in 0.4s ease-in forwards;")]
}

fn list_closed_styles() {
  [s.display("none"), s.animation("fade-out 0.4s ease-out forwards")]
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

fn selection_list(
  state: TagsInputState,
  state_change: fn(TagsInputState) -> msg,
  filtered_suggestions: List(String),
) -> Element(msg) {
  let list_class = case state.open {
    True -> list_open_styles()
    False -> list_closed_styles()
  }
  let list_element = html.div(
    [select_list_class(), list_class] |> list.flatten |> s.class,
    [],
    _,
  )
  let list_button = fn(option) {
    html.button(select_button_list_class() |> s.class, [], [html.text(option)])
  }
  html.div(selection_list_class(), [], [
    case list.is_empty(filtered_suggestions) {
      False ->
        list_element(
          list.map(filtered_suggestions, fn(o) {
            html.div(
              s.class([]),
              [
                event.on_click(state_change(
                  TagsInputState(
                    ..state,
                    open: False,
                    current_input: "",
                    current_values: state.current_values |> set.insert(o),
                  ),
                )),
              ],
              [list_button(o)],
            )
          }),
        )
      True -> html.div(s.class([]), [], [])
    },
  ])
}
