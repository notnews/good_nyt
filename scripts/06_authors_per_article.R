#
# No. of authors per article over time
# 

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

# Average Number of Authors per Article
n_auth <-
  nyt %>%
  group_by(publication.year) %>%
  summarize(avg_n_auth = mean(n_authors, na.rm = T))
 
ggplot(n_auth, aes(publication.year, avg_n_auth)) + 
  geom_smooth(method = "loess", span = 0.3, colour = "#ccaaaa", alpha = 0.7, se = F) +
  geom_point(color = "#42C4C7", alpha = 0.35,) +
  ylab("Average Number of Authors Per Article") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(1, 1.5), breaks = seq(1, 1.5, .1), labels = nolead0s(seq(1, 1.5, .1)), expand = c(.03, .03)) +
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(0, 0)) +
  cust_theme

ggsave("good_nyt/figs/all_n_auth_by_yr.pdf")
