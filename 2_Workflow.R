# Week 2

#Workflow basics  ####------------------------------------------------


y <- 56
x <- 43
seq(1,10)
x
library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

fliter(mpg, cyl = 8)
filter(diamond, carat > 3)

#q2

filter(mpg, cyl == 8)
filter(diamonds, carat > 3)

#alt shft k brings up the keyboard shortcut list

# Data transformation ####---------------------------------

install.packages("nycflights13")
library(nycflights13)
flights
view(flights)
#^ Is displaying the entire data frame/tibble
flights <- flights

#dplyr tools

#filter(rows)
#arrange
#select (variables/columns)
#mutate (creates new variables with existing
#summarise 
#group_by (changes scope of function to focus on one part)

# general form: function(dataframe, what you want to do) and result is the new dataframe   
#note, use == with filter to denote what you want to filter
jan_1 <- filter(flights, month == 1, day == 1)
#note in the above the <- is being used to put the filter in the data frame in the environment
dec_25 <- filter(flights, month == 12, day == 25)

# Logical Operators
# & =AND
# | = OR
# ! = NOT
#examples
filter(flights, month == 11 | month ==12)
#        The above example returns all flights in November and December. CANNOT express as (11 | 12)

# simplification of previous code, creates a short list and gets data based upon list (list being c)
filter(flights, month %in% c(11,12))

#multiple ways to filter using different logic layers ie see following. 
#extra conditions/logic gets condusing fast and hard to know if you have done it correctly.
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120 & dep_delay <= 120)
#Can assign filters to a factor in the environment
#NAs are contagious like in excel
#can use "is.na()" to t/f check for missing data

# Exercises 5.2.4
#1 
#a
filter(flights, arr_delay > 120)
#tibble returns 10,034 results for arrival delay greater than two hours

#b
filter(flights, dest == "IAH")
# fligts bound for IAH  = 7,918

filter(flights, dest == "HOU")
# flights bound for HOU = 2,115
7918 + 2115
# total flights to Houston are 10,033
filter(flights, dest %in% c ("HOU", "IAH"))
#returns 9313
 #marks way: also yields 9313. Lots of ways to skin a cat.
filter(flights, dest == "IAH" | dest == "HOU")

#c
#unique(flights$carrier) to find the values of the carriers. Need to use this for own DF if there is no metadata
unique(flights$carrier)
filter(flights, carrier == "UA")
# UA returns 58,655
filter(flights, carrier == "AA")
#AA returns 32,729
filter(flights, carrier == "DL")
#DL returns 48,110

58655 + 32729 + 48110
#Total flights across these three carriers: 139494

# below is trying to filter for all three
filter(flights, carrier == "UA" & "AA" & "DL") #this won't work due the the &s saying the obs must have all three carriers.
filter(flights, carrier %in% c("AA", "UA", "DL"))

my_airlines <- c("AA", "UA", "DL")
filter(flights, carrier %in% my_airlines)

# returns 139,504
# the next code is the longer form, without logical simplifiers. Returns the same value
filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")

#d
filter(flights, month %in% c (7,8,9))
#flights in months 7,8,9 (summer) number 86,326

#e 
filter(flights, arr_delay > 120, dep_delay == 0)
#flights with arrival delay more than 2 hours but left on time, are 3

#f
filter(flights, dep_delay > 60, arr_delay < (dep_delay - 30))
#1819
#number of flights that were delayed by over and hour, but made up more than 30mins en route

#g
filter(flights, dep_time <= 0600)
#number of flights between midnight and 0600 is 9344.

# for further understanding playing around to find flights between 6 and 8am
filter(flights, dep_time < 0800 & dep_time > 0600)


#2
#dplyr between
??deplyr
help("dplyr-package")
#dplyr:between is a a way of selecting data with vector values in a given range.
 
#3
#number of flights without dep_time in dataset:
#code from https://stackoverflow.com/questions/24027605/determine-the-number-of-na-values-in-a-column
sum(is.na(flights$dep_time))
#8255


#Arrange
#changes the way data is displayed. e.g.:
arrange(flights, desc(arr_delay))


#5.3.1

#1
arrange(flights, desc(is.na(dep_time)))
#this brigngs the dep_time NAs to the top of the data.
#2
arrange(flights, desc(arr_delay))
arrange(flights, desc(dep_time))
# first and second part being the most delayed and the the earliest departing.
#4
distance_df <- arrange(flights, distance, year, month, day)
view(distance_df)
#distance_df <- arrange(flights, distance, year, month, day)
#view(distance_df)
#This shows data in ascending distance, could reverse to with 'desc' for largest distance travelled.


