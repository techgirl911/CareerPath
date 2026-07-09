'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const Career = sequelize.define(
    'Career',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      title: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      salaryRange: {
        type: DataTypes.JSON,
        defaultValue: { min: 0, max: 0 },
      },
      demandLevel: {
        type: DataTypes.ENUM('high', 'medium', 'low'),
        defaultValue: 'medium',
      },
    },
    {
      tableName: 'careers',
      timestamps: true,
    }
  );

  Career.associate = (models) => {
    Career.hasMany(models.CareerRecommendation, {
      foreignKey: 'careerId',
    });
  };

  return Career;
};