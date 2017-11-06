#
# Number of Stories Per Author Per Year
# 

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

"
No. of Stories Per Author Per Year (entire newspaper)
"    

# Assuming no duplicate author names + missing at random
nyt_s <- 
  nyt[, c(authcols, "publication.year")] %>%
  gather(key, name, -publication.year)

# No. of Articles Per Author per year
n_art_auth_yr <-
  nyt_s%>%
  group_by(publication.year, name) %>% 
  summarize(n = n()) %>%
  group_by(publication.year) %>%
  summarize(avg_n = mean(n), med_n = median(n))
 
ggplot(wire_news_yr, aes(publication.year, avg_wire)) + 
  geom_point(color = "#42C4C7") +
  ylab("Proportion of AP and Reuters News Stories") +
  xlab("Publication Year") +
  ylim(0, .1) +
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(0, 0)) +
  cust_theme

ggsave("good_nyt/figs/all_n_stories_per_auth_by_yr.pdf")
