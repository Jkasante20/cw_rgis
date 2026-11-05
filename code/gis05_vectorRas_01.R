if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               sf,
               terra,
               tidyterra,
               exactextractr)

## finsync survey site
sf_site <- readRDS("data/sf_finsync_nc.rds")

## county polygons
sf_nc_county <- readRDS("data/sf_nc_county.rds")

## precipitation raster
spr_prec_nc <- rast("data/spr_prec_nc.tif")

ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_site) +
  scale_fill_viridis_c() + # change color palette for raster
  theme_bw()

## point extraction (use terra:: explicitly to avoid tidyr::extract clash)
(sf_site_prec <- terra::extract(x = spr_prec_nc,
                                y = vect(sf_site),
                                bind = TRUE) %>% 
    st_as_sf())

ggplot() +
  geom_sf(data = sf_nc_county,       
          fill = "grey") + 
  geom_sf(data = sf_site_prec,      
          aes(color = precipitation)) +
  scale_color_viridis_c() +         
  theme_bw()                       

## project to UTM 17N
sf_nc_county_proj <- st_transform(sf_nc_county,
                                  crs = 32617)

spr_prec_nc_proj <- terra::project(x = spr_prec_nc, 
                                   y = "EPSG:32617",
                                   method = "bilinear") 

(df_prec_county <- exact_extract(x = spr_prec_nc_proj,
                                 y = sf_nc_county_proj,
                                 fun = "mean",
                                 append_cols = "county",
                                 progress = FALSE) %>% 
    as_tibble() %>%                  # convert to tibble
    rename(precipitation = mean))    # rename the output column

(sf_nc_county_prec <- sf_nc_county %>% 
    left_join(df_prec_county,
              by = "county"))

ggplot() +
  geom_sf(data = sf_nc_county_prec,
          aes(fill = precipitation)) +
  scale_fill_viridis_c() +
  theme_bw()

## alternative: area-weighted mean on unprojected data
df_prec_county_alt <- exact_extract(x = spr_prec_nc,
                                    y = sf_nc_county,
                                    fun = "weighted_mean",
                                    weights = "area",
                                    append_cols = "county",
                                    progress = FALSE) %>% 
  as_tibble() %>%                         # convert to tibble
  rename(precipitation = weighted_mean)   # rename the output column  <-- extra ")" removed

## buffers
sf_site_proj <- sf_site %>%
  st_transform(crs = 32617)

sf_site_buff_proj <- sf_site_proj %>%
  st_buffer(dist = 10000) # unit is meter in a projected CRS

sf_site_buff <- sf_site_buff_proj %>%
  st_transform(crs = 4326)

ggplot() +
  geom_sf(data = sf_nc_county,
          fill = "grey") +
  geom_sf(data = sf_site_buff,
          fill = "salmon") +
  geom_sf(data = sf_site) +
  theme_bw()

df_prec_buff <- exact_extract(x = spr_prec_nc_proj,
                              y = sf_site_buff_proj,
                              fun = "mean",
                              append_cols = "site_id",
                              progress = FALSE) %>%
  as_tibble() %>%
  rename(precipitation = mean)

(sf_site_prec_buff <- sf_site %>% 
    left_join(df_prec_buff,
              by = "site_id"))

ggplot() +
  geom_sf(data = sf_nc_county,
          fill = "grey") + 
  geom_sf(data = sf_site_prec_buff,
          aes(color = precipitation)) +
  scale_color_viridis_c() +
  theme_bw()
