module.exports = (sequelize,DataTypes)->
  return sequelize.define("TimesheetTask", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true 
    name:
      type:DataTypes.BIGINT
    comments:
      type: DataTypes.STRING(2000)  
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