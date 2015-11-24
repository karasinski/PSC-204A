# Load data
gwide <- read.csv("confidence.csv")

# Convert from wide to long format
public <- rep(c(0, 1), each = 150)
obs <- rep(c("t1", "t2", "t3"), 100)
time <- rep(c(0.5, 1.5, 2.5), 100)
id <- paste("id", 1:100, sep = "")
observation <- unlist(lapply(1:100, function(x) {gwide[x, 1:3]}))
glong <- data.frame(id, obs, time, public, observation)
head(glong)
tail(glong)

# Test for effect of public/private university
summary(aov(observation ~ public + Error(id), data = glong))

# Test for effect of observation
summary(aov(observation ~ obs + Error(id), data = glong))

# Add Polynomial Contrasts to describe trajectories
glong[, 6] <- contr.poly(3)[, 1]
glong[, 7] <- contr.poly(3)[, 2]

colnames(glong) <- c(colnames(glong[, 1:5]), c("l", "q"))

# Test to see linear/quadratic contrasts describe the observations
summary(aov(observation ~ l + q + Error(id), data = glong))
summary(aov(observation ~ l * public + q * public + Error(id), data = glong))

# Test for interation effect
summary(aov(observation ~ public * obs + Error(id), data = glong))

# Follow-up options Simple Effects split on interaction: e.g., public vs. private
summary(aov(observation ~ obs + Error(id), glong[which(glong$public == 0), ]))
summary(aov(observation ~ obs + Error(id), glong[which(glong$public == 1), ]))

pairwise.t.test(glong$observation, glong$obs, paired = TRUE, p.adjust = c("bonf"))


pairwise.t.test(glong[which(glong$public == 1), "observation"],
                glong[which(glong$public == 1), "obs"],
                paired = TRUE, p.adjust = c("bonf"))

# we shouldn't do this for the placebo group given that the test was not
# significant, but we can for the sake of practice here
pairwise.t.test(glong[which(glong$public == 0), "observation"],
                glong[which(glong$public == 0), "obs"],
                paired = TRUE, p.adjust = c("bonf"))

# or, using the polynomial contrasts
summary(aov(observation ~ l + q + Error(id), glong[which(glong$public == 0), ]))
summary(aov(observation ~ l + q + Error(id), glong[which(glong$public == 1), ]))
