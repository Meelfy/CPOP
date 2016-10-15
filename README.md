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
#### Area extraction

We extract the ocean range is 100°E - 290°E & 50°N - 50°S. This range covers the entire Pacific Ocean. For different data sets we use different mask, which are provided along with the raw data. The marine area is shown below
<div align="center">
    <img src="https://github.com/MajorChina/CPOOP/blob/master/img/Ocean_Range.png" width="500">
</div>

#### Fineness conversion
We transform the resolution of oceanic data from different resolutions into 1° * 1°. Both to reduce the amount of data and make the data structure of unity. China's land precipitation data only deal with null values. 


### SPI

Calculate the Standardized Precipitation Index.

### EOF

### Clustering

#### Akaike information criterion

AIC(Akaike information criterion) is a measure of the relative quality of statistical models for a given set of data(From [wiki][AIC_wiki]). This is an effective means to determine the optimal number of clusters. You can read the [original paper][AIC article] for more information. Using this algorithm for China's land precipitation data, the results are as follows
<div align="center">
    <img src="https://github.com/MajorChina/CPOOP/blob/master/img/Clusters_AIC_200_Optimal_23.png" width="500">
</div>
We can see that. As the number of clusters increases, AIC value decreases first and then increases. When AIC value is minimum, the number of clusters is 23.

#### Hierarchical Clustering
Hierarchical clustering (also called hierarchical cluster analysis or HCA) is a method of cluster analysis which seeks to build a hierarchy of clusters(From [wiki][Hierarchical Clustering wiki]). The biggest advantage of this clustering algorithm is that it does not need to set the number of clusters at the beginning. The following figure is the result of clustering using this algorithm.
<div align="center">
    <img src="https://github.com/MajorChina/CPOOP/blob/master/img/Clusters_Hierarchical_Clustering.png" width="500">
</div>
But we still need to choose a height to determine the original data of a division.

### TDNN

### NARX+TDNN

### Deep Learning


## Staged Results and Visualization

## Reference

[1] Akaike H. Information Theory and an Extension of the Maximum Likelihood Principle[J]. Inter.symp.on Information Theory, 1973, 1:610-624.

## License

The MIT License (MIT)

Copyright (c) 2016 Mei Jie

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


[PREC]:http://data.cma.cn/data/detail/dataCode/SURF_CLI_CHN_PRE_MON_GRID_0.5.html
[OISST]:http://www.esrl.noaa.gov/psd/
[Wind]:http://www.remss.com/measurements/ccmp
[AIC_wiki]:https://en.wikipedia.org/wiki/Akaike_information_criterion
[AIC article]:http://link.springer.com/chapter/10.1007/978-1-4612-1694-0_15
[Hierarchical Clustering wiki]:https://en.wikipedia.org/wiki/Hierarchical_clustering 