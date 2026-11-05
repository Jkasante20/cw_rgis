if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

(st_read(dsn = "data/nc.shp",
        quiet = TRUE))

# read a shapefile 

(sf_nc_county <- st_read(dsn = "data/nc.shp",
                         quiet = TRUE))

st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.shp",
         append = FALSE)


st_write(sf_nc_county, 
         dsn = "data/sf_nc_county.gpkg",
         append = FALSE)


saveRDS(sf_nc_county,
        file = "data/sf_nc_county.rds")


sf_nc_county <- readRDS(file = "data/sf_nc_county.rds")

sf_nc_county

(sf_site <- readRDS("data/sf_finsync_nc.rds"))
sf_site

mapview(sf_site,
        col.regions = "blue", # point's fill color
        legend = FALSE) # disable legend

mapview(sf_site,
        col.regions = "red", # point's fill color
        legend = FALSE) # disable legend

## first 10 sites
(sf_site_f10 <- sf_site %>% 
    slice(1:10))

mapview(sf_site_f10,
        col.regions = "black", # point's fill color
        legend = FALSE) # disable legend

(sf_str <- readRDS("data/sf_stream_gi.rds"))

## first 10 line strings
(sf_str_f10 <- sf_str %>% 
    slice(1:10))


mapview(sf_str_f10,
        color = "white",
        legend = FALSE)

mapview(sf_str_f10,
        color = "steelblue", # line's color
        legend = FALSE) # disable legend




mapview(sf_nc_county,
        col.regions = "grey", # polygon's fill color
        legend = FALSE) # disable legend

(sf_nc_gi <- sf_nc_county %>% 
    filter(county == "guilford"))

ggplot() +
  geom_sf(data = sf_nc_county)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site)

 
##Excercise 
(sf_str_as <- readRDS("data/sf_stream_as.rds"))

sf_str_as

st_crs(sf_str_as)
st_crs(sf_nc_county)


st_crs(sf_str_as) == st_crs(sf_nc_county)


ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = sf_str_as)
(sf_nc_as <- sf_nc_county %>% 
    filter(county == "ashe"))

ggplot() +
  geom_sf(data = sf_nc_as) +
  geom_sf(data = sf_str_as)

# Vector Data Manipulation


 st_join(x = sf_site, # base layer
                        y = sf_nc_county) 

