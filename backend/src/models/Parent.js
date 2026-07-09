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
      childId: {
        type: DataTypes.UUID,
        allowNull: true,
        references: {
          model: 'Students',
          key: 'id',
        },
      },
      relationship: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      childrenCount: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
    },
    {
      tableName: 'parents',
      timestamps: true,
    }
  );

  Parent.associate = (models) => {
    Parent.belongsTo(models.User, { foreignKey: 'userId' });
    Parent.belongsTo(models.Student, { foreignKey: 'childId' });
  };

  return Parent;
};