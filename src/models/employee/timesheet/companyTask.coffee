module.exports = (sequelize,DataTypes)->
  return sequelize.define("CompanyTask", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    name:
      type: DataTypes.STRING(1000)
    isActive:
      type: DataTypes.BOOLEAN
      defaultValue: true
  })	