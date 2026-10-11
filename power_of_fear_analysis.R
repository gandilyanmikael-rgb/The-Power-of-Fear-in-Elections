#Final Research Proposal
rm(list = ls(all=T))
library(poliscidata)
library(survey)

#Loading the survey data (place the CSV in the same folder as this script)
final <- read.csv("UNMD0007_OUTPUT_strings.csv")

#Variable Transformation and Descriptive Statistics
###Dependent Variable
class(final$Question2)
freq(final$Question2, final$weight)
final$angela_dummy = as.numeric(final$Question2=="Angela Alsobrooks (Democrat)")
freq(final$angela_dummy, final$weight)
describe(final$angela_dummy, weights=final$weight)
wtd.mean(final$angela_dummy, final$weight)
wtd.mode(final$angela_dummy, final$weight)
wtd.median(final$angela_dummy, final$weight)
###Independent Variable of Interest
class(final$Question21)
final$fearofviolence = as.numeric(final$Question21)
freq(final$fearofviolence, final$weight)
describe(final$fearofviolence, weights=final$weight)
hist(final$fearofviolence, main="Figure 1: \n Histogram of Robbery Expectations", xlab="% Expectation of Robbery", col="maroon")
wtd.mean(final$fearofviolence, final$weight)
wtd.mode(final$fearofviolence, final$weight)
wtd.median(final$fearofviolence, final$weight)
###First Control Variable
class(final$urbanicity2)
freq(final$urbanicity2, final$weight)
#My attempt at classifying the "not asked" folks as one or the other
final$urbanicity2.factor = as.factor(final$urbanicity2)
freq(final$urbanicity2.factor, final$weight)
levels(final$urbanicity2.factor) = c("City","not asked","Not City","Not City","City","Not City")
#just three categories now:
freq(final$urbanicity2.factor, final$weight)
#Need to impute data for all those coded as "not asked"
not_asked_indices <- which(final$urbanicity2.factor == "not asked")
set.seed(123)
n_total <- length(not_asked_indices)
#select 30.89% to be "City"
n_ones <- round(n_total * 0.3089)
ones_indices <- sample(not_asked_indices, n_ones)
#Assign "City" to randomly selected
final$urbanicity2.factor[ones_indices] <- "City"
#assign "Not City" to remaining respondents
zeros_indices <- setdiff(not_asked_indices, ones_indices)
final$urbanicity2.factor[zeros_indices] <- "Not City"
freq(final$urbanicity2.factor, final$weight)
#Now turn into a numeric dummy
final$urban = as.numeric(final$urbanicity2.factor=="City")
freq(final$urban, final$weight)
#descriptive statistics
describe(final$urban, weights=final$weight)
wtd.mean(final$urban, final$weight)
wtd.mode(final$urban, final$weight)
wtd.median(final$urban, final$weight)
###Second Control Variable
class(final$gender)
freq(final$gender, final$weight)
final$female = as.numeric(final$gender=="Female")
freq(final$female, final$weight)
describe(final$female, weights=final$weight)
wtd.mean(final$female, final$weight)
wtd.mode(final$female, final$weight)
wtd.median(final$female, final$weight)
################################################################################

###Logistic Regression Model
#Bivariate
finalD = svydesign(id=~1, data=final, weights=~weight)
alsobrooks.logit.bi = svyglm(angela_dummy ~ fearofviolence, design=finalD,
                             family="quasibinomial", na.action="na.omit")
summary(alsobrooks.logit.bi)
orci(alsobrooks.logit.bi)
#Now with CVs
finalD = svydesign(id=~1, data=final, weights=~weight)
alsobrooks.logit = svyglm(angela_dummy ~ fearofviolence + urban + female, design=finalD,
                          family="quasibinomial", na.action="na.omit")
summary(alsobrooks.logit)
orci(alsobrooks.logit)
###NOW PLOT
fear.values = seq(0,100,by=1)
log.odds.female.urban = 0.145987 - 0.011141*fear.values + 0.517580 + 0.464560
log.odds.male.urban = 0.145987 - 0.011141*fear.values + 0.517580
log.odds.female.nonurban = 0.145987 - 0.011141*fear.values + 0.464560
log.odds.male.nonurban = 0.145987 - 0.011141*fear.values
plot(x="",y="",xlim=range(fear.values), ylim=c(0,1), xlab="Fear of Robbery",
     ylab="Probability of Voting for Alsobrooks",
     main="Figure 2: \n Probability of an Alsobrooks Vote by Fear of Robbery \n Controlling for Residency and Gender", cex.main=1)
lines(x=fear.values, y=inverse.logit(log.odds.female.urban), lty=1, col="palevioletred", lwd=2)
lines(x=fear.values, y=inverse.logit(log.odds.male.urban), lty=1, col="lightblue", lwd=2)
lines(x=fear.values, y=inverse.logit(log.odds.female.nonurban), lty=2, col="palevioletred", lwd=2)
lines(x=fear.values, y=inverse.logit(log.odds.male.nonurban), lty=2, col="lightblue", lwd=2)
legend("topright", lty=c(1,1,2,2), 
       col=c("palevioletred","lightblue","palevioletred","lightblue"),
       lwd=c(2,2,2,2),
       bty="y", cex=.75, 
       legend=c("Urban Females", "Urban Males", "Nonurban Females", "Nonurban Males"))
