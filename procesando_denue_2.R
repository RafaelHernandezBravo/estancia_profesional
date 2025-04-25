df = read.csv("diccionario_denue_11_2024.csv", encoding = "latin1")
# Obtener la lista de archivos .csv
# lista_archivos = list.files(path = "denue_11_2024", pattern = "",full.names = T, recursive = T)
load("NOMBRE.RData")
# Verificando si hay que unir al comercio al pormenor (4 csv), otros servicios no
# gubernamentales (2 csv) o alojamientos y alimentación (2 csv)
lista_comercio_al_pormenor = Z[4:7]
for(i in seq_along(lista_comercio_al_pormenor)) {
  if(i == 1 | i == 2) {
    db_comercio_al_pormenor = merge(lista_comercio_al_pormenor[[1]], lista_comercio_al_pormenor[[2]], by = 0, all = T)
  }else {
    db_comercio_al_pormenor = merge(db_comercio_al_pormenor, lista_comercio_al_pormenor[[i]], by = 0, all = T)
  }
  rownames(db_comercio_al_pormenor) = db_comercio_al_pormenor$Row.names
  db_comercio_al_pormenor$Row.names = NULL
}

# El dataset de servicios no gubernamentales no se puede generar mediante merges o joins porque
# tienen las mismas columnas y las filas representan a municipios distintos en su mayoría
# sin embargo, tienen en común 113 municipios por lo que tenemos que sumar aquellos municipios
# que son comunes a las dos tablas antes de aplicar un row bind, es decir, una unión de filas.
mpos_no_gub14 = rownames(Z[[14]])
mpos_no_gub15 = rownames(Z[[15]])
mpos_comunes = intersect(mpos_no_gub14, mpos_no_gub15)
db_servicios_no_gub_mpos_comunes = Z[[14]][mpos_comunes,] + Z[[15]][mpos_comunes,]
db_servicios_no_gub_1 = Z[[14]][!rownames(Z[[14]]) %in% mpos_comunes,] 
db_servicios_no_gub_2 = Z[[15]][!rownames(Z[[15]]) %in% mpos_comunes,] 
db_servicios_no_gubernamentales = rbind(rbind(db_servicios_no_gub_1, db_servicios_no_gub_mpos_comunes),db_servicios_no_gub_2)

# En el caso de alojamiento y servicios de alimentación tenemos la misma situación que
# en servicios no gubernamentales, es decir municipios repetidos en dos tablas distintas pero con
# las mismas columnas (unidades económicas), por lo que sumamos la información de los
#municipios comunes para así no tener municipios duplicados
dim(Z[[16]])
dim(Z[[17]])
mpos_comunes_alojamiento = intersect(rownames(Z[[16]]),rownames(Z[[17]]))
db_alojamiento_mpos_comunes = Z[[16]][mpos_comunes_alojamiento,] + Z[[17]][mpos_comunes_alojamiento,]
db_alojamiento_1 = Z[[16]][!rownames(Z[[16]]) %in% mpos_comunes_alojamiento,] 
db_alojamiento_2 = Z[[17]][!rownames(Z[[17]]) %in% mpos_comunes_alojamiento,] 
db_alojamiento = rbind(rbind(db_alojamiento_1, db_alojamiento_mpos_comunes), db_alojamiento_2)

Z[c(4:7,14:17)] = NULL

Z[[18]] = db_comercio_al_pormenor
names(Z)[18] = "denue_inegi_46111-46911"
Z[[19]] = db_servicios_no_gubernamentales
names(Z)[19] = "denue_inegi_81"
Z[[20]] = db_alojamiento
names(Z)[20] = "denue_inegi_72"
# Transformar de TABLE a Data.frame.matrix, Realizar un Merge --> (Outter join)
# y Checar lo de Comercio al por menor para ver si es combeniente hacer un bine  
# El 1 sum los totales de las filas y el 2 sum los totales de las columnas 
apply(Z[[1]],1,sum)

# A continuación calculamos los totales por municipio de cada una de las 
# 25 categoríaa de actividades económicas
list_DB = list()
for (i in 1:length(Z)){
  print(i)
  DB = as.data.frame(apply(Z[[i]],1,sum))
  list_DB[[i]] = DB
  print(head(DB))
}

# Outter join de todas las actividades económicas
DB0 = merge(list_DB[[1]], list_DB[[2]], by = 0, all = T)
rownames(DB0) = DB0$Row.names
DB0$Row.names = NULL
for (i in 3:length(list_DB)) {
  print(i)
  DB0 = merge(DB0, list_DB[[i]], by = 0, all = T)
  rownames(DB0) = DB0$Row.names
  DB0$Row.names = NULL
  print(dim(DB0))
}

# Arreglando nombres de columnas para interpretar PCA
catalogo0 = df[-c(5:8,14:17), c("nombre_abreviado", "csv")]
catalogo0$csv = gsub(paste0("denue_inegi_",gsub(catalogo0$csv, pattern = "^_00_|_$", replacement = "")), pattern = "31_33", replacement = "31-33")
catalogo1 = data.frame("nombre_abreviado" = c("Comercio al pormenor", "Servicios no gubernamentales", "Servicios de alojamiento y alimentación"),
                       "csv" = c("denue_inegi_46111-46911", "denue_inegi_81", "denue_inegi_72"))
catalogo = rbind(catalogo0, catalogo1)
catalogo$csv = factor(catalogo$csv, levels = names(Z))
catalogo = catalogo[order(catalogo$csv),]
colnames(DB0) = catalogo$nombre_abreviado
rownames(DB0) = gsub("_","",rownames(DB0))
DB0[is.na(DB0)] = 0
write.csv(DB0, "actividades_económicas_por_municipio.csv")