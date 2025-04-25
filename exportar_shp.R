# Transformar a archivo shp

library(tidytransit)
library(terra)
library(sp)
library(sf)
library(dplyr)

DB0 = read.csv("actividades_económicas_por_municipio.csv")
archivo_shp = st_read("00mun.shp")
print(archivo_shp)

RF_SHP = merge(archivo_shp, DB0, by.x = "CVEGEO",by.y = 0, all = TRUE)
print(RF_SHP)
class(RF_SHP)

plot(st_geometry(RF_SHP))

st_write(RF_SHP, "actividades_mun.shp")
