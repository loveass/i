data = require "data.coffee"
jade = require "jade"
fs = require "fs"

JADE_DIR = "src/views"
LISTS_DIR = "lists"
DETAIL_DIR = "pages"
ASSETS_DIR = "assets"
ITEM_PER_PAGE = 24

pageFn = jade.compileFile "#{JADE_DIR}/page.jade" 
detailFn = jade.compileFile "#{JADE_DIR}/detail.jade"

# Splite an array into chuncks.
# Steal from http://stackoverflow.com/questions/8495687/split-array-into-chunks
Array.prototype.chunk = (chunkSize)->
    array = @
    [].concat.apply [],
        array.map (elem, i)->
            if i % chunkSize then [] else [array.slice(i, i + chunkSize)];

compileJade = (callback)->
    compileListPages()
    callback?()

compileListPages = ->
    pageItems = data.chunk(ITEM_PER_PAGE)
    for items, i in pageItems
        items.forEach (elem, j)->
            rank = elem.rank = data.length - (i * ITEM_PER_PAGE + j)
            elem.title = "第#{rank}期：#{elem.title}"
            compileDetailPage elem
        fs.writeFileSync "#{LISTS_DIR}/#{i + 1}.html", pageFn({
            name: "FUCK"
            totalCount: pageItems.length
            items: items
            currentPage: i + 1
            prefix: "/lists/"
        })

compileDetailPage = (elem)->    
    images = fs.readdirSync "#{ASSETS_DIR}/#{elem.folder}"
    fs.writeFileSync "#{DETAIL_DIR}/#{elem.rank}.html", detailFn(
        {elem, images, totalCount: data.length}
    )

module.exports = compileJade