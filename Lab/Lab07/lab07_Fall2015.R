#Joseph E. Gonzales
#PSC 204a lab07
#Fall 2015

######################################
#Install some R packages
######################################

#select mirror
chooseCRANmirror()
	#choose http mirrors, then choose CA 1 or 2

#Install packages
install.packages(c("car"))




######################################

#Factorial ANOVA

######################################

#Data
set.seed(1113)
female <- rep(c(0,1), each = 50)

drug1 <- drug2 <- rep(0, 100)
drug1;drug2

drug1[sample(1:100, 33, replace = FALSE)] <- 1
drug1

drug2[sample(which(drug1 == 0), 33, replace = FALSE)] <- 1
drug2

dose <- rep("P", 100)
dose[which(drug1 == 1)] <- "D1"
dose[which(drug2 == 1)] <- "D2"


which((drug1 + drug2) > 1)

a1c <- 12 - 2*drug1 - 7*drug2 - 2*female -3*drug1*female + 
	5.5*drug2*female + rnorm(100,0,3)


#####################################
#Descriptives
#####################################

by(a1c, dose, mean)

by(a1c, female, mean)

by(a1c, list(dose,female), mean)



#####################################

#ANOVA and Factorial ANOVA

#####################################
#ANOVAS

anova(lm(a1c ~ dose))

anova(lm(a1c ~ female))


##################################
#Factorial ANOVA, no Interaction

anova(lm(a1c ~ female + dose))


##################################
#Factorial ANOVA, Interaction

anova(lm(a1c ~ female + dose + female*dose))

anova(lm(a1c ~ female*dose))

anova(lm(a1c ~ dose*female))
	#These differ, why? They are the same model ...

library(car)

Anova(lm(a1c ~ female*dose), type = c(2))
	#Type 2 vs. 1 SS


##################################################

#Simple Effects

#We can evaluate the effect of Bio Sex across different
#Dose conditions, or we can evaluate the effect of
#Dose across different Bio Sex conditions
#Which makes more sense given the questions you are trying
#to evaluate?

#I'll split data by bio sex, as I'm interested in how dose
#condition effects may differ by bio sex

a1cf <- a1c[which(female == 1)]
dosef <- dose[which(female == 1)]

a1cm <- a1c[which(female == 0)]
dosem <- dose[which(female == 0)]

#females
anova(lm(a1cf ~ dosef))

#males
anova(lm(a1cm ~ dosem))

#That was informative ... pairwise comparisons

pairwise.t.test(a1cf,dosef,p.adjust=c("bonf"))
by(a1cf, dosef, mean)

pairwise.t.test(a1cm,dosem,p.adjust=c("bonf"))
by(a1cm, dosem, mean)

#Got it, so Drug1 is best for female diabetics
#and Drug2 is best for male diabetics looking to control
#blood glucose levels

##############################

#Plot it

##############################

afm <- by(a1cf,dosef,mean)[c(3,1,2)]
afs <- by(a1cf,dosef,sd)[c(3,1,2)]
afs <- (afs/sqrt(33))*qt(.025,33,lower.tail=FALSE)

amm <- by(a1cm,dosem,mean)[c(3,1,2)]
ams <- by(a1cm,dosem,sd)[c(3,1,2)]
ams <- (ams/sqrt(33))*qt(.025,33,lower.tail=FALSE)


plot(1,1,type="n",
	ylim=c(0,15),xlim=c(0,4),
	xaxt="n",
	xlab = "Drug Condition",
	ylab = "Average A1c",
	main = "A1c Control by Drug Condition")
	axis(1,at=c(.5,2,3.5),label=c("Placebo","Drug 1","Drug 2"))
points(c(.35,1.85,3.35),afm, pch = "F")
	points(c(.35,1.85,3.35),(afm-afs), pch = "-", cex = 2)
	points(c(.35,1.85,3.35),(afm+afs), pch = "-", cex = 2)
points(c(.65,2.15,3.65),amm, pch = "M")
	points(c(.65,2.15,3.65),(amm-ams), pch = "-", cex = 2)
	points(c(.65,2.15,3.65),(amm+ams), pch = "-", cex = 2)
legend(0,3,pch=c("F","M"),c("Females","Males"))
	abline(h=c(7,8), lty = 3)

###################################################
###################################################
###################################################
###################################################


###################################################

#RM ANOVA

###################################################

#Data Gen
glucp1 <- rnorm(50,160,10)
glucd1 <- rnorm(50,160,10)

