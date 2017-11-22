#!/usr/bin/env Rscript
handler <- function(input) {
  rmarkdown::render_site(input = input)
}

servr::httw(".", site.dir = "docs",
            pattern = "(.*\\.Rmd|_site\\.yml|_common\\.R|include/.*)",
            handler = handler("."))
