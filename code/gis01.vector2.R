# Vector 2:Spatial Join

if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

rm(list=ls())

sf_site <- readRDS("data/sf_finsync_nc.rds")
sf_nc_county <- readRDS("data/sf_nc_county.rds")

#Visualize
mapview(sf_nc_county, legend =  FALSE) +mapview(sf_site, legend = FALSE)

# Joine county information to sf_site
sf_site_join <- st_join(x = sf_site,
                        y = sf_nc_county)


# count number of fish survey sites within guilford county

sf_site_join %>% 
  filter(county == "guilford")


sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford")

#Count sites in clay county

sf_site_clay <- sf_site_join %>% 
  filter(county == "clay")

sf_gi_county <- sf_site_join %>% 
  filter(county == "guilford")

#re-read stream layer
sf_str <- readRDS ("data/sf_stream_gi.rds")

ggplot() +
  geom_sf(data = sf_gi_county) +
  geom_sf(data = sf_str,
          color = "blue") +
  geom_sf(data = sf_gi_county,
          color = "tomato")

#geometric analysis
sf_str_proj <- st_transform (sf_str,
                             crs = 32617)

sf_str_proj

# Calculate the length of each stream line segment
v_str_l <- st_length(sf_str_proj)
v_str_l
head(v_str_l)

sf_str_w_len  <- sf_str %>% 
  mutate( length = v_str_l)

sf_str_w_len
           
# area 
sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617)

  sf_nc_county_proj
# calculate the area of county polygons
v_area <- st_area(sf_nc_county_proj)

# create a column "area" in sf_nc_county_proj, and identify the county is the largest
sf_nc_county_w_area <- sf_nc_county_proj %>% 
  mutate(area = as.numeric(v_area) / 1E+6)%>% #unit conversion from m^2 to km^2
  arrange(desc(area))

# subset polygons for mapping 
sf_county1k <- sf_nc_county_w_area %>% 
  filter(area > 1E+9)
#map of the subset of counties
ggplot()+
  geom_sf(data= sf_county1k)


#Excersice
sf_quakes <- readRDS("data/sf_quakes.rds")
sf_nz <- readRDS("data/sf_nz.rds")


mapview(sf_nz) + mapview(sf_quakes)

sf_quakes_join <- st_join(x = sf_quakes,
                          y = sf_nz)

sf_quakes_nc <- drop_na(sf_quakes_join, fid)

nrow(sf_quakes_nc)

df_n <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n= n())

sf_n_site <- left_join(sf_nc_county, df_n, by = "county")

sf_n10 <- sf_n_site %>% 
  filter(n > 10)

ggplot() +
  geom_sf(data = sf_nc_county)+
  geom_sf(data = sf_n_site,
          fill = "grey") +
  geom_sf(data = sf_n10,
          fill = "salmon")
  
  
  
  

  
