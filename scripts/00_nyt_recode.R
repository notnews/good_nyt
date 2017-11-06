"

Takes NYT Clean Data,
Cleans up Sections + Byline (parses out authors) 

"

# Set directory
setwd(githubdir)

# Load libs 
library(readr)
library(stringr)
library(gender)
library(tidyr)
library(dplyr)
library(ggplot2)
library(goji)

# Read in the data
nyt <- read_csv(paste0(basedir, "data/media/nyt/nyt.csv"))
names(nyt) <- tolower(make.names(names(nyt)))

# Take out bad years
nyt <- subset(nyt, !is.na(publication.year) & publication.year!= 11310)

# Recode

# News Category

# Variables of Interest
# online.section -- nytimes.com section(s) in which article is placed
# news.desk --- news desk that produced the article.
# descriptors --- hand indexed (too much info.)
# types.of.material --- ...

# news.desk
nyt$news.desk[nyt$news.desk %in% c('Metropolitan desk', 'Metropolitian desk')]  <- 'Metropolitan Desk'
nyt$news.desk[nyt$news.desk == 'Business/Financial Desk'] <- 'Financial Desk'

# news.desk Based Classification

nyt$categories <- NA

# Arts
arts <- c("Art and Leisure Desk", "Museums", "Arts Almanac Supplement", "Cultural Desk - SummerTimes Supplement",
	      "Cultural", "Arts", "The Arts", "Arts/Cultural Desk", "Cultural Desk", "Arts and Leisure Desk",
	      "Arts & Leisure", "Cultural Desk;", "Arts & Liesure Desk", "The Art/Cultural Desk", "Cultural/Arts Desk",
	      "The Arts/Cultural Desk", "Tha Arts/Cultural Desk", "<br>The Arts/Cultural Desk", "The Arts\\Cultural Desk",
	      "Summer Arts Supplement", "Arts & Ideas/Cultural Desk", "Art & Ideas/Cultural Desk", "The Arts/Cultrual Desk",
	      "Cultural desk")

style <- c("Style", "Style Desk", "Stlye Desk", "Styles of the Times Desk", "Men's Fashions of The Times Magazine",
	      "Style Desk;", "Style of The Times", "Styles of The Times Desk", "Styles of The TimesStyles of The Times",
	      "Styles of the Times", "Men's Fashions of The Times", "Men's Fashions of The TimesMagazine",
	      "Men's Fashion of The Times Magazine", "Men's Fashion of the Times Magazine", "T: Women's Fashion Magazine",
	      "T: Men's Fashion Magazine", "Thursday Styles Desk", "Style and Entertaining Magazine",
	      "Men's Fashions of the Times Magazine", "Fashions of the Times Magazine", "Fashions of The Times Magazine",
	      "Living DeskStyle Desk", "House & Home/Style Desk", "Styles of The Times", "Thursday Styles",
	      "Style and Entertaining MagazineStyle and Enter") 

books <- c("Book Review Desk", "Book Review Dest", "Book Reviw Desk")

travel <- c("TravelDesk", "Travel Desk", "Sophisticated Traveler Magazine", "T: Travel Magazine", "Travel DeskTravel Desk", "Escapes")

local <- c("Metropitan Desk", "Metroploitan Desk", "Metropoliton Desk", "Metropolitan", "Metropolitan Desk;",
	       "Metrpolitan Desk", "Metropolian Desk", "Metropoltan Desk", "Metropolitan Desak", "Metropolitan Deski",
	       "Metroplitan Desk", "qMetropolitan Desk", "Metrolpolitian Desk", "Metropolitain Desk", "Metroploitian Desk",
	       "Metropolitan Desk", "Connecticut Weekly Desk", "New Jersey Desk", "New Jersey Weekly Desk",
	       "Westchester Weekly Desk", "Westchester Weekly Deask", "Long Island Weekly Desk", "Long Island Waekly Desk",
	       "Long Island Weekly", "Long Island Desk", "New Jersey Weely Desk", "The City Weekly Desk", "The City Weekly",
	       "The City" , "The City Weekly Section", "The City Desk", "City Weekly Desk", "The City Weekly/Queens",
	       "The City Weelky Desk", "TheCity Weekly Desk", "The City/Weekly Desk", "New Jersey/Weekly Desk",
	       "The City Weeky Desk", "Connecticut Desk", "Metropoliatn Desk", "Metropoltian Desk", "Metro Desk",
	       "The City Weekly Deslk", "The City Weekly Desk\n The City Weekly Desk", "The City Weekl Desk",
	       "Metropolitan DeskMetropolitan Desk", "Connecticut Weekly desk", "New Jerey Weekly Desk",
	       "Metropolitan Desk Section D", "Metropolitian Desk", "Metropolitan Dsk", "Metropolitan Deskreign Desk")

