module.exports = (sequelize,DataTypes)->
  return sequelize.define("Verification", {
    verificationuid:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
  	verificationId:
  	  type: DataTypes.STRING(300)
  	  allowNull: false
    signInId:
      type: DataTypes.STRING(300)
      allowNull: false
    companyId:
      type: DataTypes.STRING(20)
      allowNull: false
    displayName:
      type: DataTypes.STRING(300)  
  })