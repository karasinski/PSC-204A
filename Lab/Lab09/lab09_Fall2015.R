#Joseph E. Gonzales
#PSC 204a lab09
#Fall 2015

######################################

#Load R Packages

library(MASS);library(MBESS);library(car)

######################################

#Data Generation

set.seed(1204)

d4m <- as.data.frame(mvrnorm(100, c(4,3.1), 
	matrix(c(1, .05, .05, 1),nrow=2,ncol=2,byrow=TRUE), 
	empirical = TRUE))
colnames(d4m) <- c("lonely","depress")

d4f <- as.data.frame(mvrnorm(100, c(3.5,2.2), 
	matrix(c(1, .23, .23, 1),nrow=2,ncol=2,byrow=TRUE), 
	empirical = TRUE))
colnames(d4f) <- c("lonely","depress")

d <- rbind(d4m,d4f)

d$lonely <- d$lonely-min(d$lonely)
d$lonely <- round(d$lonely,2)
d$depress <- d$depress-min(d$depress)
d$depress <- round(d$depress,2)

d$female <- rep(c(0,1),each=100)

d$substance <- unlist(lapply(1:200, function(x){
	use <- .35 + .4*d[x,"depress"] + .2*d[x,"depress"]*d[x,"lonely"]
	use2 <- round((100*(exp(use)/(1+exp(use)))),0)
	sample(c(rep(0,(100-use2)),rep(1,use2)),1)
	}))


head(d)
summary(d)

##############################################

#The Many Faces of Multiple Regression

#Factorial ANOVA
m1 <- anova(lm(lonely ~ female + substance, data = d))
m1
m1r <- sum(m1[1:2,2])/sum(m1[1:3,2]);m1r

#ANCOVA
m2 <- anova(lm(depress ~ substance + lonely, data = d))
m2
m2r <- sum(m2[1:2,2])/sum(m2[1:3,2]);m2r

#How do these differ from a multivaraiate regression?
summary(lm(lonely ~ female + substance, data = d))
m1r

summary(lm(depress ~ substance + lonely, data = d))
m2r

summary(lm(depress ~ female + lonely + substance, data = d))
	#They don't, this is all the same type of model


########################

#Regression model basics

#Same form as ANOVA models

# y = B0 + B1*x1 + B2*x2 + ... Bk*xk + e

#dichotomous variables
m3 <- summary(lm(depress ~ female, data = d))
m3

	#this is the same as a t-test

m3t <- t.test(d[which(d$female == 0),"depress"],
	 d[which(d$female == 1),"depress"],var.equal=TRUE)
m3t

m30 <- mean(d[which(d$female == 0),"depress"])
m31 <- mean(d[which(d$female == 1),"depress"])
m30;m31
m30-m31

coef(m3)


	#The relation between F and t values

anova(lm(depress ~ female, data = d))
sqrt(anova(lm(depress ~ female, data = d))[1,4])
m3t$statistic
m3t$statistic^2

#All this is to say that
# t(df)^2 = F(1, df) & sqrt(F(1, df)) = t(df)


#Interpreting simple regression
#dichotomous
m3

#continuous
m4 <- summary(lm(depress ~ lonely, data = d))
m4

#two or predictors
m5 <- summary(lm(depress ~ lonely + female, data = d))
m5

#An interaction
m6 <- summary(lm(depress ~ lonely*female, data = d))
m6

m6z <- summary(lm(depress ~ lonely*female, 
	data = as.data.frame(scale(d)[,])))
m6z

	#Why do the results differ when using z-scored data?

d$inter <- d$lonely*d$female

dz <- as.data.frame(scale(d)[,])
dz$inter <- dz$lonely*dz$female

cor(d)
cor(dz)

	#Correlation between interaction terms and main terms
	#is not as strong when main terms are z-scored


#Comparing correlations
#Does the association of depression and loneliness
#differ between men and women?

m6

	#What do we think?

#Let's reconsider what this model really says

#depress = Intercept + B1*lonely + B2*female + B3*lonely*female

