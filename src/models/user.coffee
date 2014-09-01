module.exports = (sequelize,DataTypes)->
  return sequelize.define("User", {
    uuid:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    signInId:
      type: DataTypes.STRING(300)
      allowNull: false
      validate:
        notEmpty: true
        notNull: true
    email:
      type: DataTypes.STRING(200)
      validate:
        isEmail: true    
    firstName:
      type: DataTypes.STRING(500) 
    middleName:
      type: DataTypes.STRING(500)   
    lastName:
      type: DataTypes.STRING(500)
    hashPassword:
      type: DataTypes.STRING(1000)
    isAccountActive:
      type: DataTypes.BOOLEAN
      defaultValue: false    
  })	