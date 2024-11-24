import bg
import blask/styled/accordion.{type AccordionState, accordion}
import blask/styled/button
import blask/styled/input
import blask/styled/pill.{simple}
import blask/styled/select.{type SelectState, select}
import blask/styled/style
import blask/styled/switch.{switch}
import blask/styled/tabs.{type TabsState, tabs}
import blask/styled/tags_input.{type TagsInputState}
import gleam/result
import lustre
import lustre/attribute
import sketch as s
import sketch/lustre as sketch_lustre
import sketch/lustre/element
import sketch/lustre/element/html
import sketch/size as sz

fn scl(styles) {
  styles |> s.class
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
    tabs_state: TabsState,
    show_lucy: Bool,
    username: String,
    password: String,
    tags_input_state: TagsInputState,
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
    tabs_state: tabs.init_state(),
    show_lucy: False,
    username: "",
    password: "",
    tags_input_state: tags_input.init_state([]),
  )
}

type Msg {
  LanguageSelectStateChange(SelectState(LanguageOption))
  AccordionStateChange(AccordionState)
  TabsStateChange(TabsState)
  ShowLucyChange(Bool)
  UsernameChange(String)
  PasswordChange(String)
  TagsInputStateChange(TagsInputState)
  NoOp
}

fn update(model: Model, msg: Msg) -> Model {
  case msg {
    LanguageSelectStateChange(new_state) ->
      Model(..model, language_select_state: new_state)
    AccordionStateChange(new_state) ->
      Model(..model, accordion_state: new_state)
    TabsStateChange(new_state) -> Model(..model, tabs_state: new_state)
    ShowLucyChange(new_state) -> Model(..model, show_lucy: new_state)
    UsernameChange(username) -> Model(..model, username: username)
    PasswordChange(password) -> Model(..model, password: password)
    TagsInputStateChange(new_state) ->
      Model(..model, tags_input_state: new_state)
    NoOp -> model
  }
}

