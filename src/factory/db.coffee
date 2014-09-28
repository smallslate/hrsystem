Sequelize = require 'sequelize'
config = require('./config')

dbConfig =
  host: config.db.host
  port: config.db.port
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

dbModels = [{'name':'Company','path':'../models/company/company'},
            {'name':'User','path':'../models/company/security/user'},
            {'name':'Verification','path':'../models/company/security/verification'},
            {'name':'Role','path':'../models/company/security/role'},
            {'name':'PageAccess','path':'../models/company/security/pageAccess'},
            {'name':'Employee','path':'../models/employee/employee'},
            {'name':'Timesheet','path':'../models/employee/timesheet/timesheet'},
            {'name':'TimesheetTask','path':'../models/employee/timesheet/timesheetTask'},
            {'name':'TimesheetDoc','path':'../models/employee/timesheet/timesheetDoc'},
            {'name':'Department','path':'../models/company/department'},
            {'name':'CompanyTask','path':'../models/employee/timesheet/companyTask'},
            {'name':'FileRoom','path':'../models/employee/fileRoom'},
            {'name':'FileRoomDoc','path':'../models/employee/fileRoomDoc'}
          ]    

class DB
  constructor:->
    @db = @
    @models = {}
    @sequelize = new Sequelize config.db.dbName, config.db.userName, config.db.password,dbConfig
    @initModels()
    @initAssociations()
    @syncModels()
    return @db     

  initModels:->
    dbModels.forEach (modelObj) =>
      @models[modelObj.name] = @sequelize.import(modelObj.path)

     
  initAssociations:->
    @models['Company'].hasMany(@models['User']).hasMany(@models['PageAccess']).hasMany(@models['Role']).hasMany(@models['Employee'])
      .hasMany(@models['Department']).hasMany(@models['CompanyTask']).hasMany(@models['FileRoom'])
    @models['User'].hasMany(@models['Role']).hasOne(@models['Employee'])
    @models['Role'].hasMany(@models['User']).hasMany(@models['PageAccess'])
    @models['PageAccess'].hasMany(@models['Role'])
    @models['Employee'].hasOne(@models['Employee'],{as:'Supervisor',foreignKey:'supervisorId'}).hasMany(@models['Timesheet'])
      .hasMany(@models['FileRoomDoc'])
    @models['Department'].hasMany(@models['Employee']).hasMany(@models['CompanyTask']).hasMany(@models['FileRoom'])
    @models['Timesheet'].hasMany(@models['TimesheetTask']).hasMany(@models['TimesheetDoc'])
    @models['CompanyTask'].hasMany(@models['Department'])
    @models['FileRoom'].hasMany(@models['Department']).hasMany(@models['FileRoomDoc'])
    
  syncModels:->
    @sequelize.sync()
      .success -> 
        console.log('All tables are created')
      .error (error) -> 
        console.log('errors while creating '+error)  
  
module.exports = new DB()