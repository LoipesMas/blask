import blask/styled/accordion.{type AccordionState, accordion}
import blask/styled/select.{type SelectState, select}
import blask/styled/style
import lustre
import lustre/element
import lustre/element/html
import sketch as s
import sketch/lustre as sketch_lustre
import sketch/options as sketch_options

fn scl(styles) {
  styles |> s.class |> s.to_lustre
}

type LanguageOption {
  Gleam
  Haskell
  Rust
  Erlang
}

fn language_to_str(language: LanguageOption) -> String {
  case language {
    Gleam -> "Gleam"
    Haskell -> "Haskell"
    Rust -> "Rust"
    Erlang -> "Erlang"
  }
}

type Model {
  Model(
    language_select_state: SelectState(LanguageOption),
    accordion_state: AccordionState,
  )
}

fn init(_flags) -> Model {
  Model(
    language_select_state: select.init_state(Gleam, [
      Gleam,
      Haskell,
      Rust,
      Erlang,
    ]),
    accordion_state: accordion.init_state(),
  )
}

type Msg {
  LanguageSelectStateChange(SelectState(LanguageOption))
  AccordionStateChange(AccordionState)
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    LanguageSelectStateChange(new_state) ->
      Model(..model, language_select_state: new_state)
    AccordionStateChange(new_state) ->
      Model(..model, accordion_state: new_state)
  }
}

fn view(model: Model) -> element.Element(Msg) {
  html.div(
    [
      scl([
        s.display("flex"),
        s.flex_direction("column"),
        s.align_items("center"),
        s.gap_("1rem"),
        s.background(
          "url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZlcnNpb249IjEuMSIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHhtbG5zOnN2Z2pzPSJodHRwOi8vc3ZnanMuZGV2L3N2Z2pzIiB2aWV3Qm94PSIwIDAgNzAwIDcwMCIgd2lkdGg9IjcwMCIgaGVpZ2h0PSI3MDAiIG9wYWNpdHk9IjAuMTEiPjxkZWZzPjxmaWx0ZXIgaWQ9Im5ubm9pc2UtZmlsdGVyIiB4PSItMjAlIiB5PSItMjAlIiB3aWR0aD0iMTQwJSIgaGVpZ2h0PSIxNDAlIiBmaWx0ZXJVbml0cz0ib2JqZWN0Qm91bmRpbmdCb3giIHByaW1pdGl2ZVVuaXRzPSJ1c2VyU3BhY2VPblVzZSIgY29sb3ItaW50ZXJwb2xhdGlvbi1maWx0ZXJzPSJsaW5lYXJSR0IiPgoJPGZlVHVyYnVsZW5jZSB0eXBlPSJmcmFjdGFsTm9pc2UiIGJhc2VGcmVxdWVuY3k9IjAuMiIgbnVtT2N0YXZlcz0iNCIgc2VlZD0iMTUiIHN0aXRjaFRpbGVzPSJzdGl0Y2giIHg9IjAlIiB5PSIwJSIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgcmVzdWx0PSJ0dXJidWxlbmNlIj48L2ZlVHVyYnVsZW5jZT4KCTxmZVNwZWN1bGFyTGlnaHRpbmcgc3VyZmFjZVNjYWxlPSI1IiBzcGVjdWxhckNvbnN0YW50PSIxIiBzcGVjdWxhckV4cG9uZW50PSIyMCIgbGlnaHRpbmctY29sb3I9IiM2MTYxNjEiIHg9IjAlIiB5PSIwJSIgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgaW49InR1cmJ1bGVuY2UiIHJlc3VsdD0ic3BlY3VsYXJMaWdodGluZyI+CiAgICAJCTxmZURpc3RhbnRMaWdodCBhemltdXRoPSIzIiBlbGV2YXRpb249IjkxIj48L2ZlRGlzdGFudExpZ2h0PgogIAk8L2ZlU3BlY3VsYXJMaWdodGluZz4KICA8ZmVDb2xvck1hdHJpeCB0eXBlPSJzYXR1cmF0ZSIgdmFsdWVzPSIwIiB4PSIwJSIgeT0iMCUiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGluPSJzcGVjdWxhckxpZ2h0aW5nIiByZXN1bHQ9ImNvbG9ybWF0cml4Ij48L2ZlQ29sb3JNYXRyaXg+CjwvZmlsdGVyPjwvZGVmcz48cmVjdCB3aWR0aD0iNzAwIiBoZWlnaHQ9IjcwMCIgZmlsbD0iIzAwMDAwMDAwIj48L3JlY3Q+PHJlY3Qgd2lkdGg9IjcwMCIgaGVpZ2h0PSI3MDAiIGZpbGw9IiM2MTYxNjEiIGZpbHRlcj0idXJsKCNubm5vaXNlLWZpbHRlcikiPjwvcmVjdD48L3N2Zz4=')",
        ),
        s.height_("100vh"),
      ]),
    ],
    [
      style.blask_style(),
      html.h1(
        [
          scl([
            s.font_size_("2rem"),
            s.width_("100%"),
            s.text_align("center"),
            s.margin_("1.5rem 0"),
          ]),
        ],
        [html.text("🌟 Blask Showcase Site 🌟")],
      ),
      html.div([scl([s.display("flex"), s.flex_direction("row")])], [
        html.div(
          [
            scl([
              s.height_("fit-content"),
              s.margin_("auto 1rem auto 0"),
              s.font_size_("1.2rem"),
            ]),
          ],
          [html.text("Your favourite language: ")],
        ),
        select(
          state: model.language_select_state,
          on_state_change: LanguageSelectStateChange,
          display: language_to_str,
        ),
      ]),
      html.div([], [
        accordion(
          state: model.accordion_state,
          on_state_change: AccordionStateChange,
          items: [
            #(
              "Gleam",
              html.p([], [
                html.text(
                  "Gleam is a general-purpose, concurrent, functional high-level programming language that compiles to Erlang or JavaScript source code.",
                ),
              ]),
            ),
            #(
              "Haskell",
              html.p([], [
                html.text(
                  "Haskell is a general-purpose, statically-typed, purely functional programming language with type inference and lazy evaluation.",
                ),
              ]),
            ),
            #(
              "Rust",
              html.p([], [
                html.text(
                  "Rust is a multi-paradigm, general-purpose programming language that emphasizes performance, type safety, and concurrency.",
                ),
              ]),
            ),
            #(
              "Erlang",
              html.p([], [
                html.text(
                  "Erlang is a general-purpose, concurrent, functional high-level programming language, and a garbage-collected runtime system",
                ),
              ]),
            ),
          ],
        ),
      ]),
    ],
  )
}

pub fn main() {
  let assert Ok(cache) =
    sketch_options.document()
    |> sketch_lustre.setup()

  let app =
    view
    |> sketch_lustre.compose(cache)
    |> lustre.simple(init, update, _)
  let assert Ok(_) = lustre.start(app, "#app", Nil)

  Nil
}
