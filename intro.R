# install libraries
#==================
install.packages('dbplyr')
devtools::install_github("tidyverse/dbplyr")
library(dbplyr)
library(dplyr)
library(DBI)
library(RSQLite)

# connect to database
#====================
con <- DBI::dbConnect(RSQLite::SQLite(), ":memory:")

# copy local data frame to database
#==================================
copy_to(con, mtcars)

# reference copied data frame
#============================
mtcars2 <- tbl(con, "mtcars")
mtcars2

# query data
#============
mtcars2 %>%
  select(mpg, cyl, drat)

mtcars2 %>%
  filter(mpg > 25)

mtcars2 %>%
  group_by(cyl) %>%
  summarise(mileage = mean(mpg))

# show query
#===========
mileages <- mtcars2 %>%
  group_by(cyl) %>%
  summarise(mileage = mean(mpg))

mileages %>% show_query()

# use collect to pull data into a tibble
#=======================================
data <- mileages %>% collect()