sports <- c("Sport Desk", "Sports", "Sports Desk", "Sports Deks", "Adventure Sports", "Sports DEsk",
	        "Sports DeskSports Desk", "Sports Deskk")

gensoft <- c("Holiday Times Supplement", "Spring Times Supplement" , "Summer Times Supplement",
	         "Summer Times Supplementa", "Autumn Times Supplement", "Winter Times Supplement",
	         "Home Entertaining Magazine",  "Television Desk", "Social Desk", "House & Home/Style",
	         "Style and Entertaining Magaziner", "House & Home\\Style Desk","Wireless Living", "T: Design Magazine",
	         "T: Living Magazine", "Televison Desk", "T: Beauty", "THoliday", "Play", "Play Magazine",
	         "Home Design Desk", "Home Design Magazine", "Entertaining Magazine", "Televison", "Society Dek",
	         "Springs Times Supplement",  "Television", "Living Desk;", "Society DeskMetropolitan Desk", "Technology",
	         "Business Travel", "The New Season Magazine", "House and Home Style", "The Marathon", "Society Desk" )

realest <- c("Real Estate", "Real Estate Desk", "Commercial Real Estate Report", "Residential Real Estate Report",
	        "Real Estate Desk", "Real Estate desk", "Real Estate desk", "Real Estate", "Commercial Real Estate Report",
	        "Residential Real Estate Report", "Real Estate desk", "Commercial Real Estate Report", "Residential Real Estate Report",
	        "Real Estate Desk")

persfin <- c("Careers Supplement Desk", "Careers Supplement" , "Financial Planning Guide: Personal Investing",
	        "Financial Planning Guide: Personal", "Workplace", "Retirement", "Financial Planning Guide: Your Taxes",
	        "Job Market Desk", "Job Market", "Your Taxes Supplement", "Personal Investing Supplement Desk")

bizfin <- c("Financial Desk", "Financial", "Business Desk", "Business/Finance Desk", "Business/Financial Desk;",
	       "Financial/Business Desk", "Business/Foreign Desk", "Money and Business/Financial Desk",
	       "Money & Business/Financial Desk", "Money & Business/Financial Desk", "Monet and Business/Financial Desk",
	       "Money and Busines/Financial Desk", "Money andBusiness/Financial Desk", "Money and Business/FinancialDesk",
	       "Business/FinancialDesk", "Business/Finacial Desk", "Business/Financial Desk Section D", "Money and Business/Financial",
	       "Money & Businees Desk", "Business Day/Financial", "Money and Business/Financial DeskMoneyand Bus",
	       "Business\\Financial Desk", "Business/Finanical Desk", "Financial Desk;", "Money and Business/Financial DeskMoney and Bus",
	       "Business/Financial desk", "DealBook", "Moneyand Business/Financial Desk", "SundayBusines", "SundayBusinessSundayBusiness",
	       "SundayBusiness", "Business/Financial", "Business/Financial DeskBusiness/Financial Desk", "Money and Business/Fiancial Desk",
	       "Small Business", "Business World Magazine", "Sunday Business", "BIZ", "The Business of Green",
	       "The Business of Health", "Retail")

cars <- c("Autmobiles", "Automobile Show Desk", "Automobies", "Automoiles", "AuTomobiles", "Automobile Desk", "Cars",
	      "Automobliles", "Automoblies", "Autombiles", "Automobile", "Automobiles Desk", "Automobles", "Automobiles")

leisure <- c("Arts CultureStyle Leisure", "Weekend Desk", "Weekend Desk", "Leisure/Weekend Desk", "Weekend DeskWeekend Desk",
             "Weekend Desk;", "Vacation", "Arts and Leisure Desk Desk", "Movies, Performing Arts/Weekend Desk",
             "Movies,Performing Arts/Weekend Desk", "Summer Movies", "Movies, Performing Arts/Weekend DeskMovies, Pe",
             "Business Financial Desk", "Arts and Leisure")

health <- c("Good Health Magazine", "The Good Health Magazine", "Health and Fitness", "Health&Fitness",
	        "Women's HealthWomen's Health", "Women's Health", "Health & Fitness", "Health & Fitness Desk" ,
	        "Men's Health", "Men & Health", "PersonalHealth", "Health")

fnews <- c("Foreign desk", "Foriegn Desk", "Foreign DEsk", "Foreignl Desk", "1;             Foreign Desk", "Foreign Desk")

