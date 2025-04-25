library(FactoMineR)

# Actividades económicas como columnas, municipios como filas
DB0 = read.csv("actividades_económicas_por_municipio.csv",colClasses = c("character", rep("numeric", 20)))
rownames(DB0) = DB0$X
DB0$X = NULL

X=PCA(DB0)
plot.PCA(X, choix = "var", axes = c(2,3))

# Municipios como columnas, actividades económicas como filas
DB0_trans = as.data.frame(t(DB0))
X_trans = PCA(DB0_trans, ncp = 10)
X_trans$eig
loadings = as.data.frame(as.matrix(X_trans$var$coord))

write.csv(loadings, "factor_loadings_mpos_PCA.csv", row.names = T)