import tables

type 
  Data* = object
    action*: string
    bids*: seq[array[2, float]]
    asks*: seq[array[2, float]]

type 
  TheirOrderbook* = object
    data*: Data
   

type 
  OurOrderbook* = ref object 
    bids*, asks*: Table[float, float]