natdesk <- c("National Desk", "National Edition - Final", "National Deskl", "Natioanl Desk", "National Dsek",
	         "National News", "National", "National desk", "National DeskNational Desk", "National Desk;"  )

living <- c("Living Desk  Section C", "Living Desk", "Living DeskLiving Desk")

classifieds <- c("Classified", "Classified Desk", "Classifed", "Classifieds", "Classsified", "Classfied", "classified" )

dining<- c("Dining In, Dining Out", "Dining in, Dining out/Style Desk" , "Dining In/Dining Out" ,
	       "Dining In/Dining Out/Living Desk", "Dining In, Dining Out/Style Desk", "Dining In, Dining Out/Cultural Desk",
	       "Dining, Dining Out/Cultural Desk", "Dining In, Dining Out/Style DeskDining In, Din"  )

misc <- c("Survey of Education Desk", "Summer Survey of Education", "Op-Ed at 20 Supplement", "World of New York Magazine",
          "Education Life SupplementMetropolitan Desk" ,  "Education Life", "Education Life Supplement", "Education Life Supple", 
          "Magazine DeskMetropolitan Desk", "Citcuits", "Circuits", "Circuits Desk","CircuitsCircuits",
          "Education Life SupplementEducation Life Supple", "E-Commerce", "Entrepreneurs", "The Millennium",
          "The Millenium", "Generations", "Flight", "Week" , "Metro", "Working", "Giving",  "The Year in Pictures",
          "The Year In Pictures" , "2005: The Year In Pictures", "ContinuousNews", "Voter Guide 2004" )  

home <- c("Home Desk", "Home DeskHome Desk", "Home Desk;", "Home Desk;", "Home Desk", "Home DeskHome Desk")                                   
wkinrev <- c("Week in Review desk", "Week in Review Desk", "Week In Review", "Week in Review", "Week in Review Desk",
	        "Week in Review desk", "Weekin Review Desk", "Week In Review Desk", "Week in review desk",
	        "Week in Review Deskn", "Week In Review DeskWeek In Review Desk")

edit <- c("Editorial desk", "Editoral Desk", "Editorial Desk", "Editorial Desk")

science <- c("Science Desk", "Science","Science Desk;", "The Natural World", "Science Desk")

obits <- c("Obituary",  "Obits", "Obituary")

mgz <- c("Magazine Desk", "New York, New York Magazine", "Magazine", "Magazine Desk", "New York, New York Magazine")                                                                     
nyt$categories[nyt$news.desk %in% arts]    <- "Arts"
nyt$categories[nyt$news.desk %in% style]   <- "Style"
nyt$categories[nyt$news.desk %in% books]   <- "Books"
nyt$categories[nyt$news.desk %in% travel]  <- "Travel"
nyt$categories[nyt$news.desk %in% local]   <- "Local"
nyt$categories[nyt$news.desk %in% sports]  <- "Sports"
nyt$categories[nyt$news.desk %in% gensoft] <- "Gen Soft"
nyt$categories[nyt$news.desk %in% realest] <- "Real Estate"
nyt$categories[nyt$news.desk %in% persfin] <- "Personal Finance"
nyt$categories[nyt$news.desk %in% bizfin]  <- "Business Finance"
nyt$categories[nyt$news.desk %in% cars]    <- "Cars"

nyt$categories[nyt$news.desk %in% leisure] <- "Leisure"
nyt$categories[nyt$news.desk %in% health]  <- "Health"
nyt$categories[nyt$news.desk %in% fnews]   <- "Foreign News"
nyt$categories[nyt$news.desk %in% natdesk] <- "National"
nyt$categories[nyt$news.desk %in% living]  <- "Living"
nyt$categories[nyt$news.desk %in% classifieds] <- "Classifieds"
nyt$categories[nyt$news.desk %in% dining]  <- "Dining"
nyt$categories[nyt$news.desk %in% misc]    <- "Misc"

nyt$categories[nyt$news.desk %in% home]    <- "Home Desk"
nyt$categories[nyt$news.desk %in% wkinrev] <- "Week in Review"
nyt$categories[nyt$news.desk %in% edit]    <- "Editorial"
nyt$categories[nyt$news.desk %in% science] <- "Science"
nyt$categories[nyt$news.desk %in% obits]   <- "Obits"
nyt$categories[nyt$news.desk %in% mgz]     <- "Magazine"

