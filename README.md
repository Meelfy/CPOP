# Chinese Precipitation And Oceanic Processes

Full name **Temporal and Spatial Information Mining and Application of Chinese Precipitation and Ocean Processes Based on Remote Sensing Large Data**

CPOOP(Chinese Precipitation And Oceanic Processes) is a scientific research project that analyzes the spatial correlation  between Chinese precipitation and the Pacific Ocean and the Indian Ocean. This project focuses on the impact of ocean processes on precipitation in China.

## Research Background

## Data Description

We have used four different data sets:

1. **Monthly precipitation in China**(中国地面降水月值) You can click on this [link][PREC] for more information.

2. **SST**(Sea surface temperature). NOAA_OI_SST_V2 data provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA, from their Web site at [here][OISST].

3. **Wind** CCMP Version-2.0 vector wind analyses are produced by Remote Sensing Systems. Data are available at [here][Wind].

4. **SLA**  [TODO]AVISO



## Research Principles and Processes

### Preprocessing
This section preprocesses the raw data. You can see the source code in the `1-Preprocessing\`. The main operations are 
- Area extraction
- Fineness conversion

We extract the ocean range is 100°E - 290°E & 50°N - 50°S. This range covers the entire Pacific Ocean. For different data sets we use different mask, which are provided along with the raw data. The marine area is shown below
<img src="https://github.com/MajorChina/CPOOP/blob/master/img/Ocean_Range.png">



### SPI

Calculate the Standardized Precipitation Index.

### EOF

### Clustering

#### Akaike information criterion
AIC(Akaike information criterion) is a measure of the relative quality of statistical models for a given set of data(From [wiki][AIC_wiki]). This is an effective means to determine the optimal number of clusters. Using this algorithm for China's land precipitation data, the results are as follows
<img src="https://github.com/MajorChina/CPOOP/blob/master/img/Clusters_AIC_200_Optimal_23.png">

We can see that. As the number of clusters increases, AIC value decreases first and then increases. When AIC value is minimum, the number of clusters is 23.

### TDNN

### NARX+TDNN

### Deep Learning


## Staged Results and Visualization

## License



[PREC]:http://data.cma.cn/data/detail/dataCode/SURF_CLI_CHN_PRE_MON_GRID_0.5.html
[OISST]:http://www.esrl.noaa.gov/psd/
[Wind]:http://www.remss.com/measurements/ccmp
[AIC_wiki]:https://en.wikipedia.org/wiki/Akaike_information_criterion