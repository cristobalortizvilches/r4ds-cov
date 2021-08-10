library(tidyverse)
library(datos)


#--Plantilla ggplot básica----
#ggplot(data = <DATOS>) +
#<GEOM_FUNCIÓN>(mapping = aes(<MAPEOS>))

#--Plantilla ggplot completa--
#ggplot(data = <DATOS>) +
  #<GEOM_FUNCIÓN>(
    #mapping = aes(<MAPEOS>),
    #stat = <ESTADÍSTICAS>,
    #position = <POSICIÓN>
  #) +
  #<FUNCIÓN_COORDENADAS> +
  #<FUNCIÓN_FACETAS>

#----Lineas y puntos para BBDD millas----
millas
?millas

ggplot(data = millas) + 
  geom_point(mapping = aes(x = cilindrada, y = autopista))

##scaling es el proceso de asignar un nivel estético a cada valor  

#scaling con var categórica "clase"
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista, color = clase))

#scaling con var continua "anio"
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista, color = anio))

#scaling que dicotomiza en base a operador lógico
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista, color = cilindrada < 5))

#podemos escalar la estética con:
#color (colour)
#size
#alpha
#shape

#asignar estética de forma manual (queda fuera de aes() y como argumento de geom_point())
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista), color = "red")

#dividir gráfico en facetas según categoría
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista)) +
  facet_wrap(~ clase, nrow = 2)

#dividir gráfico en facetas según combinación de dos variables
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista)) +
  facet_grid(traccion ~ cilindros)

#mas de un geom_
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista)) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista))

#escalar la estética para lineas con:
#linetype

#mas dee un geom_ con escalamiento
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista, color = traccion)) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista, linetype = traccion))

##diferentes maneras de escalar
#por linetype
ggplot(data = millas) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista, linetype = traccion))
#por color
ggplot(data = millas) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista, color = traccion))
#por group (no agrega leyenda)
ggplot(data = millas) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista, group = traccion))


##mostrar más de un geom de manera eficiente
#tenemos:
ggplot(data = millas) +
  geom_point(mapping = aes(x = cilindrada, y = autopista)) +
  geom_smooth(mapping = aes(x = cilindrada, y = autopista))
#es lo mismo que: 
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point() +
  geom_smooth()

#escalando estéticas al interior de cada capa
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(mapping = aes(color = clase)) +
  geom_smooth(mapping = aes(linetype = traccion))

#escalando y filtrando categorías 
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(mapping = aes(color = clase)) +
  geom_smooth(data = filter(millas, traccion == "t"), mapping = aes(linetype = traccion),se = FALSE)
#otro ejemplo quitando se de geom_smooth
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(mapping = aes(color = clase)) +
  geom_smooth(data = filter(millas, clase == "subcompacto"), se = FALSE)

#ejercicio
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista, color = traccion)) +
  geom_point()
#lo que viene es lo mismo? R: todo indica que sí
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(mapping = aes(color = traccion))

#ejercicio 2: recreando gráficos
#1
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(size = 4) +
  geom_smooth(color = "blue", se = F)
#2
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista)) +
  geom_point(size = 4) +
  geom_smooth(aes(group = traccion),color = "blue", se = F)
#3
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista, color = traccion)) +
  geom_point(size = 4) +
  geom_smooth(size = 1.5,se = F)
#4
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista, color = traccion)) +
  geom_point(size = 4) +
  geom_smooth(color = "blue", size = 1.5, se = F)
#5
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista, color = traccion, linetype = traccion)) +
  geom_point(size = 4) +
  geom_smooth(color = "blue", size = 1.5, se = F)
#6 -> tuve que buscar la solución
ggplot(data = millas, mapping = aes(x = cilindrada, y = autopista, color = traccion)) +
  geom_point(size = 4, color = "white") +
  geom_point(aes(color = traccion))

#----Barras para BBDD diamantes----

ggplot(data = diamantes) +
  geom_bar(mapping = aes(x = corte))
#mismo gráfico que el anterior, pero diferentes comandos. explicación: geom_bar usa stat_count
ggplot(data = diamantes) +
  stat_count(mapping = aes(x = corte))
#mismo grafico anteior pero con proporción
ggplot(data = diamantes) +
  geom_bar(mapping = aes(x = corte, y = stat(prop), group = 1))

#para ver todas las transformaciones estadísticas disponibles:
?stat_bin

#escalar color del contorno 
ggplot(data = diamantes) +
  geom_bar(mapping = aes(x = corte, colour = corte))
#escalar color del relleno
ggplot(data = diamantes) +
  geom_bar(mapping = aes(x = corte, fill = corte))
#escalar apilando la suma de determinada categoría
ggplot(data = diamantes) +
  geom_bar(mapping = aes(x = corte, fill = claridad))
#escalar apilando la proporción de determinada categoría
ggplot(data = diamantes, mapping = aes(x = corte, fill =claridad)) +
  geom_bar(position = "fill")
#escalar con dogdge
ggplot(data = diamantes, mapping = aes(x = corte, fill =claridad)) +
  geom_bar(position = "dodge")

#invertir ejes
ggplot(data = millas, mapping = aes(x = autopista, y = clase)) +
  geom_boxplot()

ggplot(data = millas, mapping = aes(x = clase, y = autopista)) +
  geom_boxplot() +
  coord_flip()


nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()


bar <- ggplot(data = diamantes) +
  geom_bar(
    mapping = aes(x = corte, fill = corte),
    show.legend = FALSE,
    width = 1
  ) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()
