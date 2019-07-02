library(shiny)
library(data.table)
library(formattable)
library(dplyr)
library(DT)
library(shinyWidgets)
library(shinyjs)

load("Rdata_outputs/geno_correlation_sig.Rdata")
df <- geno_corr_df
load("Rdata_outputs/geno_correlation_male_sig.Rdata")
df_m <- geno_corr_df
load("Rdata_outputs/geno_correlation_female_sig.Rdata")
df_f <- geno_corr_df

fix_dataframe <- function(df, rpheno=TRUE, full_html_path=TRUE) {
    # Restrict to subset of columns
    choices <- unique(paste0(df$p1, ': ', df$description_p1))
    if (full_html_path) {
        df$description_p1 <- paste0("<a href='https://ukbb-rg.hail.is/rg_summary_", df$p1,".html'>", df$description_p1,"</a>")
        df$description_p2 <- paste0("<a href='https://ukbb-rg.hail.is/rg_summary_", df$p2,".html'>", df$description_p2,"</a>")
    } else {
        df$description_p1 <- paste0("<a href='rg_summary_", df$p1,".html'>", df$description_p1,"</a>")
        df$description_p2 <- paste0("<a href='rg_summary_", df$p2,".html'>", df$description_p2,"</a>")
    }

    df$p1 <- as.factor(df$p1)
    df$p2 <- as.factor(df$p2)
    if(rpheno) {
        df <- df %>% rename("ID1" = p1, "ID2" = p2, "Phenotype 1" = description_p1, "Phenotype 2" = description_p2,
        "h2" = h2_obs, "h2 SE" = h2_obs_se, "rg SE" = se, "h2 intercept" = h2_int, "h2 intercept SE" = h2_int_se, 
        "rg intercept" = gcov_int, "rg intercept SE" = gcov_int_se, "rpheno" = r2p, "Z" = z)
        setcolorder(df, c("ID1", "ID2", "Phenotype 1",
        "Phenotype 2", "h2", "h2 SE", "h2 intercept", "h2 intercept SE", "rpheno", "rg", "rg SE", "Z","p", "rg intercept", "rg intercept SE"))
    } else {
        df <- df %>% rename("ID1" = p1, "ID2" = p2, "Phenotype 1" = description_p1, "Phenotype 2" = description_p2,
        "h2" = h2_obs, "h2 SE" = h2_obs_se, "rg SE" = se, "h2 intercept" = h2_int, "h2 intercept SE" = h2_int_se, 
        "rg intercept" = gcov_int, "rg intercept SE" = gcov_int_se, "Z" = z)
        setcolorder(df, c("ID1", "ID2", "Phenotype 1",
        "Phenotype 2", "h2", "h2 SE", "h2 intercept", "h2 intercept SE", "rg", "rg SE", "Z","p", "rg intercept", "rg intercept SE"))
    }
    setkeyv(df, cols=c("ID1", "ID2"))
    return(list(df = df, choices = choices))
}

df <- fix_dataframe(df)
df_m <- fix_dataframe(df_m, rpheno=FALSE)
df_f <- fix_dataframe(df_f, rpheno=FALSE)

choices <- unique(c(df$choices, df_m$choices, df_f$choices))
df <- df$df
df_m <- df_m$df
df_f <- df_f$df

# min/max for the coloring
lo <- -1 
hi <- 1

n <- length(unique(geno_corr_df$description_p1))
n_tests <- n * (n-1) / 2
bonf_thres <- 0.05 / n_tests
nominal <- 0.05
choices <- factor(c("All", as.character(choices)))


ui <- navbarPage(
    title = "UKBB Genetic Correlation", position='fixed-top',
    tabPanel("Browser",
        fluidPage(
            useShinyjs(),
            withMathJax(),
            titlePanel("Genetic Correlation Browser"),
                tags$head(tags$script(src="rainbowvis.js")),
                sidebarLayout(
                    sidebarPanel(
                        sliderInput("slider2", label = "\\(r_g\\) range:", min = -1, max = 1, value = c(-10, 10), step=0.001),
                        sliderTextInput("pvalue","\\(p\\)-value of \\(r_g\\):",
                            choices=c(0, 10^(seq(-8,0))), selected=c(0,1), grid = TRUE),
                        selectizeInput('pheno1', label='Phenotype 1', choices=choices, multiple=TRUE, selected='All', list(placeholder = 'select a collection of phenotypes')),
                        selectizeInput('pheno2', label='Phenotype 2', choices=choices, multiple=TRUE, selected='All', list(placeholder = 'select a collection of phenotypes')),
                        downloadButton('downloadData', 'Download'),
                        width=3
                    ),
                    mainPanel(
                      tabsetPanel(type = "tabs", id='opentab',
                                  tabPanel("Both sexes", DT::dataTableOutput("rg_js")),
                                  tabPanel("Males", DT::dataTableOutput("rg_js_m")),
                                  tabPanel("Females", DT::dataTableOutput("rg_js_f")))
                      )
                )
            )
        )
    )

