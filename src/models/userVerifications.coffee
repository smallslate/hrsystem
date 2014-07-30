module.exports = (sequelize,DataTypes)->
  return sequelize.define("UserVerifications", {
    verificationId:
      type:DataTypes.STRING(100)
      allowNull: false
    userId:
      type: DataTypes.STRING(250)
      allowNull: false
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
    isMailSent:
      type: DataTypes.BOOLEAN
      defaultValue: false
    isVerified:
      type: DataTypes.BOOLEAN
      defaultValue: false  
  })

  
      