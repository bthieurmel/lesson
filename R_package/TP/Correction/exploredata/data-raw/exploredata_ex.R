## code to prepare `exploredata_ex` dataset goes here

exploredata_ex <- data.frame(
  value = rnorm(1000),
  group = sample(LETTERS[1:5], 1000, replace = T)
)
usethis::use_data(exploredata_ex, overwrite = TRUE)
