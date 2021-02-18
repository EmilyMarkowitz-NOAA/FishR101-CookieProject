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
library(snakecase)

# functions ---------------------------------------------------------------

functions <- list.files(here::here("functions"))

purrr::walk(functions, ~ source(here::here("functions", .x)))


# data --------------------------------------------------------------------

cookie_names <- names(read_excel(path = here::here("data", "holiday_cookie_ingredients.xlsx"), 
                                 n_max = 0))

cookie_dat <- read_excel(path = here::here("data", "holiday_cookie_ingredients.xlsx"), skip = 2,
                      col_names = cookie_names)


# clean up raw data -------------------------------------------------------

cookies <- cookie_dat %>% 
  janitor::clean_names() %>% 
  rename(ingredient_group = cookie,
         ingredient = x2,
         units = x3) %>% 
  dplyr::select(- x4) %>% 
  dplyr::filter(!is.na(ingredient_group))

# View(cookies)
str(cookies)


# set up calcs ------------------------------------------------------------

# how many batches of each cookie type do you want?
# # op 1: read in amounts in spreadsheet
cookie_batches <- read_excel(path = here::here("data", "holiday_cookie_ingredients.xlsx"), 
                             n_max = 1) %>% 
  janitor::clean_names() %>% 
  dplyr::select(-cookie, -x2, -x3, -x4, -total, -what_we_have, -total_to_buy) #%>% 

# # here's where you can customize how many batches 
cookie_batches <- get_batches(cookie_batches)

# multiply ingredient amount by number of batches
batch_totals <- cookies %>% #multiply all elems in column by matchng location in vector
  dplyr::select(-total, -what_we_have, -total_to_buy) %>%
  mutate(sugar_cookies =  sugar_cookies * cookie_batches$sugar_cookies,        
         gingerbread_cookies =  gingerbread_cookies * cookie_batches$gingerbread_cookies,   
         bars_of_death =  bars_of_death * cookie_batches$bars_of_death,         
         oatmeal_drops =  oatmeal_drops * cookie_batches$oatmeal_drops,         
         hazelnut_balls = hazelnut_balls * cookie_batches$hazelnut_balls,        
         fudge =  fudge * cookie_batches$fudge,                 
         truffles = truffles * cookie_batches$truffles,               
         peanut_butter_bark = peanut_butter_bark * cookie_batches$peanut_butter_bark,     
         white_mac_cookies =  white_mac_cookies * cookie_batches$white_mac_cookies,    
         m_m_cookies =  m_m_cookies * cookie_batches$m_m_cookies,           
         chocloate_chip_cookies = chocloate_chip_cookies * cookie_batches$chocloate_chip_cookies, 
         grandpa_joes_eggnog =  grandpa_joes_eggnog * cookie_batches$grandpa_joes_eggnog,   
         icing = icing * cookie_batches$icing)

# View(batch_totals)

# sum across rows for total ingredient amount
cookies_calc <- batch_totals %>% 
  # dplyr::select(-total, -what_we_have, -total_to_buy) %>% 
  mutate(total = rowSums(across(where(is.numeric)), na.rm = T))

# View(cookies_calc)

# modify how much we have
ingred_in <-  cookies %>%  #this is where you can customize amount of each ingredient you have: either directly or read-in
  dplyr::select(ingredient_group, ingredient, units, what_we_have) 

ingred_we_have(ingred_in)

ingred <-  cookies_calc %>% # then modify what we have column
  mutate(what_we_have = ingred_we_have(ingred_in))

# tell me how much of each ingredient to buy
# # subtract how much we have from total needed (note: less than 0 = 0)

ingred_buy <- ingred %>% 
  mutate(total_to_buy = total - what_we_have) %>% 
  mutate(total_to_buy = if_else(total_to_buy < 0, 0, total_to_buy)) %>% 
  dplyr::filter(total_to_buy > 0)

# View(ingred_buy)

# optional: convert cups to bags/boxes etc to buy


# output my shopping list

shopping_list <- paste(ingred_buy$ingredient,":",
                       ingred_buy$total_to_buy,
                       ingred_buy$units)


write_lines(shopping_list, 
            path = here::here("output", paste0(Sys.Date(), "_shopping_list.txt")))

write_lines(paste(names(cookie_batches), ":", cookie_batches), 
            path = here::here("output", paste0(Sys.Date(), "_batches.txt")))
