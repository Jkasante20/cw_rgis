if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

(spr_prec <- rast("data/spr_prec_us.tif"))

ext(spr_prec)

sf_nc_county <- readRDS("data/sf_nc_county.rds")

spr_prec_crop <- crop(x = spr_prec,
                      y = c(-80, -75, 34, 37))

ggplot() +
  geom_spatraster(data = spr_prec_crop) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) ## alpha = 0.25 makes the polygon layer transparent

spr_prec_nc <- crop(x = spr_prec,
                    y = sf_nc_county)


ggplot() +
  geom_spatraster(data = spr_prec_nc) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25) ## alpha = 0.25 makes the polygon layer transparent

spr_nw <- rast("data/spr_prec_ncnw.tif") # Northwest NC
spr_ne <- rast("data/spr_prec_ncne.tif") # Northeast NC
spr_sw <- rast("data/spr_prec_ncsw.tif") # Southwest NC
spr_se <- rast("data/spr_prec_ncse.tif") # Southeast NC


ggplot() +
  geom_spatraster(data = spr_nw) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)


spr_n <- merge(spr_nw, spr_ne)


ggplot() +
  geom_spatraster(data = spr_n) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

list_spr <- list(spr_nw,
                 spr_ne,
                 spr_sw,
                 spr_se)


spr_col <- sprc(list_spr)

spr_merge <- merge(spr_col)


ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

writeRaster(spr_merge, 
            filename = "data/spr_prec_nc.tif",
            overwrite = TRUE)

spr_prec_nc <- rast("data/spr_prec_nc.tif")
spr_tmp_nc <- rast("data/spr_tmp_nc.tif")

print(spr_prec_nc)


(spr_pt_nc <- c(spr_prec_nc,
                spr_tmp_nc))

spr_pt_nc$precipitation


print(spr_prec_nc)  


(spr_prec_nc_proj <- project(x = spr_prec_nc,
                             y = "EPSG:32617")) 


#Exercise 
sf_nc_county <- readRDS("data/sf_nc_county.rds")

spr_tmp_nw <- rast("data/spr_tmp_ncnw.tif") # Northwest NC
spr_tmp_ne <- rast("data/spr_tmp_ncne.tif") # Northeast NC
spr_tmp_sw <- rast("data/spr_tmp_ncsw.tif") # Southwest NC
spr_tmp_se <- rast("data/spr_tmp_ncse.tif") # Southeast NC

list_spr_tmp <- list(spr_tmp_nw,
                     spr_tmp_ne,
                     spr_tmp_sw,
                     spr_tmp_se)

spr_col_tmp <- sprc(list_spr_tmp)

spr_col_tmp

spr_merge <- merge(spr_col_tmp)

ggplot() +
  geom_spatraster(data = spr_merge) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)

sf_camden <- sf_nc_county %>%
  filter(county == "camden")

ext(sf_camden)

spr_tmp_camden <- crop(x = spr_merge,
                       y = sf_camden)

spr_tmp_camden

ggplot() +
  geom_spatraster(data = spr_tmp_camden) +
  geom_sf(data = sf_nc_county,
          alpha = 0.25)
spr_tmp_camden_proj <- project(x = spr_tmp_camden,
                               y = "EPSG:32618",
                               method = "bilinear")

print(spr_tmp_camden_proj) 
