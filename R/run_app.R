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
#' @import rio
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
#' @importFrom golem with_golem_options
run_app <- function(
    dirNavegador = NULL, # Valor padrão é NULL
    onStart = NULL,
    options = list(),
    enableBookmarking = NULL,
    uiPattern = "/",
    ...
) {

  # Seleção do Navegador:
  # dirNavegador <- r"(H:\Material de Estudos\R\Shiny\Complementos\OrganizadorIpern\GoogleChromePortable\App\Chrome-bin\chrome.exe)"
  # # dirNavegador <- NULL
  #
  # if (!is.null(dirNavegador) && file.exists(dirNavegador)) {
  #
  #   message("Modo de Teste: Usando navegador específico em modo App.")
  #
  #   options(browser = function(url) {
  #
  #     # Pega resolução da tela
  #     res_h <- shell("wmic path Win32_VideoController get CurrentHorizontalResolution /value", intern = TRUE)
  #     res_v <- shell("wmic path Win32_VideoController get CurrentVerticalResolution /value", intern = TRUE)
  #
  #     screen_w <- as.numeric(gsub("\\D", "", res_h[grep("CurrentHorizontal", res_h)]))
  #     screen_h <- as.numeric(gsub("\\D", "", res_v[grep("CurrentVertical", res_v)]))
  #
  #     w <- 1010
  #     h <- 675
  #     left <- round((screen_w - w) / 2)
  #     top  <- round((screen_h - h) / 2)
  #
  #     cmd <- paste0(
  #       shQuote(dirNavegador),
  #       #" --start-minimized",
  #       " --window-size=", w, ",", h,
  #       " --window-position=", left, ",", top,
  #       " --app=", url
  #     )
  #
  #     shell(cmd, wait = FALSE)
  #
  #   })
  #
  # } else if (!is.null(dirNavegador) && !file.exists(dirNavegador)) {
  #
  #   warning("Caminho do navegador informado não encontrado. Seguindo com padrão do sistema.")
  #
  # } else {
  #
  #   message("O R usará a configuração de browser do sistema ou vbs.")
  #
  # }


  # # Diretório do navegador para testes:
  # dirNavegador <- r"(H:\Material de Estudos\R\Shiny\Complementos\GoogleChromePortable\App\Chrome-bin\chrome.exe)"
  #
  #
  #   base::options(browser = function(url) {
  #
  #     # Pega resolução da tela
  #     res_h <- shell("wmic path Win32_VideoController get CurrentHorizontalResolution /value", intern = TRUE)
  #     res_v <- shell("wmic path Win32_VideoController get CurrentVerticalResolution /value", intern = TRUE)
  #
  #     screen_w <- as.numeric(gsub("\\D", "", res_h[grep("CurrentHorizontal", res_h)]))
  #     screen_h <- as.numeric(gsub("\\D", "", res_v[grep("CurrentVertical", res_v)]))
  #
  #     w <- 1010
  #     h <- 675
  #     left <- round((screen_w - w) / 2)
  #     top  <- round((screen_h - h) / 2)
  #
  #     cmd <- paste0(
  #       shQuote(dirNavegador),
  #       #" --start-minimized",
  #       " --window-size=", w, ",", h,
  #       " --window-position=", left, ",", top,
  #       " --app=", url
  #     )
  #
  #     shell(cmd, wait = FALSE)
  #
  #   })


  # Retirando limite de upload:
  base::options(shiny.maxRequestSize = 100 * 1024^2)


  # Localiza e define o tessdata portátil
  Sys.setenv(TESSDATA_PREFIX = system.file("app/www", package = "organizadoripern"))


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
