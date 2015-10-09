#Joseph E. Gonzales
#PSC 204a
#Fall 2015
#Lab 03

#########################################
#Problem 4 example

set.seed(2)
v1 <- rnorm(100,0,1)
v2 <- sample(c("a","b"),100,replace=TRUE)
v3 <- sample(c("x","y","z"),100,replace=TRUE)
d <- data.frame(v1,v2,v3)

#calc mean, median, etc., for v1 by subsets of v2 and v3

by(d$v1, list(d$v2,d$v3), mean)
by(d$v1, list(d$v2,d$v3), median)


##################### Other helpful tips

temp <- sample(1:100,15)
temp

#Remember to respect the order of operations

##########
#Example 1
##########

sum(temp-mean(temp))

sum(temp-mean(temp))^2

sum((temp-mean(temp))^2)

##########
#Example 2
##########

length(temp-1)

(length(temp)-1)


#############

#The Scale Function for scaling data (e.g., z-scores)

#############

?scale
#scale(x, center = TRUE, scale = TRUE)
	#x, the value or vector to be z-scored
	#center, the mean value, default is to use the mean
	#of the vector
	#scale, the sd value, defaults i to use the sd
	#of the vector
	#you can specify certain values instead of using
	#sample statistics

scale(temp)
scale(temp, 50, 15)

class(scale(temp, 50, 15))
	#returns a matrix, so you have to subset data to get vector
scale(temp, 50, 15)[,1]

#just as easy to use the formula

(temp-50)/15

##########################################################
##########################################################
##########################################################
##########################################################

##########################################################
#The z distribution
##########################################################

#Probability of a normal distribution value
pnorm(1.96, 0, 1)
pnorm(-1.96, 0, 1)

#z value associated with a proportion in the normal distribution
qnorm(.025, 0, 1, lower.tail = TRUE)
qnorm(.025, 0, 1, lower.tail = FALSE)

##########################################################
#The t distribution
##########################################################

#Probability of a t distribution value
pt(1.9, 14, lower.tail = FALSE)
pt(-1.9, 14, lower.tail = TRUE)
plot(density(rnorm(100000,0,1)))
abline(v=c(-1.96,1.96))

pt(1.9, 49, lower.tail = FALSE)
pt(-1.9, 49, lower.tail = TRUE)

pt(1.9, 99, lower.tail = FALSE)
pt(-1.9, 99, lower.tail = TRUE)

#t value associated with a proportion in the t the distribution
qt(.025, 4, lower.tail = TRUE)
qt(.025, 4, lower.tail = FALSE)

qt(.025, 14, lower.tail = TRUE)
qt(.025, 14, lower.tail = FALSE)

qt(.025, 29, lower.tail = TRUE)
qt(.025, 29, lower.tail = FALSE)

#######################################

#z vs. t via histogram and SD

#######################################

par(mfrow = c(2,2))
hist(rnorm(1000,0,1), xlim = c(-7,7))
hist(rt(1000,df = 4), xlim = c(-7,7))
hist(rt(1000,df = 14), xlim = c(-7,7))
hist(rt(1000,df = 29), xlim = c(-7,7))

sd(rnorm(1000,0,1))
sd(rt(1000,df = 4))
sd(rt(1000,df = 14))
sd(rt(1000,df = 29))


#######################################

#Z tests of mean differences

#Imagine you have 3 samples from sub-populations, 
#each with an average IQ score.

#pop1: xbar = 82, N = 15
#pop2: xbar = 96, N = 10
#pop3: xbar = 110, N = 11

#IQ scores are ~N(100,15) in the population

#Do any of these populations differ significantly from the population?

pop1z <- (82-100)/(15/sqrt(15))
pop1z
.025 > pnorm(pop1z, lower.tail = TRUE)
	#Two-tailed, alpha = .05
.01 > pnorm(pop1z, lower.tail = TRUE)
	#Two-tailed, alpha = .01

pop2z <- (96-100)/(15/sqrt(10))
pop2z
.025 > pnorm(pop2z, lower.tail = TRUE)
	#Two-tailed, alpha = .05
.01 > pnorm(pop2z, lower.tail = TRUE)
	#Two-tailed, alpha = .01

