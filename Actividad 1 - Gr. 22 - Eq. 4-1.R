library(readr)
avocado_updated_2020 <- read_csv("C:/Documentos profesionales/Maestria/analisis masivos de datos para el negocio/avocado-updated-2020.csv")
View(avocado_updated_2020)
##### PUNTO 1 #####
# Copia a la base original
copia_avocado <- avocado_updated_2020
# Dimensiones, caracteristicas y resumen de la copia
dim(copia_avocado)
str(copia_avocado)
summary(copia_avocado)
# Gráfica de caja de precio
boxplot(x = copia_avocado$average_price)
# Gráfica de caja de precio por tipo de aguacate
boxplot(formula = copia_avocado$average_price~copia_avocado$type)
# Gráfica de precio por total de volumen de ventas
plot(copia_avocado$total_volume,copia_avocado$average_price)
# Covarianza y Correlación de volumen total y precio
cov(copia_avocado$total_volume,copia_avocado$average_price)
cor(copia_avocado$total_volume,copia_avocado$average_price)
# Gráfica de total de ventas por fecha
plot(copia_avocado$date,copia_avocado$total_volume)
# Gráfica de caja de volumen de ventas
boxplot(x = copia_avocado$total_volume)
# Gráfica de caja de referencias de aguacate
boxplot(copia_avocado[["4046"]], copia_avocado[["4225"]], copia_avocado[["4770"]],
        main = "Diagrama de Cajas de Tres Variables",
        names = c("4046", "4225", "4770"),
        col = c("lightblue", "lightgreen", "lightpink"),
        border = c("darkblue", "darkgreen", "darkred"))
# Gráfica de caja de tamaños de paquetes
boxplot(copia_avocado[["small_bags"]], copia_avocado[["large_bags"]], copia_avocado[["xlarge_bags"]],
        main = "Diagrama de Cajas de Tres Variables (tipo de paquete)",
        names = c("small_bags", "large_bags", "xlarge_bags"),
        col = c("lightblue", "lightgreen", "lightpink"),
        border = c("darkblue", "darkgreen", "darkred"))
# Se analizan los valores unicos para Geography
unique(copia_avocado$geography)
# Como se identificó que hay registros del total de estados unidos, se genera una copia de la data
# sin incluir el Total U.S.
copia_avocado_sintotalUS <- copia_avocado[copia_avocado$geography != "Total U.S.",]
# Se calcula un resumen
summary(copia_avocado_sintotalUS)
# se recalcula la covarianza y correlación entre volumen total y precio
cov(copia_avocado_sintotalUS$total_volume,copia_avocado_sintotalUS$average_price)
cor(copia_avocado_sintotalUS$total_volume,copia_avocado_sintotalUS$average_price)
# Se grafica de nuevo las graficas de volumen total Vs precio, precio vs fecha y volumen total
# vs fecha
plot(copia_avocado_sintotalUS$total_volume,copia_avocado_sintotalUS$average_price)
plot(copia_avocado_sintotalUS$date,copia_avocado_sintotalUS$average_price)
plot(copia_avocado_sintotalUS$date,copia_avocado_sintotalUS$total_volume)
boxplot(x = copia_avocado_sintotalUS$total_volume)
# Se grafica de nuevo las graficas de cajas de tipo de referencia y tamaño de paquetes
boxplot(copia_avocado_sintotalUS[["4046"]], copia_avocado_sintotalUS[["4225"]], copia_avocado_sintotalUS[["4770"]],
        main = "Diagrama de Cajas de las referencias",
        names = c("4046", "4225", "4770"),
        col = c("lightblue", "lightgreen", "lightpink"),
        border = c("darkblue", "darkgreen", "darkred"))
boxplot(copia_avocado_sintotalUS[["small_bags"]], copia_avocado_sintotalUS[["large_bags"]], copia_avocado_sintotalUS[["xlarge_bags"]],
        main = "Diagrama de Cajas de Tres Variables (tipo de paquete)",
        names = c("small_bags", "large_bags", "xlarge_bags"),
        col = c("lightblue", "lightgreen", "lightpink"),
        border = c("darkblue", "darkgreen", "darkred"))
##### PUNTO 2 #####
precio_tipo_ciudad_Albany_Boston <- copia_avocado[(copia_avocado$geography=="Albany"|copia_avocado$geography=="Boston")&copia_avocado$type=="organic",c("average_price","type","geography")]
precio_Albany_Boston <- copia_avocado[(copia_avocado$geography=="Albany"|copia_avocado$geography=="Boston")&copia_avocado$type=="organic",c("average_price")]
##### PUNTO 3 #####
# Se generan bases independientes por tipo de aguacate
copia_avocado_organico <- copia_avocado[copia_avocado$type=="organic",]
copia_avocado_conventional <- copia_avocado[copia_avocado$type=="conventional",]
# Se calculan las covarianzas y correlaciones entre precio y volumen de ventas
# Organico
cov(copia_avocado_organico$average_price,copia_avocado_organico$total_volume)
cor(copia_avocado_organico$average_price,copia_avocado_organico$total_volume)
# Convencional
cov(copia_avocado_conventional$average_price,copia_avocado_conventional$total_volume)
cor(copia_avocado_conventional$average_price,copia_avocado_conventional$total_volume)
##### PUNTO 4 #####
# Relación en logaritmos para previo y volumen (Orgánico)
# La variable dependiente sería el volumen total
# La variable independiente sería el precio
lm(copia_avocado_organico$total_volume~copia_avocado_organico$average_price)
lm(log(copia_avocado_organico$total_volume)~log(copia_avocado_organico$average_price))
# La fórmula sería VolumenTotal=10.1407-0.7665*Precio
# Relación en logaritmos para previo y volumen (Convencional)
# La variable dependiente sería el volumen total
# La variable independiente sería el precio
lm(copia_avocado_conventional$total_volume~copia_avocado_conventional$average_price)
lm(log(copia_avocado_conventional$total_volume)~log(copia_avocado_conventional$average_price))
# La fórmula sería VolumenTotal=13.42-1.32*Precio
##### PUNTO 5 #####
copia_organico_albany <- copia_avocado[copia_avocado$type=="organic"&copia_avocado$geography=="Albany",]
cov(copia_organico_albany$average_price,copia_organico_albany$total_volume)
cor(copia_organico_albany$average_price,copia_organico_albany$total_volume)
lm(copia_organico_albany$total_volume~copia_organico_albany$average_price)
lm(log(copia_organico_albany$total_volume)~log(copia_organico_albany$average_price))
estimacion_organico_albany <- lm(copia_organico_albany$total_volume~copia_organico_albany$average_price)
summary(estimacion_organico_albany)
# se puede creer
plot(copia_organico_albany$average_price)
precio_organico_albany <- ts(copia_organico_albany$average_price, start=c(2015,1), frequency = 52)
plot(precio_organico_albany)
# descomposión (ciclo, tendencia, irregular, estacional)
decompose(precio_organico_albany)
plot(decompose(precio_organico_albany))
descomposicion_precio_albany_org <- decompose(precio_organico_albany)
install.packages("forecast")
library(forecast)
modeloprecio_albany_organico <-auto.arima(precio_organico_albany)
prediccion_precio_albany_org <- forecast(modeloprecio_albany_organico,20)
plot(prediccion_precio_albany_org)
prediccion_precio_albany_org$mean





