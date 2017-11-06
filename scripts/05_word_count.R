#
# Average Length of Article Over Time
# 

# Set Working dir.
setwd(githubdir)

# Source recode
source("good_nyt/scripts/00_nyt_recode.R")

# Summary stat
summary(nyt$word.count)

# Min.  1st Qu.   Median     Mean  3rd Qu.     Max.     NA's 
#       0      132      415      608      864 30101630       48 

# Clearly some miscodings. 
length(nyt$word.count[!is.na(nyt$word.count) & nyt$word.count > 10000])
# 445

# Average Word Count
art_length <-
  nyt %>%
  subset(word.count <= 10000) %>%
  group_by(monthly) %>%
  summarize(avg_len = mean(word.count, na.rm = T))
 
ggplot(art_length, aes(monthly, avg_len)) + 
  geom_smooth(method = "loess", span = 0.3, colour = "#ccaaaa", alpha = 0.7, se = F) +
  geom_point(color = "#42C4C7", alpha = 0.35) +
  ylab("Average Word Count Per Article") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, 800), breaks = seq(0, 800, 50), labels = nolead0s(seq(0, 800, 50)), expand = c(.03, .03)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_word_len_by_mon.pdf")

# Median Word Count
art_length <-
  nyt %>%
  group_by(monthly) %>%
  summarize(avg_len = median(word.count, na.rm = T))
 
ggplot(art_length, aes(monthly, avg_len)) + 
  geom_smooth(method = "loess", span = 0.3, colour = "#ccaaaa", alpha = 0.7, se = F) +
  geom_point(color = "#42C4C7", alpha = 0.35) +
  ylab("Median Word Count Per Article") +
  xlab("Publication Year") +
  scale_y_continuous(limits = c(0, 800), breaks = seq(0, 800, 50), labels = nolead0s(seq(0, 800, 50)), expand = c(.03, .03)) +
  scale_x_date(date_breaks = "1 year", date_labels = "%y", expand = c(.03, .03)) +
  cust_theme

ggsave("good_nyt/figs/all_word_len_median_by_mon.pdf")
ggsave("good_nyt/figs/all_word_len_median_by_mon.png")