pop3z <- (110-100)/(15/sqrt(11))
pop3z
.025 > pnorm(pop3z, lower.tail = FALSE)
	#Two-tailed, alpha = .05
.01 > pnorm(pop3z, lower.tail = FALSE)
	#Two-tailed, alpha = .01

###################################################

#We can do the same thing with Confidence Intervals

###################################################

#Recall that CI equals
#xbar +/- Std.Error*Critical.z.score

#qnorm can give critical z-score

critz <- qnorm(.025, 0, 1, lower.tail = FALSE)

#Std.Error is sigma/sqrt(N)

sepop1 <- 15/sqrt(15)
sepop2 <- 15/sqrt(10)
sepop3 <- 15/sqrt(11)

#95% CI to test pop1

c((100 - sepop1*critz),(100 + sepop1*critz))
	#pop1 xbar = 82; is that within the 95% CI?

#95% CI to test pop2

c((100 - sepop2*critz),(100 + sepop2*critz))
	#pop2 xbar = 96; is that within the 95% CI?

#95% CI to test pop3

c((100 - sepop3*critz),(100 + sepop3*critz))
	#pop3 xbar = 110; is that within the 95% CI?

#################################################################
#################################################################
#################################################################

temp1 <- round(rnorm(30, 5, 1),2)
temp2 <- round(rnorm(30, 6, 1),2)



#############################################################
#############################################################

#The t-test arguments

?t.test
#t.test(x, y = NULL,
#       alternative = c("two.sided", "less", "greater"),
#       mu = 0, paired = FALSE, var.equal = FALSE,
#       conf.level = 0.95, ...)

#x is a vector, you need to specify at least one to test
	#if you only have one vector it is a one-sample
	#t-test

#y is Null by default, so t-test is a one-sample t-test
	#by default. For a two-sample or paired t-test,
	#you specify another vector

#alternative is the specification of the alternative hypothesis.
	#By default alternative is two.tailed, meaning that t-test
	#assumes alpha should be split between both tails.
	#We can specify one-tailed hypotheses in either tail
	#using "less" and "greater"

#mu = 0 specifies the difference to be tested. So, in a one-sample
	#t-test, this is the population mu (xbar-mu). For the
	#two-sample t-test, this is the expected difference
	#between the two-samples. Generally, we would assume the
	#difference is zero, because we are testing whether the
	#means differ. However, one could imagine a situation where
	#one would want to test whether a difference between
	#two groups was consistent across different samples.

t.test(temp1,temp2, mu = 0)
t.test(temp1,temp2, mu = 1)
t.test(temp1,temp2, mu = -1)

#paired = FALSE is the default. This is whether the two vectors
	#are independent, or if they have some dependency.
	#So, a random, independent sample of students drawn from 
	#two schools and assessed on self-esteem would have no 
	#dependency. A random sample of students from two schools
	#who are assessed on self-esteem at the beginning of the
	#academic year and end of the academic year would have
	#a dependency if you were comparing pre- and post-academic
	#year self-esteem scores. But not if you were comparing
	#school one vs. school two student self-esteem scores

#var.equal = FALSE is the default. This means that t.test
	#assumes that variances are not equal between two
	#samples, regardless of whether this is paired or
	#independent. This is not a bad assumption since
	#and consequently the Welch Two Sample t-test is implemented.
	#We can test if the variances are equal before
	#conducting the t-test. If they do not differ significantly
	#then we can change the default to TRUE and conduct a
	#general t-test.
		#we can use the var.test() for this and will discuss
		#it in a moment.

#conf.level = .95 is the default. By default, t.test assumes an
	#alpha of .05. We can change this by specifying another
	#proportion value (e.g., .90 for alpha of .10).


#The one-tailed test

t.test(temp1, mu = 0)
t.test(temp1, mu = 5)

t.test(temp2, mu = 5)

	#Obviously, the further mu is from the mean
	#of the population the data was generated from
	#the more significant the difference is
	#We can visualize this pretty easily
	#considering that 0 <= p <= 1

pval <- unlist(
	lapply(seq(0,10,.01), function(x) {

		t.test(temp1, mu = x)$p.value))

	}))

plot(seq(0, 10, .01),
	pval,
	ylim = c(0,1),
	xlim = c(3,7),
	xlab = "Mu Values",
	ylab = "P-Values"
	)
	abline(v = mean(temp1), lty = 3)

