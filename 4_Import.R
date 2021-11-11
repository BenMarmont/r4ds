#R for Data science workshop 4, first in new project
library(tidyverse)
library(nycflights13)

#Chapter 10:Tibbles ----
iris
as_tibble(iris)
#tibbles are a type of data frame. The main differences:
# It shortens the data to ten rows, and gives header types and labels
#You can creat a data frame as such below
tibble(
  x = 1:5,
  y = 1,
  z = x ^ 2 + y
)
#Tibbles never change the variable types, where as normal R may do this. Change string to factor for example
#default data frames don't label the same way

#you can make tibbles with non-syntactic names that normal R cannot handle, use back ticks(above)
tb <- tibble(
            `:)` = "smile",
            ` ` = "space",
            '2000' = "number"
)
tb
#hence when running the tb in the console you can see the non-syntax values

#tribble short for transposed tibble
tribble(
        ~x, ~y, ~z,
         #--|--|----
        "a", 2, 3.6,
        "b", 1, 8.5
        )
#the row under the column headers is the data type, <chr> means characterm <dbl> means double number
#when you print a tibble in the console in sends as many variables as fit in the screen
#if you wide screen it will print more rows
#you can print as a data frmae
as.data.frame(flights)
#another way of viewing data is to make it an object and open it in another script tab by clicking on the object in the environment
flights <- flights
#try not to use the mouse , script should work without any mouse interaction

#subsetting-----

df <- tibble(
  x = runif(5),
  y = rnorm (5)
  )
df

#extract by name----
df$x
#the above pulls all values in the x column from the df tibble
#or, alternatively, but longer
df[["x"]]
#if you are using a random number somewhere in the code but want to make the code
#reproduable, you can set the seed via
set.seed(123)

#Never refer to column placement, always call the name, so that dplyr manipulations don't cause issues

df %>% .$x
# if using a tibble in a pipe you need the .$ to say you are grabbing a function from a tibble, rather than an object

#Some older codes don't work as tibbles, can determin with
class(df)
#which shows what sort of data it is
#can change from tibble to df
df_as_dataframe <-  as.data.frame(df)
class(df_as_dataframe)
#base r functions tends to be .case, where tidyverse is snakecase (_case)

#10.5 Exercises--------------------
#1 
#How can you tell if an object is a tibble?
mtcars
#When printed mtcars displays the whole dataset, tibbles only display 10rows and as many columns as fit in the console
#Can also check with
class(mtcars)
#Which shows it is a dataframe

#2.
#df <- data.frame(abc = 1, xyz = "a")
#f$x
#df[, "xyz"]
#df[, c("abc", "xyz")]
df_as_dataframe
df
df$x
df[,"y"] #this is a refernce to row, column. As no row identifier will get all the rows, and the y column. Causes a character as a result
df[, c("x","y")] #This gets all the rows and all the culmns
#These operations may cause issues in a date frame because they are calling for a value with x in
#rather the the name column label

#3 
#to extract a reference variable
#df$. where '.' is a place holder for the variable you are trying to extract from the tibble. Extracting by possition uses [[.]]
#but this won't work here because it isn't in the tibble
#instead use 
df[[var]] #which is causing for an object


#4
#Practising referring to non-syntactic names
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
#i.extracting the variable 1
annoying$`1`
ggplot(data = annoying, mapping = aes(x = `1`, y = `2`))+
  geom_point()
#this didn't work initially for me as i used '' instead of ``, but after introducing the back ticks it did.

#ii)
annoying2 <- annoying %>% 
  mutate(`3` = `2` /  `1`)
annoying2
#back ticks can be used to preserve non-syntactically correct, i.e. normal case words in labels opposed to snake case
#Or, you can use syntax correct and change the labels before publication

#5
?tibble::enframe
#enframe() converts named atomic vectors or lists to one- or two-column data frames. For a list, the result will be a nested tibble with a column of type list. For unnamed vectors, the natural sequence is used as name column.
#deframe() converts two-column data frames to a named vector or list, using the first column as name and the second column as value. If the input has only one column, an unnamed vector is returned.
enframe(1:3)
#makes data into a tibble

#extension random distribution x random distribution, with result plotted against the input. Looks like a butterfly?
extension <- tibble(
  distribution_1 = rnorm(10000),
  distribution_2 = rnorm(10000),
  distributionxdistribution = distribution_2 * distribution_1
)
extension
ggplot(data = extension, mapping = aes(x = distribution_1, y = distributionxdistribution)) +
  geom_point()
ggplot(data = extension, mapping = aes(x = distributionxdistribution, y = distribution_1)) +
  geom_point()


#Chapter 11: Import--------------------
#Importing CSV data
?read_csv()
?read_csv2
#csv2 is a colon separated file rather than comma as some parts of the world use comma as the decimal separator
?read_fwf
#read fixed width file
#all of these have similar syntax (syntax being the order of words to form a syntax, in coding order of commands to form code)

#This will create a file called data
dir.create("data")
# here is a link to the csv we want
#https://github.com/hadley/r4ds/blob/master/data/heights.csv
#code to download data into r: download.file(url, destfile)

