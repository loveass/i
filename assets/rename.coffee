fs = require "fs"
for dir, i in fs.readdirSync "."
    newName = "p-#{i+1}"
    if dir.match /\.coffee/ then continue
    fs.renameSync dir, newName
