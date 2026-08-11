fui_ControlePagamentos <- function(){
  
  nav_panel(title = "Controle Pagamentos", # Título da aba
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-2, 2, -2, 4, -2),
                           
                           dateInput(inputId = "MesAnoCP", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoCP", label = strong("Selecione os arquivos da pasta"),
                                     buttonLabel = "Procurar...", placeholder = "", multiple = TRUE)),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarCP", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoCP", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadCP",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}