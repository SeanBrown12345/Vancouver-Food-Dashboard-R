# Vancouver-Food-Dashboard-R

 An interactive dashboard exploring food programs across Vancouver.

 Check out the deployment here: https://019cde55-8bc0-ce16-46c1-466850d2ac3f.share.connect.posit.cloud/

 ## Running the app locally

 - Clone the repository and open `app.r` in RStudio.

 - Install the required R packages by running the following command in the R console:

```r
install.packages(c(
  "shiny",
  "bslib",
  "dplyr",
  "jsonlite",
  "leaflet",
  "shinyWidgets"
))
```

- Run the app:

```r
shiny::runApp("app.r")
```