server <- function(input, output) {

    observe(
    {

    restrict <- function(df=df)
    {

        if(!('All' %in% input$pheno1)) {
            df <- df %>% filter(ID1 %in% gsub(":.*", "", input$pheno1))
        }

        if(!('All' %in% input$pheno2)) {
            df <- df %>% filter(ID2 %in% gsub(":.*", "", input$pheno2))
        }

        return(df %>% filter(rg >= input$slider2[1], rg <= input$slider2[2], 
                             p >= input$pvalue[1], p <= input$pvalue[2]))
    }

    create_dt <- function(df, rpheno=TRUE)
    {
        if(rpheno) {
            var_before_rg <- 5

        } else {
            var_before_rg <- 4
        }

        where_rg <- which(names(df) == 'rg') - 1 - var_before_rg
        columns_invisible <- which(names(df) %in% c("h2", "h2 SE", "rg SE", "h2 intercept", "h2 intercept SE", 
            "rg intercept", "rg intercept SE", "rpheno", "Z")) - 1

        thin_cols <- which(names(df) %in% c("h2", "h2 SE", "h2 intercept", "h2 intercept SE", "rpheno", "rg", "rg SE", "Z", "p", "rg intercept", "rg intercept SE")) - 1

        return(
            datatable(restrict(df),
                rownames = FALSE,
                caption = htmltools::tags$caption(
                  style = 'caption-side: top; text-align: left;',
                  htmltools::em('Columns can be added and removed using the column visibility button.')
                ), 
                escape = FALSE,
                extensions = c('Buttons'), 
                options = list(
                    dom='Btlpr',
                    buttons = I('colvis'),
                    deferRender = TRUE,
                    autoWidth = TRUE,
                    columnDefs = list(list(visible=FALSE, targets=columns_invisible),
                                    list(width='80px', targets=c(0,1)),
                                    list(width='300px', targets=c(2,3)),
                                    list(width='300px', targets=c(2,3)),
                                    list(width='30px', targets=thin_cols)),
                    rowCallback = DT::JS(paste0(
                        'function(row, data) {
                          
                          var rainbow = new Rainbow();
                          rainbow.setSpectrum("#6495ed", "white", "#cd5555");

                          rainbow.setNumberRange(',lo,',',hi,'); 
                          var v = ', where_rg, ';
                          $("td:eq("+v+")", row).html("<span style=\'display: block; padding: 0 4px; border-radius: 4px; background-color: " + "#" + rainbow.colourAt(data[v+',var_before_rg,']) + ";\'>" + Math.round(data[v+',var_before_rg,'] * 100) / 100 + "</span>")
                        }'
                    ))
                )
            )
        )
    }

    dt <- create_dt(df)
    dt_m <- create_dt(df_m, FALSE)
    dt_f <- create_dt(df_f, FALSE)

    output$rg_js <- DT::renderDataTable(
        server = TRUE, dt %>% formatSignif(c('p', 'h2', 'h2 SE', 'rg SE', 'h2 intercept', 'h2 intercept SE', 'rg intercept', 'rg intercept SE', 'Z'), digits=3) %>% 
        formatRound(c('rpheno'), 2)
    )

    output$rg_js_m <- DT::renderDataTable(
        server = TRUE, dt_m %>% formatSignif(c('p', 'h2', 'h2 SE', 'rg SE', 'h2 intercept', 'h2 intercept SE', 'rg intercept', 'rg intercept SE', 'Z'), digits=3)
    )

    output$rg_js_f <- DT::renderDataTable(
        server = TRUE, dt_f %>% formatSignif(c('p', 'h2', 'h2 SE', 'rg SE', 'h2 intercept', 'h2 intercept SE', 'rg intercept', 'rg intercept SE', 'Z'), digits=3)
    )

    observeEvent(input$opentab, {
        dl_btn <- function(df) {
        return(
            downloadHandler(
                filename = function() {
                    paste('data-', Sys.Date(), '.csv', sep='')
                },
                content = function(con) {
                    write.csv(restrict(df), con, row.names=FALSE)
                }
            )
        )
        }
        if(input$opentab == "Both sexes")
        {
            output$downloadData <- dl_btn(df)
        } else if(input$opentab == "Males") {
            output$downloadData <- dl_btn(df_m)
        } else {
            output$downloadData <- dl_btn(df_f)
        }
    })

    })

} # server

shinyApp(ui=ui, server=server)






