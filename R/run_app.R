#' Run the Shiny Application
#'
#' @param ... arguments to pass to golem_opts.
#' @param dirNavegador Caminho opcional para o executável do navegador
#' See `?golem::get_golem_options` for more details.
#' @inheritParams shiny::shinyApp
#'
#' @export
#' @import shiny
#' @import shinybusy
#' @import bslib
#' @import bsicons
#' @import chromote
#' @import shinyjs
#' @import rio
#' @import readr
#' @import dplyr
#' @import purrr
#' @import tidyr
#' @import tibble
#' @import stringr
#' @import magrittr
#' @import forcats
#' @import lubridate
#' @import pdftools
#' @import tesseract
#' @import archive
#' @import golem
run_app <- function(
    dirNavegador = NULL, # Valor padrão é NULL
    onStart = NULL,
    options = list(),
    enableBookmarking = NULL,
    uiPattern = "/",
    ...
) {


  # Retirando limite de upload:
  base::options(shiny.maxRequestSize = 100 * 1024^2)


  # Localiza e define o tessdata portátil
  Sys.setenv(TESSDATA_PREFIX = system.file("app/www", package = "ferramentasipern"))


  # Configurações de Rede:
  # options$port <- httpuv::randomPort()
  options$port <- 3838
  options$host <- "127.0.0.1"
  # options$launch.browser <- TRUE


  # Execução via Golem:
  with_golem_options(
    app = shiny::shinyApp(
      ui = app_ui,
      server = app_server,
      onStart = onStart,
      options = options,
      enableBookmarking = enableBookmarking,
      uiPattern = uiPattern
    ),
    golem_opts = list(...)
  )
}
