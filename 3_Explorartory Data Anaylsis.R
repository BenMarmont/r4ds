#Week, chapter 5 EDA
# Exploratory Data Analysis####-------------------------------

library(tidyverse)

#not a formal process, more an exploratory and learned one.
# better to be approximately right, than accurately wrong. EDA encapsulates this, not a formal technique.
# Creative process
#considering variation between variables and covariation between variables

#Variation####----------------------------------------
?diamonds
ggplot(data=diamonds) +
  geom_bar(mapping = aes(x=cut))

diamonds %>%
  count(cut)

#continuous variables ar those that can take an infinite number of values
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x=carat), binwidth = 0.5)

diamonds %>% 
  count(cut_width(carat, 0.5))

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.1)

#binwidht is the size of each bar category, ie binwidth of 5 is 1-5,6-10,11-15 etc. Trade off of accuracy and easy of reading.

ggplot(data=smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = .1)
ggplot(data = smaller, mapping = aes(x = carat)) + 
  geom_histogram(binwidth = 0.01)
#when displaying large datasets, nothing may show on the graph, but that doesn't mean no data, perhaps there isn't enough to generate a pixel.

#moving to the old faithful example

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
# this graph is bimodal i.e. two peaks, quite interesting.

?faithful

ggplot(data = faithful, mapping = aes(x = waiting)) + 
  geom_histogram(binwidth = 0.25)

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

# in this case y is the width of the diamond#the scale is a bit wierd, now lets look to zoom in on the graph

ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) + 
  coord_cartesian(ylim = c(0, 50))

# the coord_cartesion with ylim is limiting the count so that low counts are included, for example the single observations and 27 and 58. For example, coord cartesion for a regression would use data outside the plot where as xlim wouldn't
#xlim by itself cuts data out, without coord_Cartesian

# the thought process of the above code to sort out unusual diamonds is findings those of unusual size and prices
unusual

#Exercises 7.3.4####-------------------
#1.
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = x)) +
  scale_x_continuous(limits = c(0,15))

?xlim

ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = y)) +
  scale_x_continuous(limits = c(0,15))


ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = z)) +
  scale_x_continuous(limits = c(0,15))

#comparing the previous three graphs offer the following insights:
# x and y tend to be similar in terms of quantity of observational values and location along the x axis(given they are fixed)
#z on the other hand has a more compact distribution at smaller values relative to x and y
#due to the more compact nature of the graph there is a higher max observational count.
# this means there is a more uniform relationship between length and width while depth is not so similar. This can be inferred as deeper diamonds being less common in this sample
?diamonds

#2.
ggplot(data = diamonds, mapping = aes(x = price, colour = cut)) +
  geom_histogram(binwidth = 500)
ggplot(data = diamonds, mapping = aes(x = price, colour = cut)) +
  geom_freqpoly(binwidth = 100)
#ideal cut diamonds dominate the lower price ranges, as price increases their share of observations decrease.

#3
ggplot(data = diamonds, mapping = aes(x= carat)) +
  geom_freqpoly(binwidth = .01) +
  xlim(0.98, 1.02)

#This plot shows that 0.99 carat diamonds number less than 100 in this dataset
#While those diamonds with carat = 1 number ~1600. 
#Noteably, the number of diamonds with 1.01 carats are 2,500. Suggesting that there is a preference for reporting diamonds greater than 1 carat

#Doing it via table (as mark did in the video)

point99 <- diamonds %>% 
  filter(carat == 0.99) %>% 
  count(carat)

point99
#the first line here is filtering the data and the second is viewing the smaller tibble

onecarat <- diamonds %>% 
  filter(carat == 1) %>% 
  count(carat)

onecarat

diamonds %>% 
  filter(carat == 1) %>% 
  count(carat)
#The final filter here doesn't create an element, just counts in the console.


#Missing values####------------------------------------
diamonds_filtered <- diamonds %>% 
  filter(between(y,3 ,20))

diamonds_missing <- diamonds %>% 
  mutate(y= ifelse( y < 3 | y > 20, NA, y ))

#this if statement creates a new y variables in the diamond missing element
#this will only keep variables between 3,10 and assign NA to the rest.

diamonds_missing <- diamonds %>% 
  mutate(y= ifelse( y < 3 | y > 20, NA, y ))

#way to put data into categorgies for work later
diamonds_category <- diamonds %>% 
  mutate(size_category = case_when( y < 7 ~ "small",
                                    y > 14 ~ "large",
                                    TRUE ~ "medium"))

diamonds_category
ggplot(data = diamonds_missing, mapping = aes(x = x, y = y)) +
  geom_point()
#this yields a plot of the relationship between x any y, but notes a warning of 9 NAs
ggplot(data = diamonds_missing, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)
#TRUE is case sensitive


library(nycflights13)

flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_minute = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_minute/60) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
    geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)

#this new variable is assuming that if the departure times are missing the flight is cancelled
#then it is separating times from poor time variables, this shouldn't happen if data quality is good

#Covariation--------------
Library(diamonds)

ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_freqpoly(mapping = aes(colour = cut), bindwidth = 500)

ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
#The first two plots are ones we have seen before where as the 3rd is calculating the density of the prices , i.e. relative

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()
#this boxplot reveals that the data has long tails and centered at the lower price ranges, plus there doesn't appear to be a premium for higher quality cuts


