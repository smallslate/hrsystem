pages =  require('../factory/pages').pages

class CommonUtils
  getFullName: (userObj) ->
    name = ''
    if userObj.firstName
      name=userObj.firstName
    if userObj.middleName 
      name= name+','+userObj.firstName
    if userObj.lastName
      name= name+','+userObj.lastName
    return name  

  getParentPageAccessList: (pageAccessList) ->
    parentAccessList = {}
    for pageAccess in pageAccessList
      parentAccessList[pages[pageAccess.pageId].parentId] = {pageId:pages[pageAccess.pageId].parentId}
    for parentAccessId of parentAccessList
      pageAccessList.push({pageId:parentAccessId})
    return pageAccessList



module.exports = new CommonUtils()