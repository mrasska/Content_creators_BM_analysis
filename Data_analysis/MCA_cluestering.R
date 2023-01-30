library(readr)
library(FactoMineR)
library(klaR)
library(questionr)
require(factoextra)

#Loading data in R
db_mca<- read_delim("Thèse/Thèse CP/db_mca_other.csv",
                    delim = ";", escape_double = FALSE, col_types = cols(...1 = col_skip()),
                    trim_ws = TRUE)

######################### MCA
#Tutorial=https://youtu.be/Sl1-UYD6iac
#Supplementary categorial variables = creator program membership + activity period + follower base (columns 13 to 15)
res.mca=MCA(db_mca, quali.sup = c(13:15))
summary(res.mca)

#Get the eig values- to know how many axes we keep for your analysis
res.mca$eig


######################## MCA for HCPC
#ncp --> Number of dimensions taken into account for MCA & HCPC
res.mca=MCA(db_mca, ncp= 12, quali.sup = c(13:15))
summary(res.mca)


########################  Hierarchical clustering
# nb.clust = specifying number of clusters
res.hcpc <- HCPC (res.mca, nb.clust = 3, graph = TRUE, proba=1)
summary(res.hcpc)

#Data table with clusters
db_clust<-res.hcpc$data.clust

# Results of hierarchical clustering : individual factor map
fviz_cluster(res.hcpc, geom = "point", main = "Cluster plot for surveyed content creators")

#Compare partition -- Nb clust=3
plot(res.hcpc, choice = "bar")
round(res.hcpc$call$t$inert.gain,3)
round(res.mca$eig[,1],3)

# Description of variable
res.hcpc$desc.var$test.chi2

# Description of each cluster by variable category (modalité)
res.hcpc$desc.var$category


# Effectif distribution per cluster
freq(res.hcpc$data.clust$clust)

# Cluster column
clust=res.hcpc$data.clust$clust


##################### Adding cluster columns in different databases

#Adding cluster column in db_eco_r (duplicated source file)
db_mca<- read_delim("Thèse/Thèse CP/db_eco_r.csv",
                    delim = ";", escape_double = FALSE,
                    trim_ws = TRUE)
db_mca['clust']<-clust

write.csv2(db_mca,file='C:/Users/mrass/Documents/Thèse/Thèse CP/db_eco_r.csv',fileEncoding = "UTF-8")

#Adding cluster column in db_eco (dummies file)
db_eco<- read_delim("Thèse/Thèse CP/db_eco.csv",
                    delim = ";", escape_double = FALSE,
                    trim_ws = TRUE)
db_eco['clust']<-clust

write.csv2(db_eco,file='C:/Users/mrass/Documents/Thèse/Thèse CP/db_eco.csv',fileEncoding = "UTF-8")

#Adding cluster column in database_cleaned_copy (copy of raw file)
db_eco<- read_delim("Thèse/Thèse CP/database_cleaned_copy.csv",
                    delim = ";", escape_double = FALSE,
                    trim_ws = TRUE)
db_eco['clust']<-clust

write.csv2(db_eco,file='C:/Users/mrass/Documents/Thèse/Thèse CP/database_cleaned_copy.csv',fileEncoding = "UTF-8")