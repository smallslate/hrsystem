module.exports = (sequelize,DataTypes)->
  return sequelize.define("Employees", {
    employeeuid:
      type:DataTypes.BIGINT
      autoIncrement : true
      primaryKey : true
      unique: true
    emplId:
      type:DataTypes.BIGINT
      allowNull: false
      validate:
        isNumeric: true
        notEmpty: true
        notNull: true
    signInId:
      type: DataTypes.STRING(300)
      allowNull: false
      validate:
        notEmpty: true
        notNull: true
    firstName:
      type: DataTypes.STRING(300)
    email:
      type: DataTypes.STRING(200)
      validate:
        isEmail: true
    hashPassword:
      type: DataTypes.STRING(500)
    isAccountActive:
      type: DataTypes.BOOLEAN
      defaultValue: false
    isAccountLocked:
      type: DataTypes.BOOLEAN
      defaultValue: true   
    companyId:
      type: DataTypes.STRING(20)
      allowNull: false  
  })	