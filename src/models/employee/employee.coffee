module.exports = (sequelize,DataTypes)->
  return sequelize.define("Employee", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    emplId:
      type:DataTypes.BIGINT
      validate:
        notEmpty: true
    isTerminated:
      type: DataTypes.BOOLEAN
      defaultValue: false   
  })	