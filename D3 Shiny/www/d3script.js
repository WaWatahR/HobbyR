Shiny.addCustomMessageHandler("jsondata",
  function(message){
    
    //Get JSON data from R
    var data = message;

    //remove previous elements to ensure when data is updated it does not duplicate data
    d3.select("#d3out").select("div").remove();
    d3.select("#d3chart2").select("svg").remove();
        
    //Standard Parameters    
    var width = 420;
    barHeight = 20;

    //Add a dic html element to my first element from the UI script. Use a # symbol for the ID
    var body = d3.select("#d3out");
    var div = body.append("div");
    div.html("Static HTML chart.");
    
    //Scale the graph to the max
    var x = d3.scale.linear()
    .domain([0, d3.max(data, function(d) { return +d.value; })])
    .range([0, width]);
    
    d3.select("#d3chart")
    .selectAll("div")
    .data(data)
    .enter().append("div")
    .style("width", function(d) { return x(+d.value) + "px"; })
    .text(function(d) { return +d.value; });
    
     
    var chart = d3.select("#d3chart2")
    .append("svg")
    .attr("width", width)
    .attr("height", barHeight * 6)
    .attr("class", "chart");

    var bar = chart.selectAll("g")
    .data(data)
    .enter().append("g")
    .attr("transform", function(d, i) { return "translate(0," + i * barHeight + ")"; });

    bar.append("rect")
    .attr("width", function(d) { return x(+d.value); })
    .attr("height", barHeight - 1);

    bar.append("text")
    .attr("x", function(d) { return x(+d.value) - 3; })
    .attr("y", barHeight / 2)
    .attr("dy", ".35em")
    .text(function(d) { return +d.value; });
    
});
