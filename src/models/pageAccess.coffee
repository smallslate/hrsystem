module.exports = (sequelize,DataTypes)->
  return sequelize.define("PageAccess", {
    pageId:
      type:DataTypes.BIGINT 
      primaryKey : true
      allowNull: false
      unique: true
  })	