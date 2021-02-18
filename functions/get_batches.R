# Holiday cookie bonanza: customize batches
# Created by: Caitlin Allen Akselrud
# Contact: caitlin.allen_akselrud@noaa.gov
# Created: 2020-02-10
# Modified: 2021-02-10

get_batches <- function(cookie_batches)
{
  print(pivot_longer(cookie_batches, cols = everything()))
  
  batch_mod <- readline(prompt = "Do you want to modify batch amounts? (y/n)")
  if(batch_mod == "n") {return(cookie_batches)
  }else if(batch_mod == "y") {
    for(i in 1: length(cookie_batches))
    {
      cookie_batches[i] <- as.numeric(readline(prompt = paste0("How many batches of ",  to_any_case(names(cookie_batches[i]), "all_caps"), "? ")))
    }
    return(cookie_batches)
  }else{print("Please enter a valid entry: y for yes or n for no")}
  
}
