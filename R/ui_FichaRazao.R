fui_FichaRazao <- function(){
  
  nav_panel(title = "Ficha Razão", # Título da aba
            
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-2, 2, -2, 4, -2),
                           
                           dateInput(inputId = "MesAnoRazao", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoRazao", label = strong("Selecione o Ficha Razão"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarRazao", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoRazao", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadRazao",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}