module.exports = (sequelize,DataTypes)->
  return sequelize.define("Company", {
    companyuid:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      allowNull: false
      unique: true
      validate:
        isNumeric: true
        notEmpty: true
        notNull: true
    companyId:
      type: DataTypes.STRING(20)
      allowNull: false
      unique: true
      validate:
        isAlphanumeric: true
        notEmpty: true
        notNull: true
    companyName:
      type: DataTypes.STRING(80) 
      validate:
        notEmpty: true
        notNull: true
    companyImg:
      type: DataTypes.STRING(20)
    isActive:
      type: DataTypes.BOOLEAN
      defaultValue: true  
  })

  
      