download.file("https://raw.githubusercontent.com/hadley/r4ds/master/data/heights.csv", "data/heights.csv")
#this downloads the data and puts it in the specified file

heights <- read_csv("data/heights.csv", skip = 19)

#you can remove meta data at the top of the file with ',skip = .'

#Exercises 11.2.2------------------
#1.
#reading csv where pipe (|) is the separator.
#read_delim("file.psv", "|")
#That is, Pipe Separated File

#2
#Arguments that read_csv and read_tsv have in common
?read_csv
?read_tsv
#Most of these arguments are the same

#3
#read_fwf most important arguments (Fixed Width File)
?read_fwf
#the most important arguments are; position, type, select in addition to normal read_ commands

#5
#Looking at the following commands and de terming what is wrong
read_csv("a,b\n1,2,3\n4,5,6")          
#We expect three columns, gets 2

read_csv("a,b,c\n1,2\n1,2,3,4")
#There is part data for a 4th column but has been dropped

read_csv("a,b\n\"1")
#3 inverted commas, so creates tibble with no data

read_csv("a,b\n1,2\na,b")
#Could confuse handling of NAs down the track

read_csv("a;b\n1;3")
#Has semi-colons separating data, where read_csv uses commas as separators.

#important take away from this question is that "\n" is shorthand for new line

#Parse----

#The parser is what converts the textual representation of R code into an internal form which
#may then be passed to the R evaluator which causes the specified instructions to be carried out. 
#The internal form is itself an R object and can be saved and otherwise manipulated within the R system.

?parse

#Numbers
#can change the number style
parse_double("1.23", locale = locale(decimal_mark = ","))
parse_double("1,23", locale = locale(decimal_mark = ","))
#The second works because the instructions regarding the decimal match

#can pull out of text too
parse_number("this cost $123.45")
parse_number("$123,456,789")
#works with comma separators on this 100 places

parse_number("$123.456.789")
#decimals as 100 separators need work
parse_number("$123.456.789", locale = locale(grouping_mark = "."))

#Characters
parse_character(donkey)
#needs speech marks
parse_character("donkey")

#non-English characters become problematic when parsing

#Factors
fruit <- c("apple", "banana")
#These are the factor levels we are expecting
parse_factor(c("apple", "banana", "bananana"), levels = fruit)
#This would be problematic because no banananana in level

#Dates
#This is the cause of many headaches due to the different date recording methods
parse_datetime("2010-10-01T2010")
#So this yeilds y/m/d time
#Assumes: no seconds, 24 hour time, time zone, date format
#You can format your own dates easily, there are many functions to do so, use book or ?()
#The best way to create the right format is to create some examples 

#11.3.5 Exercises---------
#Brief in video

#1
?locale(.)
?parse_number
#The locale controls defaults that vary from place to place. The default locale is US-centric (like R), 
#but you can use locale() to create your own locale that controls things like the default time zone, 
#encoding, decimal mark, big mark, and day/month names.
#The most important of these arguments are:
#date names, date format, time format, decimal mark, grouping mark, time zone, encoding

#2
parse_number("$123.456.789", locale = locale(grouping_mark = ".", decimal_mark = "."))              
#Setting decimal and grouping mark to the same format yields errors
parse_number("$123.456.789", locale = locale(grouping_mark = "."))              
#setting grouping mark to "." yields no decimal places if they are intended to be that way
parse_number("$123.456,789", locale = locale(grouping_mark = ".", decimal_mark = ","))              
#To maintain decimal places after assigning grouping mark as "." assign the decimal mark another mark

#3
#date and timezone format are important where there are different ways of approaching datetime
?date_format(.)
parse_datetime("2001-01-01T1010")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
#This illustrates the importance of stipulating date format and the same holds for time zone.

#5
#read_csv and read_csv2 differentiate by their delimiter (separator). Use depending on the data type.

#6
#In Europe common delimiter is ".", in most English countries ",", in Asia "." (Indonesia and Mongolia ",")


#Parse a file-----------
#There is a hierarchy when parsing a file, everything can be stored as a character, 
#only numbers can be numbers and only logical arguments can be so when parsing. So when parsing a file 
#if there are multiple types there may be problems, inferring defaulting to characters.
#It uses the first 1000 rows to guess the type of a column, which may have a deviation from the entire data set. 
#You can specify data types

flights
write_csv(flights, "flights.csv")
#can also write and RDS (R Data Science doc)
write_rds(flights, "flights.rds")
#this preserves any manipulations and can be read back in with read_rds 
#note, with this it is best to put this in an object
#makes for an efficient work flow if you only have to load in an RDS to pick up where you left off.

#there are packages to read many data types i.e. SAS, SPSS, Stata etc, also DATABASE specific
#because we know R, we don't need to learn all these other languages and structure as they can be accessed via R

#Power point presentation----
#novice behaviour: working in console, working in other software, slow, quiet, uninvolved, missing equipment
#novices don't have a mental model of a problem, use concepts from other workflows that are efficient here