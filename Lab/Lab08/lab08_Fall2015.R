#Joseph E. Gonzales
#PSC 204a lab08
#Fall 2015

######################################
#Install some R packages
######################################

#select mirror
chooseCRANmirror()
	#choose (http mirrors), then choose CA 1 or 2

#Install packages
install.packages(c("MASS","MBESS","lavaan"))


######################################

#############

#Correlation: The degree of association between two measurements

#cor(x, y)

#cov(x, y)

#cor.test(x, y,
#         alternative = c("two.sided", "less", "greater"),
#         method = c("pearson", "kendall", "spearman"),
#         conf.level = 0.95, ...)

#plot(x, y)

#---------------------------

library(MASS);library(MBESS)


#A correlation matrix
corm <- matrix(c(
 1, .5,
.5,  1 ), nrow = 2, ncol = 2, byrow = TRUE)
corm
	#symmetric with 1 in the diagonal


#A covariance matrix

#cor2cov(cor.mat, sd) : from MBESS

covm <- cor2cov(corm, c(2,3))
covm
	#symmetic with variances in the diagonal and
	#covariances in off-diagonal

#Matrix algebra for conversion to covariance from correlation
sdm <- matrix(c(
2, 0,
0, 3), nrow = 2, ncol = 2, byrow = TRUE)
sdm
	#a matrix with SD in the diagonal and zero in off-diagonal

sdm%*%corm%*%sdm
covm

#Matrix algebra for conversion to correlation from covariance
sdm2 <- matrix(c(
1/2,   0,
0  , 1/3), nrow = 2, ncol = 2, byrow = TRUE)
sdm2

sdm2%*%covm%*%sdm2
corm

##############################

#mvrnorm(n = 1, mu, Sigma, empirical = FALSE) : From MASS

set.seed(25)
dat <- mvrnorm(50, c(0,0), covm, empirical = TRUE)

head(dat);tail(dat)
cor(dat)
corm

cov(dat)
covm

plot(dat[,1],dat[,2])
abline(lm(dat[,2] ~ dat[,1]))
	#abline : a, b line. In other words, slope and intercept
	#lm means linear model, so what is the linear model?

summary(lm(dat[,2] ~ dat[,1]))
	#not very informative

	#Let's get standardized coefficients
summary(lm(scale(dat[,2])[,1] ~ scale(dat[,1])[,1]))
	#scale() returns a matrix of normed data
	#the default is to make standard normal: N(0,1)

	#let's grab what I want
coef(summary(lm(scale(dat[,2])[,1] ~ scale(dat[,1])[,1])))[2,1]
	#coef() : extracts coefficients from model
	
cor(dat[,1], dat[,2])
	#so, the standardized regression weight is the same as our
	#correlation value
	#this is a special condition of the bivariate regression

##################################

#Correlation doesn't care about mean values

cord <- as.data.frame(matrix(NA,nrow = 50, ncol = 3))
colnames(cord) <- c("meanX","meanY","corXY")
temp <- NA

for(i in 1:50){
  cord[i,1:2] <- c( 
	sample(1:1000,1),
	sample(1:1000,1)
			)

  temp <- mvrnorm(50, c(cord[i,1],cord[i,2]), covm, empirical = TRUE)

  cord[i,3] <- cor(temp[,1],temp[,2])
	}
cord


#Correlation doesn't care about SD values

cord2 <- as.data.frame(matrix(NA,nrow = 50, ncol = 3))
colnames(cord2) <- c("sdX","sdY","corXY")
temp2 <- temp <- NA

for(i in 1:50){
  cord2[i,1:2] <- c( 
	sample(.1:100,1),
	sample(.1:100,1)
			)
  temp2 <- cor2cov(corm, c(cord2[i,1],cord2[i,2]))
  temp <- mvrnorm(50, c(0,0), temp2, empirical = TRUE)

  cord2[i,3] <- cor(temp[,1],temp[,2])
	}
cord2


#SD only matters for covariance

cord3 <- as.data.frame(matrix(NA,nrow = 50, ncol = 3))
colnames(cord3) <- c("sdX","sdY","covXY")
temp2 <- temp <- NA

for(i in 1:50){
  cord3[i,1:2] <- c( 
	sample(.1:100,1),
	sample(.1:100,1)
			)
  temp2 <- cor2cov(corm, c(cord3[i,1],cord2[i,2]))
  temp <- mvrnorm(50, c(0,0), temp2, empirical = TRUE)

  cord3[i,3] <- cov(temp[,1],temp[,2])
	}
cord3


#However, Covariance doesn't care about mean values either

cord4 <- as.data.frame(matrix(NA,nrow = 50, ncol = 3))
colnames(cord4) <- c("meanX","meanY","covXY")
temp <- NA

for(i in 1:50){
  cord4[i,1:2] <- c( 
	sample(1:1000,1),
	sample(1:1000,1)
			)

  temp <- mvrnorm(50, c(cord4[i,1],cord4[i,2]), covm, empirical = TRUE)

  cord4[i,3] <- cov(temp[,1],temp[,2])
	}
