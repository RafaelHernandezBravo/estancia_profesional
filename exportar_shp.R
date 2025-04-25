# Transformar a archivo shp

library(tidytransit)
library(terra)
library(sp)
library(sf)
library(dplyr)

catalogo = read.csv("catalogo_act_eco_clave.csv")
DB0 = read.csv("actividades_económicas_por_municipio.csv", colClasses = c("character", rep("numeric", 20)))
rownames(DB0) = DB0$X
DB0$X = NULL
#colnames(DB0) = abbreviate(iconv(colnames(DB0), to="ASCII//TRANSLIT"), minlength = 5)
colnames(DB0) = abbreviate(gsub(catalogo$csv, pattern = "denue_inegi_", replacement = ""), minlength = 5)
archivo_shp = st_read("00mun.shp")
print(archivo_shp)

RF_SHP = merge(archivo_shp, DB0, by.x = "CVEGEO",by.y = 0, all = TRUE)
print(RF_SHP)
class(RF_SHP)
colnames(RF_SHP)
plot(st_geometry(RF_SHP))
colnames(RF_SHP)[1] = "cvegeo"
st_write(RF_SHP, "actividades_mun.shp", append = F)
  