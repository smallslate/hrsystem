module.exports = (sequelize,DataTypes)->
  return sequelize.define("Role", {
    roleId:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      allowNull: false
      unique: true
      validate:
        isNumeric: true
    roleName:
      type: DataTypes.STRING(20)
      allowNull: false
    roleDescr:
      type: DataTypes.STRING(500) 
  })	