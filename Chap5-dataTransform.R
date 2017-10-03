## 5 Data transformation

library(nycflights13)
library(tidyverse)

# Tibbles are data frames, but slightly tweaked to work better in the tidyverse

# dplyr functions:
# filter() allows you to subset observations based on their values.
jan1 <- filter(flights, month == 1, day == 1) # creats new data frame

# For comparison: >, >=, <, <=, != (not equal), and == (equal).
# be careful with == for floating point numbers, can get wrong result, 
# instead use: near()
near(sqrt(2) ^ 2,  2) # returns TRUE

# Boolean operators: & is “and”, | is “or”, and ! is “not”
filter(flights, month == 11 | month == 12)
# or we can use the following:
filter(flights, month %in% c(11, 12))
# De Morgan’s law: 
# !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y

# Missing Values
# If you want to determine if a value is missing, use is.na()
# To preserve missing values, ask for them explicitly:
filter(df, is.na(x) | x > 1)

## 5.2.4 Exercises
#1
# Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)
# Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")
# Were operated by United, American, or Delta
filter(flights, carrier %in% c("UA", "AA", "DL"))
# Departed in summer (July, August, and September)
filter(flights, month %in% c(7, 8, 9))
# Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay >= 120 & dep_delay == 0)
# Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & (dep_delay-arr_delay) >= 30)
# Departed between midnight and 6am (inclusive)
filter(flights, dep_time >= 0 & dep_time <= 6)

#2
# between(x, left, right) is a shortcut for x >= left & x <= right
filter(flights, between(dep_time, 0, 6))

#3
# How many flights have a missing dep_time?
nrow(filter(flights, is.na(dep_time))) # returns a tibble: 8,255 x 19
# [1] 8255
filter(flights, is.na(dep_time)) # also no arrival time, probably cancelled flights

#4
# Why is NA ^ 0 not missing? Any value to power 0 is equal to 1.
# Why is NA | TRUE not missing? finds true, and since it's 'or' eval as True
# Why is FALSE & NA not missing? First sees F and then &, directly gives F
# 
#NA * 0 gives NA


## 5.3 Arrange rows with arrange()
# arrange() works similarly to filter() except that instead of selecting rows, 
# it changes their order.
arrange(flights, year, month, day)
# Use desc() to re-order by a column in descending order:
arrange(flights, desc(arr_delay))

#5.3.1 Exercises
#1
# Use arrange() to sort all missing values to the start? (Hint: use is.na())
arrange(flights, desc(is.na(dep_time)), dep_time)
# This sorts by increasing dep_time, but with all missing values put first.

#2
# Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay), dep_time)

#3
# Sort flights to find the fastest flights.
arrange(flights, air_time)

#4
# Which flights travelled the longest? Which travelled the shortest?
arrange(flights, desc(distance))
arrange(flights, distance)


## 5.4 Select columns with select()
# Used to select certain variables, make a smaller subset 
# Select columns by name
select(flights, year, month, day) # choose only those three vars
# Select all columns between year and day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

#There are a number of helper functions you can use within select():
# starts_with("abc"): matches names that begin with “abc”.
# ends_with("xyz"): matches names that end with “xyz”.
# contains("ijk"): matches names that contain “ijk”.
# matches("(.)\\1"): selects variables that match a regular expression. 
# This one matches any variables that contain repeated characters. 
# num_range("x", 1:3) matches x1, x2 and x3.

# Use rename() to rename vars
rename(flights, tail_num = tailnum) # new name = old name

# Use use select() in conjunction with the everything() helper. 
# To move a handful of variables to the start of the data frame
select(flights, time_hour, air_time, everything())

## 5.4.1 Exercises
#1
# Select dep_time, dep_delay, arr_time, and arr_delay from flights.
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep_"), starts_with("arr_"))
select(flights, matches("^(dep|arr)_(time|delay)$"))

#2
# What happens if you include the name of a variable multiple times in a select() call?
# duplicate is ignored

#3
# What does the one_of() function do?
# select variables based on their names, here variables in character vector.
# can easily pass to select: 
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

#4
select(flights, contains("TIME"))
# contains does not consider lower or upper case, 
# add the argument ignore.case = FALSE
select(flights, contains("TIME", ignore.case = FALSE))


## 5.5 Add new variables with mutate()

# adds new vars at end
mutate(flights,
       gain = arr_delay - dep_delay,
       speed = distance / air_time * 60
)
# you can refer to columns that you’ve just created, could add in above
# gain_per_hour = gain / hours

# If you only want to keep the new variables, use transmute()

# 5.5.1 Useful creation functions
# function must be vectorised: it must take a vector of values as input, 
# return a vector with the same number of values as output

