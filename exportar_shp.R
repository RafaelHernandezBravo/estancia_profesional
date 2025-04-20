# Transformar a archivo shp

library(tidytransit)
library(terra)
library(sp)
library(sf)
library(dplyr)

archivo_shp = st_read("C:/proyecto_ep/scrapping_ok/DENUE/11_2024/00mun.")
print(archivo_shp)

RF_SHP = merge(archivo_shp, DB0, by.x = "CVEGEO",by.y = 0, all = TRUE)
print(RF_SHP)
class(RF_SHP)

plot(st_geometry(RF_SHP))

st_write(RF_SHP, "C:/proyecto_ep/scrapping_ok/DENUE/11_2024/actividades_mun")
