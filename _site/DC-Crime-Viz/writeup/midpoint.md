# Mid-Point Writeup

## Time Series Plot

![time series](screenshots/dc_crime_rate_timeseries.png?raw=true "Title")

* The time series plot above displays total violent crime rates from 1960 to 2019 in Washington, DC, Virginal and Maryland, also known as the DMV. Violent crime refers to. In a violent crime, a victim is harmed by or threatened with violence. Violent crimes include rape and sexual assault, robbery, assault and murder.As see in the graph, Washington DC, has the highest violent crime rates when compared to neighboring states Virginia and Maryland.

* This plot was created in R using the plotly package. Readers are able to interact with the plot by clicking on the graph to focuse on partical time periods or states.

## Scatter Plot

![scatter plot](screenshots/dc_crime_rate_scatter.png?raw=true "Title")
* The scatter plot above is used to visualize violent murder crime rates in District of Colombia, Maryland and Virginia from 1960 to 2019. The bullet points each represent the size of the population for each state and districts. While DC, has the smallest population, it has a the highest crime rate when compared to VA and MD. The animation presented in the scatter plot are intended to highlight the large difference in murder crime rates in each state, and how wider the gaps get over time. 

* The visualization is created is are using r packages ggplot and gganimate.

## Violin Graph

![violon](screenshots/violin.png?raw=true "Title")

* A violin plot is used to visualize the distribution of the various crimes. The log10 transformed number of incidents is used for better scaling and visibility. The typical rainbow color scheme is used to distinguish the types of crimes. The viewer is able to select the type of crimes either from the violins or the legend, and see details of the crimes in the tooltips feature. 

* However, its interactivity is limited to the basic plotly functionalities. Only the DC data is included due to a temporary obstacle in wrangling the VA dataset. It realized only part of the functions we expected. I'll strive to make improvements later, where adding the function to select area and year from the menu is the most crucial next step. I'll also create a button for switching between the identity and log10 measure of the y-axis and make some other improvements on the tooltips. 

## Maps

* The first choropleth map is showing the overall crime number and crime rate in each of the eight wards. The color of this choropleth is dependent on the absolute value of number of crimes, which indicates the frequency of the crime activities. Tooltips will show ward number, the exact number on number of crimes and crime rate based on population when hovering the mouse over.

![wordcloud](screenshots\crime_2021.png?raw=true "Title")

* The second map is a prototype of choropleth map that has a drop down menu to allow user to explore the data freely. Users will be able to choose the type offense and type of map to show at will. The main purpose of this graph is to show the differences between different type of crimes.

![crimetype](screenshots/crime_type_2021.png?raw=true "Title")

## Wordcloud

![wordcloud](screenshots/wordcloud.png?raw=true "Title")

* The two wordclouds are based on types of crimes and DC Wards respectively. The size of words are positively related to the number of incidents. For both of them, the "random-dark" color is used with white background. The wordclouds aim to provide a conclusion-like visualization that the viewer would immediately have the idea about which towns are the most dangerous/safest, or which crimes are most prevalent. 

* It doesn't have much interactability yet besides the tooltips showing the selected name (ward or crime), and the corresponded number of incidents. I'm striving to add the ability to select area and year without diminishing the visual effects. 

## Faceted Bar Graph

![faceted bar graph](screenshots/VA_violent_crime.png?raw=true "Title")

* The faceted bar graph shown above is an overview of the Virginia metropolitan area's 2017 violent crime rate breakdown. The crime rate gives the number of crimes matching each county/city for every 1,000 people living in that area for the year 2017. It is calculated by dividing the number of different types of violent crimes by the estimated population, and multiplying the result by 1,000. The use of facet clearly shows the different distributions of each type of violent crime rate in each county/city in Virginia-Washington metropolitan area. The audience can have a clear idea on the very area that has the most aggravated assaults whereas the area has the least violent crimes in total in the year of 2017.

* It's worth mentioning that since the original dataset has three NAs of Murder and Nonnegligent Manslaughter in Culpeper county, city of Fairfax, and Rappahannock county, so that there has no bar showing in the their individual bar plots. 
