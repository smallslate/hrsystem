module.exports = (sequelize,DataTypes)->
  return sequelize.define("Users", {
    useruid:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      allowNull: false
      unique: true
    userId:
      type: DataTypes.STRING(250)
      allowNull: false
      unique: true
      validate:
        isAlphanumeric: true
        notEmpty: true
        notNull: true
    companyuid:
      type:DataTypes.BIGINT
      allowNull: false  
      validate:
        isNumeric: true
        notEmpty: true
        notNull: true   
    email:
      type: DataTypes.STRING(1000) 
      allowNull: false
      validate:
        isEmail: true
        notEmpty: true
        notNull: true
    password:
  	  type: DataTypes.STRING(3000)
    salt:
      type: DataTypes.STRING(3000) 
    isActive:
      type: DataTypes.BOOLEAN
      defaultValue: false
    isLocked:
      type: DataTypes.BOOLEAN
      defaultValue: false  
  })

  
      