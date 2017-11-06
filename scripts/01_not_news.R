#
# Not News
# P(not_news) over time on front page, entire newspaper
#

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

"
Not News By Year (Entire Newspaper)

Def. Not News: 
1. Using News Desk --- news_desk_soft
2. Using Online Section --- onlinem_soft, onlines_soft

"

"
1. Proportion of Not News Stories by Month (Not News Using News Desk)
"    

# Not News per year
apol_news_month <-
  nyt %>%
  group_by(monthly) %>%
  summarize(avg_nds = mean(news_desk_soft))
 
ggplot(apol_news_month, aes(monthly, avg_nds)) + 
  geom_smooth(method = "gam", formula = y ~ s(x), colour = "grey", alpha = 0.05, se = F) +
  geom_point(color = "#42C4C7") +
  ylab("Proportion of News Stories About Cooking, Travel, etc.") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(.1, .5), breaks = seq(.1, .5, .1), labels = nolead0s(seq(.1, .5, .1)), expand = c(.03, .03)) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_apol_nd_by_month.pdf")
ggsave("good_nyt/figs/all_apol_nd_by_month.png")

"
2. Proportion of Not News Stories on A1 by Month (Not News Using News Desk)
" 

apol_front_news_month <-
  nyt %>%
  subset(page == 1 & section == 'A') %>%
  group_by(monthly) %>%
  summarize(avg_nds = mean(news_desk_soft))
    
ggplot(apol_front_news_month, aes(monthly, avg_nds)) + 
  geom_smooth(method = "gam", formula = y ~ s(x), colour = "grey", alpha = 0.05, se = F) +
  geom_point(color = "#42C4C7") +
  ylab("Proportion of News Stories About Cooking, Travel, etc. on A1") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, .3), breaks = seq(0, .3, .05), labels = nolead0s(seq(0, .3, .05)), expand = c(.03, .03)) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/a1_apol_nd_by_month.pdf")


"
3. Proportion of Not News Stories by Month (Not News Using Online Section)
" 

apol_os_month <-
  nyt %>%
  group_by(monthly) %>%
  summarize(avg_nos = mean(onlines_soft), avg_nms = mean(onlinem_soft), avg_nds = mean(news_desk_soft))

apol_os_month_l <- gather(apol_os_month, measure, value, avg_nos:avg_nds)
apol_os_month_l$measure <- car::recode(apol_os_month_l$measure, "'avg_nos' = 'Online Section'; 'avg_nds' = 'News Desk'; 'avg_nms' = 'Online Section (Multiple)'") 

ggplot(apol_os_month_l, aes(monthly, value, color = measure)) + 
  geom_smooth(method = "gam", formula = y ~ s(x), alpha = 0.05, se = F) +
  geom_point(alpha = .25) +
  ylab("Proportion of News Stories About Cooking, Travel, etc.") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, .5), breaks = seq(0, .5, .05), labels = nolead0s(seq(0, .5, .05)), expand = c(.03, .03)) + 
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_apol_3_by_month.pdf")
