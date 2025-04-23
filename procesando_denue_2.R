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

db_servicios_no_gubernamentales = merge(Z[[14]], Z[[15]], by = 0, all = T)
rownames(db_servicios_no_gubernamentales) = db_servicios_no_gubernamentales$Row.names
db_servicios_no_gubernamentales$Row.names = NULL

db_servicios_alojamiento_alimentos = merge(Z[[16]], Z[[17]], by = 0, all = T)
rownames(db_servicios_alojamiento_alimentos) = db_servicios_alojamiento_alimentos$Row.names
db_servicios_no_gubernamentales$Row.names = NULL

Z[c(4:7,14:17)] = NULL
# Transformar de TABLE a Data.frame.matrix, Realizar un Merge --> (Outter join) y Checar lo de Comercio al por menor para ver si es combeniente hacer un bine  
# El 1 sum los totales de las filas y el 2 sum los totales de las columnas 
apply(Z[[1]],1,sum)

# A continuación calculamos los totales por municipio de cada una de las 25 categoríaa de actividades económicas
list_DB = list()
for (i in 1:length(Z)){
  print(i)
  DB = as.data.frame(apply(Z[[i]],1,sum))
  list_DB[[i]] = DB
  print(head(DB))
}

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

colnames(DB0) = gsub("/|denue_inegi_|_.csv","",gsub(path, "", A))
rownames(DB0) = gsub("_","",rownames(DB0))
DB0[is.na(DB0)] = 0


