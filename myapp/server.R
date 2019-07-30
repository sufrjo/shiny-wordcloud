library(shiny)
library(colourpicker)
library(scater)
library(ggplot2)
server <- function(input, output) {
  sce_Astro<-readRDS("sce_Astro.rds")
  sce_Astro -> sce
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
