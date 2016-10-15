# Chinese Precipitation And Oceanic Processes

Full name **Temporal and Spatial Information Mining and Application of Chinese Precipitation and Ocean Processes Based on Remote Sensing Large Data**

CPOOP(Chinese Precipitation And Oceanic Processes) is a scientific research project that analyzes the spatial correlation  between Chinese precipitation and the Pacific Ocean and the Indian Ocean. This project focuses on the impact of ocean processes on precipitation in China.

## Research Background

## Data Description

We have used four different data set:

1. **Monthly precipitation in China**(中国地面降水月值) You can click on this [link][PREC] for more information.

2. **SST**(Sea surface temperature). NOAA_OI_SST_V2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their Web site at [here][OISST].

3. **Wind** CCMP Version-2.0 vector wind analyses are produced by Remote Sensing Systems. Data are available at [here][Wind].

4. **SLA**  [TODO]AVISO



## Research Principles and Processes

### Preprocessing
This section preprocesses the raw data. You can see the source code in the `1-Preprocessing\`. The main operations are 
- Area extraction
- Fineness conversion

#### Precipitation


#### SST
#### SLA
#### WIND

### SPI
### EOF
### Clustering
### TDNN
### NARX+TDNN
### Deep Learning

## Staged Results and Visualization

## License



[PREC]:http://data.cma.cn/data/detail/dataCode/SURF_CLI_CHN_PRE_MON_GRID_0.5.html
[OISST]:http://www.esrl.noaa.gov/psd/
[Wind]:http://www.remss.com/measurements/ccmp