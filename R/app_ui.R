#' A interface do usuário do aplicativo
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @noRd
app_ui <- function(request) {
  tagList(

    # Recursos externos do golem:
    golem_add_external_resources(),


    page_fluid(

      title = "",

      # Selecionando tema e versão do bootstrap:
      theme = bs_theme(fg = "#101010",
                       bg = "#FBF5F5",
                       primary = "firebrick",
                       secondary = "firebrick",

                       "progress-bar-bg" = "#009E73",
                       "input-border-color" = "firebrick",

                       base_font = font_google("Roboto Slab"),
                       bootswatch = "united"),

      # Renomeia barra de tarefas:
      tags$head(tags$script(HTML("document.title = 'Organizador • IPERN';"))),

      # Redimensiona janela do navegador:
      # tags$head(tags$script(HTML(
      #   "window.onload = function() {
      #   var w = 1010, h = 675;
      #   var left = (screen.width - w) / 2;
      #   var top = (screen.height - h) / 2;
      #   window.resizeTo(w, h);
      #   window.moveTo(left, top);
      #   };"))),


  #     tags$head(
  #       tags$script(HTML("
  #   (function() {
  #     var w = 1400, h = 900;
  #     var left = (screen.width - w) / 2;
  #     var top = (screen.height - h) / 2;
  #     window.resizeTo(w, h);
  #     window.moveTo(left, top);
  #   })();
  #
  #   window.onload = function() {
  #     setTimeout(function() {
  #       window.focus();
  #     }, 5000);
  #   };
  # "))
  #     ),


      # Adiciona logo:
  # tags$head(tags$link(rel = "icon", type = "image/x-icon", href = "www/Logo-IPERN32.ico")),

  tags$head(
    tags$link(rel = "icon", type = "image/x-icon", href = "www/Logo-IPERN.ico"),
    tags$link(rel = "shortcut icon", href = "www/Logo-IPERN.ico")
  ),


      tags$head(tags$style(HTML(".tooltip {font-size:12px;}"))),

      # Altera mensagem de upload:
      tags$script(HTML("Shiny.addCustomMessageHandler('upload_msg', function(msg) {var target = $('#' + msg.inputId + '_progress').children()[0]; target.innerHTML = msg.text;});")),

      br(),

      # Título do aplicativo:
      layout_columns(col_widths = c(2, -1, 6, -3),

                     img(src = "www/Logo IPERN.png", width = 80, height = 80),

                     h2(strong("Organizador de Arquivos"), align = "center", style = "position:relative; margin-top:calc(2%)")),


      br(),


      page_navbar(

        navbar_options = navbar_options(bg = "firebrick"),


        title = "",                             # Título da barra


        # Página inicial:
        fui_Inicial(),


        # Opções de organização:
        nav_menu(

          title = "Organize aqui",


          # Almoxarifado:
          fui_Almoxarifado(),


          # Controle Pagamentos:
          fui_ControlePagamentos(),


          # Extrato Bancário:
          fui_ExtratoBancario(),


          # Ficha Razão:
          fui_FichaRazao(),


          # Folhas de pagamento:
          fui_FolhasPagamento(),


          # Guia Recebimento:
          fui_GuiaRecebimento(),


          # Controle de Investimento:
          fui_ControleInvestimentos(),


          # Ordens Bancárias:
          fui_OrdensBancarias(),


          # Retenção Realizada:
          fui_RetencaoRealizada(),

        ), # nav_menu


        # Sobre:
        fui_Sobre(),



      ) # page_navbar


    )   # page_fluid
  ) # fim do tagList
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
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(ext = "ico", rel = "icon"),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "Organizador-IPERN"
    )
    # Adicione aqui outros recursos externos.
    # por exemplo, você pode adicionar shinyalert::useShinyalert()
  )
}
