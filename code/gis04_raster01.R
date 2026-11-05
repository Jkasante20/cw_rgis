if (!require(pacman)) install.packages("pacman")

pacman::p_load(tidyverse,
               terra,
               tidyterra,
               mapview,
               stars)

(spr_ex <- rast("data/spr_example.tif"))

# overwrite = TRUE enables overwriting
writeRaster(x = spr_ex, 
            filename = "data/spr_elev.tif",
            overwrite = TRUE)
ggplot() +
  geom_spatraster(
    data = spr_ex)

star_ex <- st_as_stars(spr_ex)
mapview(star_ex)


#data Type in raster
# Continous raster data= variables that change smoothly acorss space

v_elev <- values(spr_ex)
head(v_elev)

extract(spr_ex, y= cbind (6.000, 50.000))
extract(spr_ex, y=cbind (5.9 , 49.67))
extract(spr_ex, y=cbind (5.9 , 48.3))


# extract data
df_point <- tibble(lon = c(6.1 , 5.9),
       lat = c(50 ,49.96))



extract(spr_ex, y = df_point)

#Discrete 
#Load forest raster

spr_for <- rast("data/spr_forest_nc.tif")

ggplot()+
  geom_spatraster(data = spr_for)
unique(spr_for)
v_binary <- values(spr_for)
v_binary

mean(v_binary) * 100

#multiple classes - code values with multple categories

spr_land <- rast("data/spr_land_reclass.tif")
unique(spr_land)
# 1001 = forest
#1010 = crop
# 1100 = urban


extract(spr_land, cbind(-79.8063, 36.0701))

#re class
(cm <- cbind(c(0, 1001, 1010, 1100),
             c(0, 1, 0, 0)))

spr_bin <- classify(spr_land,
                    rcl = cm)
v_bin <- values(spr_bin)
mean(v_bin)
#Crop
cm_crop<- cbind(
  c(0,1001, 1010, 1100),
  c(0,0,1,0)
)
spr_crop <-classify(
  x= spr_land,
  rcl = cm_crop)

spr_crop
v_crop <- values(spr_crop)
mean(v_crop)*100

#Urban
cm_urban<- cbind(
  c(0,1001, 1010, 1100),
  c(0,0,0,1)
)
spr_urban <-classify(
  x= spr_land,
  rcl = cm_urban)

spr_urban
v_urban <- values(spr_urban)
mean(v_urban)*100



#Excercise 
spr_land <- rast("data/spr_land_reclass.tif")

(spr_prec_ncne <- rast("data/spr_prec_ncne.tif"))

ggplot() +
  geom_spatraster(data = spr_prec_ncne)

sf_site <- readRDS("data/sf_finsync_nc.rds")
df_xy <- st_coordinates(sf_site)
df_land <- extract(spr_land, df_xy)
df_land

table(df_land[0, 2])

cm <- cbind(c(0, 1001, 1010, 1100),
            c(0, 0, 0, 1))
spr_urban <- classify(spr_land, rcl = cm)

v_urban <- values(spr_urban)
mean(v_urban)

