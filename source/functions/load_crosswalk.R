load_crosswalk <- function(year){
  
  # check inputs
  if (is.numeric(year) == FALSE){
    stop("The 'year' value provided is invalid. Please provide a numeric value between 2009 and 2021.")
  }
  
  if (year %in% c(2009:2022) == FALSE){
    stop("The 'year' value provided is invalid. Please provide a numeric value between 2009 and 2021.")
  }
  
  # load data
  if (year %in% c(2009, 2010)){
    out <- readxl::read_excel(path = paste0("data/data_raw/ZIPCodetoZCTACrosswalk", year , "UDS.xls"))
  } else {
    out <- readxl::read_excel(path = paste0("data/data_raw/ZIPCodetoZCTACrosswalk", year , "UDS.xlsx")) 
  }
  
  # tidy
  if (year == 2009) {
    
    ## address columns
    out <- dplyr::select(out, ZIP = ZIP, PO_NAME = CityName, STATE = StateAbbr, ZCTA = ZCTA_USE)
    
  } else if (year %in% c(2010:2013) == TRUE){
    
    ## preliminary fixes
    if (year %in% c(2012, 2013) == TRUE){
      out <- dplyr::mutate(out, StateAbbr = ifelse(is.na(StateAbbr) == TRUE, StateName, StateAbbr))
    }
    
    ## address columns
    out <- dplyr::select(out, ZIP, PO_NAME = CityName, STATE = StateAbbr, ZIP_TYPE = ZIPType, ZCTA = ZCTA_USE)
    
    ## additional fixes
    if (year %in% c(2010:2013) == TRUE){
      
      # fix capitalization
      out <- dplyr::mutate(out, PO_NAME = stringr::str_to_title(PO_NAME))
      
      # address ZIP_TYPE
      out <- dplyr::mutate(out, ZIP_TYPE = dplyr::case_when(
        ZIP_TYPE == "U" ~ "Post Office or large volume customer",
        ZIP_TYPE == "P" ~ "Post Office or large volume customer",
        ZIP_TYPE == "L-PY" ~ "L-PY",
        ZIP_TYPE == "M" ~ "M",
        ZIP_TYPE == "S" ~ "ZIP Code area"
      ))
      
      # fix ZIPs in 2010
      # if (year == 2010){
      #  out <- dplyr::filter(out, ZCTA != "N/A")
      # }
      
    }
    
  } else if (year == 2014){
    
    out <- dplyr::mutate(out, ZIP = ifelse(ZIP == "4691", "04691", ZIP))
    
  } else if (year %in% c(2016:2022)){
    
    ## fix ZCTA name
    if (year == 2022){
      out <- dplyr::rename(out, ZCTA = zcta)
    }
    
    ## fix ZIP code name
    out <- dplyr::rename(out, ZIP = ZIP_CODE)
    
    ## remove non-ZCTA geometries
    # if (year %in% c(2019:2021)){
    #  out <- dplyr::filter(out, ZCTA != "No ZCTA")
    # }
  }
  
  # convert to lower-case
  out <- dplyr::rename_with(out, tolower)
  
  # re-order output
  out <- dplyr::arrange(out, zip)
  
  # convert to tibble
  out <- tibble::as_tibble(out)
  
  # return output
  return(out)
  
}