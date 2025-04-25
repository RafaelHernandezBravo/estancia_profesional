# RUTA AL DIRECTORIO DE TRABAJO
PATH = "C:/proyecto_ep/scrapping_ok"

# ESTABLECER DIRECTORIO DE TRABAJO
setwd(PATH)
getwd() #VER EL DIRECTORIO

# ver contenido del directorio 
dir()

df = read.csv("DICCIONARIO_DENUE - 11_2024.csv")
df$descarga_csv

# LOOP MEJORADO

options(timeout = 600)

for (i in 1:nrow(df)) {
  print(i)
  download_url <- df$descarga_csv[i] # Asumiendo que df$descarga_csv contiene las URLs
  file <- df$Act...Economica[i] # Asumiendo que quieres usar esto para nombres de archivos
  print(file)
  
  # Limpia el nombre del archivo para evitar problemas con caracteres especiales
  file_clean <- gsub("[^[:alnum:]_.-]", "_", file) # Reemplaza caracteres no alfanuméricos con guiones bajos
  
  tryCatch({
    download.file(download_url, destfile = paste0("C:/proyecto_ep/scrapping_ok/DENUE/11_2024/", file_clean, ".zip"), mode = "wb")
    print(paste("Descarga exitosa:", file_clean, ".zip"))
  }, error = function(e) {
    print(paste("Error al descargar", file_clean, ".zip:", e$message))
  })
}

### Objetivo: Tener en una misma carpeta "conjunto_de_datos" TODOS los archivos .csv ###

options(timeout = 600)

# Define la ruta base donde se guardarán los archivos descargados
ruta_base <- "C:/proyecto_ep/scrapping_ok/DENUE/11_2024/conjunto_de_datos/"

# Verifica si el directorio existe y crea la carpeta conjunto_de_datos si no existe
if (!dir.exists(ruta_base)) {
  dir.create(ruta_base, recursive = TRUE)
}

for (i in 1:nrow(df)) {
  print(i)
  download_url <- df$descarga_csv[i]
  file <- df$Act...Economica[i]
  
# Limpia el nombre del archivo para evitar problemas con caracteres especiales
  file_clean <- gsub("[^[:alnum:]_.-]", "_", file)
  
  tryCatch({
    # Construye la ruta completa para guardar el archivo .csv
    ruta_completa <- paste0(ruta_base, file_clean, ".csv")
    
    # Descarga el archivo y lo guarda en la carpeta conjunto_de_datos
    download.file(download_url, destfile = ruta_completa, mode = "wb")
    
    print(paste("Descarga exitosa:", file_clean, ".csv"))
  }, error = function(e) {
    print(paste("Error al descargar", file_clean, ".csv:", e$message))
  })
}

# Obtener la lista de archivos .csv

path = "C:/proyecto_ep/scrapping_ok/DENUE/11_2024/conjunto_de_datos_11_2024"
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


library(corrplot)
df$nombres_columnas = gsub(df$csv, pattern = "_00_|_$", replace = "")
DB0_trans = t(DB0)
DB0_trans_nombres = merge(DB0_trans, df[,c("nombres_columnas", "Act...Economica")], by.x = 0, by.y = "nombres_columnas")
rownames(DB0_trans_nombres) = DB0_trans_nombres$Act...Economica
DB0_trans_nombres$Row.names = NULL
DB0_trans_nombres$Act...Economica = NULL
corrplot(cor(t(DB0_trans_nombres)))

getwd()
library(FactoMineR)
library(Factoshiny)
library(missMDA)
library(FactoInvestigate)
library(Rcmdr)
pdf("PCA.pdf")
require(FactoMineR)
X=PCA(DB0)
DB0_trans = t(DB0)
X_trans = PCA(DB0_trans)
X_trans$eig
loadings = X_trans$var$coord# Esto me pidió gabo


PCA(X, scale.unit = TRUE, ncp = 25, ind.sup = NULL, 
    quanti.sup = NULL, quali.sup = NULL, row.w = NULL, 
    col.w = NULL, graph = TRUE, axes = c(1,2))

#Singular Value Decomposition #GEMINI#
svd_resultado <- svd(DB0)

svd_resultado$v
corrplot(svd_resultado$v)
corrplot(X$svd$V)


cat("Matriz de vectores singulares izquierdos (u):\n")
print(head(svd_resultado$u))
cat("\nVector de valores singulares (d):\n")
print(svd_resultado$d)
cat("\nMatriz de vectores singulares derechos (v):\n")
print(head(svd_resultado$v))


k_componentes <- 10 # Número de componentes a conservar
DB0_reducida <- svd_resultado$u[, 1:k_componentes] %*% diag(svd_resultado$d[1:k_componentes])

cat("\nMatriz de DB0 reducida a", k_componentes, "componentes:\n")
print(head(DB0_reducida))



X$svd$U
corrplot(X$svd$V)
cor(X$svd$V)
