module.exports = (sequelize,DataTypes)->
  return sequelize.define("Companies", {
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
    companyDescr:
  	  type: DataTypes.STRING(3000)
    companyImg:
      type: DataTypes.STRING(20)
    isPaidCustomer:
      type: DataTypes.BOOLEAN
      defaultValue: false
    contactDetails:
      type: DataTypes.STRING(3000)
    primaryPhone:
      type: DataTypes.STRING(20)
      isNumeric: true
    otherPhones:
      type: DataTypes.STRING(500)
    primaryEmail:
      type: DataTypes.STRING(100)
      validate:
        isEmail: true
    otherEmails:
      type: DataTypes.STRING(1000)
    address:
      type: DataTypes.STRING(3000)
    city:
      type: DataTypes.STRING(100)
    state:
      type: DataTypes.STRING(100)
    country:
      type: DataTypes.STRING(100)
    zipCode:
      type: DataTypes.STRING(100)
    notes:
      type: DataTypes.TEXT
    isActive:
      type: DataTypes.BOOLEAN
      defaultValue: true  
  })

  
      