# Online Section
# -----------------
nyt$opinion      <- grepl("Opinion", as.character(nyt$online.section))
nyt$obituaries   <- grepl("Obituaries", as.character(nyt$online.section))
nyt$corrections  <- grepl("Corrections", as.character(nyt$online.section))
nyt$classifieds  <- grepl("Classified", as.character(nyt$online.section))

# Apolitical News
# -----------------

# Based on news.desk
nyt$news_desk_soft <-  nyt$categories %in% c("Arts", "Books", "Cars", "Dining", "Gen Soft", "Leisure", "Living", "Sports",
                                           "Style", "Travel", "Personal Finance",  "Health", "Real Estate")

# Based on online.sections

# NA to Sections with more than 1 label
nyt$online_sectionr <- ifelse(grepl(";", nyt$online.section), NA, nyt$online.section)

# Match only where there is one label
nyt$onlines_soft <-  nyt$online_sectionr %in% c("Automobiles", "Arts", "Theater", "Dining and Wine", "Movies", "Style",
	                                          "Books", "Home and Garden", "Sports", "Travel")

# Match any of the labels; code if one or more matches
matches <- lapply(c("Automobiles", "Arts", "Theater", "Dining and Wine", "Movies", "Style","Books", "Home and Garden",
	                "Sports", "Travel"), grepl, nyt$online.section, fixed = TRUE)

nyt$onlinem_soft <- rowSums(as.data.frame(matches)) > 0

# Opinion
nyt$op <- nyt$online_sectionr == 'Opinion'

# Wires
nyt$wire <- nyt$byline %in% c(" AP ", "(AP)", "Reuters", "(Reuters", "(REUTERS)")

# Time
# -----------
nyt$publication.month <- as.numeric(nyt$publication.month)
nyt$quarter <- with(nyt, ifelse( publication.month <= 3, 1,  ifelse(publication.month <= 6, 2, ifelse(publication.month <= 9, 3, 4))))

# This code is necessary to make the values unique
nyt$pdom2 <- ifelse(nyt$publication.day.of.month < 10, paste0("0", nyt$publication.day.of.month), nyt$publication.day.of.month)
nyt$m2    <- ifelse(nyt$publication.month < 10, paste0("0", nyt$publication.month), nyt$publication.month)

nyt$year.quarter   <- paste0(nyt$publication.year, nyt$quarter)
nyt$day.month.year <- paste0(nyt$publication.year, nyt$m2, nyt$pdom2)

# Make some dates
nyt$day2   <- ifelse(nchar(nyt$publication.day.of.month) < 2, paste0("0", nyt$publication.day.of.month), nyt$publication.day.of.month)
nyt$month2 <- ifelse(nchar(nyt$publication.month) < 2, paste0("0", nyt$publication.month), nyt$publication.month)
nyt$rdate  <- as.Date(paste0(nyt$day2, nyt$month2, nyt$publication.year), "%d%m%Y")

nyt$monthly <- as.Date(cut(nyt$rdate, breaks = "month"))

# Journalist cols.
# ------------------

# Number of authors
nyt$n_authors <- str_count(nyt$normalized.byline, ";") + 1
nyt$n_authors[!is.na(nyt$normalized.byline) & nyt$n_authors == 0] <- 1 

# Declare n_authors new columns
authcols    <- paste0("author", 1:max(nyt$n_authors, na.rm = T)) 
nyt[, authcols]  <- NA

# Split by authors
authors <- strsplit(nyt$normalized.byline, ";")

for(i in 1:length(authcols)) {
	nyt[, authcols[i]] <- sapply(authors, "[", i)
}

# Author f_names
authcols_fname    <- paste0("author_fname", 1:max(nyt$n_authors, na.rm = T)) 
nyt[, authcols_fname]  <- sapply(nyt[, authcols], function(x) sub("\\s.*","", sub('.*,\\s*','', x)))

# Custom ggplot theme
cust_theme <- 
theme_minimal() +
theme(panel.grid.major = element_line(color = "#e1e1e1",  linetype = "dotted"),
      panel.grid.minor = element_blank(),
      legend.position  = "bottom",
      legend.key       = element_blank(),
      legend.key.width = unit(1, "cm"),
      axis.title   = element_text(size = 10, color = "#555555"),
      axis.text    = element_text(size = 10, color = "#555555"),
      axis.title.x = element_text(vjust = 1, margin = margin(10, 0, 0, 0)),
      axis.title.y = element_text(vjust = 1),
      axis.ticks   = element_line(color = "#e1e1e1", linetype = "dotted", size = .2),
      axis.text.x  = element_text(vjust = .3),
      plot.margin = unit(c(.5, .75, .5, .5), "cm"))
