mockStart = 108

data = []
currentDate = new Date(1413219714488)
for mockIndex in [mockStart..1]
    title = "#{currentDate.getFullYear()}年#{currentDate.getMonth()}月#{currentDate.getDate()}日 更新"
    currentDate.setDate(currentDate.getDate() - 1)
    data.push {"folder": "p-#{mockIndex}", title}

data = [
    # New Date Here!!
].concat data

module.exports = data
