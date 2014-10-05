module.exports = (sequelize,DataTypes)->
  return sequelize.define("Timesheet", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    weekId:
      type:DataTypes.STRING(50)
      validate:
        notEmpty: true
    submittedOn:
      type:DataTypes.DATE
    approvedOn:
      type:DataTypes.DATE
    approvedBy:  
      type:DataTypes.BIGINT
    status:
      type: DataTypes.STRING(10)
      defaultValue: 'draft'     
  })	