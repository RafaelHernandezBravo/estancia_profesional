# Cargando librerías
library(readxl)
library(tidyverse)
library(reshape2)

# Procesando información Jóvenes
programas = read_excel("2024T3.xlsx")
write.csv(programas, "2024T3.csv", row.names = F)
programas = read.csv("2024T3.csv",skip = 6) %>% na.omit()
nombres = gsub(strsplit(readLines("2024T3.csv",n = 6), split = ",")[[6]], 
     pattern = "NA|\"|:|\\.", replacement = "") %>% 
  gsub(pattern = " +", replacement = "_") %>% 
  tolower()
programas = read_excel("2024T3.xlsx",skip = 6) %>% na.omit()
colnames(programas) = paste0(colnames(programas),"_",nombres)
programas$`Cve Entidad Federativa_` = as.numeric(programas$`Cve Entidad Federativa_`)

programas_jovenes = programas %>% 
  select(c(colnames(programas)[1:4],grep(colnames(programas), pattern = "s280", ignore.case = T, value = T)))
colnames(programas_jovenes)[1] = "entidad"
colnames(programas_jovenes) = gsub(colnames(programas_jovenes),
                                   pattern = "Periodo : | 2024|\\.\\.\\.5.|.*-",
                                   replacement = "")

#Cargando DENUE procesada
denue = read.csv("actividades_económicas_por_municipio.csv")
denue$entidad = gsub(denue$X, pattern = "...$", replacement = "")
# Calculando totales por entidad de los totales municipales
denue_entidad = denue %>%
  melt(id = c("X", "entidad")) %>% 
  dcast(entidad ~ variable, value.var = "value", fun.aggregate = sum) %>% 
  mutate(entidad = as.numeric(entidad)) %>% 
  arrange(entidad)

denue_melt = melt(denue, id = c("X", "entidad"))
denue_dcast= dcast(denue_melt, entidad ~ variable, value.var = "value", fun.aggregate = sum)

# Uniendo información 
programa_jovenes_denue = merge(programas_jovenes, denue_entidad, by = "entidad")
colnames(programa_jovenes_denue) = abbreviate(colnames(programa_jovenes_denue), 15)

# Correlación del número de apoyos asignados por entidad con el número de unidades
# económicas de diversos tipos igualmente por entidad
#pdf("programa_jovenes_denue.pdf", 10, 10)
corrplot::corrplot(cor(programa_jovenes_denue[,-(1:2)])[1:5,])
#dev.off()
