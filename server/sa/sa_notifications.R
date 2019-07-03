#----------------------------------------------------------------------------
# This script adds to the SA tab notifications based on yesterday's Potomac River flows 
# and yesterday's total Potomac withdrawals. Note that when the agreements refer to "flow"
# they are generally referring to what we now call Little Falls "adjusted flow",
# and below we report flow and triggers in terms of Little Falls observed flow.
# Adjusted flow is equal to observed flow + total WMA Potomac withdrawals.
#
#----------------------------------------------------------------------------
# First compute yesterday's mean flows and withdrawals:
#
cfs_to_mgd <- 0.6464 # = 1/1.547; should put this in a parameters file
#
tot.withdrawal <- reactive({ # this is yesterday's total WMA Potomac withdrawal, mgd
  req(!is.null(todays.date()))
  if (is.null(withdrawals.df())) return(NULL)
  withdr.scalar <- withdrawals.df() %>%
    filter(date_time == todays.date() - lubridate::days(1),
           site == "potomac_total") %>%
    mutate(flow = round(flow)) %>%
    pull(flow)
  if (length(withdr.scalar) == 0) return(NULL)
  return(withdr.scalar)
})
#
#
por.yesterday.cfs <- reactive({
  req(!is.null(todays.date()))
  if (is.null(daily.df())) return(NULL)
  por.scalar <- daily.df() %>%
    filter(date_time == todays.date() - lubridate::days(1),
           site == "por") %>%
    mutate(flow = round(flow)) %>% 
    pull(flow)
  if (length(por.scalar) == 0) return(NULL)
  return(por.scalar)
})
#
#
lfalls.yesterday.mgd <- reactive({ # this is yesterday's observed flow at Little Falls
  req(!is.null(todays.date()))
  if (is.null(daily.df())) return(NULL)
  lfalls.scalar <- daily.df() %>%
    filter(date_time == todays.date() - lubridate::days(1),
           site == "lfalls") %>%
    mutate(flow = round(flow * cfs_to_mgd)) %>% 
#    mutate(flow = round(flow)) %>% 
    pull(flow)
  if (length(lfalls.scalar) == 0) return(NULL)
  return(lfalls.scalar)
})
#----------------------------------------------------------------------------
# Next, prepare outputs to report flows and triggers:
#
# Report mean daily observed flow at POR yesterday:
output$sa_notification_1 <- renderText({
  if (is.null(por.yesterday.cfs())) {
    paste("Yesterday's mean flow at Point of Rocks ",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("Yesterday's mean flow at Point of Rocks = ",
          por.yesterday.cfs(),
          " cfs.")
  }
})
#
# Report mean daily observed flow at lfalls yesterday:
output$sa_notification_2 <- renderText({
  if (is.null(lfalls.yesterday.mgd())) {
    paste("Yesterday's mean flow at Little Falls (observed) ",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("Yesterday's mean flow at Little Falls (observed) = ",
          lfalls.yesterday.mgd(),
          " MGD.")
  }
})
#
# Report mean daily total WMA Potomac withdrawals yesterday:
output$sa_notification_3 <- renderText({
  if (is.null(tot.withdrawal())) {
    paste("Yesterday's mean WMA total Potomac withdrawals ",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("Yesterday's mean WMA total Potomac withdrawals = ",
          tot.withdrawal(),
          " MGD.")
  }
})
#
# Next, the trigger for drought ops - as stated in the WSCA's Drought Manual
#
output$sa_notification_4 <- renderText({
  if (is.null(tot.withdrawal())) {
    paste("The trigger for drought operations under the WSCA ",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("Drought operations under the WSCA commences when flow at Little Falls < ",
          tot.withdrawal() + 100,
          " MGD.")
  }
})
#
# Next the LFAA's threshold for the Alert Stage: LFAA pp. 11-12 gives the threshold 
# in terms of "adjusted flow": W > 0.5*Qadj (where Qadj = Qobs + W, 
# and W is total WMA Potomac withdrawals). Converting to observed flow, the threshold is:
# Qobs < W (both values from yesterday, calculated from midnight to midnight)
output$sa_notification_5 <- renderText({
  if (is.null(tot.withdrawal())) {
    paste("The numerical trigger for the LFAA Alert Stage ",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("The LFAA's Alert Stage may be triggered when yesterday's flow at Little Falls < ",
          tot.withdrawal(),
          " MGD.")
  }
})
#
# Next the LFAA's threshold for the Restriction Stage, 
# given in the Memorandum of Intent, p. 2, 3., is W + 100 > 0.8*Qadj (in mgd)
# or Qobs < W/4 + 125 mgd:

output$sa_notification_6 <- renderText({
  if (is.null(tot.withdrawal())) {
    paste("The numerical trigger for the LFAA Restriction Stage",
          "cannot be calculated for the currently selected 'Todays Date'.")
  } else {
    paste("The LFAA Restriction Stage may be triggered when 
          yesterday's flow at Little Falls < ",
          round(tot.withdrawal() * 0.25 + 125),
          " MGD.")
  }
})
#----------------------------------------------------------------------------
# Display VA and MD drought status maps
map_va <- "http://deq1.bse.vt.edu/drought/state/images/maps/imageMapFile152053721827416.png"
output$sa_graphics_1 <- renderText({c('<img src="',map_va,'">')})
#
map_md <- "http://mde.maryland.gov/programs/Water/droughtinformation/Currentconditions/PublishingImages/DroughtGraphsStarting2017Apr30/Drought2018-01-31.png"
output$sa_graphics_2 <- renderText({c('<img src="',map_md,'">')})
  