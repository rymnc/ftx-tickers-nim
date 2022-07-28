import std/json
import asyncdispatch, ws
import tables
import strutils
import std/threadpool
import structs
import vwap

{.experimental.}



proc startStream(ticker: string) =
  var ws = waitFor newWebSocket("wss://ftx.com/ws/")

  let payload = %* 
    {
      "op": "subscribe",
      "market": ticker,
      "channel": "orderbook"
    }

  waitFor ws.send($payload)
  let orderbook = new(OurOrderbook)
  while true:
    let node = waitFor ws.receiveStrPacket()
    let jsonNode = parseJson(node)
    if jsonNode{"data"} != nil: 
      let unmarshalled = to(jsonNode, TheirOrderbook)
      if unmarshalled.data.bids.len() > 0:
        for i in 0..<unmarshalled.data.bids.len():
          let bid = unmarshalled.data.bids[i]
          orderbook.bids[bid[0]] = bid[1]
      if unmarshalled.data.asks.len() > 0:
        for i in 0..<unmarshalled.data.asks.len():
          let ask = unmarshalled.data.asks[i]
          orderbook.asks[ask[0]] = ask[1]
      echo(ticker, ":", getVwap(orderbook))
  ws.close()


proc main() =
  let tickers = ["BTC-PERP", "ETH-PERP", "SOL-PERP", "LTC-PERP"]
  parallel:
    for i in 0..<tickers.len():
      spawn startStream(tickers[i])
    sync()

main()
