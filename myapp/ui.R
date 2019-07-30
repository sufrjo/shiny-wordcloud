library(shiny)
library(colourpicker)
sce_Astro<-readRDS("sce_Astro.rds")
sce_Astro -> sce
ui <- fluidPage(
  # App title ----
  titlePanel("Single Nuclei Explorer"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    # Sidebar panel for inputs ----
    sidebarPanel(
      # Input: Slider for the number of bins ----
      #radioButtons(inputId = "type", label = "Cell type", choices = c("Astrocytes" , "Oligodendrocytes", "Neurons")),
      selectInput(inputId = "gene", label = "Gene", choices = rownames(sce)),
      sliderInput(inputId = "threshold", label = "Normalized Gene Expression threshold",
                  min = 1,  max = 8, value = 2),
      colourInput(inputId = "col1", label="High_expression_color", value = "red"),
      colourInput(inputId = "col2", label="low_expression_color", value = "blue"),
      sliderInput(inputId = "shape", label = "Point shape",
                  min = 10,  max = 28, value = 14),
      sliderInput(inputId = "size", label = "tSNE point size",
                  min = 1,  max = 30, value = 5)
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      # tabsetPanel(
      #   tabPanel("Astrocytes"),
      #   tabPanel("Oligodendrocytes"),
      #   tabPanel("Neurons")),
      
      # Output: Histogram ----
      plotOutput(outputId = "tsne", width=600, height=500),
      plotOutput(outputId = "gene", width=600, height=500),
      plotOutput(outputId = "violin", width=600, height=500)
    )
  )
)
