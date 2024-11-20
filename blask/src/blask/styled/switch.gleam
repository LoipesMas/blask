import gleam/list
import blask/internals/utils.{scld}
import lustre/attribute as a
import sketch/lustre/element/html
import lustre/event
import sketch as s

pub type SwitchState =
  Bool

fn switch_class() {
  [
    s.width_("2.45rem"),
    s.min_width_("2.45rem"),
    s.height_("1.4rem"),
    s.margin_("0.2em"),
    s.border_radius_("0.7rem"),
    s.padding_("0"),
    s.transition("background 0.15s ease-out"),
    s.cursor("pointer"),
    s.hover([s.important(s.property("--switch-color", "#eee"))]),
  ]
}

fn switch_class_checked() {
  [s.background("#222222"), s.border("2px solid var(--switch-color, #ccc)")]
}

fn switch_class_unchecked() {
  [s.background("#151515"), s.border("2px solid var(--switch-color, #666)")]
}

fn span_class() {
  [
    s.height_("1.05rem"),
    s.width_("1.05rem"),
    s.border_radius_("50%"),
    s.display("block"),
    s.margin_("auto auto"),
    s.transition(
      "transform 0.3s cubic-bezier(.45,.43,.15,.86), background 0.15s ease-out",
    ),
  ]
}

fn span_class_checked() {
  [s.background("var(--switch-color, #ccc)"), s.transform("translateX(0.5rem)")]
}

fn span_class_unchecked() {
  [
    s.background("var(--switch-color, #666)"),
    s.transform("translateX(-0.5rem)"),
  ]
}

pub fn switch(
  state state: SwitchState,
  on_state_change state_change: fn(SwitchState) -> msg,
  id id: String,
) {
  let switch_class_anim = case state {
    True -> switch_class_checked()
    False -> switch_class_unchecked()
  }
  let span_class_anim = case state {
    True -> span_class_checked()
    False -> span_class_unchecked()
  }
  html.button(
  [

      switch_class(),
      switch_class_anim,
  ] |> list.flatten |> s.class,

    [
      event.on_click(state_change(!state)),
      a.id(id),
    ],
    [html.span([span_class(), span_class_anim] |> list.flatten |> s.class, [], [])],
  )
}
