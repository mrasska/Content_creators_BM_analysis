library(readr)
library(FactoMineR)
library(klaR)
library(questionr)
require(factoextra)

### Loading data
#db_clustering <- file generated from script 2_1
db_clustetring <- read_delim("file_path", delim = ";", escape_double = FALSE, trim_ws = TRUE)


####### MCA
db_clustetring <- db_clustetring[,-1]
res.mca=MCA(db_clustetring)
get_eigenvalue(res.mca)
fviz_screeplot(res.mca, addlabels = TRUE, ylim = c(0, 45))

# Variables contribution to the axes
res.mca$var
fviz_contrib(res.mca, choice = "var", axes = 1)
fviz_contrib(res.mca, choice = "var", axes = 2)
fviz_contrib(res.mca, choice = "var", axes = 3)
fviz_contrib(res.mca, choice = "var", axes = 4)

# New MCA with first 4 dimensions----
res.mca=MCA(db_clustetring, ncp=4)
summary(res.mca)

### Hierarchical clustering with 5 clusters ----
# nb.clust = specifying number of clusters
res.hcpc <- HCPC (res.mca, nb.clust = 5, graph = TRUE, proba=1)

# Description of each cluster by variable category
res.hcpc$desc.var$category

# Effectif distribution per cluster
freq(res.hcpc$data.clust$clust)

# Cluster column
clust_5=res.hcpc$data.clust$clust


### Hierarchical clustering with 3 clusters ----
# nb.clust = specifying number of clusters
res.hcpc <- HCPC (res.mca, nb.clust = 3, graph = TRUE, proba=1)

# Description of each cluster by variable category (modalité)
res.hcpc$desc.var$category

# Effectif distribution per cluster
freq(res.hcpc$data.clust$clust)

# Cluster column
clust_3=res.hcpc$data.clust$clust


####### Adding clusters variable in econometric file
db_econometrics['cluster_3']<-clust_3
db_econometrics['cluster_5']<-clust_5
write.csv2(db_econometrics,file='file_path',fileEncoding = "UTF-8")

db_raw <- read_delim("file_path", delim = ";", escape_double = FALSE, trim_ws = TRUE)

db_raw['cluster_3']<-clust_3
write.csv2(db_raw,file='D:/Dropbox/Doctorat/Chapitre 1/database_cleaned_cluster.csv',fileEncoding = "UTF-8")

