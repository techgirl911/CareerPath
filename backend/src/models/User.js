'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define(
    'User',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      fullName: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      email: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      password: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      role: {
        type: DataTypes.ENUM('student', 'parent', 'admin'),
        allowNull: false,
        defaultValue: 'student',
      },
      isActive: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
    },
    {
      tableName: 'Users',
      timestamps: true,
      indexes: [
        {
          fields: ['email', 'role'],
          unique: true,
          name: 'unique_email_per_role',
        },
      ],
    }
  );

  User.associate = (models) => {
    // Add associations here if needed
  };

  return User;
};