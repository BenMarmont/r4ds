# Intro to R for Ben
# week 1, note that this is only a portion of the code, the first portion I used the R console 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))
ggplot(data = mpg) +
  geom_point(mapping = aes(x = cyl, y = cty, color = displ < 5))
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)
ggplot (data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = cty, linetype = class))      
?geom_smooth()
ggplot(data = mpg, mapping = aes(x = displ, cty)) +
  geom_smooth() +
  geom_point()
geom_are
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)
  geom_point() + 
  geom_smooth(se = FALSE)
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point() + 
    geom_smooth()
  ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
    geom_point(aes(stroke = 3)) +
    geom_smooth(se = FALSE)
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = after_stat(group = 1)))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = color, y = after_stat(prop)))
ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_count()
ggplot(mpg, aes(cyl, hwy)) +
  geom_boxplot()
ggplot(mpg, aes(cyl, hwy)) +
  geom_statplot
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +_
coord_quickmap
ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")



ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_polar()



bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

ggplot(data = mpg) +
  geom_bar(mapping = aes(x = class, fill = class)) +
  coord_flip() +
  coord_polar()

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
  geom_point() +
  geom_abline() + 
  coord_fixed()
#the ab line is a reference line where x and y values are equal ie 20,20 etc for ref against data set.
#should have looked for the abline ?help
?coord_fixed
#coordfixed maintains the same aspect ratio along intersect
library(ggplot2)

#head(data) shows the top of the data set
