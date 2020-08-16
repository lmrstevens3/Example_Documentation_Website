library(sparkline)
library(dplyr)
library(DT)

add_coding_to_factor <- function(col_name, var_levels, data){
    factor(data[[col_name]], 
           levels = var_levels[[col_name]][which(var_levels[[col_name]] %in% unique(data[[col_name]]))],
           labels = names(var_levels[[col_name]])[which(var_levels[[col_name]] %in% unique(data[[col_name]]))])
}

simpleCap <- function(a) {
    s <- strsplit(a, " ")[[1]]
    paste(toupper(substring(s, 1,1)), substring(s, 2),
          sep="", collapse=" ")
}

applyQuantiles <- function(x, numTiles){
    quantilesVector <- cut(x, breaks=c(quantile(x, probs = seq(0, 1, by = 1/numTiles), na.rm =T)), 
                           include.lowest=T, right = F)
    return(quantilesVector)
}

proportion_missing <- function(data) {
    missing_data <- data %>% summarise_all(funs("_number_missing"=sum(is.na(.)), "_n"=length(.), 
                                     "_proportion_missing"=sum(is.na(.))/length(.))) %>%
        tidyr::gather(cat, info) %>% tidyr::separate(cat, into = c("var", "cat"), sep = "__") %>%
        tidyr::spread(., cat, info)
    return(missing_data[order(missing_data$proportion_missing), ])
}

is_continuous <- function(x){
    (length(unique(x)) > 10 & is.numeric(x) & (!is_date(x)))
}

is_date <- function(x){inherits(x, 'Date')}

calc_frequencies <- function(data){
    var_frequcies <- lapply(colnames(data), function(x){
        freq_x = table(data[[x]], useNA = "always")
        freq_df <- cbind.data.frame("var" = x, 
                                    "cat" = replace(names(freq_x), is.na(names(freq_x)), "NA/NULL"),
                                    "count" = as.vector(freq_x),
                                    "info" = paste0(freq_x, " (",  round(prop.table(freq_x)*100,1), "%) "))
    })
    return(do.call(rbind, var_frequcies[!vapply(var_frequcies, is.null, logical(1))]))
}

calc_summary_stats <- function(data){
    data %>% dplyr::summarize_all(
        funs("_min" = min(.,na.rm = T), "_max" = max(., na.rm = T), "_mean" = mean(., na.rm = T),
             "_SD" = sd(., na.rm = T), "_NA/NULL" = sum(is.na(.)), "_N" = sum(!is.na(.))))  %>%
        mutate_if(is.numeric, round, 3) %>% tidyr::gather(cat, info) %>% 
        tidyr::separate(cat, into = c("var", "cat"), sep = "__")
}

calc_chart_data <- function(data){
    #get date columns (line chart) and continuous columns (box chart)
    boxData <- data %>% dplyr::select(colnames(data)[sapply(data, is_continuous)])
    lineData <- data %>% dplyr::select(colnames(data)[sapply(data, is_date)])
    #get counts for sparkline data if data has less than or equal 10 categories
    barData <- calc_frequencies(data[!colnames(data) %in% c(colnames(lineData), colnames(boxData))])
  return(list("barData" = barData, "boxData" = boxData, "lineData" = lineData))
}

spk_tool_tip <- function(labels) {
    htmlwidgets::JS(
        sprintf("function(sparkline, options, field) {return %s[field[0].offset];}", 
                jsonlite::toJSON(labels))
    )
}

spk_tool_tip_ln <- function(labels) {
    htmlwidgets::JS(
        sprintf("function(sparkline, options, field) {return %s[field.x];}", 
                jsonlite::toJSON(labels))
    )
}


calc_sparkline_data <- function(chart_data_list, spk_width = 60, spk_height = 20, barWidth = 12){
    #get frequency from tabulated data 
    spk_data_bx <- chart_data_list$boxData %>% 
        summarize_all(spk_chr,  type = "box", 
                     chartRangeMin = 0, outlierLineColor = 'black', outlierFillColor = 'red', 
                     width = spk_width, height = spk_height) %>% 
       tidyr::gather(key = "var", value = "html_chart")
        
    spk_data_ln <- chart_data_list$lineData %>% 
        summarize_all(funs(spk_chr(as.numeric(.),  type = "line", outlierFillColor = 'red', 
                      width = spk_width, height = spk_height, tooltipFormatter = spk_tool_tip_ln(.)))) %>% 
        tidyr::gather(key = "var", value = "html_chart")
    
    spk_data_br <- chart_data_list$barData %>% dplyr::group_by(var) %>% 
        dplyr::summarize(html_chart = spk_chr(count, type = "bar", chartRangeMin = 0, 
                                              barWidth = barWidth, height = spk_height, highlightColor = 'red',
                                              tooltipFormatter=spk_tool_tip(paste(cat, info, sep=": ")))) 
    spk_data <- do.call("rbind.data.frame", list(spk_data_br, spk_data_bx, spk_data_ln)) 
    return(spk_data)
}    


