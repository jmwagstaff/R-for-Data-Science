## Data visualisation

library(tidyverse)


## 3.2.4 Exercises
#1
ggplot(data = mpg)

#2
str(mpg)
# this gives: 234 obs. of  11 variables
summary(mpg)
dim(mpg)

#3
?mpg #to get info on data
#drv
#f = front-wheel drive, r = rear wheel drive, 4 = 4wd

#4
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = cyl, y = hwy, color = class))

#5
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = class, y = drv))
#not so useful. shows no relationsship. just classifications.



## 3.3.1 Exercises
#1 
# should be outside brackets

ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = year))
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, size = year))
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, shape = year)) 
#error returned in for shape

#4
#multiple aes
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = cty, size = cty))

#5
#stroke
#Use the stroke aesthetic to modify the width of the border
ggplot(data = mpg) +
        geom_point(mapping = aes(x = displ, y = hwy), shape = 21, 
                                 colour = "black", fill = "white", size = 5, 
                   stroke = 2)

#6
# use mapping to separate data
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))


##3.5.1 Exercises

#To facet your plot by a single variable, use facet_wrap()
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_wrap(~ class, nrow = 2)
#To facet your plot on the combination of two variables, add facet_grid()

#1
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(.~ class)

#2
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) + 
        facet_grid(drv ~ cyl)
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = drv, y = cyl))
#for some drive type, there are no data with cylinder

#3
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) +
        facet_grid(drv ~ .) #in column
ggplot(data = mpg) + 
        geom_point(mapping = aes(x = displ, y = hwy)) +
        facet_grid(. ~ drv) #in rows

## 3.6 Geometric objects
#?geom_smooth
# LOESS Curve Fitting (Local Polynomial Regression)

##3.6.1 Exercises
#1 What geom would you use to draw a line chart? A boxplot? A histogram? 
# An area chart?

# define the mapping in ggplot() to make general and not repeat. can specify local 
# mapping in individual geoms.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
        geom_line()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
        geom_boxplot()
ggplot(data = mpg, mapping = aes(x = displ, color = drv)) + 
        geom_histogram()
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
        geom_area()

#2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
        geom_point() + 
        geom_smooth(se = FALSE) # se is the standard error in smooth

#6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point() + 
        geom_smooth(se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point() + 
        geom_smooth(mapping = aes(group=drv),se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, colour = drv)) + 
        geom_point() + 
        geom_smooth(mapping = aes(group = drv),se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point(mapping = aes(colour = drv)) + 
        geom_smooth(mapping = aes(linetype = drv),se = FALSE)
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
        geom_point(mapping = aes(fill = drv), shape = 21, colour = "white", 
                   size = 2) 


## 3.7 Statistical transformations

# simple bar charts
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut))

# can explicitely set what stat to calculate
ggplot(data = diamonds) + 
        stat_count(mapping = aes(x = cut))

# bar chat of proportion:
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

## 3.7.1 Exercises

#1
# default: geom = "pointrange"
ggplot(data = diamonds) + 
        geom_pointrange(
                mapping = aes(x = cut, y = depth),
                stat = "summary",
                fun.ymin = min,
                fun.ymax = max,
                fun.y = median
        )

#2
# geom_bar uses stat_count by default: it counts the number of cases at each x 
# position. geom_col uses stat_identity: it leaves the data as is.
# where identity uses the heights of the bars to represent values in the data,

#4
# need to set group =1 in the plot below, to make proportion of total
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, fill = color, y = ..prop.., group = 1))

## 3.8 Position adjustments

# colour in bar charts with fill
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, fill = clarity))

# stacking is performed automatically by the position adjustment specified 
# by the position argument. If you don’t want a stacked bar chart, you can use 
# one of three other options: "identity", "dodge" or "fill".

## 3.8.1 Exercises
#1
# problem with this plot?
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
        geom_point()
# over plotting, use jitter to see more density
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
        geom_point(position = "jitter")

#2
# geom_jitter() is a convenient shortcut for geom_point(position = "jitter")
# parameters wisth and height control amount of vertical and horizontal jitter

#3 geom_count also helps to visulaise overplotting
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
        geom_count()

# 4 geom_boxplot()
#boxplot compactly displays the distribution of a continuous variable. 
# default position = "dodge", position = "dodge" places overlapping objects 
# directly beside one another. This makes it easier to compare individual values.
ggplot(data = diamonds) + 
        geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

ggplot(data = mpg, mapping = aes(x = cyl, y = hwy, group = cyl)) +
        geom_boxplot()


## 3.9 Coordinate systems

# coord_flip() switches the x and y axes, useful for long labels
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
        geom_boxplot() +
        coord_flip()

# +coord_quickmap() sets the aspect ratio correctly for maps
# +coord_polar() uses polar coordinates

## 3.9.1 Exercises
#1 make a pie chart from bar chart
ggplot(mpg, aes(x = factor(1), fill = drv)) +
        geom_bar()

ggplot(mpg, aes(x = factor(1), fill = drv)) +
        geom_bar(width = 1) +
        coord_polar(theta = "y")

#2
# labs is a shortcut function to add labels to different scales
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
        geom_boxplot() +
        coord_flip() +
        labs(y = "Highway MPG", x = "")

#4
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
        geom_point() + 
        geom_abline() +
        coord_fixed()

# The coordinates coord_fixed ensures that the abline is at a 45 degree angle, 
# which makes it easy to compare
