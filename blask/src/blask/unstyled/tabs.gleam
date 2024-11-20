import blask/internals/utils.{append_attributes, append_class, split_pairs}
import gleam/list
import lustre/event
import sketch as s
import sketch/lustre/element.{type Element}
import sketch/lustre/element/html

pub type TabsState {
  TabsState(opened_tab_idx: Int)
}

pub fn init_state() {
  TabsState(0)
}

pub type TabsItem(msg) =
  fn(Bool) -> #(List(s.Style), Element(msg), List(s.Style), Element(msg))

pub fn tabs(
  state state: TabsState,
  on_state_change change_state: fn(TabsState) -> msg,
  tabs items: List(TabsItem(msg)),
) -> Element(msg) {
  let elements =
    list.index_map(items, fn(item, idx) {
      let open = state.opened_tab_idx == idx
      let new_state = case open {
        True -> state
        False -> TabsState(idx)
      }
      view_item(open: open, change_state: change_state(new_state), item: item)
    })
  let #(heads, bodies) = split_pairs(elements)
  html.div(s.class([]), [], [
    html.div(s.class([s.display("flex"), s.flex_direction("row")]), [], heads),
    html.div(s.class([]), [], bodies),
  ])
}

fn body_class() {
  []
}

fn body_class_open() {
  []
}

fn body_class_closed() {
  [s.display("none")]
}

fn view_item(
  open open: Bool,
  change_state change_state: msg,
  item item: TabsItem(msg),
) -> #(Element(msg), Element(msg)) {
  let body_class_animed = case open {
    True -> body_class_open()
    False -> body_class_closed()
  }
  let #(head_styles, head, body_styles, body) = item(open)
  let body_class =
    [body_class(), body_class_animed, body_styles]
    |> list.flatten
    |> s.class
  #(
    append_attributes(head, [event.on_click(change_state)])
      |> append_class(head_styles |> s.class),
    append_class(body, body_class),
  )
}