cord4

############################################

#Is correlation smart?

corm2 <- matrix(c(
 1,  .85,
.85,  1 ), nrow = 2, ncol = 2, byrow = TRUE)
corm2

set.seed(25)
dat2 <- mvrnorm(10000, c(0,0), corm2, empirical = TRUE)
cor(dat2)
par(mfrow = c(1,2))
plot(dat2[,1],dat2[,2])
abline(lm(dat2[,2] ~ dat2[,1]), lwd = 5, col = "red")

#Let's change the relation to quadratic
dat2[which(dat2[,1] > 0),2] <- dat2[which(dat2[,1] > 0),2]*-1
plot(dat2[,1],dat2[,2])

cor(dat2)
abline(lm(dat2[,2] ~ dat2[,1]), lwd = 5, col = "red")

#########################################################
#########################################################
#########################################################
#########################################################

#Comparing correlations, let me count the ways

dat3 <- as.data.frame(mvrnorm(200, c(0,0), corm2, empirical = TRUE))
colnames(dat3) <- c("x","y")
head(dat3)

c3 <- cor.test(dat3$x, dat3$y)
c3
c3$conf.int[1:2]
#If a correlation value (r) is outside this boundary
#we would be inclined to say they significantly differ


#What if we have two groups? Males vs. Females
#http://www.quantpsy.org/corrtest/corrtest.htm
#There's a nice citation there for the interested

#First, we convert R to Fisher's Z

d4m <- as.data.frame(mvrnorm(100, c(0,0), corm2, empirical = TRUE))
colnames(d4m) <- c("x","y")

d4f <- as.data.frame(mvrnorm(100, c(0,0), 
	matrix(c(1, .70, .70, 1),nrow=2,ncol=2,byrow=TRUE), 
	empirical = TRUE))
colnames(d4f) <- c("x","y")

cor(d4m)
cor(d4f)

#fisher's z conversion: .5*log((1+r)/(1-r))
fzm <- .5*log((1+with(d4m,cor(x,y)))/(1-with(d4m,cor(x,y))))
fzf <- .5*log((1+with(d4f,cor(x,y)))/(1-with(d4f,cor(x,y))))
fzm;fzf

#Test of difference

# (fz1 - fz2)/sqrt((1/(n1-3)) + (1/(n2-3)))
# sqrt(1/(n-3)) : SE for Fisher Z
# sqrt(1/n1-3 + 1/n2-3) : SE for two Fisher Z

diffz <- (fzm - fzf)/sqrt((1/(dim(d4m)[1]-3)) + (1/(dim(d4f)[1]-3)))
diffz

#Does diffz exceed +/- 1.96?



#What if we have a smaller sample?

fzm <- .5*log((1+with(d4m[1:30,],cor(x,y)))/(1-with(d4m[1:30,],cor(x,y))))
fzf <- .5*log((1+with(d4f[1:30,],cor(x,y)))/(1-with(d4f[1:30,],cor(x,y))))
fzm;fzf

diffz <- (fzm - fzf)/sqrt((1/(30-3)) + (1/(30-3)))
diffz

#Now does diffz exceed +/- 1.96?


#Another way?

library(lavaan)

d5 <- rbind(d4m,d4f)
class(d5)
head(d5);tail(d5)
d5$female <- rep(c(0,1), each = 100)
head(d5)

m1 <- '
	x ~~ y
	x ~~ .99*x
	y ~~ .99*y
	'
fit1 <- sem(m1, 
           data = d5, 
           group = "female")
summary(fit1, standard = TRUE, fit.measures = TRUE)

m2 <- '
	x ~~ c(c1,c1)*y
	x ~~ .99*x
	y ~~ .99*y
	'
fit2 <- sem(m2, 
           data = d5, 
           group = "female")
summary(fit2, standard = TRUE, fit.measures = TRUE)


#Recall, chisq for the first model was 0, with 4 df
#In the second model with the covariance/correlation
#constrained to equality chisq is now 11.957, with 5 df
#The difference in chisq is 11.957 and the difference in df is 1

chisqdiff <- fitMeasures(fit2)[3]-fitMeasures(fit1)[3]
chisqdiff

pchisq(chisqdiff, 1, lower.tail = FALSE)
	#Is this significantly worse fitting?

#The other indices mostly agree
		M1		M2
#CFI		1		.964
#TLI		1.01		.986
#RMSEA	0		.118
#SRMR		0		.034
#AIC		947.6		957.6
#BIC		967.4		958.2

#AIC and BIC, love hate
#smaller = better
#what is meaningful? Who knows

#Proportion difference?
(947.6-957.6)/957
(947.6-957.6)/947.6

(967.4-958.2)/967.4
(967.4-958.2)/958.2


#######################################################
#######################################################
#Free Play

#We've made several data sets along the way, go back
#visit them, play with them
#OR
#Try making some of your own and then testing things out!

