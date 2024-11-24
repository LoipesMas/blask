import blask/styled/pill
import blask/unstyled/input
import gleam/function
import gleam/list
import gleam/option.{type Option}
import gleam/set.{type Set}
import gleam/string
import lustre/event
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html
import sketch/size

pub type TagsInputState {
  TagsInputState(open: Bool, current_input: String, current_values: Set(String))
}

pub fn init_state(current_values current_values: List(String)) -> TagsInputState {
  TagsInputState(
    open: False,
    current_input: "",
    current_values: current_values
      |> set.from_list,
  )
}

pub fn get_current_values(state: TagsInputState) -> List(String) {
  state.current_values |> set.to_list
}

pub fn set_current_values(
  state: TagsInputState,
  values: List(String),
) -> TagsInputState {
  TagsInputState(..state, current_values: values |> set.from_list)
}

fn handle_input_change(state: TagsInputState, new_input: String) {
  case string.ends_with(new_input, " ") {
    False -> TagsInputState(..state, current_input: new_input)
    True -> {
      let new_value = new_input |> string.trim_end
      case string.is_empty(new_value) {
        True -> TagsInputState(..state, current_input: "")
        False ->
          TagsInputState(
            ..state,
            current_values: state.current_values
              |> set.insert(new_value),
            current_input: "",
          )
      }
    }
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
      open: False,
      current_values: state.current_values |> set.delete(value),
    ),
  ))
  |> pill.build
}

fn input_styles() {
  [
    s.background("#151515"),
    s.border_radius_("0.3rem"),
    s.color("whitesmoke"),
    s.padding_("0.3rem 0.5rem"),
    s.font_family("inherit"),
    s.font_size_("1.07rem"),
    s.border("1px solid #606060"),
    s.outline("none"),
    s.display("flex"),
    s.flex_wrap("wrap"),
    s.focus([s.border("1px solid #909092")]),
    s.max_width_("20rem"),
    s.min_width_("15rem"),
    s.min_height_("1.8rem"),
  ]
}

pub type NoSuggestions

pub type Suggestions

pub type NoPlaceholder

pub type Placeholder

pub type TagsInputProps(msg, suggestions, placeholder) {
  TagsInputProps(
    state: TagsInputState,
    on_state_change: fn(TagsInputState) -> msg,
    suggestions: List(String),
    placeholder: Option(String),
  )
}

pub fn new(
  state: TagsInputState,
  on_state_change: fn(TagsInputState) -> msg,
) -> TagsInputProps(msg, NoSuggestions, NoPlaceholder) {
  TagsInputProps(
    state:,
    on_state_change:,
    suggestions: [],
    placeholder: option.None,
  )
}

pub fn with_suggestions(
  props: TagsInputProps(msg, NoSuggestions, placeholder),
  suggestions: List(String),
) -> TagsInputProps(msg, Suggestions, placeholder) {
  TagsInputProps(
    state: props.state,
    on_state_change: props.on_state_change,
    suggestions: suggestions,
    placeholder: props.placeholder,
  )
}

pub fn with_placeholder(
  props: TagsInputProps(msg, s, NoPlaceholder),
  placeholder: String,
) -> TagsInputProps(msg, s, Placeholder) {
  TagsInputProps(
    state: props.state,
    on_state_change: props.on_state_change,
    suggestions: props.suggestions,
    placeholder: option.Some(placeholder),
  )
}

pub fn build(props: TagsInputProps(msg, s, p)) -> Element(msg) {
  let state = props.state
  let state_change = props.on_state_change
  let filtered_suggestions =
    props.suggestions
    |> list.filter(string.contains(_, state.current_input))
    |> list.filter(fn(v) {
      !list.contains(state.current_values |> set.to_list, v)
    })
  html.div(
    s.class([s.position("relative")]),
    [
      event.on("focusin", fn(_) {
        Ok(state_change(TagsInputState(..state, open: True)))
      }),
      event.on("focusout", fn(_) {
        Ok(state_change(TagsInputState(..state, open: False)))
      }),
    ],
    [
      html.div(s.class(input_styles()), [], [
        html.div(
          s.class([s.display("flex"), s.flex_wrap("wrap"), s.gap_("0.2rem")]),
          [],
          list.map(
            state.current_values
              |> set.to_list
              |> list.sort(by: string.compare),
            tag_pill(state, state_change, _),
          ),
        ),
        input.text()
          |> {
            option.map(props.placeholder, fn(p) { input.with_placeholder(_, p) })
            |> option.unwrap(function.identity)
          }
          |> input.with_value(state.current_input)
          |> input.on_input(fn(v) {
            state_change(handle_input_change(state, v))
          })
          |> input.with_attributes([
            event.on_keydown(fn(k) {
              case k == "Enter" {
                True -> handle_input_change(state, state.current_input <> " ")
                False -> state
              }
              |> state_change
            }),
          ])
          |> input.with_styles([
            s.background("none"),
            s.border("none"),
            s.color("whitesmoke"),
            s.outline("none"),
            s.font_family("inherit"),
            s.font_size_("1.07rem"),
            s.width_("8rem"),
            s.flex_grow_("1"),
          ])
          |> input.build,
      ]),
      selection_list(state, state_change, filtered_suggestions),
    ],
  )
}

fn selection_list_class() {
  [
    s.display("flex"),
    s.flex_direction("column"),
    s.position("absolute"),
    s.z_index(10),
    s.left_("0"),
    s.right_("0"),
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
  [s.display("block"), s.animation("fade-in 0.3s ease-in forwards;")]
}

fn list_closed_styles() {
  [s.display("none"), s.animation("fade-out 0.3s ease-out forwards")]
}

fn suggestion_button_list_class() {
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
    s.text_align("left"),
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
    html.button(suggestion_button_list_class() |> s.class, [], [
      html.text(option),
    ])
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
