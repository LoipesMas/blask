import lustre/element/html

pub fn blask_style() {
  html.style(
    [],
    "

@keyframes fade-in {
  0% {
    opacity: 0;
    display: none;
  }

  100% {
    opacity: 1;
    display: block;
  }
}

@keyframes fade-out {
  0% {
    opacity: 1;
    display: block;
  }

  100% {
    opacity: 0;
    display: none;
  }
}


@keyframes fade-in-o {
  0% {
    opacity: 0;
  }

  100% {
    opacity: 1;
  }
}

@keyframes fade-out-o {
  0% {
    opacity: 1;
  }

  100% {
    opacity: 0;
  }
}
    ",
  )
}
