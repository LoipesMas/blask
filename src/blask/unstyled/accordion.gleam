import blask/internals/utils.{scl}
import gleam/list
import gleam/option
import lustre/element.{type Element}
import lustre/element/html
import lustre/event
import sketch as s

pub type AccordionState {
  AccordionState(opened_item_idx: option.Option(Int))
}

pub fn init_state() {
  AccordionState(option.None)
}

pub type AccordionItem(msg) =
  #(Element(msg), Element(msg))

pub fn accordion(
  state state: AccordionState,
  on_state_change change_state: fn(AccordionState) -> msg,
  items items: List(AccordionItem(msg)),
  item_holder item_holder: fn(List(Element(msg))) -> Element(msg),
) -> Element(msg) {
  html.div([], {
    {
      use item, idx <- list.index_map(items)
      let open =
        option.map(state.opened_item_idx, fn(o) { o == idx })
        |> option.unwrap(or: False)
      let new_state = case open {
        True -> AccordionState(option.None)
        False -> AccordionState(option.Some(idx))
      }
      view_item(
        open: open,
        change_state: change_state(new_state),
        item: item,
        item_holder: item_holder,
      )
    }
    // TODO: this shouldn't be in the unstyled version
    |> list.intersperse(html.hr([scl([s.margin_("0")])]))
  })
}

fn body_class() {
  [] |> scl
}

fn body_class_anim(open: Bool) {
  case open {
    True -> [s.overflow("scroll")] |> scl
    False -> [s.max_height_("0"), s.overflow("clip")] |> scl
  }
}

fn view_item(
  open open: Bool,
  change_state change_state: msg,
  item item: AccordionItem(msg),
  item_holder item_holder: fn(List(Element(msg))) -> Element(msg),
) -> Element(msg) {
  let #(head, body) = item
  item_holder([
    html.div([event.on_click(change_state), scl([s.cursor("pointer")])], [head]),
    html.div([body_class(), body_class_anim(open)], [body]),
  ])
}