#Select
#Selects the columns you want
select(flights, distance, year)
#or Existing data set, but remove some variables with '-'
select(flights, -(year :dep_time))

#to bring a variable to the front:
select(flights, distance, everything())

#other useful arguments: starts_with, ends_with, contains, matches, rename
select(flights, starts_with("sched"))
#this is v cool, ensure the " " are used as we are searching for names.

#5.4.1 Exercise (Select)
#1 
# To get these variables we could select indiv, select with start/end/contains, :
#2
# Selecting variable names multiple times only grabs the column once, excludes duplicates
#3
#any_of() grabs the data need from an object, ie select within a smaller portion of data, or object that be applied to other dataset
#4
# code shouldn't work because TIME is capitalised, generally r is case sensitive, tidyverse verbs arent. can change this with an arg


#mutate
#creating new variables
#making a small flights dataset for simplicity
flight_small <- select(flights, year:day, ends_with("delay"), distance, air_time)

mutate(flight_small,
       gain = dep_delay - arr_delay,
       speed = distance / air_time * 60,
       hours = air_time / 60,
       gain_per_hour = gain / hours)

#note as seen above you can use variables mutate in the previously line, even in the same portion of code. 
#see gain and speed used in sequential lines
#must be careful with mutations as the scaling is constant here, but if vectors aren't in favour of this you can code bad things
#lead and lag functions are useful for comparisons. MANY uses for mutate. NOTE that 


#5.5.2 Ecercises: mutate
#1 Having trouble conceptualising the change but do understand code
flight_24hour <- select(flights, year:day, contains("dep"))
mutate(flight_24hour, 
       nice_dep_time = dep_time * 1440)
#2
The difference of the mutation is the hourly difference, would need changing to minutes.

#5 
1:3 + 1:10
#This returns an error message that the object lengths are different. This is useful as it illustrates the importance of being careful when mutating as values would be recycled to complete


#Summarise (grouped summaries)
#   Collapses data frame to single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
#the above code summarises the mean delay accross whole dataset wuith NAs removed.
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
# This gives a daily average delay with NAs removed.

#workflow scripts  ####------------------------------------------------

#5.6.7
#1 brainstorming
#To assess the various scenarios regarding lateness Create a new variable of early and late (sched_arrival-arrival) with can be summarised to find the mean, Arrival delay is more important that dep_delay, as the latter can be offset by gain.
#3 cancelled flights is not optimal as it should only refer to arr_delay not the or dep_delay NA errors. The latter is more important.





#Returning on 28/10/21 to revisit reformatting time####___________
#I had trouble initially understaning how to transform the discontinuous time data in 5.5.1 regarding departure
#copying it down and changing the :
##5.5.2 Ecercises: mutate
#1 Having trouble conceptualising the change but do understand code
flight_24hour <- select(flights, year:day, contains("dep"))
mutate(flight_24hour, 
       nice_dep_time = dep_time * 60)
view(flight_24hour)
#this yields a rooted column. FAIL.




#The select function is grabbing flight particulars and all columns with 'dep' in the title. How to convert them to minutes since mightnight.
#Brainstorm, separate into hours and minutes then multiple hours by 60 and add minutes. But how...
?'%/%'
#dividing by 100 should get to hour time in decimal, but decimals arent indicative of minutes in this case.
#%% and %/%. The former does the division and keeps the remainder while the latter rounds the division to the nearest whole number.
1504 %% 100
#=4,see above calculations meaning minutes remaining after calculating hour i.e. the division
1504 %/% 100
#=15, that is whole number without remainder in hours. 
#in practice...
mutate(flight_24hour,
       test1_minutes_since_midnight = dep_time %/% 100 * 60, + dep_time %% 100)
#still not quite right, it decomposes the two calculations into two columns and labelling could be better
#DIDNT work becase of the comma, removing it make the code work correctly. But am unsure the need for adding the %% 1440 after the mutation (from solutions)
mutate(flight_24hour,
       dep_m.s.m_test = dep_time %/% 100 * 60 + dep_time %% 100) %% 1440
arrange(flight_24hour, desc(test1_minutes_since_midnight))
arrange(flight_24hour, asc(dep_m.s.m_test))

#setting it for real to make the columns we want
mutate(flight_24hour,
       depmsm = dep_time %/% 100 * 60 + dep_time %% 100) %% 1440
#could do the same by creating a tibble with arrival time i.e. 'time' filter and same calculations.
#take away is that %/% and %% create a whole number and remainder which can be useful in separating values depending how they are recorded.