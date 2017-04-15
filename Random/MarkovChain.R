library(markovchain)

part='000089'

#inventory qoh
i = 2
aslquantity=1
#demand ( to be simulated)
d = 0

#bo Quantity on backorder
bo = 0

#per unit profit
price = 10
cost = 8
p = price-cost

#holding cost function
holding_cost = function(qoh, demand,safetystock){
  cost_per_unit=10
  return(cost_per_unit*(qoh-demand-safetystock))
}
h = holding_cost(i,d,aslquantity)
h

#unfulfillment_cost function
unfulfillment_cost = function(demand, qoh, qob){
  return(0.01)
}
u = unfulfillment_cost(d,i,bo)

#backorder cost function
backorder_cost = function(qob){
  return(0.01)
}

#earnings
if(i < d){
  e = d * p - holding_cost(i, d) 
}else {
  e = d * p - unfulfillment_cost(d, i , bo) - backorder_cost(bo) 
}