#
# Proportion of Female Journalists
# 
# Assuming author info. is missing at random

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

"
Proportion Female Authors (entire newspaper)
"    

# Wide to long for fname cols + pub.year
nyt_s <- 
  nyt[, c(authcols_fname, "publication.year")] %>%
  gather(key, name, -publication.year)

# Get gender assuming age = 40
nyt_s_gen <- 
  nyt_s %>% 
  distinct(name, publication.year) %>% 
  rowwise() %>% 
  do(results = gender(.$name, years = .$publication.year -40, method = "demo")) %>% 
  do(bind_rows(.$results))

# Proportion Female Authors per year
avg_fem_yr <-
  nyt_s_gen %>%
  select(proportion_female, year_max) %>%
  group_by(year_max) %>%
  summarize(avg_fem = mean(proportion_female))
 
ggplot(avg_fem_yr, aes(year_max + 40, avg_fem)) + 
  geom_point(color = "#42C4C7") +
  ylab("Proportion of Female Journalists") +
  xlab("Publication Year") +
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(.03, .03)) +
  scale_y_continuous(lim = c(.25, .5), breaks = seq(.2, .5, .05), labels = nolead0s(seq(.2, .5, .05)), expand = c(0, 0)) + 
  cust_theme

ggsave("good_nyt/figs/all_avg_fem_by_yr.pdf")

# Proportion of Female Journalists per article
# Missing at random

nyt_w <- 
  nyt_s %>%
  left_join(nyt_s_gen, by = "name") %>%
  group_by(year_max) %>%
  summarize(avg_fem = mean(proportion_female))
 
ggplot(nyt_w, aes(year_max + 40, avg_fem)) + 
  geom_point(color = "#42C4C7") +
  ylab("Proportion of Female Journalists Per Article") +
  xlab("Publication Year") +
  scale_x_continuous(breaks = seq(1987, 2007, 1), labels = substr(seq(1987, 2007, 1), 3, 4), expand = c(.03, .03)) +
  scale_y_continuous(lim = c(.0, .25), breaks = seq(0, .25, .05), labels = nolead0s(seq(0, .25, .05)), expand = c(0, 0)) + 
  cust_theme

ggsave("good_nyt/figs/all_avg_fem_per_art_by_yr.pdf")
ggsave("good_nyt/figs/all_avg_fem_per_art_by_yr.png")
