# Holiday cookie bonanza: convert excel spreadsheet to R code
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-12-18
# Modified: 2021-01-18


# libraries ---------------------------------------------------------------

library(here)
library(tidyverse)
library(readxl)
library(janitor)

# functions ---------------------------------------------------------------

functions <- list.files(here::here("functions"))

purrr::walk(functions, ~ source(here::here("functions", .x)))


# data --------------------------------------------------------------------

# read in data


# clean up raw data -------------------------------------------------------

# clean up raw data (names, columns needed, etc.)


# check your data set
View(cookies)
str(cookies)


# set up calcs ------------------------------------------------------------

# how many batches of each cookie type do you want?


# multiply ingredient amount by number of batches


# sum across rows for total ingredient amount


# subtract how much we have from total needed (note: less than 0 = 0)


# tell me how much of each ingredient to buy


# optional: convert cups to bags/boxes etc to buy


# output my shopping list
