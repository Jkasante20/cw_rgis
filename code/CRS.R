# Cordinate Reference System


pacman::p_load(tidyverse,
               sf,
               mapview)


#get fish site data

df_fish <- read_csv("cw_rgis/data/data_finsync_nc.csv")
print(df_fish)

view(df_fish)

#remove duplicates

sf_site <- df_fish %>% 
  distinct(site_id, lon, lat) %>% 
  st_as_sf(coords = c("lon", "lat"),
           crs = 4326)

sf_site
class(sf_site)

mapview(sf_site)

#export 
saveRDS(sf_site, "data/sf_finsync_nc.rds")

#projection
sf_ft_wgs <- sf_site %>% 
  slice(c(1,2))

sf_ft_utm <- sf_ft_wgs %>% 
  st_transform(crs = 32617)

mapview(sf_ft_wgs)

st_distance(sf_ft_utm)

# Quakes exercise

df_quakes <- as_tibble(quakes)

print(df_quakes)

sf_quakes <- df_quakes %>% 
  st_as_sf(coords = c("long", "lat"),
           crs = 4326)

sf_quakes
class(sf_quakes)

mapview(sf_quakes)

sf_ft_quakes <- sf_quakes %>% 
  slice(c(1, 2))

sf_ft_quakes_proj <- sf_ft_quakes %>% 
  st_transform(crs = 32760)

st_distance(sf_ft_quakes_proj)

saveRDS(sf_quakes, file = "data/sf_quakes.rds")