#We would see the same thing using the two-tailed test
	#when mu -> xbar1 - xbar2

#You may have noted in the lapply statement that I had
	#t.test(temp1, mu = x)$p.value
	#Many of the t.test components can
	#be called as objects using a call name

#statistic - the value of the t-statistic.
 
#parameter - the degrees of freedom for the t-statistic.
 
#p.value - the p-value for the test.
 
#conf.int - a confidence interval for the mean 
	#appropriate to the specified alternative hypothesis.
 
#estimate - the estimated mean or difference in 
	#means depending on whether it was a one-sample 
	#test or a two-sample test.
 
#null.value - the specified hypothesized value of 
	#the mean or mean difference depending on 
	#whether it was a one-sample test or a two-sample test.
 
#alternative - a character string describing the alternative hypothesis.
 
#method - a character string indicating what type of t-test was performed.
 
#data.name - a character string giving the name(s) of the data.

#so, for example

t.test(temp1)$p.value
t.test(temp1)$statistic
t.test(temp1)$conf.int
t.test(temp1)$parameter

	#This is useful if you are ever running many
	#tests iteratively, but only want certain 
	#values, rather than the entire test,
	#or if you're building tables in R

############

#Two independent samples t-test

t.test(temp1, temp2)
t.test(temp1, temp2, alt = c("greater"))
t.test(temp1, temp2, alt = c("less"))

#Are the variances different, or can we change
#the var.equal default from FALSE to TRUE?

?var.test
#var.test(x, y, ratio = 1,
#         alternative = c("two.sided", "less", "greater"),
#         conf.level = 0.95, ...)

#x is the vector of one sample
#y is the vector of the other sample
#ratio = 1, indicates that the ratio of variances should
	#be 1, or, that the variances are non-zero and 
	#equal in value
#alternative and conf.level are the same as in t.test()

var.test(temp1, temp2)
	#We would conclude that the variances do not
	#differ significantly

t.test(temp1, temp2, var.equal = TRUE)
t.test(temp1, temp2)

	#We see that the Welch test makes an adjustment to
	#the df, which results in a difference in the pvalue

t.test(temp1, temp2, var.equal = TRUE)$parameter
t.test(temp1, temp2)$parameter

###########################

#Paired t-tests

#Make some paired data
	mean(temp1);sd(temp1);length(temp1)
set.seed(300)
temp3 <- 3 + .2*temp1 + rnorm(30, 0, 2)
cor(temp1,temp3)
mean(temp3);sd(temp3)

set.seed(300)
temp4 <- -.2 + .9*temp1 + rnorm(30, 0, 1)
cor(temp1,temp4)
mean(temp4);sd(temp4)
	#This is just a basic linear equation
	#showing the relation between temp1
	#and both temp3 & temp4, which allows
	#us to generate those values

#---------------------------------------------------
#Paired vs. Independent t-tests

t.test(temp1, temp3, paired = FALSE)
	#Here we are not using a paired t.test

t.test(temp1, temp3, paired = TRUE)
	#Here we use the paired t.test

t.test(temp1, temp4, paired = FALSE)
	#Here we are not using a paired t.test

t.test(temp1, temp4, paired = TRUE)

#Compare the paired and independent t-tests
	#with each other

t.test(temp1, temp3, paired = TRUE)$statistic -
	t.test(temp1, temp3, paired = FALSE)$statistic
	cor(temp1,temp3)

t.test(temp1, temp4, paired = TRUE)$statistic -
	t.test(temp1, temp4, paired = FALSE)$statistic
	cor(temp1,temp4)

	#The difference between the paired and independent
	#samples t-test depends on the strength of association
	#between the two scores.
	#The weaker the association, the less difference between
	#paired and independent, the stronger the association
	#the more powerful the paired vs. the independent.


############################################
#Practice

v1 <- rnorm(100,0,1)
v2 <- rnorm(100,2,2)
v3 <- rnorm(100,4,.5)
v4 <- rnorm(100,-2,6)
v5 <- rnorm(100,3,.25)

d <- data.frame(v1,v2,v3,v4,v5)

#Practice conducting one-sample, independent samples, and paired
#t-tests using v1-v5.
































