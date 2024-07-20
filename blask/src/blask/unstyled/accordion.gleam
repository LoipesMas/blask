import blask/internals/utils.{append_attributes, scl, scld}
import gleam/list
import gleam/option
import lustre/attribute
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
  fn(Bool, List(attribute.Attribute(msg))) -> #(Element(msg), Element(msg))

pub fn accordion(
  state state: AccordionState,
  on_state_change change_state: fn(AccordionState) -> msg,
  items items: List(AccordionItem(msg)),
  item_holder item_holder: fn(List(Element(msg))) -> Element(msg),
  separator separator: Element(msg),
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
    |> list.intersperse(separator)
  })
}

fn body_class() {
  [] |> scld("accordion-body")
}

fn body_class_open() {
  [s.overflow("auto")] |> scld("accordion-body-open")
}

fn body_class_closed() {
  [s.max_height_("0"), s.overflow("clip")] |> scld("accordion-body-closed")
}

fn view_item(
  open open: Bool,
  change_state change_state: msg,
  item item: AccordionItem(msg),
  item_holder item_holder: fn(List(Element(msg))) -> Element(msg),
) -> Element(msg) {
  let body_class_animed = case open {
    True -> body_class_open()
    False -> body_class_closed()
  }
  let body_attrs = [body_class(), body_class_animed]
  let #(head, body) = item(open, body_attrs)
  item_holder([
    append_attributes(head, [
      event.on_click(change_state),
      scl([s.cursor("pointer")]),
    ]),
    body,
  ])
}
