#
# Proportion of Corrections
# 

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")
   
# Corrections per year
cor_yr <-
  nyt %>%
  group_by(publication.year) %>%
  summarize(avg_cor = mean(!is.na(correction.date)))
 
ggplot(cor_yr, aes(publication.year, avg_cor)) + 
  geom_smooth(method = "loess", span = 0.3, colour = "#ccaaaa", alpha = 0.7, se = F) +
  geom_point(color = "#42C4C7", alpha = 0.35) +
  ylab("Proportion of News Stories by Foreign News Desk") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, .25), breaks = seq(0, .25, .05), labels = nolead0s(seq(0, .25, .05)), expand = c(.03, .03)) +
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_cor_by_yr.pdf")