glucp2 <- glucp1 + rnorm(50,0,5)
glucp3 <- glucp2 + rnorm(50,0,5)
glucp4 <- glucp3 + rnorm(50,0,5)

glucd2 <- glucd1 - 30 + rnorm(50,0,5)
glucd3 <- glucd2 - 15 + rnorm(50,0,5)
glucd4 <- glucd3 + rnorm(50,0,5)

drug <- rep(c(0,1), each = 50)
t1 <- c(glucp1,glucd1)
t2 <- c(glucp2,glucd2)
t3 <- c(glucp3,glucd3)
t4 <- c(glucp4,glucd4)
gwide <- data.frame(drug,t1,t2,t3,t4)
head(gwide)
tail(gwide)

drug <- rep(drug, each = 4)
obs <- rep(c("t1","t2","t3","t4"), 100)
time <- rep(c(0.5,1.5,2.5,3.5), 100)
id <- rep(paste("id",1:100,sep=""),each = 4)
glucose <- unlist(lapply(1:100, function(x){
			gwide[x,2:5]
		}))
glong <- data.frame(id,obs,time,drug,glucose)
head(glong)
tail(glong)

####################################################

#Plot Data

par(mfrow = c(1,2))
plot(1,1,type="n",
	ylim = c(min(glong$glucose),max(glong$glucose)),
	xlim = c(0,3),
	xaxt = "n",
	xlab = "Hours Since Meal",
	ylab = "Blood Glucose",
	main = "Placebo Condition")
	axis(1,at=c(0:3),labels=c("0.5","1.5","2.5","3.5"))
	lapply(1:50,function(x){
		lines(0:3,gwide[x,2:5],lty = 3)
		})
	lines(0:3,sapply(gwide[1:50,2:5],mean),col = "red", lwd = 5)
plot(1,1,type="n",
	ylim = c(min(glong$glucose),max(glong$glucose)),
	xlim = c(0,3),
	xaxt = "n",
	xlab = "Hours Since Meal",
	ylab = "Blood Glucose",
	main = "Drug Condition")
	axis(1,at=c(0:3),labels=c("0.5","1.5","2.5","3.5"))
	lapply(51:100,function(x){
		lines(0:3,gwide[x,2:5],lty = 3)
		})
	lines(0:3,sapply(gwide[51:100,2:5],mean),col = "red", lwd = 5)

#OR, another plot idea

gpm <- sapply(gwide[which(gwide$drug == 0), 2:5],mean)
gdm <- sapply(gwide[which(gwide$drug == 1), 2:5],mean)
gps <- (sapply(gwide[which(gwide$drug == 0), 2:5],sd)/sqrt(50))*
		qt(.025,50,lower.tail=FALSE)
gds <- (sapply(gwide[which(gwide$drug == 1), 2:5],sd)/sqrt(50))*
		qt(.025,50,lower.tail=FALSE)


plot(1,1,type="n",
	ylim = c(min(glong$glucose),max(glong$glucose)),
	xlim = c(0,3),
	xaxt = "n",
	xlab = "Hours Since Meal",
	ylab = "Blood Glucose",
	main = "Drug Condition")
	axis(1,at=c(0:3),labels=c("0.5","1.5","2.5","3.5"))
	lines(0:3,gpm, col = "red", lwd = 5)
	lines(0:3,(gpm-gps), col = "red", lty = 3, lwd = 3)
	lines(0:3,(gpm+gps), col = "red", lty = 3, lwd = 3)
	lines(0:3,gdm, col = "green", lwd = 5)
	lines(0:3,(gdm-gds), col = "green", lty = 3, lwd = 3)
	lines(0:3,(gdm+gds), col = "green", lty = 3, lwd = 3)

#or, rather than predicted 95% CI, observed 95% CI

gpcl <- sapply(gwide[which(gwide$drug == 0), 2:5], quantile, .025)
gpcu <- sapply(gwide[which(gwide$drug == 0), 2:5], quantile, .975)
gdcl <- sapply(gwide[which(gwide$drug == 1), 2:5], quantile, .025)
gdcu <- sapply(gwide[which(gwide$drug == 1), 2:5], quantile, .975)

plot(1,1,type="n",
	ylim = c(min(glong$glucose),max(glong$glucose)),
	xlim = c(0,3),
	xaxt = "n",
	xlab = "Hours Since Meal",
	ylab = "Blood Glucose",
	main = "Drug Condition")
	axis(1,at=c(0:3),labels=c("0.5","1.5","2.5","3.5"))
	lines(0:3,gpm, col = "red", lwd = 5)
	lines(0:3,gdm, col = "green", lwd = 5)
	lines(0:3, gpcl, col = "red", lty = 5, lwd = 3)
	lines(0:3, gpcu, col = "red", lty = 5, lwd = 3)
	lines(0:3, gdcl, col = "green", lty = 5, lwd = 3)
	lines(0:3, gdcu, col = "green", lty = 5, lwd = 3)

