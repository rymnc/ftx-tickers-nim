import structs
import tables

proc getVwap*(orderbook: OurOrderbook): float = 
  let bids = orderbook.bids
  let asks = orderbook.asks


  var weightedBids = 0.0
  var weightedAsks = 0.0

  var sumBidsVolume = 0.0
  var sumAsksVolume = 0.0  

  for key, val in bids:
    let weight = key * val
    sumBidsVolume += val
    weightedBids += weight

  for key, val in asks:
    let weight = key * val
    sumAsksVolume += val
    weightedAsks += weight
  
  result = (weightedBids + weightedAsks) / (sumBidsVolume + sumAsksVolume)