calc_col_NA <- function(data){
    #add missing values 
    perccent_na = apply(data, 2, function(x) sum(is.na(x))/length(x))
    #data <- dataDeath
    na_df <- cbind.data.frame('var' = colnames(data), "Missing (%)" = round(perccent_na, 2), stringsAsFactors = F)
    return(na_df)
}


calc_data_overview_spkln <- function(data, subsetText = NULL){
    chart_data <- calc_chart_data(data)
    spk_data <- calc_sparkline_data(chart_data, spk_width = 90, spk_height = 30, barWidth = 10)
    spk_data <- merge(calc_col_NA(data), as.data.frame(spk_data, stringsAsFactors = F), by = 'var')
    colnames(spk_data) <- c("Variable", paste0(subsetText, c("Missing (%)", "Distribution")))
    return(spk_data)
}

make_var_distribution_html <- function(freq_dist_data,  headerText){
    style_info <-  "<table class = \"display\" style = \"font-size:14px;  border:solid .5px grey; float:center; border-spacing: 0px; width:100%;\">"
    header <- paste0("<thead style = 'font-size:12px; text-align:left; font-style:italic;'><tr><th style = 'font-weight:normal; padding:2px;'>", headerText, "</th></tr></thead>")
    #caption <- paste0("<caption style = 'font-size:10px; text-align:left; '><i>", caption, "</i></caption>")
    body <- paste0("<tr  style = 'border:solid .5px grey;'><td><b>",freq_dist_data[['cat']], '</b>: ',freq_dist_data[['info']], collapse = '</td></tr>')
    tableText <- paste0( style_info, header,  body, "</table>") 
    return(tableText)
}

calc_distribution_html <- function(data, subsetText = NULL){
    chart_data <-calc_chart_data(data)
    continuous_vars <- c(names(chart_data$boxData), unique(as.character(chart_data$lineData$var)))
    #box bar chart tables  
    var_summary <- do.call("rbind.data.frame", 
                           list(calc_summary_stats(data[,continuous_vars]) %>% mutate(info = as.character(info)),
                                chart_data$barData %>% dplyr::select(-count)))
    summary_html_data <- var_summary %>% group_by(var) %>% split(group_indices(.)) %>% 
        purrr::map_df( .f = function(.x) {
            .x %>% summarise(html_table = htmltools::HTML(make_var_distribution_html(.x, paste(subsetText,unique(.x$var), "Summary"))))})
    colnames(summary_html_data) <- c("Variable", paste0(subsetText,"Summary"))
    return(summary_html_data)
}

calc_data_overview_dist_childrow <- function(data, subsetText = NULL){
    data_overview_spkln <- calc_data_overview_spkln(data, subsetText)
    dist_html_tbl <- calc_distribution_html(data, subsetText)
    data_overview_dist_childrow <- full_join(data_overview_spkln, dist_html_tbl)
    return(data_overview_dist_childrow)
}

calc_data_overview_by_interest_var <- function(data, interest_var){
    interest_var_overview_tbls <- lapply(levels(as.factor(data[[interest_var]])), function(factorLevel){
        datasubset <- data[data[[interest_var]] == factorLevel, colnames(data)[!colnames(data) %in% interest_var]]
        subset_overview_dist_childrow <- calc_data_overview_dist_childrow(datasubset, subsetText = paste0(interest_var, "=", factorLevel, "-"))[,-c(2)]
        return(subset_overview_dist_childrow)
    })
    dt_overview_by_interest_var <- join_all(interest_var_overview_tbls)
    return(dt_overview_by_interest_var)
}