#Reorder---------
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x =reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot()
#this graph reorders the graph by taking the median of hwy in ascending order
#FUN is build in function shortcut
#could also be done outside of ggplot in a data frame
#tiding the graph by spacing the labels. Could also change the title for clarity
ggplot(data = mpg, mapping = aes(x =reorder(class, hwy, FUN = median), y = hwy)) +
  geom_boxplot() +
  coord_flip()
#the addition of coord flip puts the values on the y rather than x axis


#Exercises 7.5.1.1-----

#1: improving visualisation of departure times of cancelled flights
flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_minute = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_minute/60) %>% 
  ggplot(mapping = aes(sched_dep_time)) + 
  geom_boxplot(mapping = aes(colour = cancelled))


flights %>% 
  mutate(cancelled = is.na(dep_time),
         sched_hour = sched_dep_time %/% 100,
         sched_minute = sched_dep_time %% 100,
         sched_dep_time = sched_hour + sched_minute/60) %>% 
  ggplot(mapping = aes(sched_dep_time, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cancelled), binwidth = 1/4)
#I did it via box plot, Mark did it via density graph

#2 What variable is the most important in determining the price of diamonds
#I would normally run a regression, but not sure how yet.
?diamonds

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(colour = x), binwidth = 500)

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()
#price goes up with the number of carats, positive relationship, somewhat exponential

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_jitter()
#Seems to be a relationship between price and cut

ggplot(data = diamonds, mapping = aes(x = clarity, y = price)) +
  geom_jitter()
#clarity doesn't appear to have a big impact on price, massive over plotting and some what bell shaped.

ggplot(data = diamonds, mapping = aes(x = cut, y = carat)) +
  geom_boxplot()
#comparing cut and carat in the above plot shows that increasing the size diminishes the effect of a lower cut

#4
#install.packages("lvplot")
library(lvplot)
ggplot(data = diamonds, mapping = aes(x = cut, y = carat)) +
  geom_lv()
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_lv()
#lvplot reduces over plotting, and offsets the difficulties with long outlier tails on 

#5.
#geom_violin displays data distribution into smooth shapes which are easy to interpret, 
#however you lose some added information from the plot relative to a box plot
#each is suited to different data outputs, i.e. frequencies, medians, tails, visualised distributions, even dataset size.
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_violin()


install.packages("ggbeeswarm")

library(ggbeeswarm)

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_quasirandom()


#can't get beeswarm to work? 
#returning with Marks help this worked, had to add "." to install packages

#6
#geom_jitter helps to reduce over plotting to prevents data points overlapping. However, in large datasets
#it can just cause lots of black, i.e. in the above diamonds geom_jitter. Beeswarm is an alternative that spaces the points out further

#Two Categorical Variables--------------------

ggplot(data = diamonds) + 
  geom_count(mapping = aes(x = cut, y = color)) + 
  coord_flip()
#without coord_flip the cut labels overlapped.

diamonds %>% 
  count(color, cut) %>% 
  ggplot(mapping = aes( x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))
#this pipe graph is showing the correspondance between the two categorical variables after putting in a table
#but this relies on categorical variables being ordered

#if the categorical variables are unordered you could use the 'seriation' package so that you can reorder
#There are numerous packages that allow for categorical variables to be displayed

#Two Continuous Variables---------------

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point()

ggplot(data = diamonds, mapping = aes(x = carat, y = price)) +
  geom_point(alpha = 1/100)
#The alpha reduces the over plotting by changing the transparency of data plots. Good way to display large overlapping dataset

#if you have too much data again you can make bin data on a histogram in two dimensions
ggplot(smaller) + 
  geom_bin2d(mapping = aes(x = carat, y = price))
#So this is an alternative way to display without over plotting, can change colour scheme easily

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))
#This is creating bins for carat

ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))
#This code is generating a graph with 20 boxplots, each with the same amount of data. This shows the density of data where they are closer together

#Patterns
?faithful
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))
#Two distinct groups in the relationship between waiting time and eruptions.

#ggplot2calls
#making the code more concise
ggplot(data = faithful) +
  geom_point(mapping = aes(x = eruptions, y = waiting))
#same as
ggplot(faithful)+
  geom_point(aes(eruptions,waiting))
#but, using x and y specifications is good for troubleshooting

#The top part in R where this is written is permanent, console is temporary
#You can restart R by Session > restart R
#Important to comment out installing packages. Runs top to bottom, so loading libraries
#and assigning objects needs to be sequential.

getwd()
#above shows where everything is saved
#can set the working directory, but don't recommend it as it makes the code unreproducible for others
#R works across PC, Mac and Linux. This changes how / and \ works. Be aware if I change platforms,

#bad habit to snip graphs, utilise
#ggsave("NAME.png")
#This saves where the project is. This is why its important to have file with ALL R work.
#Use relative, not absolute pathways so that work can be reproduced painlessly

#7.5.3.1
#3 returning to run this graph to answer the question
ggplot(diamonds) + 
  geom_bin2d(mapping = aes(x = carat, y = price))
