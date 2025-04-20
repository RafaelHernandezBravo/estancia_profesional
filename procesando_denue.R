df = read.csv("diccionario_denue_11_2024.csv", encoding = "latin1")
# Obtener la lista de archivos .csv
path = "denue_11_2024/conjunto_de_datos_11_2024"
A = list.files(path = path, pattern = "\\.csv$", full.names = T)
fx = function(x) {
  D = read.csv(A[x], colClasses = "character")
  id = paste(D$cve_ent, D$cve_mun, sep="_")
  as.data.frame.matrix(table(id, D$codigo_act))}

Z = lapply(1:length(A), fx)
str(Z)
names(Z) = gsub(path, "", A)
saveRDS(Z, "NOMBRE.rds")

# Transformar de TABLE a Data.frame.matrix, Realizar un Merge --> (Outter join) y Checar lo de Comercio al por menor para ver si es combeniente hacer un bine  
class(Z[[1]])

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


