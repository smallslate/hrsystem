module.exports = (sequelize,DataTypes)->
  return sequelize.define("FileRoomDoc", {
    id:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true 
    orginalName:
      type: DataTypes.STRING(1000)
    cloudName:
      type: DataTypes.STRING(1000)
    mimeType:
      type: DataTypes.STRING(100)
    extension:
      type: DataTypes.STRING(10)
  })	