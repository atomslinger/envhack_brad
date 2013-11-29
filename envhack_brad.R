setwd("~/Repos/envhack/data")

# build URL string
build.url <- function(dvar1,year,dvar2,datenf,tvar,north,west,east,south,tbeg,tend) {
paste( "http://opendap.bom.gov.au:8080/thredds/ncss/grid/daily_",
       dvar1,
       "_5km/",
       year,
       "/",
       dvar2,
       "-day_awap_daily_0deg05_aust_",
       datenf,
       ".nc?var=",
       tvar,
       "_day&spatial=bb&north=",
       north,
       "&west=",
       west,
       "&east=",
       east,
       "&south=",
       south,
       "&temporal=range&time_start=",
       tbeg,
       "T00%3A00%3A00Z&time_end=",
       tend,
       "T00%3A00%3A00Z&horizStride=1&addLatLon=true", 
       sep="")
}

library(raster)
library(ncdf)

tbeg <- as.Date(0,origin="01-07-2010",format="%d-%m-%Y")
tend <- as.Date(-1,origin="01-07-2011",format="%d-%m-%Y")
tser <- seq(tbeg,tend,by="days")

#Mediterranean forest: N -33.6 S -33.7 E 119 W 118.9
#Desert: N -25 S -25.1 E 125.4 W 125.4
#Tropical grassland: N -25.2 S -25.3 E 149.1 W 149.0
#Temperate grassland: N -29.0 S -29.1 E 147 W 146.9
co1 <- c(-33.6,-33.7,119,118.9) # Mediterranean forest
co2 <- c(-25,-25.1,125.4,125.4) # desert grass
co3 <- c(-25.2,-25.3,149.1,149.0) # tropical grass
co4 <- c(-25.2,-29.1,147,146.9) # temperate grass

para.fold   <-c("maximum_temperature","minimum_temperature","rain","vapour_pressure_9am")
para.days   <-c("temperature-maximum","temperature-minimum","rainfall","vapour-pressure-9am")
para.vars   <-c("temp_max","temp_min","rain","water_vapour_pressure_9am")

co1 <- formatC( co1, format="f", digits=4 )
co2 <- formatC( co2, format="f", digits=4 )
co3 <- formatC( co3, format="f", digits=4 )
co4 <- formatC( co4, format="f", digits=4 )

nulb <- formatC( c(-31.5,-32.5,125.1,123.2), format="f", digits=4 )

build.url("maximum_temperature",2010,"temperature-maximum",gsub("-","",tbeg),
          "temp_max",co2[1],co2[2],co2[3],co2[4],tbeg,tend)


for( i in 1:2 ) {
    for( j in 1:31 ) {
        time.unf <- gsub("-","",tser[j])
        uri <- build.url( para.fold[i], 2010, para.days[i], time.unf, para.vars[i],
                         nulb[1], nulb[2], nulb[3], nulb[4], tser[j], tend )
        system(paste("wget",uri))
        Sys.sleep(5)
    }
}

