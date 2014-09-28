module.exports = (sequelize,DataTypes)->
  return sequelize.define("FileRoom", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    roomName:
      type: DataTypes.STRING(500)
      validate:
        notEmpty: true
    accessToEmployee:
      type: DataTypes.ENUM('OD', 'DU','NA')
      defaultValue: 'NA'
    accessToSupervisor:
      type: DataTypes.ENUM('OD', 'DU','NA')
      defaultValue: 'NA'
  })	