labels <- read.table('labels_detailed.csv', quote = "\"")

# scale <- function(x) { x }

args <- commandArgs(trailingOnly = TRUE)
y <- as.matrix(read.table(args[1], sep=","))
colnames(y) <- t(labels)

# Drop continuous variables
drops <- c("AGE", "LOS", "TOTCHG")
y <- y[, !(colnames(y) %in% drops)]

d <- dist(scale(t(y)), method="euclidean")
cl <- hclust(d, method="ward.D2")
svg(args[2], height=100, width=10)
require(graphics)
par(mai=c(0.5,0.5,0.5,4))
plot(as.dendrogram(cl),horiz=T)
dev.off()