library(tidyverse)
# without pipe
ggplot(data = iris,
       mapping = aes(x = Sepal.Length,
                     y = Sepal.Width))

# with pipe
iris %>% 
  ggplot(mapping = aes(x = Sepal.Length,
                       y = Sepal.Width))

# basic plot
iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width)) +
  geom_point()

# change color by "Species" column
iris %>% 
  ggplot(aes(x = Sepal.Length,
             y = Sepal.Width,
             color = Species)) +
  geom_point()
# sample data
df0 <- tibble(x = rep(1:50, 3),
              y = x * 2)


# basic plot
df0 %>% 
  ggplot(aes(x = x,
             y = y)) +
  geom_line()



# basic plot; bins = 30 by default
iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram()

# change bin width
iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram(binwidth = 0.5)
# change bin number
iris %>% 
  ggplot(aes(x = Sepal.Length)) +
  geom_histogram(bins = 50) 

# change fill by "Species"
iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             fill = Species)) +
  geom_boxplot()

# change fill by "Species", but consistent color
iris %>% 
  ggplot(aes(x = Species,
             y = Sepal.Length,
             fill = Species)) +
  geom_boxplot(color = "darkgrey")
