AWSAPI = require 'aws-sdk'
nodeUuid = require("node-uuid")
config = require('./config')
awsConfig = config.aws
fs = require('fs')
P = require("q")
AWSAPI.config.update({accessKeyId: awsConfig.accessKeyID, secretAccessKey: awsConfig.secretAccessKey,region: 'us-east-1'})
fileBucket = new AWSAPI.S3({params: {Bucket: 'hrsystem'}})

class AWS
  uploadTimesheetToStore: (file,uuid,weekId) ->
  	P.nfcall(fs.readFile,file.path)
  	.then (fileData) ->
      verificationId = nodeUuid.v4()
      fileName = uuid+'_'+weekId+'_'+verificationId+'.'+file.extension
      fileName = fileName.replace(/\//g, '_');
      params = {Key: config.uploadPath.timeSheets+fileName,Body: fileData,ContentType: file.mimetype}
      P.ninvoke(fileBucket,'putObject',params)
      .then () ->
        fs.unlink(file.path)
        return fileName  

  downloadTimesheetFromStore: (fileName) ->
  	params = {Key:config.uploadPath.timeSheets+fileName}
  	P.ninvoke(fileBucket,'getObject',params)
  	.then (data) ->
  	  return data.Body

  deleteTimesheetFromStore: (fileName) ->
    fileBucket.deleteObject {Key:config.uploadPath.timeSheets+fileName}, (err,data) ->

  empUploadToFileRoom: (file,uuid,fileRoomId) ->
    P.nfcall(fs.readFile,file.path)
    .then (fileData) ->
      verificationId = nodeUuid.v4()
      fileName = uuid+'_'+fileRoomId+'_'+verificationId+'.'+file.extension
      fileName = fileName.replace(/\//g, '_');
      params = {Key: config.uploadPath.fileRoom+fileName,Body: fileData,ContentType: file.mimetype}
      P.ninvoke(fileBucket,'putObject',params)
      .then () ->
        fs.unlink(file.path)
      return fileName  

  deleteFileRoomFileFromStore: (fileName) ->
    fileBucket.deleteObject {Key:config.uploadPath.fileRoom+fileName}, (err,data) ->

  downloadFileRoomFileFromStore: (fileName) ->
    params = {Key:config.uploadPath.fileRoom+fileName}
    P.ninvoke(fileBucket,'getObject',params)
    .then (data) ->
      return data.Body

module.exports = new AWS()