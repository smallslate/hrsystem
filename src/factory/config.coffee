module.exports =
  server:	
    #serverUrl : 'http://hrsystem.elasticbeanstalk.com'
    serverUrl : 'http://localhost:3000'
  db:
    #host: 'aa1xtsgnwnh1qzg.cndorxuubkhh.us-east-1.rds.amazonaws.com'
    host: 'localhost'
    port: 3306
    dbName: 'hrsystem'
    userName: 'root'
    #password: '$S3sysadm'
    password: 'sysadm'
  mail:
    user: 'support@smallslate.com'
    pass: 'facebooksathya'
  aws:
    accessKeyID:'AKIAJY5GXAH4OAYBKMCQ'
    secretAccessKey:'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'
  uploadPath:
    timeSheets:'timesheets/test/'
    fileRoom:'fileroom/test/'
    #timeSheets:'timesheets/prod/'
    #fileRoom:'fileroom/prod/'    