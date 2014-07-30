Sequelize = require 'sequelize'

dbConfig =
  host: 'localhost'
  port: 3306
  maxConcurrentQueries: 100
  dialect: 'mysql'
  define:
    syncOnAssociation: true,
    charset: 'utf8',
    collate: 'utf8_general_ci',
    timestamps: true
  pool:
    maxConnections: 5
    maxIdleTime: 30

dbModels = [{'name':'Companies','path':'../models/companies'},
            {'name':'Users','path':'../models/users'},
            {'name':'UserVerifications','path':'../models/userVerifications'}
           ]    

class DB
  constructor:->
    @db = @
    @models = {}
    @sequelize = new Sequelize 'hrsystem', 'root', 'sysadm',dbConfig
    @initModels()
    return @db     

  initModels:->
    dbModels.forEach (modelObj) =>
      @models[modelObj.name] = @sequelize.import(modelObj.path)

    @sequelize.sync()
      .success -> 
        console.log('All tables are created')
      .error (error) -> 
        console.log('errors while creating '+error)  
  
module.exports = new DB()