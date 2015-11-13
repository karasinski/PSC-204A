#Joseph E. Gonzales
#PSC 204a
#Fall 2015
#Lab 06

################################################################

#Post-exam Review & Such

################################################################

#Paired t-test

#What determines if samples are paired (dependent) or not?

#e.g., Husbands and Wives, such that husband 1 is married to wife 1,
#husband 2 with wife 2, and so on.
#vs.
#Samples of married men and women were collected and compared on ...

#Advantage to considering pairs?
#var(g1-g2) = var(g1) + var(g2) - 2*cov(g1,g2)
#We can remove common variance
#What else can happen? Will this always make a difference?

#Husband Life Satisfaction Scores: 4, 5, 6, 6, 5
#Wife life Satisfaction Scores: 3, 4, 4, 5, 3

hls <- c(4,5,6,6,5)
wls <- c(3,4,4,5,3)

cor(hls,wls)

mean(hls)-mean(wls)
mean(hls-wls)

#SD independent vs. paired
sqrt((3*var(hls)+3*var(wls))/(8-2))
sd(hls-wls)

#df independent vs. paired
sqrt(8)
sqrt(3)

#SE independent vs. paired
sqrt((3*var(hls)+3*var(wls))/(8-2))/sqrt(8)
sd(hls-wls)/sqrt(3)


#What if they negatively covary? Recall formula.
#var(g1-g2) = var(g1) + var(g2) - 2*cov(g1,g2)

set.seed(1030)
hls2 <- round(rnorm(10,mean(hls),sd(hls)),0)
wls2 <- round((9 + hls2*-.6 + rnorm(10,0,.5)),0)
cor(hls2,wls2)

sqrt((3*var(hls2)+3*var(wls2))/(8-2))
sd(hls2-wls2)
#If samples are negatively related then paired t-test
#will have less power to detect a difference than the
#independent samples t-test

#T of independent samples vs. paired
ti <- (mean(hls2)-mean(wls2))/(sqrt((3*var(hls2)+3*var(wls2))/(20-2))/
	sqrt(20))
tp <- mean(hls2-wls2)/(sd(hls2-wls2)/sqrt(10))
ti;tp

pt(ti, 19, lower.tail = FALSE)
pt(tp, 9, lower.tail = FALSE)

#Important to consider paired samples for several reasons.

##############################################################

#ANOVA

##############################################################

flag <- rep(c("b","r","w"),each = 4)
score <- c(4,2,2,4,5,6,6,5,4,4,4,3)

anova(lm(score ~ flag))

#Pairwise comparisons
#Just t-tests
#Either indepdent samples or paired samples

pairwise.t.test(score,flag,p.adjust=c("none"))
pairwise.t.test(score,flag,p.adjust=c("bonf"))

#or, something like this

t.test(score[which(flag == "b")],
       score[which(flag == "r")])
t.test(score[which(flag == "b")],
       score[which(flag == "w")])
t.test(score[which(flag == "r")],
       score[which(flag == "w")])


###############################################################

#Practice

###############################################################



score1 <- c(rnorm(10,5,1),rnorm(10,4.5,.8),rnorm(10,5.1,.75))
score2 <- c(rnorm(10,6,1.4),rnorm(10,6.5,1.6),rnorm(10,7.1,1.1))
cond <- rep(c("b","r","w"), each = 10)
d <- data.frame(cond,score1,score2)

#Same hypothesis as on the exam, flag colors and national identity
#is score

#Conduct one-way ANOVA
#Conduct post-hoc pairwise comparisons
#Conduct orthogonal contrasts






