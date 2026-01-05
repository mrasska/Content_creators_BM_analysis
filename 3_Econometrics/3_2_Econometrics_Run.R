library(readr)
library(dplyr)
library(nnet)
library(lmtest)
library(fastDummies)
library(psych)
library(stargazer)

db_econometrics <- read_delim("file_path", delim = ";", escape_double = FALSE, trim_ws = TRUE)

#Setting variables as factors ----
#Main variable
#Preferred platform
db_econometrics$A6 <-as.factor(db_econometrics$A6)

#Content creator's video genre
db_econometrics$topic <-as.factor(db_econometrics$topic)
db_econometrics$topic <- relevel(db_econometrics$topic, ref="Autre")

#Creator's seniority
db_econometrics$duration <-as.factor(db_econometrics$duration)
db_econometrics$duration <- relevel(db_econometrics$duration, ref="5 years and more")

#Creator's audience size
db_econometrics$following <-as.factor(db_econometrics$following)
db_econometrics$following <- relevel(db_econometrics$following, ref="Less than 1 000 followers")

#Control variables
#Creator's gender
db_econometrics$E1 <-as.factor(db_econometrics$E1)

#Age
db_econometrics$E2 <-as.factor(db_econometrics$E2)
#db_econometrics$E2 <- relevel(db_econometrics$E2, ref="Plus de 50 ans")
db_econometrics$E2 <- relevel(db_econometrics$E2, ref="De 18 à 25 ans")

#Highest diploma
db_econometrics$E3 <-as.factor(db_econometrics$E3)
db_econometrics$E3 <- relevel(db_econometrics$E3, ref="Sans diplôme")

#Current job
db_econometrics$E5 <-as.factor(db_econometrics$E5)
db_econometrics$E5 <- relevel(db_econometrics$E5, ref="Sans emploi")

# Setting 3rd model as reference (free production) ----
db_econometrics$cluster_3[db_econometrics$cluster_3 == 1] <- 'Model_1'
db_econometrics$cluster_3[db_econometrics$cluster_3 == 2] <- 'Model_2'
db_econometrics$cluster_3[db_econometrics$cluster_3 == 3] <- 'Model_3'

db_econometrics$cluster_3 <-as.factor(db_econometrics$cluster_3)

## Combining two age groups into one -> 36 y.o and more ----
db_econometrics <- mutate(db_econometrics, E2 = recode(E2, 
                                 'De 36 à 50 ans' = '36 ans et plus',
                                 'Plus de 50 ans' = '36 ans et plus'))

##### Statistical description of independent variables ----
dataf <- dummy_cols(db_econometrics)
describe(dataf)

######## Multinomial logistic regression ----
## Reference : Production without earning revenues
# E3 : highest diploma <- REGRESSION MODEL FOR THE CHAPTER
db_econometrics$cluster_3<- relevel(db_econometrics$cluster_3, ref='Model_3')
econ_3_logit<- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2 +E3, data = db_econometrics)
#Logit coefficient
stargazer(econ_3_logit, type='text')

# Odds ratio
coeff <- exp(coef(econ_3_logit))
coeff

#### Multinomial probit (just as a test)
econ_3_logit<- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2 +E3, data = db_econometrics)
stargazer(econ_3_logit, type='text')


##### Other regressions -----
# E5: CSP
econ_3_full <- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2 +E5, data = db_econometrics)
stargazer(econ_3_full, type='text')

## Reference : Production financed by community
db_econometrics$cluster_3<- relevel(db_econometrics$cluster_3, ref='Model_1')
econ_3_full <- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2 +E3, data = db_econometrics)
stargazer(econ_3_full, type='text')

#Likelihood ratio test : to test variable significance in model
econ_3_plat <- multinom(cluster_3 ~ topic + duration + following +E1 +E2 +E5, data = db_econometrics)
econ_3_topic <- multinom(cluster_3 ~ A6 + duration + following +E1 +E2 +E5, data = db_econometrics)
econ_3_duration <- multinom(cluster_3 ~ A6 + topic + following +E1 +E2 +E5, data = db_econometrics)
econ_3_follow <- multinom(cluster_3 ~ A6 + topic + duration +E1 +E2 +E5, data = db_econometrics)
econ_3_age <- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E5, data = db_econometrics)
econ_3_csp <- multinom(cluster_3 ~ A6 + topic + duration + following +E1 +E2, data = db_econometrics)

lrtest(econ_3_full, econ_3_plat)
lrtest(econ_3_full, econ_3_topic)
lrtest(econ_3_full, econ_3_duration)
lrtest(econ_3_full, econ_3_follow)
lrtest(econ_3_full, econ_3_age)
lrtest(econ_3_full, econ_3_csp)
