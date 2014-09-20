module.exports = (sequelize,DataTypes)->
  return sequelize.define("TimesheetTask", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    uuid:
      type: DataTypes.STRING(1000)  
    name:
      type: DataTypes.STRING(1000)
    Sun:
      type: DataTypes.DECIMAL
    Mon:
      type: DataTypes.DECIMAL
    Tue:
      type: DataTypes.DECIMAL
    Wed:
      type: DataTypes.DECIMAL
    Thu:
      type: DataTypes.DECIMAL
    Fri:
      type: DataTypes.DECIMAL
    Sat:
      type: DataTypes.DECIMAL
  })	