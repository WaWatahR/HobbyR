#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
   
    pages = reactive({
        nrow_data = length(im1)#nrow(data())
        # rows_per_page = ceiling(nrow_data / input$pager$pages_total)
        
        row_starts = seq(1, nrow_data, by = 6)
        row_stops  = c(row_starts[-1] - 1, nrow_data)
        
        page_rows = mapply(`:`, row_starts, row_stops, SIMPLIFY=F)
        
        return(page_rows)
    })
    
    ImageList = reactive({
        if(input$img_type=='Type 1') return(Type1Images)
        if(input$img_type=='Type 2') return(Type2Images)
        if(input$img_type=='Type 3') return(Type3Images)
    })
    
    
    WeightMatrix = reactive({
        wmatrix = matrix(0.3, xdim, ydim)
        #top_left_anchor = seq(1, xdim*ydim, by = (xdim+1))
        #top_right_anchor = seq(xdim, xdim*(xdim-1)+1, (xdim-1))
        #bottom_right_anchor = seq(xdim*ydim, 1, by =-(xdim+1))
        #bottom_left_anchor = seq(xdim*(xdim-1)+1, xdim, by = -(xdim-1))
        
        step = round(xdim / 8,0)
        wmatrix[step:(ydim-step+1), step:(xdim-step+1)] = 0.5
        wmatrix[(2*step):(ydim-(2*step)+1), (2*step):(xdim-(2*step)+1)] = 1
        wmatrix[(3*step):(ydim-(3*step)+1), (3*step):(xdim-(3*step)+1)] = 3
        
        return(wmatrix)
    })
    
    output$ImageInputUI <- renderUI({ 
        selectInput("imgName", "Select your image", ImageList(),selected = '1037.jpg')
    })
    
   
    subsetImage = reactive({
        
        # par(mfrow=c(1,3))
        start = Sys.time()
        wm = setNames(melt(WeightMatrix()), c('x', 'y', 'weight'))
        tryCatch({ 
            if(input$img_type=='Type 1') im = im1[[which(input$imgName==Type1Images)]]
            if(input$img_type=='Type 2') im = im2[[which(input$imgName==Type2Images)]]
            if(input$img_type=='Type 3') im = im3[[which(input$imgName==Type3Images)]]
            
            # plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            d = RedFilter(as.data.frame(im))
            #newd = RedRegionSelect(d, sxdim, sydim)
            
            # plot(suppressWarnings(as.cimg(d[c('x','y','cc','value')])), xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            
            xdim = max(d$x)
            ydim = max(d$y)
            
            start=Sys.time()
            wvalues= values = data.frame()
            rc = 0
            cc = 0
            for(i in seq(1, (xdim-sxdim),2)){
                rc = rc+1
                cc=1
                for(j in seq(1, (ydim-sydim),2)){
                    wvalues[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1 * wm$weight[wm$x %in% i:(i+sxdim-1) & wm$y %in% j:(j+sydim-1)])
                    values[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1)
                    cc=cc+1
                }
            }
            finish = Sys.time()
            finish - start
            
            wystart = max(col(wvalues)[wvalues==max(wvalues)])
            wxstart = which.max(wvalues[,wystart])
            
            wystart = seq(1, (ydim-sydim),2)[wystart]
            wxstart = seq(1, (xdim-sxdim),2)[wxstart]
            
            ystart = max(col(values)[values==max(values)])
            xstart = which.max(values[,ystart])
            ystart = seq(1, (ydim-sydim),2)[ystart]
            xstart = seq(1, (xdim-sxdim),2)[xstart]
            
            cc = sum(d$value[(d$x >= wxstart & d$x <= (wxstart+sxdim)) & (d$y >= wystart & d$y <= (wystart+sydim)) & d$cc==1]==1)
            oc = sum(d$value[(d$x >= xstart & d$x <= (xstart+sxdim)) & (d$y >= ystart & d$y <= (ystart+sydim)) & d$cc==1]==1)
            
            cat(paste('cc= ', cc, 'oc= ', oc, '\n'))
            
            if((2*cc) < oc){
                # plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
                # rect(xstart, ystart,(xstart+sxdim), (ystart+sydim), border="white", lwd=2.5)
            } else {
                # plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
                # rect(wxstart, wystart,(wxstart+sxdim), (wystart+sydim), border="white", lwd=2.5)
                xstart = wxstart
                ystart = wystart
            }
            d = as.data.frame(im)
            newd = d[d$x >= xstart & d$x <= (xstart+sxdim-1) & d$y >= ystart & d$y <= (ystart+sydim-1),]
            newd$x = newd$x - xstart + 1
            newd$y = newd$y - ystart + 1
            cat(Sys.time()-start)
            return(suppressWarnings(as.cimg(newd)))
            
        }, 
        error= function(e){ 
            NULL 
        }) 
    })
    
    output$redblock = renderPlot({
        
        par(mfrow=c(1,3))
        start = Sys.time()
        wm = setNames(melt(WeightMatrix()), c('x', 'y', 'weight'))
        tryCatch({ 
            if(input$img_type=='Type 1') im = im1[[which(input$imgName==Type1Images)]]
            if(input$img_type=='Type 2') im = im2[[which(input$imgName==Type2Images)]]
            if(input$img_type=='Type 3') im = im3[[which(input$imgName==Type3Images)]]
            
            plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            d = RedFilter(as.data.frame(im))
            #newd = RedRegionSelect(d, sxdim, sydim)
            
            plot(suppressWarnings(as.cimg(d[c('x','y','cc','value')])), xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            
            xdim = max(d$x)
            ydim = max(d$y)
            rc = 0
            cc = 0
            wvalues = values = data.frame()
            for(i in seq(1, (xdim-sxdim),2)){
                rc = rc+1
                cc=1
                
                for(j in seq(1, (ydim-sydim),2)){
                    wvalues[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1 * wm$weight[wm$x %in% i:(i+sxdim-1) & wm$y %in% j:(j+sydim-1)])
                    values[rc,cc] =  sum(d$value[d$x %in% i:(i+sxdim-1) & d$y %in% j:(j+sydim-1) & d$cc==1]==1)
                    cc=cc+1
                }
            }
            cat("Wroking\n")
            wystart = max(col(wvalues)[wvalues==max(wvalues)])
            wxstart = which.max(wvalues[,wystart])
            
            wystart = seq(1, (ydim-sydim),2)[wystart]
            wxstart = seq(1, (xdim-sxdim),2)[wxstart]
            
            ystart = max(col(values)[values==max(values)])
            xstart = which.max(values[,ystart])
            ystart = seq(1, (ydim-sydim),2)[ystart]
            xstart = seq(1, (xdim-sxdim),2)[xstart]
            
            cc = sum(d$value[(d$x >= wxstart & d$x <= (wxstart+sxdim)) & (d$y >= wystart & d$y <= (wystart+sydim)) & d$cc==1]==1)
            oc = sum(d$value[(d$x >= xstart & d$x <= (xstart+sxdim)) & (d$y >= ystart & d$y <= (ystart+sydim)) & d$cc==1]==1)
            
            cat(paste('cc= ', cc, 'oc= ', oc, '\n'))
            
            if((2*cc) < oc){
                 plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
                 rect(xstart, ystart,(xstart+sxdim), (ystart+sydim), border="white", lwd=2.5)
            } else {
                 plot(im, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
                 rect(wxstart, wystart,(wxstart+sxdim), (wystart+sydim), border="white", lwd=2.5)
                # xstart = wxstart
                # ystart = wystart
            }
            # d = as.data.frame(im)
            # newd = d[d$x >= xstart & d$x <= (xstart+sxdim-1) & d$y >= ystart & d$y <= (ystart+sydim-1),]
            # newd$x = newd$x - xstart + 1
            # newd$y = newd$y - ystart + 1
            # cat(Sys.time()-start)
            # return(suppressWarnings(as.cimg(newd)))
            
        }, 
        error= function(e){ 
            NULL 
        }) 
    })
    
    output$colchannels = renderPlot({
        
        par(mfrow=c(1,3))
       
        tryCatch({ 
            if(input$img_type=='Type 1') im = im1[[which(input$imgName==Type1Images)]]
            if(input$img_type=='Type 2') im = im2[[which(input$imgName==Type2Images)]]
            if(input$img_type=='Type 3') im = im3[[which(input$imgName==Type3Images)]]
            
            r = b = g = im
            
            G(r) = B(r) = 0
            R(b) = G(b) = 0
            R(g) = B(g) = 0
            plot(r, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            plot(g, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            plot(b, xaxt='n', yaxt='n', ann=FALSE, frame.plot=F)
            
        }, 
        error= function(e){ 
            NULL
        }) 
    })
    
    
    output$pictransform = renderPlot({
        
        par(mfrow=c(2,2))
        
        tryCatch({ 
            # if(input$img_type=='Type 1') im = im1[[which(input$imgName==Type1Images)]]
            # if(input$img_type=='Type 2') im = im2[[which(input$imgName==Type2Images)]]
            # if(input$img_type=='Type 3') im = im3[[which(input$imgName==Type3Images)]]
            im = subsetImage()
            
            #vanvliet(im,sigma=input$sigma,order=input$order,axis="y") %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Vanvliet Y')
            plot(im, xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Original')
            deriche(im, sigma=input$sigma, order=input$order ,axis="y") %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Deriche Y')
            blur_anisotropic(im, ampl=1e3, sharp=input$sharpness) %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Blur')
            #vanvliet(im,sigma=input$sigma,order=input$order,axis="X") %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Vanvliet X')
            #deriche(im, sigma=input$sigma, order=input$order ,axis="X") %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'Deriche X')
            imgradient(im, "xy") %>% plot(xaxt='n', yaxt='n', col.lab='white', frame.plot=F, main = 'XY Gradient', layout="row")
        }, 
        error= function(e){ 
            NULL
        }) 
    })
    
    source("imageplots1.R", local=T)
    source("imageplots2.R", local=T)
    source("imageplots3.R", local=T)
    
    
    source("imagelayout.R", local=T)
    
    observeEvent(
        eventExpr = {
            c(input$num_rows_per_page)
        },
        handlerExpr = {
            
            pages_total1 = ceiling(length(im1) / (img_rows*img_cols))
            pages_total2 = ceiling(length(im2) / (img_rows*img_cols))
            pages_total3 = ceiling(length(im3) / (img_rows*img_cols))
            
            
            page_current1 = input$pager$page_current
            if (input$pager$page_current > pages_total1) {
                page_current1 = pages_total1
            }
            
            page_current2 = input$pager2$page_current
            if (input$pager2$page_current > pages_total2) {
                page_current2 = pages_total2
            }
            
            page_current3 = input$pager3$page_current
            if (input$pager3$page_current > pages_total3) {
                page_current3 = pages_total3
            }
            
            updatePageruiInput(
                session, 'pager',
                page_current = page_current1,
                pages_total = pages_total1
            )
            
            updatePageruiInput(
                session, 'pager2',
                page_current = page_current2,
                pages_total = pages_total2
            )
            
            updatePageruiInput(
                session, 'pager3',
                page_current = page_current3,
                pages_total = pages_total3
            )
        }
    )
})
