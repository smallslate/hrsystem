module.exports = (sequelize,DataTypes)->
  return sequelize.define("Department", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    departmentName:
      type: DataTypes.STRING(80) 
      validate:
        notEmpty: true
        notNull: true
    departmentHead:
      type:DataTypes.BIGINT
    isActive:
      type: DataTypes.BOOLEAN
      defaultValue: true  
  })

  
      