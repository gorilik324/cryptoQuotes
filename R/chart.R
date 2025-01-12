# script: scr_chart
# date: 2023-10-06
# author: Serkan Korkmaz, serkor1@duck.com
# objective: Chart the quotes using
# plotly
# script start;

#' Create a candlestick chart
#'
#' This function returns a plotly kline chart with
#' the most common indicators.
#'
#' @param quote A cryptoQuote in xts/zoo format.
#' @param deficiency Logical. FALSE by default, if TRUE color defiency compliant
#' colors are used.
#' @param slider Logical. TRUE by default. If FALSE, no slider will be included.
#'
#' @returns NULL
#' @export

kline <- function(
    quote,
    deficiency = FALSE,
    slider = TRUE
) {

  # 1) Covnert the Quote
  # to data.frame
  quoteDF <- toDF(
    quote = quote
  )


  # 2) Create candlestick
  # plot
  plot <- plotly::plot_ly(
    data = quoteDF,
    name = attributes(quote)$interval,
    yaxis = 'y',
    x    = ~Index,
    type = 'candlestick',
    open = ~Open,
    close = ~Close,
    high  = ~High,
    low   = ~Low,
    increasing = list(
      line =list(color =ifelse(
        test = deficiency,
        yes = '#FFD700',
        no  = 'palegreen'
      )
      )
    ),
    decreasing = list(
      line =list(color =ifelse(
        test = deficiency,
        yes = '#0000ff',
        no  = 'tomato'
      )
      )
    )
  )




  plot_list <- list(
    main = plot
  )

  attributes(plot_list)$quote <- quoteDF
  attributes(plot_list)$deficiency <- deficiency

  return(
    invisible(plot_list)
  )

}



ohlc <- function(
    quote,
    deficiency = FALSE,
    slider = TRUE
) {

  # 1) Covnert the Quote
  # to data.frame
  quoteDF <- toDF(
    quote = quote
  )


  # 2) Create candlestick
  # plot
  plot <- plotly::plot_ly(
    data = quoteDF,
    name = attributes(quote)$interval,
    yaxis = 'y',
    x    = ~Index,
    type = 'ohlc',
    open = ~Open,
    close = ~Close,
    high  = ~High,
    low   = ~Low,
    increasing = list(
      line =list(color =ifelse(
        test = deficiency,
        yes = '#FFD700',
        no  = 'palegreen'
      )
      )
    ),
    decreasing = list(
      line =list(color =ifelse(
        test = deficiency,
        yes = '#0000ff',
        no  = 'tomato'
      )
      )
    )
  )




  plot_list <- list(
    main = plot
  )

  attributes(plot_list)$quote <- quoteDF
  attributes(plot_list)$deficiency <- deficiency

  return(
    invisible(plot_list)
  )

}





#' Chart your data
#'
#' @param chart A kline or ohlc chart with and without
#' indicators
#'
#' @param slider Logical. TRUE by default.
#'
#' @export
chart <- function(
    chart,
    slider = TRUE
) {

  quoteDF <- attributes(chart)$quote
  quote   <-  attributes(chart)$quote

  # 1) Main Chart
  chart <- plotly::subplot(
    # chart$main,
    # chart$volume,
    # chart$rsi,
    chart,
    nrows = length(chart),
    shareX = TRUE,
    titleY = TRUE,
    heights = c(
      0.5,
      rep(
        (1-0.5)/length(chart),
        length(chart) - 1
      )
    )
  )

  chart <- chart %>% plotly::layout(
    yaxis = list(
      title = 'Price'
    ),
    xaxis = list(
      rangeslider = list(visible = slider)
    ),
    showlegend = FALSE,
    paper_bgcolor='rgba(0,0,0,0)',
    plot_bgcolor='rgba(0,0,0,0)'
  ) %>% plotly::add_annotations(
    x= 0,
    y= 1,
    xref = "paper",
    yref = "paper",
    text = paste(
      '<b>Ticker:</b>',
      attributes(quote)$tickerInfo$ticker,
      '<b>Interval:</b>', attributes(quote)$tickerInfo$interval, paste0('(', attributes(quote)$tickerInfo$market,')'),
      '<b>Exchange:</b>', attributes(quote)$tickerInfo$source),
    showarrow = FALSE,
    font = list(
      size = 18
    )

  )

  return(chart)
}








