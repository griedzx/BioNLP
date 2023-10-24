library(ggplot2)
library(stringr)
library(enrichplot)
library(clusterProfiler)
library(GOplot)
library(DOSE)
library(ggnewscale)
library(topGO)
library(circlize)
library(ComplexHeatmap)
library(org.Hs.eg.db)
library(forcats) 


entity <- read.csv("entity.tsv", header = FALSE, sep = "\t")
#筛选出第五列是Gene对应的第六列
gene_id <- entity[entity[,5] == "Gene",6]
#若元素中包含；则分割
gene_id <- str_split(gene_id, ";")
gene_id <- unlist(gene_id)
gene_num <- as.numeric(gene_id)

GO_database <- 'org.Hs.eg.db' 
KEGG_database <- 'hsa' 

GO <- enrichGO(gene_num,
              OrgDb = GO_database,
              keyType = "ENTREZID",#设定读取的gene ID类型
              ont = "ALL",
              pvalueCutoff = 0.05,
              qvalueCutoff = 0.05,
              readable = TRUE)

KEGG<-enrichKEGG(gene_num,#KEGG富集分析
                 organism = KEGG_database,
                 pvalueCutoff = 0.05,
                 qvalueCutoff = 0.05)

pdf("all_gene_GO_dotplot.pdf", width = 10, height = 10)
dotp <- ggplot(GO,  
    aes(GeneRatio, fct_reorder(Description, GeneRatio))) + 
    geom_segment(aes(xend=0, yend = Description)) +
    geom_point(aes(color=p.adjust, size = Count)) +
    scale_color_viridis_c(guide=guide_colorbar(reverse=TRUE)) +
    scale_size_continuous(range=c(2, 10)) +
    theme_minimal() + 
    ylab(NULL)
print(dotp)
dev.off()

pdf("all_gene_circular.pdf", width = 10, height = 10)
cir <- enrichplot::cnetplot(GO,circular=T,colorEdge = TRUE)
print(cir)
dev.off()

GO2 <- pairwise_termsim(GO)
pdf("all_gene_emapplot.pdf", width = 10, height = 10)
en <- enrichplot::emapplot(GO2,showCategory = 20, color = "p.adjust", layout = "kk")#通路间关联网络图
print(en)
dev.off()

KEGG2 <- pairwise_termsim(KEGG)
pdf("all_gene_emapplot_KEGG.pdf", width = 10, height = 10)
en2 <- enrichplot::emapplot(KEGG2,showCategory = 20, color = "p.adjust", layout = "kk")#通路间关联网络图
print(en2)
dev.off()


#entity 根据第五列为DNAMutation筛出对应的第一列，记得去重，再在第一列中符合对应的行中筛出第五列为Gene的
mutation_pmid_id <- unique(entity[entity[,5] == "DNAMutation",1])
mutation_gene_id <- entity[entity[,1] %in% mutation_pmid_id & entity[,5] == "Gene",6]
mutation_gene_id <- str_split(mutation_gene_id, ";")
mutation_gene_id <- unlist(mutation_gene_id)
mutation_gene_num <- as.numeric(mutation_gene_id)

GO <- enrichGO(mutation_gene_num,
              OrgDb = GO_database,
              keyType = "ENTREZID",#设定读取的gene ID类型
              ont = "ALL",
              pvalueCutoff = 0.05,
              qvalueCutoff = 0.05,
              readable = TRUE)
pdf("mutation_gene_GO_barplot.pdf", width = 10, height = 10)
bar <- barplot(GO, split = "ONTOLOGY") +
        facet_grid(ONTOLOGY~., scale="free") +
        scale_y_discrete(labels=function(x) str_wrap(x, width = 100))
print(bar)
dev.off()

KEGG <- enrichKEGG(mutation_gene_num,#KEGG富集分析
                 organism = KEGG_database,
                 pvalueCutoff = 0.05,
                 qvalueCutoff = 0.05)

pdf("mutation_gene_dotplot.pdf", width = 10, height = 10)
dotp <- ggplot(GO,
    aes(GeneRatio, fct_reorder(Description, GeneRatio))) + 
    geom_segment(aes(xend=0, yend = Description)) +
    geom_point(aes(color=p.adjust, size = Count)) +
    scale_color_viridis_c(guide=guide_colorbar(reverse=TRUE)) +
    scale_size_continuous(range=c(2, 10)) +
    theme_minimal() + 
    ylab(NULL)
print(dotp)
dev.off()

