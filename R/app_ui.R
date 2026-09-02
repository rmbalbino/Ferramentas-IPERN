#' A interface do usuário do aplicativo
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui <- function(request) {

  tagList(

    # Recursos externos do golem:
    golem_add_external_resources(),

    # Cabeçalho / metadados:
    tags$head(

      tags$script(
        HTML(
          "document.title = 'Ferramentas • IPERN';"
        )
      ),

      tags$link(
        rel = "icon",
        type = "image/x-icon",
        href = "www/Logo-IPERN.ico"
      ),

      tags$link(
        rel = "shortcut icon",
        href = "www/Logo-IPERN.ico"
      ),

      tags$link(
        rel = "stylesheet",
        type = "text/css",
        href = "www/styles.css?v=6"
      ),

      tags$script(
        src = "www/handlers.js?v=9"
      )
    ),


    page_navbar(

      navbar_options = navbar_options(
        bg = "#7a0c32"
      ),

      title = tagList(

        tags$img(
          src = "www/Logo IPERN - Branca.png",
          height = "50px",
          style = "margin-right: 22px;"
        ),

        "Instituto de Previdência dos Servidores do Estado do Rio Grande do Norte"
      ),

      nav_spacer(),

      theme = bs_theme(
        fg = "#101010",
        bg = "#FFFFFF",
        primary = "#7a0c32",
        secondary = "#7a0c32",
        "input-border-color" = "#7a0c32",
        base_font = font_google("Roboto Slab"),
        bootswatch = "united"
      ),

      fui_Inicial(),

      fui_Sobre()
    )
  )
}

#' Adicionar recursos externos ao aplicativo
#'
#' Essa função é usada internamente para adicionar elementos externos.
#' recursos dentro do aplicativo Shiny.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  golem::add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "ico", rel = "icon"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Ferramentas-IPERN"
    )
    # Adicione aqui outros recursos externos.
    # por exemplo, você pode adicionar shinyalert::useShinyalert()
  )
}
