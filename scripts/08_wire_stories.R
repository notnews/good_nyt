#
# Proportion of AP and Reuters stories
# 


# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

"
Proportion Wire Stories by Year (entire newspaper)
"    

# Not News per year
wire_news_yr <-
  nyt %>%
  group_by(publication.year) %>%
  summarize(avg_wire = mean(wire))
 
ggplot(wire_news_yr, aes(publication.year, avg_wire)) + 
  geom_point(color = "#42C4C7") +
  ylab("Proportion of AP and Reuters News Stories") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, .1), breaks = seq(0, .1, .005), labels = nolead0s(seq(0, .1, .005)), expand = c(.005, .005)) + 
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(.005, .005)) +
  cust_theme

ggsave("good_nyt/figs/all_wire_by_yr.pdf")
