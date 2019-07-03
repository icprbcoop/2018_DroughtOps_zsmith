tabPanel("Situational Awareness",
         fluidRow(
           align = "center",
           plotOutput("sa", height = plot.height, width = plot.width),
           br()
         ), 
         fluidRow(
           column(width = 6,
                  h2("Potomac Flows, Withdrawals, and Triggers")
                  ),
           column(width = 3,
                  h2("Virginia Drought Status Map")
                  ),
           column(width = 3,
                  h2("Maryland Drought Status Map"))
         ),
         fluidRow(
           br(),
           #         column(6, textOutput("sa_notification_1")),
           # column(width = 12,
           #        align = "left",
           #        textOutput("sa_notification_1"),
           #        tags$head(
           #          tags$style(
           #            HTML("#sa_notification_1{
           #                 color: #FF0000;
           #                 height:40px;
           #                 font-size: 20px;
           #                 font-style: bold;}"
           #            )
           #            )
           #            )
           #            ),# End column
#           hr(),
           column(width = 6, #offset = 1, align = "left",
                  h4(textOutput("sa_notification_1")), # POR flow
                  h4(textOutput("sa_notification_2")), # LFalls flow
                  h4(textOutput("sa_notification_3")), # total Pot withdrawals
                  h4(textOutput("sa_notification_4")), # WSCA ops trigger
                  h4(textOutput("sa_notification_5")), # LFAA Alert stage
                  h4(textOutput("sa_notification_6")) # LFAA Restriction stage
#                  tags$ul(
#                    tags$li(textOutput("sa_notification_6"))
#                  )
           ),
# I've found 2 ways to display an online image - but in the first method I don't know 
# how to control size:
           column(width = 3,
                  htmlOutput("sa_graphics_1")),
           column(width = 3, 
                  tags$img(src = "http://mde.maryland.gov/programs/Water/droughtinformation/Currentconditions/PublishingImages/DroughtGraphsStarting2017Apr30/Drought2018-01-31.png",
                           width = "300px",
                           height = "300px")
                              )
         ) # End FluidRow
) # End tabPanel
