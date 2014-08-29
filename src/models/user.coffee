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
    displayName:
      type: DataTypes.STRING(300)   
    email:
      type: DataTypes.STRING(200)
      validate:
        isEmail: true
    hashPassword:
      type: DataTypes.STRING(1000)
    isAccountActive:
      type: DataTypes.BOOLEAN
      defaultValue: false
    isAccountLocked:
      type: DataTypes.BOOLEAN
      defaultValue: false     
  })	