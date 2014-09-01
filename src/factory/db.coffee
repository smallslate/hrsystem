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

dbModels = [{'name':'Company','path':'../models/company'},
            {'name':'User','path':'../models/user'},
            {'name':'Verification','path':'../models/verification'},
            {'name':'Role','path':'../models/role'},
            {'name':'PageAccess','path':'../models/pageAccess'},
            {'name':'Employee','path':'../models/employee/employee'}]    

class DB
  constructor:->
    @db = @
    @models = {}
    @sequelize = new Sequelize 'hrsystem', 'root', 'sysadm',dbConfig
    @initModels()
    @initAssociations()
    @syncModels()
    return @db     

  initModels:->
    dbModels.forEach (modelObj) =>
      @models[modelObj.name] = @sequelize.import(modelObj.path)

     
  initAssociations:->
    @models['Company'].hasMany(@models['User']).hasMany(@models['PageAccess']).hasMany(@models['Role']).hasOne(@models['Employee'])
    @models['User'].hasMany(@models['Role']).hasOne(@models['Employee'])
    @models['Role'].hasMany(@models['User']).hasMany(@models['PageAccess'])
    @models['PageAccess'].hasMany(@models['Role'])
    @models['Employee'].hasOne(@models['Employee'],{as:'Supervisor',foreignKey:'supervisorId'})
    
  syncModels:->
    @sequelize.sync()
      .success -> 
        console.log('All tables are created')
      .error (error) -> 
        console.log('errors while creating '+error)  
  
module.exports = new DB()