# Modular arithmetic: %/% (integer division) and %% (remainder)
# allows you to break integers up into pieces e.g. you can compute hour and 
# minute from dep_time with
transmute(flights,
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# Logs: log(), log2(), log10(). For log2() a difference of 1 on the log scale 
# corresponds to doubling on the original scale and a difference of -1 
# corresponds to halving.

# Offsets: lead() and lag() allow you to refer to leading or lagging values.
# Lead and lag are useful for comparing values offset by a constant 
# (e.g. the previous or next value)
# compute running differences (e.g. x - lag(x)) or find when values change 
# (x != lag(x))

# Cumulative and rolling aggregates:functions for running sums, 
# products, mins and maxes: cumsum(), cumprod(), cummin(), cummax(); 
# and dplyr provides cummean() for cumulative means.

# Ranking: Start with min_rank(). It does the most usual type of ranking 
# (e.g. 1st, 2nd, 2nd, 4th). Use desc(x) to give the largest values the smallest ranks.
# variants: row_number(), dense_rank(), percent_rank(), cume_dist(), ntile()

## 5.5.2 Exercises
#1
mutate(flights,
       dep_time_mins = dep_time %/% 100 * 60 + dep_time %% 100, # int devision and remainder
       sched_dep_time_mins = sched_dep_time %/% 100 * 60 + sched_dep_time %% 100) %>%
        select(dep_time, dep_time_mins, sched_dep_time, sched_dep_time_mins)
# here the %>% is a pipe, a flow of operations on data, select just shows the following vars

#2
# the differences occur because of shifting time zones
mutate(flights,
       air_time2 = arr_time - dep_time,
       air_time_diff = air_time2 - air_time) %>%
        filter(air_time_diff != 0) %>%
        select(air_time, air_time2, dep_time, arr_time, dest)

#3
# min_rank: equivalent to rank(ties.method = "min")

#4
# 1:3 + 1:10 gives a warning message because the vectors have different dimesions

#6
# trigonometric functions in R: cos, sin, tan, acos, asin, atan etc...

## 5.6 Grouped summaries with summarise()

# summarise(). It collapses a data frame to a single row
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))
# Here na.rm argument removes the missing values prior to computation, so that 
# output is not full of NAs. Can also use filter to remove NAs

not_cancelled <- flights %>% 
        filter(!is.na(dep_delay), !is.na(arr_delay))


# Summarise is very useful when paired with group_by(),
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# The pipe, %>%, very useful for a series of steps: eg group, then summarise, 
# then filter
delays <- flights %>% # on this data
        group_by(dest) %>% 
        summarise(
                count = n(), # count the flights
                dist = mean(distance, na.rm = TRUE),
                delay = mean(arr_delay, na.rm = TRUE)
        ) %>% 
        filter(count > 20, dest != "HNL") 
# Filter to remove noisy points and Honolulu airport, which is almost twice as 
# far away as the next closest airport

# Whenever you do any aggregation, it’s always a good idea to include either 
# a count n(), or a count of non-missing values sum(!is.na(x)). 
# That way you can check that you’re not drawing conclusions based on very 
# small amounts of data. To count the number of distinct (unique) values, 
# use n_distinct(x)

not_cancelled %>% 
        count(dest) # a count helper in dplyr
not_cancelled %>% 
        count(tailnum, wt = distance) # count the miles a plane flew

# Counts and proportions of logical values: sum(x > 10), mean(y == 0)
# sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion

# more example:
delays %>% 
        filter(n > 25) %>% # filter out extreem values to see pattern better
        ggplot(mapping = aes(x = n, y = delay)) + # inc ggplot into pipe
        geom_point(alpha = 1/10)

# 5.6.4 Useful summary functions
# Measures of spread: sd(x), interquartile range IQR() and 
# median absolute deviation mad(x)

# Measures of rank: min(x), quantile(x, 0.25), max(x)
# Measures of position: first(x), nth(x, 2), last(x)

# If you need to remove grouping, and return to operations on ungrouped data, 
# use ungroup()
daily %>% 
        ungroup() %>%             # no longer grouped by date
        summarise(flights = n())

## 5.6.7 Exercises
#1


## 5.7 Grouped mutates (and filters)
# Find the worst members of each group:
flights_sml %>% 
    group_by(year, month, day) %>%
    filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold:
popular_dests <- flights %>% 
    group_by(dest) %>% 
    filter(n() > 365)

# Standardise to compute per group metrics:
popular_dests %>% 
    filter(arr_delay > 0) %>% 
    mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
    select(year:day, dest, arr_delay, prop_delay)