#or, if you don't feel like building your own

with(glong, interaction.plot(obs, drug, glucose))

#you can modify values as you see fit

with(glong, interaction.plot(obs, drug, glucose,
	col = c("red","green"), lwd = c(5,5)))


##########################################


#RM ANOVA Model methods - Many routes, few are satisfying
#We'll review what I think is the most straightforward today
#But more to come next week

#Also, for those of you who would like a more detailed
#explanation of compound symmetry/sphericity, I like this:
#http://homepages.gold.ac.uk/aphome/spheric.html


summary(aov(glucose ~ drug, data = glong))
	#What's wrong here?

#Remeber the nature of the data

head(glong);head(gwide)
dim(glong);dim(gwide)

summary(aov(glucose ~ drug + Error(id), data = glong))

summary(aov(glucose ~ obs + Error(id), data = glong))

summary(aov(glucose ~ drug + obs + Error(id), data = glong))

summary(aov(glucose ~ drug*obs + Error(id), data = glong))


#Polynomial Contrasts to describe trajectories

contr.poly(4)

glong[,6] <- contr.poly(4)[,1] 
glong[,7] <- contr.poly(4)[,2] 
glong[,8] <- contr.poly(4)[,3] 


colnames(glong) <- c(colnames(glong[,1:5]),c("l","q","c"))
head(glong)
tail(glong)


summary(aov(glucose ~ l + q + c + Error(id), data = glong))


summary(aov(glucose ~ l*drug + q*drug + c*drug + 
	Error(id), data = glong))


########

#Follow-up options

#Simple Effects split on interaction: e.g., drug vs. placebo


summary(aov(glucose ~ obs + Error(id), glong[which(glong$drug == 0),]))
summary(aov(glucose ~ obs + Error(id), glong[which(glong$drug == 1),]))

pairwise.t.test(glong[which(glong$drug == 1),"glucose"],
		    glong[which(glong$drug == 1),"obs"],
		    paired = TRUE, p.adjust = c("bonf"))

#we shouldn't do this for the placebo group given
#that the test was not significant, but we can
#for the sake of practice here

pairwise.t.test(glong[which(glong$drug == 0),"glucose"],
		    glong[which(glong$drug == 0),"obs"],
		    paired = TRUE, p.adjust = c("bonf"))

pairwise.t.test(glong[which(glong$drug == 0),"glucose"],
		    glong[which(glong$drug == 0),"obs"],
		    paired = TRUE, p.adjust = c("none"))
	#Looks like the omnibus test was on the ball today

#or, using the polynomial contrasts

summary(aov(glucose ~ l + q + c + 
	Error(id), glong[which(glong$drug == 0),]))

summary(aov(glucose ~ l + q + c + 
	Error(id), glong[which(glong$drug == 1),]))


#More on RM ANOVA and Multilevel Models next week

####################################################

#I was asked to go over the pairwise t-test exam question

#Suppose an investigator is interested in differences between 
#husbands and wives with respect to life satisfaction. Use the 
#data below to answer the following questions. Note that the 
#first husband score corresponds with the first wife score, 
#the second husband score corresponds with the second wife score, 
#and so on.

#Husband Life Satisfaction Scores: 4, 5, 6, 6, 5
#Wife life Satisfaction Scores: 3, 4, 4, 5, 3

hls <- c(4,5,6,6,5)
wls <- c(3,4,4,5,3)

d <- data.frame(hls,wls)
d

d$dls <- d$hls - d$wls
d

mdls <- sum(d$dls)/length(d$dls)
mdls

sdls <- sqrt(sum((d$dls - mdls)^2)/(length(d$dls)-1))
sdls

sedls <- sdls/sqrt(length(d$dls))
sedls

tdls <- (mdls - 0)/sedls
tdls

qt(.025, (length(d$dls)-1), lower.tail=FALSE)
qt(.025, (length(d$dls)-1), lower.tail=FALSE) > tdls
	#Reject Null

#Reporting t-test
#t(df) = t-value, p <=> p-value
#t(4) = 5.72, p < .05
#Interpretation:
#Husbands report greater life-satisfaction than their wives.




