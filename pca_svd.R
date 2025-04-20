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
loadings = X_trans$var$coord

##
X$svd$U
corrplot(X$svd$V)
cor(X$svd$V)

### EDICION PENDIENTE
library(corrplot)
df$nombres_columnas = gsub(df$csv, pattern = "_00_|_$", replace = "")
DB0_trans = t(DB0)
DB0_trans_nombres = merge(DB0_trans, df[,c("nombres_columnas", "Act...Economica")], by.x = 0, by.y = "nombres_columnas")
rownames(DB0_trans_nombres) = DB0_trans_nombres$Act...Economica
DB0_trans_nombres$Row.names = NULL
DB0_trans_nombres$Act...Economica = NULL
corrplot(cor(t(DB0_trans_nombres)))
