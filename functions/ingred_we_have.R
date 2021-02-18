# Holiday cookie bonanza: customize how much we have of each ingredient
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-02-10
# Modified: 2021-02-10

ingred_we_have <- function(ingred_in)
{
  # print(pivot_longer(ingred_in, cols = everything()))
  # 
  ingred_mod <- readline(prompt = "Do you want to modify ingredient amounts? (y/n)")
  if(ingred_mod == "n") {return(ingred_in$what_we_have)
  }else if(ingred_mod == "y") {
    for(i in 1: dim(ingred_in)[1])
    {
      ingred_in$what_we_have[i] <- as.numeric(readline(prompt = paste0("How many ", to_any_case(ingred_in$units[i], "all_caps"), " of ",  to_any_case((ingred_in$ingredient[i]), "all_caps"), "? ")))
    }
    return(ingred_in$what_we_have)
  }else{print("Please enter a valid entry: y for yes or n for no")}
}
