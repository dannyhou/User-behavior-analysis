datafile = "user_behavior_d7.csv"
dfdata = read.csv(datafile, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

name1 <- names(dfdata)
name2 <- c("userid","request_contact","request_search_phonenum", "request_lbs", 
           "accept_contact","accept_search_phonenum","accept_lbs",
           "req_accept_contact",   
           
           "req_accept_search_phonenum","req_accept_lbs",      
           
           "friend_auto_new","reply",                     
           
           "no_reply","Msg","freq_chat", "gender",                   
           
           "age","msg_chat_sticker","day_chat_sticker",        
           
           "action_download_sticker","day_download_sticker","lbs","day_lbs",                   
           
           "msg_chat_group", "day_chat_group","msg_chat_photo","day_chat_photo",         
           
           "msg_week2","day_chat_week2")



dfdata1 <- dfdata[name2]
dfdata1 <- dfdata1[dfdata1$age >0,]
dfdata1$gender <- as.factor(dfdata1$gender)


library(ggplot2)
library(MASS)

#******************************* histogram of gender 0 vs 1 ********************************#

ggplot(dfdata1, aes(age, fill=gender))+  
  geom_histogram(alpha = 0.5, binwidth=1.5, position = 'dodge')+ 
  scale_fill_manual(values=c("black", "red"))

#******************************* test for normality of msg-chat *******************************************************#
m = mean(dfdata1$Msg)
s = sd(dfdata1$Msg)

test <- ks.test(dfdata1$Msg,"pnorm")
par(mfrow=c(1,2)) 
qqnorm(dfdata1$Msg,main='qqnorm')
qqline(dfdata1$Msg,main='qqline')

# ****************************** Testing differences ******************************************************#
# Diference of msg-chat between male vs female
wilcox.test(Msg ~ gender, data = dfdata1)

# Diference of msg-chat between users download sticker vs users don't download sticker
dfdata1$hasdown = 0
dfdata1[dfdata1$day_download_sticker > 1, ]$hasdown = 1
dfdata1[dfdata1$day_download_sticker <= 1, ]$hasdown = 0
dfdata1$hasdown <- as.factor(dfdata1$hasdown)
wilcox.test(Msg ~ hasdown, data = dfdata1)

# Histogram msg of 2 users groups:users download sticker vs users don't download sticker
par(mfrow=c(1,2)) 
p1 <- hist(dfdata1[dfdata1$hasdown==1,]$Msg, col="blue", main="Users download sticker", xlab = "msg")
p0 <- hist(dfdata1[dfdata1$hasdown==0,]$Msg, col="red", main="Users don't download sticker", xlab = "msg")



# ****************************** Linear Analysis & ANOVA Analysis ******************************#
# Use data having Msg > 1
dfdata_positive <- dfdata1[dfdata1$Msg >1,]
dfdata_positive$logmsg <- log(dfdata_positive$Msg)
dfdata_positive <- dfdata_positive[dfdata_positive$logmsg > 0,]
graphics.off

# boxcox transformation
bc <- boxcox(logmsg ~ accept_contact + accept_search_phonenum + accept_lbs + friend_auto_new + action_download_sticker, data = dfdata_positive ,  lambda = seq(-5, 5, length = 10), plotit = TRUE)
bc <- data.frame(bc)
maxlikelihood = max(bc$y)
lambda <- bc[bc$y==maxlikelihood,]$x
dfdata_positive$logmsg_lambda <- dfdata_positive$logmsg^lambda
model <- lm(logmsg_lambda ~ accept_contact + accept_search_phonenum + accept_lbs + friend_auto_new + action_download_sticker, data = dfdata_positive)


summary(model)
anova(model)
qqnorm(model$residuals,main='qqnorm')
qqline(model$residuals,main='qqline')


