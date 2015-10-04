#Joseph E. Gonzales
#204a R Lab 2
#Fall 2015
#####################################################################

#Let's talk about the Central Limit Theorem (CLT)

#But first, some functions to generate data with
#certain distributional properties

#runif(N, min, max)
#Generates random uniform distribution data based on
#argument parameters

runif(100,0,10)
hist(runif(1000,0,10))

#rnorm(N, mean, sd)
#Generates random normal distribution data based on
#argument parameters

rnorm(100,0,1)
hist(rnorm(1000,0,1))

#rf(N, df1, df2)
#Generates random f distribution data based on
#argument parameters

rf(100, 1, 6)
hist(rf(1000, 1, 6))

#We can make some populations of scores

set.seed(100215)
pop1 <- rnorm(400000, 0, 1)

pop2 <- runif(400000, -5, 5)

pop3 <- rf(400000, 1, 30)

################################

#OK, What does the CLT tell us about these populations?

################################

par(mfrow = c(3,1))
	#par is a function to control various plot features
	#mfrow specifically argues how many figures to include
	#in a single image and how to arrange them
		#by rows and columns : c(rows, columns)

hist(pop1);hist(pop2);hist(pop3)

#What should the distribution of the means look like with these things?

#We can test this in R

#Let us build ...

#The means from sampling
pop1m <- lapply(c(1,5,15,30,50), function(x){
   unlist(lapply(1:300, function(y){
	mean(sample(pop1,x,replace=FALSE),na.rm=TRUE)
	}))
	})

pop2m <- lapply(c(1,5,15,30,50), function(x){
   unlist(lapply(1:300, function(y){
	mean(sample(pop2,x,replace=FALSE),na.rm=TRUE)
	}))
	})

pop3m <- lapply(c(1,5,15,30,50), function(x){
   unlist(lapply(1:300, function(y){
	mean(sample(pop3,x,replace=FALSE),na.rm=TRUE)
	}))
	})

#The Plot

par(mfrow = c(2,3))
lapply(1:length(pop1m), function(x){
	hist(pop1m[[x]])
	})

par(mfrow = c(2,3))
lapply(1:length(pop2m), function(x){
	hist(pop2m[[x]])
	})

par(mfrow = c(2,3))
lapply(1:length(pop3m), function(x){
	hist(pop3m[[x]])
	})

#From Class yesterday
#What about a population where everyone but 1 person has a score
#of 1, the other person has a score of 0

pop4 <- c(0,rep(1, 99999))
hist(pop4)
mean(pop4);sd(pop4)

pop4m <- lapply(c(1,30,100,1000,5000), function(x){
   unlist(lapply(1:1000, function(y){
	mean(sample(pop4,x,replace=FALSE),na.rm=TRUE)
	}))
	})

par(mfrow = c(2,3))
lapply(1:length(pop4m), function(x){
	hist(pop4m[[x]])
	mean(pop4m[[x]])
	})
hist(pop4m[[1]], xlim = c(0,2))
hist(pop4m[[2]], xlim = c(0,2))
hist(pop4m[[3]], xlim = c(.98,1))
hist(pop4m[[4]], xlim = c(.996,1))
sd(pop4m[[1]])
sd(pop4m[[2]])
sd(pop4m[[3]])
sd(pop4m[[4]])
sd(pop4m[[5]])
sd(pop4)

pop5 <- sample(c(0,1),40000,replace=TRUE)
pop5m <- lapply(c(1,5,15,30,50), function(x){
   unlist(lapply(1:300, function(y){
	mean(sample(pop5,x,replace=FALSE),na.rm=TRUE)
	}))
	})

lapply(1:length(pop5m), function(x){
	hist(pop5m[[x]])
	})

#####################################################################
#####################################################################
#####################################################################
#####################################################################

#Let's talk about the Biased vs. Unbiased SD and evaluate
#how they function

#First problem, we only have the unbiased SD using the sd() function
#We'll need to build a function

#Here are the basics of a function via the function() function

#function(arg1, arg2, ... ){
#	statements
#	return()
#	}

#We can look at the internal structure of built-in functions by
#simply typing and entering the function name

sd

#It looks like the sd function simply calls the var function
#and then takes the square root ... pretty efficient

var

#Ahh, yes, this is less clear

#We want to compare the biased and unbiased sd
#so we'll make new functions for both and compare them with
#the built-in sd function results

b.sd <- function(data, na.rm = FALSE){

	if(na.rm == TRUE){
		dat2 <- data[which(is.na(data) == FALSE)]
		n <- length(data[which(is.na(data) == FALSE)])
		}else{
		dat2 <- data
		n <- length(data)}

	bsd <- sqrt((sum((dat2-mean(dat2))^2))/n)
	return(bsd)
	}
set.seed(100253)
temp <- rnorm(10,0,1)
temp2 <- rnorm(10,0,1)
temp2[1] <- NA

b.sd(temp)
b.sd(temp, na.rm = TRUE)
b.sd(temp2)
b.sd(temp2, na.rm = TRUE)

sd(temp)
sd(temp2)
sd(temp2, na.rm=TRUE)

