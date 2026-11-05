if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               mapview)

sf_site <- readRDS("data/sf_finsync_nc.rds")
sf_nc_county <- readRDS("data/sf_nc_county.rds")

sf_site_join <- st_join
st_join(x = sf_site, # base layer
        y = sf_nc_county) # overlaying layer

sf_site_join <- st_join(x = sf_site, # base layer
                        y = sf_nc_county) # overlaying layer
print(sf_site)

print(sf_site_join)

sf_site_guilford <- sf_site_join %>% 
  filter(county == "guilford")

sf_nc_guilford <- sf_nc_county %>% 
  filter(county == "guilford")

ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str) +
  geom_sf(data = sf_site_guilford) +
  theme_bw()

ggplot() +
  geom_sf(data = sf_nc_guilford) +
  geom_sf(data = sf_str,
          color = "black") +
  geom_sf(data = sf_site_guilford,
          color = "salmon") +
  theme_bw()

(sf_str_proj <- st_transform(sf_str, crs = 32617))

v_str_l <- st_length(sf_str_proj)

#First 10 elements
head(v_str_l)

sf_str_w_len <- sf_str %>% 
  st_transform(crs = 32617) %>%       # transform to projected CRS (utm zone 17n) for accurate length calculation
  mutate(length = st_length(.)) %>%   # calculate length of each feature and store it in a new column
  st_transform(crs = 4326)           # transform back to geographic CRS (wgs84) for consistency with other layers

# # the above code returns identical results with the code below
# sf_str_proj <- st_transform(sf_str, crs = 32617)
# v_str_l <- st_length(sf_str_proj)               
# sf_str <- sf_str %>% 
#   mutate(length = v_str_l)                      

(sf_nc_county_proj <- st_transform(sf_nc_county, crs = 32617))


(sf_nc_county_1000 <- sf_nc_county_w_area %>% 
    mutate(area = as.numeric(area) / 1e+6) %>% 
    filter(area > 1000))

ggplot() +
  geom_sf(data = sf_nc_county_1000) +
  theme_bw()

 #Excerise 

sf_quakes <- readRDS("data/sf_quakes.rds")
sf_nz <- readRDS("data/sf_nz.rds")

sf_nz

mapview(sf_nz) + mapview(sf_quakes)

sf_quakes_join <- st_join(x = sf_quakes, # base layer
                          y = sf_nz)     # overlaying layer

sf_quakes_nz <- drop_na(sf_quakes_join, fid)

nrow(sf_quakes_nz)

df_n <- sf_site_join %>% 
  as_tibble() %>% 
  group_by(county) %>% 
  summarize(n = n())

sf_n_site <- left_join(sf_nc_county, df_n, by = "county")

sf_n10 <- sf_n_site %>% 
  filter(n > 10)

ggplot() +
  geom_sf(data = sf_nc_county) +
  geom_sf(data = drop_na(sf_n_site, n),
          fill = "grey") +
  geom_sf(data = sf_n10,
          fill = "salmon") +
  theme_bw()
