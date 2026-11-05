library(tidyverse)

set.seed(123)

# Sample 3 rows per species
iris_sub <- as_tibble(iris) %>%
  group_by(Species) %>%
  sample_n(3) %>%
  ungroup()

print(iris_sub)

# Filter examples
filter(iris_sub, Species == "virginica")

filter(iris_sub, Species %in% c("virginica", "versicolor"))

filter(iris_sub, Species != "setosa")

# AND
filter(iris_sub, Petal.Length > 5 | Sepal.Length > 5)


filter(iris_sub, Species == "setosa" | Sepal.Length > 3)

# Assignment <-
sub_wide_sepals <- filter(iris_sub, Sepal.Width > 3)
sub_wide_sepals

# Select()
select(iris_sub, -c(Sepal.Length, Sepal.Width))

select(iris_sub, contains("al."))

# Mutate()
(x_max <- nrow(iris_sub))

iris_sub <- mutate(iris_sub, row_id = 1:nrow(iris_sub))
iris_sub

iris_sub %>%
  group_by(Species) %>%
  summarize(mu_sl = mean(Sepal.Length))

iris_sub <- group_by(iris_sub, Species) %>%
  mutate(mu_sl = mean(Sepal.Length)) %>%
  ungroup()
iris_sub

# Pipe
iris_sub %>%
  filter(Species == "virginica")


iris_sub <- mutate(iris_sub, sl_two_times = 2 * Sepal.Length)
iris_sub

iris_pw <- select(iris_sub, Petal.Width, Species)
iris_pw

iris_pipe <- iris_sub %>%
  filter(Species == "setosa") %>%
  mutate(pw_2times = 2 * Petal.Width)
iris_pipe