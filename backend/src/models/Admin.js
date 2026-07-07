'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const Admin = sequelize.define(
    'Admin',
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
      permissions: {
        type: DataTypes.JSON,
        defaultValue: {
          canManageUsers: true,
          canManageCareers: true,
          canManageQuizzes: true,
        },
      },
    },
    {
      tableName: 'Admins',
      timestamps: true,
    }
  );

  Admin.associate = (models) => {
    Admin.belongsTo(models.User, { foreignKey: 'userId' });
  };

  return Admin;
};