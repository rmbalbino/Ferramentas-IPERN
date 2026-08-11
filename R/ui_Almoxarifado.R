fui_Almoxarifado <- function(){
  
  nav_panel(title = "Almoxarifado", # Título da aba
            
            
            br(),
            
            
            # Inputs:
            layout_columns(col_widths = c(-1, 2, 4, 4, -1),
                           
                           dateInput(inputId = "MesAnoAlmoxarifado", label = strong("Competência"), format = "mm/yyyy", language = "pt-br"),
                           
                           fileInput(inputId = "BotaoAlmoxarifado", label = strong("Selecione o Almoxarifado"), buttonLabel = "Procurar...", placeholder = ""),
                           
                           fileInput(inputId = "BotaoDescrição", label = strong("Selecione a planilha de Descrição"), buttonLabel = "Procurar...", placeholder = "")),
            
            
            br(),
            
            
            # Execução:
            layout_columns(col_widths = c(-5, 2, -3, 1),
                           
                           actionButton(inputId = "ExecutarAlmoxarifado", label = "Executar",
                                        class = "bnt-success", icon = icon("circle-check")),
                           
                           actionButton(inputId = "InfoAlmoxarifado", label = "", class = "info", icon = icon("info"))),
            
            
            br(),
            
            
            # Saída:
            layout_columns(col_widths = c(-5, 2, -5),
                           downloadButton(outputId = "DownloadAlmoxarifado",
                                          label = "Baixar", class = "bnt-success", icon = icon("download"))),
            
            
  )}