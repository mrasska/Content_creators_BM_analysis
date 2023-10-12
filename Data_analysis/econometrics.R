library(readr)
library(nnet)
library(stargazer)

db_econometrics <- #path

#Setting variables as factors
db_econometrics$A6 <-as.factor(db_econometrics$A6)

db_econometrics$topic <-as.factor(db_econometrics$topic)
db_econometrics$topic <- relevel(db_econometrics$topic, ref="Autre")

db_econometrics$duration <-as.factor(db_econometrics$duration)
db_econometrics$duration <- relevel(db_econometrics$duration, ref="5 years and more")

db_econometrics$following <-as.factor(db_econometrics$following)
db_econometrics$following <- relevel(db_econometrics$following, ref="Less than 1 000 followers")

db_econometrics$E1 <-as.factor(db_econometrics$E1)

db_econometrics$E2 <-as.factor(db_econometrics$E2)
db_econometrics$E2 <- relevel(db_econometrics$E2, ref="Plus de 50 ans")

db_econometrics$E5 <-as.factor(db_econometrics$E5)
db_econometrics$E5 <- relevel(db_econometrics$E5, ref="Sans emploi")


db_econometrics$cluster_3 <-as.factor(db_econometrics$cluster_3)
db_econometrics$cluster_5 <-as.factor(db_econometrics$cluster_5)

#Cluster regression
econ_3 <- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2 +E5, data = db_econometrics)
summary(econ_3)
stargazer(econ_3, type='text')

econ_5 <- multinom(cluster_5 ~ A6 + topic + duration + following +E1 +E2 +E5, data = db_econometrics)
summary(econ_5)
stargazer(econ_5, type='text')

stargazer(econ_3, econ_5, type='text')
