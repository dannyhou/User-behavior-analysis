# User-behavior-analysis
- Draw histogram of user by age of 2 user groups: male vs female
- Test normality of number of msg-chat of user
- Test differences of msg-chat between 2 groups: male vs female
- Test differences of msg-chat between 2 user groups: users download sticker and user don't download sticker
- Use linear model to evaluate the relation of a set of behavior and chatting behavior of user on social network
     + Use Box-cox to transform Msg before put it into model
     + Look at the residual analysis and ANOVA to analyse the variance of the model. I often look at the qqnorm to know if the residual is normally distributed. One other thing is that if p-value of F test less than 0.05, relation between independent variables and dependent variable siginificant
     
Refernces:
http://reliawiki.org/index.php/Simple_Linear_Regression_Analysis
http://www.ievbras.ru/ecostat/Kiril/R/Biblio/R_eng/R%20dummies.pdf
http://blog.minitab.com/blog/adventures-in-statistics/regression-analysis-how-do-i-interpret-r-squared-and-assess-the-goodness-of-fit
     