#Intercept = Fixed value
#Female = 0,1 => B2 and B3 are either in or out of equation

#Therefore:

#Male equation
#depress = Intercept + B1*lonely

#Female equation
#depress = (Intercept + B1) + (B2 + B3)*lonely 


#Compare this with Fisher's Z-test

mcor <- cor(d[which(d$female == 0),"lonely"],
    d[which(d$female == 0),"depress"])

fcor <- cor(d[which(d$female == 1),"lonely"],
    d[which(d$female == 1),"depress"])

mcorz <- .5*log((1+mcor)/(1-mcor))
mcorz

fcorz <- .5*log((1+fcor)/(1-fcor))
fcorz

zres <- (fcorz-mcorz)/sqrt((1/97)+(1/97))


	#t vs. z value comparison
zres


	#p-value comparison
2*pnorm(zres, lower.tail = FALSE)

m6


#What if the difference were larger?

d4m <- as.data.frame(mvrnorm(100, c(4,3.1), 
	matrix(c(1, .05, .05, 1),nrow=2,ncol=2,byrow=TRUE), 
	empirical = TRUE))
colnames(d4m) <- c("lonely","depress")

d4f <- as.data.frame(mvrnorm(100, c(3.5,2.2), 
	matrix(c(1, .35, .35, 1),nrow=2,ncol=2,byrow=TRUE), 
	empirical = TRUE))
colnames(d4f) <- c("lonely","depress")

d2 <- rbind(d4m,d4f)
d2$female <- rep(c(0,1),each=100)

m7 <- summary(lm(depress ~ lonely*female, data = d2))

mcor2 <- cor(d2[which(d2$female == 0),"lonely"],
    d2[which(d2$female == 0),"depress"])

fcor2 <- cor(d2[which(d2$female == 1),"lonely"],
    d2[which(d2$female == 1),"depress"])

mcorz2 <- .5*log((1+mcor2)/(1-mcor2))
mcorz2

fcorz2 <- .5*log((1+fcor2)/(1-fcor2))
fcorz2

zres2 <- (fcorz2-mcorz2)/sqrt((1/97)+(1/97))


	#t vs. z value comparison
zres2


	#p-value comparison
2*pnorm(zres2, lower.tail = FALSE)
m7

#######################################################
#######################################################
#######################################################

#data

exp(0)/(1+exp(0))
exp(1)/(1+exp(1))
exp(-1)/(1+exp(-1))

set.seed(12042)
x <- rnorm(300,0,2)

y <- unlist(lapply(1:300, function(r){
	temp <- .5 + .7*x[r] + rnorm(1,0,.1)
	temp2 <- round((100*(exp(temp)/(1+exp(temp)))),0)
	sample(c(rep(0,(100-temp2)),rep(1,temp2)),1)
	}))


#Logistic Regression

m8 <- summary(glm(y ~ x, family=binomial(link=logit)))
m8

m81 <- glm(y ~ x, family=binomial(link=logit))

#Quick Plots
par(mfrow=c(1,2))
plot(x,predict(m81),
	main="Plot of Predicted loglikelihood")
abline(h=0)

plot(x,y,
	main="Plot of observed Values and Sigmoid Probability")
points(x,
	(exp(predict(m81))/(1+exp(predict(m81)))),
	col="green")
abline(h=.5)




###################################################################
###################################################################

#P-hacking


data <- matrix(NA,nrow=1000,ncol = 10)
lapply(1:1000, function(x){

	temp <- rnorm(5,0,1)
	data[x,1] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,2] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,3] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,4] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,5] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,6] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,7] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,8] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,9] <<- t.test(temp)$p.value
	temp <- c(temp,rnorm(5,0,1))
	data[x,10] <<- t.test(temp)$p.value
	})

data

hit <- unlist(lapply(1:1000, function(x){
	sum(data[x,] < .05)
	}))
length(which(hit > 0))/1000

hit2 <- unlist(lapply(1:10, function(x){
	sum(data[,x] < .05)
	}))
hit2/1000






