#
# Proportion of News Stories produced by the Foreign News Desk
# 

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")
   
# Not News per year
int_news_month <-
  nyt %>%
  group_by(monthly) %>%
  summarize(avg_int = mean(categories == "Foreign News", na.rm = T))
 
ggplot(int_news_month, aes(monthly, avg_int)) + 
  geom_smooth(method = "loess", span = 0.2, colour = "#ccaaaa", alpha = 0.7, se = F) +
  geom_point(color = "#42C4C7", alpha = 0.35) +
  ylab("Proportion of Foreign News Desk Stories") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, .3), breaks = seq(0, .3, .05), labels = nolead0s(seq(0, .3, .05)), expand = c(.03, .03)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_int_by_month.pdf")
ggsave("good_nyt/figs/all_int_by_month.png")