calc_data_overview_DT <- function(dt_data, show_missing = F, index_childrow_cols, ... ){
    print(index_childrow_cols)
    if(show_missing){vis_cols = index_childrow_cols}else{vis_cols = c(index_childrow_cols, which(colnames(dt_data) %in% c("Missing (%)")))}
    print(vis_cols)
    #make table
    container = htmltools::withTags(table(
        class = 'display',
        thead(
            tr(th(rowspan = 2,  " "),
               th(style ='border:none; padding:10px;', colspan = length(dt_data)-1, 'GWTG COVID Data Overview')
               ),
            tr(lapply(c(colnames(dt_data)), th, style = 'font-weight:normal; font-size:1rem;'))
        )
    ))
    dt_data <- cbind(" " = paste0(htmltools::withTags(span(style = 'cursor:pointer;', title = "Click the plus to see additional details for a variable", htmltools::HTML('&oplus;')))), dt_data)
    dt <- spk_add_deps(datatable(dt_data, escape = F, rownames = F,  class = 'cell-border condensed hover compact', container =  container, #style = 'bootstrap',
                           options = list(drawCallback = JS("function() {HTMLWidgets.staticRender(); this.api().table().column(0).nodes().to$().css({'border-right': 'none'})}"),
                                          pageLength = nrow(dt_data),
                                          columnDefs = list(list(visible = FALSE, targets = c(vis_cols)),
                                                            list(className = 'dt-center', targets = c(grep("Distribution|Type|Missing", colnames(dt_data)))),
                                                            list(orderable = FALSE, className = 'details-control', targets = c(0)) 
                                                            
                                          )
                           ), 
                           callback = JS(paste0("table.column(1).nodes().to$().css({cursor: 'pointer'});
                                                table.column(0).nodes().to$().css({cursor: 'pointer'});
                                                var format = function(d) {
                                                var colWidth =  'width:' + $('td').eq(2).width() + 'px;';
                                                var tableDivStyle = '<div style=\"background-color:#eee; padding:5px; float:right;' + colWidth + '\">'; 
                                                var childRowTables = tableDivStyle + ",  paste0("d[", index_childrow_cols, "]  ", collapse = "+ '</div>' +  tableDivStyle + "), " + '</div>';
                                                return '<div style=\" background-color:#eee; width:100%; overflow:scroll; \">' + childRowTables + '</div>';
                                                
                                                };
                                                table.on('click', 'td.details-control', function() {
                                                var td = $(this), row = table.row(td.closest('tr'));
                                                if (row.child.isShown()) {
                                                row.child.hide();
                                                td.html('&oplus;');
                                                } else {
                                                row.child(format(row.data())).show();
                                                td.html('&CircleMinus;');
                                                }
                                                });"
                                 ))))
    if(show_missing){
        dt <- dt %>% formatStyle("Missing (%)", "Missing (%)",
                                     background = styleColorBar(c(0,1), 'pink', angle = -90),
                                     backgroundSize = '98% 20%',
                                     backgroundRepeat = 'no-repeat',
                                     backgroundPosition = 'right bottom') %>% formatPercentage("Missing (%)", digits = 1, interval = 3, mark = ",",
                                                                                               dec.mark = getOption("OutDec"))

    }

    return(dt)
    
}


data <- cbind(" " = paste0(htmltools::withTags(span(style = 'cursor:pointer;', title = "Click the plus to see additional details for a variable", htmltools::HTML('&oplus;')))), covid_overview)
container <- htmltools::withTags(table(
    class = 'display',
    thead(
        tr(th(rowspan = 2,  " "),
           th(style ='border:none;', colspan = length(d)-1, 'GWTG COVID Data Overview')
        ),
        tr(lapply(c(colnames(d)), th, style ="font-weight:normal; font-size:.75rem;"))
    )
))

dt <- spk_add_deps(datatable(data, escape = F, rownames = F,  class = 'cell-border condensed hover compact', container =  container, #style = 'bootstrap',
                             options = list(drawCallback = JS("function() {HTMLWidgets.staticRender(); this.api().table().column(0).nodes().to$().css({'border-right': 'none'})}"),
                                            pageLength = nrow(data),
                                            columnDefs = list(list(visible = FALSE, targets = c(vc)),
                                                              list(className = 'dt-center', targets = c(grep("Distribution|Type|Missing", colnames(data)))),
                                                              list(orderable = FALSE, className = 'details-control', targets = c(0)) 
                                                              
                                            )
                             ), 
                             callback = JS(paste0("table.column(1).nodes().to$().css({cursor: 'pointer'});
                                                  table.column(0).nodes().to$().css({cursor: 'pointer'});
                                                  var format = function(d) {
                                                  var colWidth =  'width:' + $('td').eq(2).width() + 'px;';
                                                  var tableDivStyle = '<div style=\"background-color:#eee; padding:5px; float:right;' + colWidth + '\">'; 
                                                  var childRowTables = tableDivStyle + ",  paste0("d[", vc, "]  ", collapse = "+ '</div>' +  tableDivStyle + "), " + '</div>';
                                                  return '<div style=\" background-color:#eee; width:100%; overflow:scroll; \">' + childRowTables + '</div>';
                                                  
                                                  };
                                                  table.on('click', 'td.details-control', function() {
                                                  var td = $(this), row = table.row(td.closest('tr'));
                                                  if (row.child.isShown()) {
                                                  row.child.hide();
                                                  td.html('&oplus;');
                                                  } else {
                                                  row.child(format(row.data())).show();
                                                  td.html('&CircleMinus;');
                                                  }
                                                  });"
                                 ))))

    dt <- dt %>% formatStyle("Missing (%)", "Missing (%)",
                             background = styleColorBar(c(0,1), 'pink', angle = -90),
                             backgroundSize = '98% 20%',
                             backgroundRepeat = 'no-repeat',
                             backgroundPosition = 'right bottom') %>% formatPercentage("Missing (%)", digits = 1, interval = 3, mark = ",",
                                                                                       dec.mark = getOption("OutDec"))
    

dt