fn view(model: Model) -> element.Element(Msg) {
  html.div(
    scl([
      s.display("flex"),
      s.flex_direction("column"),
      s.align_items("center"),
      s.gap_("1rem"),
      s.background(bg.bg_svg),
      s.height_("100%"),
      s.max_width_("100vw"),
      s.padding_("0 1em"),
      s.padding_bottom(sz.em(10.0)),
    ]),
    [],
    [
      style.blask_style() |> element.styled,
      html.h1(
        scl([
          s.font_size_("2rem"),
          s.width_("100%"),
          s.text_align("center"),
          s.margin_("1.5rem 0"),
        ]),
        [],
        [html.text("🌟 Blask Showcase Site 🌟")],
      ),
      html.div(scl([s.display("flex"), s.flex_direction("row")]), [], [
        html.div(
          scl([
            s.height_("fit-content"),
            s.margin_("auto 1rem auto 0"),
            s.font_size_("1.2rem"),
          ]),
          [],
          [html.text("Your favourite language: ")],
        ),
        select(
          state: model.language_select_state,
          on_state_change: LanguageSelectStateChange,
          display: language_to_str,
        ),
      ]),
      html.div(scl([s.width_("500px"), s.max_width_("100%")]), [], [
        accordion(
          state: model.accordion_state,
          on_state_change: AccordionStateChange,
          items: [
            #(
              "Gleam",
              html.p(s.class([]), [], [
                html.text(
                  "Gleam is a general-purpose, concurrent, functional high-level programming language that compiles to Erlang or JavaScript source code.",
                ),
              ]),
            ),
            #(
              "Haskell",
              html.p(s.class([]), [], [
                html.text(
                  "Haskell is a general-purpose, statically-typed, purely functional programming language with type inference and lazy evaluation.",
                ),
              ]),
            ),
            #(
              "Rust",
              html.p(s.class([]), [], [
                html.text(
                  "Rust is a multi-paradigm, general-purpose programming language that emphasizes performance, type safety, and concurrency.",
                ),
              ]),
            ),
            #(
              "Erlang",
              html.p(s.class([]), [], [
                html.text(
                  "Erlang is a general-purpose, concurrent, functional high-level programming language, and a garbage-collected runtime system",
                ),
              ]),
            ),
          ],
        ),
      ]),
      html.div(scl([s.width_("600px"), s.max_width_("100%")]), [], [
        tabs(state: model.tabs_state, on_state_change: TabsStateChange, tabs: [
          #(
            "FP",
            html.p(scl([]), [], [
              html.text(
                "Functional Programming is a programming paradigm where programs are constructed by applying and composing functions. It is a declarative programming paradigm in which function definitions are trees of expressions that map values to other values, rather than a sequence of imperative statements which update the running state of the program.",
              ),
            ]),
          ),
          #(
            "AP",
            html.p(scl([]), [], [
              html.text(
                "Array Programming refers to solutions that allow the application of operations to an entire set of values at once. Such solutions are commonly used in scientific and engineering settings. ",
              ),
            ]),
          ),
          #(
            "OOP",
            html.p(scl([]), [], [
              html.text(
                "Object-oriented programming is a programming paradigm based on the concept of objects, which can contain data and code: data in the form of fields (often known as attributes or properties), and code in the form of procedures (often known as methods). In OOP, computer programs are designed by making them out of objects that interact with one another.",
              ),
            ]),
          ),
        ]),
      ]),
      html.div(
        scl([
          s.width_("fit-content"),
          s.max_width_("100%"),
          s.display("flex"),
          s.flex_direction("row"),
        ]),
        [],
        [
          switch(
            state: model.show_lucy,
            on_state_change: ShowLucyChange,
            id: "show-lucy",
          ),
          html.label(
            scl([s.height_("fit-content"), s.margin_("auto 0.3em")]),
            [attribute.for("show-lucy")],
            [html.text("Show Lucy")],
          ),
          html.img(
            case model.show_lucy {
              True -> scl([])
              False -> scl([s.opacity(0.0)])
            },
            [attribute.src("priv/static/lucy.svg"), attribute.height(30)],
          ),
        ],
      ),
      html.div(scl([s.width_("fit-content"), s.max_width_("100%")]), [], [
        button.primary(NoOp, "Primary"),
        button.secondary(NoOp, "Secondary"),
        button.outlined(NoOp, "Outlined"),
      ]),
      html.div(
        scl([
          s.width_("fit-content"),
          s.max_width_("100%"),
          s.display("flex"),
          s.flex_direction("column"),
          s.gap_("0.5rem"),
        ]),
        [],
        [
          input.text()
            |> input.with_value(model.username)
            |> input.on_input(UsernameChange)
            |> input.with_placeholder("Username")
            |> input.build(),
          input.password()
            |> input.with_value(model.password)
            |> input.on_input(PasswordChange)
            |> input.with_placeholder("Password")
            |> input.build(),
          input.file()
            |> input.build_file(),
        ],
      ),
      pill.simple("Simple pill"),
      pill.new()
        |> pill.with_content(
          html.div(s.class([s.font_weight("bold")]), [], [
            html.text("Closable bold pill"),
          ]),
        )
        |> pill.with_close_button(NoOp)
        |> pill.build,
      tags_input.new(model.tags_input_state, TagsInputStateChange)
        |> tags_input.with_placeholder("Tags input")
        |> tags_input.with_suggestions(["Atag", "Btag"])
        |> tags_input.build,
    ],
  )
}

pub fn main() {
  let assert Ok(cache) = s.cache(strategy: s.Ephemeral)

  sketch_lustre.node()
  // Add the sketch CSS generation "view middleware".
  |> sketch_lustre.compose(view, cache)
  // Give the new view function to lustre runtime!
  |> lustre.simple(init, update, _)
  // And voilà!
  |> lustre.start("#app", Nil)
  |> result.is_ok
}
