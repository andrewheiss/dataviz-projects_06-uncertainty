library(tidyverse)

# Build a lookup table with {tigris} ----
library(tigris)

regions_info <- regions() |> 
  sf::st_drop_geometry() |> 
  select(REGION_ID = GEOID, REGION = NAME)

divisions_info <- divisions() |> 
  sf::st_drop_geometry() |> 
  select(DIVISION_ID = GEOID, DIVISION = NAME)

states_info <- states(cb = FALSE) |> 
  sf::st_drop_geometry() |> 
  select(REGION_ID = REGION, DIVISION_ID = DIVISION, STATEFP, STUSPS, NAME)

state_details <- states_info |>
  left_join(regions_info, by = join_by(REGION_ID)) |>
  left_join(divisions_info, by = join_by(DIVISION_ID)) |>
  select(
    state = NAME,
    state_abb = STUSPS,
    # state_fips = STATEFP,
    region = REGION,
    division = DIVISION
  )

readr::write_csv(state_details, "data/state_details.csv")


# Save the tidytuesday data ----
tuesdata <- tidytuesdayR::tt_load('2020-09-15')
readr::write_csv(tuesdata$kids, "data/kids.csv")


# Build answer key so that the plots to recreate exist in images/ ----
quarto::quarto_render(
  "answers.qmd",
  output_format = c("html", "typst")
)
