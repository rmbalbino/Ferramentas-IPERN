fui_RetencaoRealizada <- function(){
  
  nav_panel(title = "Retenção Realizada", # Título da aba
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-1, 2, 4, 4, -1),
                           
                           dateInput(inputId = "MesAnoRR", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoRR", label = strong("Selecione a Retenção Realizada"), buttonLabel = "Procurar...", placeholder = ""),
                           
                           fileInput(inputId = "BotaoRRCNPJ", label = strong("Selecione a planilha de CNPJs"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarRR", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoRR", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadRR",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
  )
  
}