u.sd <- function(data, na.rm = FALSE){

	if(na.rm == TRUE){
		dat2 <- data[which(is.na(data) == FALSE)]
		n <- (length(data[which(is.na(data) == FALSE)])-1)
		}else{
		dat2 <- data
		n <- (length(data)-1)}

	u.sd <- sqrt((sum((dat2-mean(dat2))^2))/n)
	return(u.sd)
	}

u.sd(temp)
u.sd(temp, na.rm = TRUE)
sd(temp)
sd(temp, na.rm = TRUE)

u.sd(temp2)
u.sd(temp2, na.rm = TRUE)
sd(temp2)
sd(temp2, na.rm = TRUE)

#These work pretty well, so we can move on after discussing a few
#new functions used to build this

#if(){}else{}
#a logical function that will test for a condition and
#give a specified response based on whether the condition
#is or is not met

unlist(lapply(-1:4, function(x){
	if(x == 1){"Yay"}else{"Boo"}
	}))

#sum()
#A command to sum a vector of data. Has a na.rm argument like
#the mean() and sd() functions

sum(1:4)
sum(1,2,3,4)

#sqrt()
#simply takes the square root of a value

sqrt(9); sqrt(25); sqrt(49)

################################
################################

#Now we can compare our new functions

#Let us build ...

pop6 <- rnorm(800000,0,1)
sd(pop6)	
b.sd(pop6)


pop6u <- lapply(c(5,10,30,100,200,1000), function(x){
   unlist(lapply(1:200, function(y){
	sd(sample(pop6,x,replace=FALSE))
	}))
	})	
pop6b <- lapply(c(5,10,30,100,200,1000), function(x){
   unlist(lapply(1:200, function(y){
	b.sd(sample(pop6,x,replace=FALSE))
	}))
	})

pop6um <- unlist(lapply(1:length(pop6u), function(x){
	mean(pop6u[[x]])
	}))
pop6bm <- unlist(lapply(1:length(pop6b), function(x){
	mean(pop6b[[x]])
	}))
pop6um - b.sd(pop6)
pop6bm - b.sd(pop6)

matrix(c(
	c(5,10,30,100,200,1000),
	round((pop6um - 1),4),
	round((pop6bm - 1),4)
	), ncol = 3, nrow = 6)

##########################################
##########################################
##########################################
##########################################

#Functions to describe the data

mean(pop1)
median(pop1)
max(pop1)
min(pop1)
sd(pop1)
var(pop1)

#all functions use the na.rm = TRUE argument
#the default argument is na.rm = FALSE

#Plots from today to demonstrate the density of the data

par(mfrow=c(1,1))
hist(pop1)
hist(pop2)
hist(pop3)
hist(pop5)

plot(density(pop1))
plot(density(pop2))

hist(pop1, main = "Histogram of Standard Normal Pop",
	xlab = "Values", xlim = c(-2,2), breaks =200)
hist(rnorm(25,0,1), main = "Histogram of Standard Normal Pop",
	xlab = "Values", xlim = c(-2,2), breaks =200)
hist(rnorm(25,0,1), main = "Histogram of Standard Normal Pop",
	xlab = "Values", xlim = c(-2,2), breaks =10)


plot(density(pop1), xlab = "Pop1 Values",
	main = "Population 1 Density Distribution")
	abline(v = mean(pop1))
	abline(h = .25)
	lines(c(-4,-2),c(.2,.3))
	lines(c(-2,0),c(.3,.2))
	lines(c(-4,0),c(.2,.2))
	points(c(4,2),c(.2,.3), pch = "P")
	points(c(2,0),c(.3,.2), pch = "P")
	points(c(4,0),c(.2,.2), pch = "P")


##################################

#Standardizing data

set.seed(10090)
temp <- rnorm(500, 5, 2.3)
hist(temp)

temp2 <- (temp-mean(temp))/sd(temp)
hist(temp2)

temp3 <- scale(temp)[,1]
hist(temp3)


tdat <- data.frame(temp,temp2,temp3)
cor(tdat)

	#cor() is the correlation function, we'll talk about
	#it much more later, for now it can be used to
	#show us that the variability between temp versions
	#is identical. So, even though the values have changed
	#the relative location of all the observations are
	#identical in each version of temp.


#############################################
#############################################


#Free time

#Create the data set
set.seed(10913)
v1 <- rnorm(500, 5, 3.3)
v2 <- rnorm(500, 3.3, .5)
v3 <- sample(c(0,1),500, replace = TRUE)
v4 <- sample(c(1,2,2,3,3,3,4,4,4,4,4,5,5,5,6,6,7),500,replace = TRUE)
d <- data.frame(v1,v2,v3,v4)

#Some exercises to conduct

#1. Get the mean, median, min, max for v1 & v2
#2. Plot v1-v4, describe the distribution of the data
#3. Calculate the biased and unbiased SD for v1-v2 & v4
#4. Calculate the frequency of 0 and 1 for v3
#5. Transform v1 and v2 into normal standard distributions
#	by "hand" and using scale()

#If you're really feeling it
#Try creating a loop to get the mean for random samples
#of v1 and v2. Consider sample sizes of 10,20,40, & 80 with
#300 samples each. Create histograms of the means for each
#sample size.









