'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const Parent = sequelize.define(
    'Parent',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      userId: {
        type: DataTypes.UUID,
        allowNull: false,
        references: {
          model: 'Users',
          key: 'id',
        },
      },
      childrenCount: {
        type: DataTypes.INTEGER,
        defaultValue: 1,
      },
    },
    {
      tableName: 'Parents',
      timestamps: true,
    }
  );

  Parent.associate = (models) => {
    Parent.belongsTo(models.User, { foreignKey: 'userId' });
  };

  return Parent;
};