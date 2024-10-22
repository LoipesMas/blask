import blask/internals/utils.{append_attributes, scl, scld, split_pairs}
import gleam/list
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import sketch as s

pub type TabsState {
  TabsState(opened_tab_idx: Int)
}

pub fn init_state() {
  TabsState(0)
}

pub type TabsItem(msg) =
  fn(Bool) -> #(Element(msg), Element(msg))

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
  html.div([], [
    html.div([scl([s.display("flex"), s.flex_direction("row")])], heads),
    html.div([], bodies),
  ])
}

fn head_class() {
  [s.flex("1 1")]
  |> scld("tabs-head")
}

fn body_class() {
  [] |> scld("tabs-body")
}

fn body_class_open() {
  []
  |> scld("tabs-body-open")
}

fn body_class_closed() {
  [s.display("none")]
  |> scld("tabs-body-closed")
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
  let body_attrs = [body_class(), body_class_animed]
  let #(head, body) = item(open)
  #(
    append_attributes(head, [event.on_click(change_state), head_class()]),
    append_attributes(body, body_attrs),
  )
}
