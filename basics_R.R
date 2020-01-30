# clear environment
rm(list=ls()) 

# set the working directory
# Mac users can just paste the file path
# Windows users need the switch directions of slashes after pasting
setwd("C:/Users/Mike Denly/Google Drive/Stata and R Training/R Basics")

# create a country character vector
country = c("france","france","france","france","france", "france")

# create a vector with some years
# note: spacing doesn't matter
year = c(2000,2005,2010, 2015,2020,2025)

# we can inspect the vector
print(year)

# enter in the French poverty rate for these years
# note: NA is for missing (no data yet 2020 and 2025)
poverty_rate = c(13.6,13.1,14,14.2,NA,NA)

# enter in the French GDP per capita for those same years
gdp_per_capita = c(22364,34760,40368,36613,NA,NA)

df$juan = 100

# classify these GDP figures by low and high values
low_high = c("low","low","high","high","NA", "NA")

# make the low_high a factor variable
# so R knows that high is bigger than low
gdp_levels <- factor(low_high, levels = c("low", "high"))

# drop the initial low_high vector
# better to keep everything clear
rm(low_high)

# classes of vectors
class(country)
class(year)
class(poverty_rate)
class(gdp_per_capita)
class(gdp_levels)

# convert the vectors to a dataframe
df = data.frame(country,year,poverty_rate,gdp_per_capita,gdp_levels)

# add variable to data frame
ipd = c(0,1,1,1,0,9)

# remove the old vectors, so we just have a data frame
rm(country)

# inspect the data frame
View(df) # look at the whole thing
head(df) # get a quick view
summary(df) # get a quick summary

# get some descriptive statistics, while dealing with missing values
mean(df$gdp_per_capita, na.rm = TRUE) 

min_year = min(df$year)
print(min_year)

# drop all observations in the data frame with missing values
df = na.omit(df)

# or just drop the observations with missing GDP values
df<-subset(df, (!is.na(df$gdp_per_capita)))
# head(df)

# are GDP and poverty rate correlated
cor(df$gdp_per_capita,df$poverty_rate)

# make very nice LaTeX tables with stargazer
# installing packages and loading libraries
# install.packages("stargazer")
library(stargazer, quietly = TRUE)

# create a dataframe with just the gdp variable
# we do this because stargazer doesn't allow $ (dollar signs)
gdp_only = subset(df, select = c("gdp_per_capita"))

# now output that LaTeX table
stargazer(gdp_only, type = "html")

# if you need help 
?stargazer

###############################################
# Graphs with ggplot2
##############################################

# install ggplot2 and load the library
install.packages("ggplot2")
library(ggplot2)

# make scatter plot of poverty rate by year
scatter= ggplot(df, aes(x=year, y=poverty_rate)) + geom_point() +
  labs( x = "Year",
        y = "Poverty Rate",
        title = "The Poverty Rate in France",
        caption = "Source: World Bank")
print(scatter)

# export/save the graph
ggsave ("scatter.png", width=5, height=5)

# make a bar graph and save/export it
bar = ggplot(df, aes(x=year, y=gdp_per_capita)) + geom_bar(stat = "identity") +
  labs( x = "Year",
        y = "GDP Per Capita",
        title = "GDP Per Capita in France",
        caption = "Source: World Bank")
print(bar)
ggsave ("bar.png", width=5, height=5)

# make an area graph and save/export it
area = ggplot(df, aes(x=year, y=gdp_per_capita)) + geom_area() +
  labs( x = "Year",
        y = "GDP Per Capita",
        title = "GDP Per Capita in France",
        caption = "Source: World Bank")
print(area)
ggsave ("area.png", width=5, height=5)

# make a line graph and save/export it
line = ggplot(df, aes(x=year, y=gdp_per_capita)) + geom_line() +
  labs( x = "Year",
        y = "GDP Per Capita",
        title = "GDP Per Capita in France",
        caption = "Source: World Bank")
print(line)
ggsave("line.png", width=5, height=5)

# let's put the graphs next to each other, using packages you may need to install
install.packages ("gridExtra")
install.packages("egg")

library(gridExtra) 
library(egg) 
all_together = ggarrange(line,bar, nrow=2, ncol=1)
ggsave(all_together, filename = "all_together.png", width = 7.5, height = 4)
# save the dataframe for later use
write.csv(df, "french_data.csv")
