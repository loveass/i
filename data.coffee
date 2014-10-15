mockStart = 108

data = []
currentDate = new Date(1413219714488)
for mockIndex in [mockStart..1]
    title = "#{currentDate.getFullYear()}年#{currentDate.getMonth() + 1}月#{currentDate.getDate()}日 更新"
    currentDate.setDate(currentDate.getDate() - 1)
    data.push {"folder": "p-#{mockIndex}", title}

data = [
    # New Date Here!!
    {folder: "p-109", title: "2014年10月15日 更新"}
    {folder: "p-110", title: "2014年10月16日 更新"}
].concat data

module.exports = data
