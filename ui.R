# Custom theme
my_theme <- bs_theme(
  bootswatch = "flatly",
  primary = "#d0fbde",
  "navbar-bg-color" = "#0c8835"
)

ui <- page_navbar( # NAVIGATION BAR
  theme = my_theme,
  bg = "#0c8835",
  title = "PioGrowth",
  nav_panel( # HOME PANEL
    title = "Home",
    layout_column_wrap(
      width = "500px",
      card(
        card_header(
          class = "bg-primary",
          "Welcome!"
        ),
        card_body(
          height = "250px",
          h4("Intro"),
          p("This is a simple multi-page Shiny application showcasing modules and modern UI design."),
          p("Navigate using the menu above to explore different sections.")
        ),
      ),
      card(
        card_header(
          class = "bg-primary",
          "Read PioReactor od_readings csv"
        ),
        read_data_ui("read_data")
      ),
      card(
		height = "800px",
        card_header(
          class = "bg-primary text",
		  "Raw data plotted"
        ),
        plot_raw_data_ui("raw_data_plot")
      ),
	  card(
        filter_reactors_ui("filter_reactors"),
	  ),
      card(
        card_header(
          class = "bg-primary text",
          "Features"
        ),
        card_body(
          tags$ul(
            class = "list-group list-group-flush",
            tags$li(class = "list-group-item", "Modern UI with bslib"),
            tags$li(class = "list-group-item", "Test text"),
            tags$li(class = "list-group-item", "Test text 2")
          )
        )
      )
    )
  ),
  nav_panel( # COUNTER PANEL
    title = "Counter",
    layout_column_wrap(
      width = "400px",
      read_data_ui("counter1"),
      calibration_ui("calibration_process")
    )
  ),
  nav_panel( # Batch PANEL
    title = "Batch growth analysis",
    layout_column_wrap(
      width = "400px",
      batch_analysis_ui("batch_analysis")
    )
  ),
  nav_panel( # ABOUT PANEL
    title = "About",
    card(
      card_header(
        class = "bg-primary text-light",
        "About This App"
      ),
      card_body(
        h4("Technical Details"),
        p("This application demonstrates several modern Shiny features:"),
        accordion(
          accordion_panel(
            "UI Components",
            tags$ul(
              tags$li("Modern navigation with page_navbar"),
              tags$li("Responsive card layouts"),
              tags$li("Bootstrap icons integration"),
              tags$li("Custom theme using bslib")
            )
          ),
          accordion_panel(
            "Architecture",
            tags$ul(
              tags$li("Modular code organization"),
              tags$li("Separated UI and server logic"),
              tags$li("Reusable components")
            )
          )
        )
      )
    )
  )
)