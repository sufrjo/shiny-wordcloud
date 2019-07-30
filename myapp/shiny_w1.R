#sce$Cluster_r
#scater::plotExpression(sce, features = "COL5A3", x= "Cluster_r", colour_by = "Condition")
library(shiny)
library(colourpicker)
library(scatterplot3d)
library(scater)
options("repos"=BiocManager::repositories())
############################
############Read RDS
###############################
# sce_Neurons <- readRDS("/home/osama/Documents/20190502/HD_for_final/20190611_reanalysis_no_gfap/Neurons/Neurons_HD-vs_Con__DGE/Neurons_k_9sce_neurons_sc3_k10_rds/Neuronssce_neurons_sc3_k10_sc3_cluster_called.rds")
# sce_Neurons$Cluster_sc3_k10->sce_Neurons$Cluster_r
# sce_Astro <- readRDS("/home/osama/Documents/20190502/HD_for_final/Final_RDS/20190512_sce_astro_HD_k6_sc3_k6_cluster_r_called.rds")
# sce_Oligo <- readRDS("/home/osama/Documents/20190502/HD_for_final/Oligodendrocytes_analysis/rds/201905047_sce_HD_Oligodendrocytes_clust_k6_sc3_k5.rds")
sce_Astro<-readRDS("sce_Astro.rds")
sce_Astro -> sce
###########################
# tSNE_outn<-sce@reducedDims@listData[["TSNE"]]
# colors2 <- unname(randomcoloR::distinctColorPalette(length(levels(sce$Cluster_r))))
# colors2-> cols2
# colors2 <- colors2[as.numeric((sce$Cluster_r))]
# binarize<-function(x,threshold){
#   ifelse(x>threshold, 1, 0)
# }
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
server <- function(input, output) {
  #ifelse(input$type=="Astrocytes", sce=sce_Astro, ifelse(input$type=="Neurons", sce=sce_Neurons, sce=sce_Oligo))
  output$violin<- renderPlot(scater::plotExpression(sce, features = input$gene, x= "Cluster_r",
                                                    colour_by = "Condition", theme_size=15)
  )
  output$tsne<- renderPlot(
    scater::plotTSNE(sce, colour_by="Cluster_r", shape_by="Condition", point_size=input$size, theme_size=15))
  #####################
  output$gene<- renderPlot(
    # logcounts(sce)[input$gene,]->a,
    # binarize(a,input$threshold)->sce$test,
    # set the levels of dat$color in the right order
    # sce$test <- as.factor(as.character(sce$test)),#
    #levels(sce$test)<- c("on","off"),
    scater::plotTSNE(sce, colour_by=input$gene, 
                     shape_by="Condition", point_size=input$size, theme_size=15)+
      scale_color_gradient2(midpoint=input$threshold, low=input$col2, mid="white",
                            high=input$col1, space ="Lab" )+
      ggtitle(input$gene)
  )
  
}
shinyApp(ui, server)
