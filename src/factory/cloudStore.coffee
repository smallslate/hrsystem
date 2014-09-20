AWSAPI = require 'aws-sdk'
nodeUuid = require("node-uuid")
awsConfig = require('./config').aws
fs = require('fs')
P = require("q")
AWSAPI.config.update({accessKeyId: awsConfig.accessKeyID, secretAccessKey: awsConfig.secretAccessKey,region: 'us-east-1'})
timesheetBucket = new AWSAPI.S3({params: {Bucket: 'hrsystem'}})

class AWS
  uploadTimesheetToStore: (file,uuid,weekId) ->
  	P.nfcall(fs.readFile,file.path)
  	.then (fileData) ->
      verificationId = nodeUuid.v4()
      fileName = uuid+'_'+weekId+'_'+verificationId+'.'+file.extension
      fileName = fileName.replace(/\//g, '_');
      params = {Key: 'timesheets/'+fileName,Body: fileData,ACL: 'public-read',ContentType: file.mimetype}
      timesheetBucket = new AWSAPI.S3({params: {Bucket: 'hrsystem'}})
      P.ninvoke(timesheetBucket,'putObject',params)
      .then () ->
        fs.unlink(file.path)
        return fileName  

  downloadTimesheetFromStore: (fileName) ->
  	params = {Key:'timesheets/'+fileName}
  	P.ninvoke(timesheetBucket,'getObject',params)
  	.then (data) ->
  	  return data.Body

  deleteTimesheetFromStore: (fileName) ->
    timesheetBucket.deleteObject {Key:'timesheets/'+fileName}, (err,data) ->

module.exports = new AWS()