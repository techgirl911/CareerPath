'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const CareerRecommendation = sequelize.define(
    'CareerRecommendation',
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      studentId: {
        type: DataTypes.UUID,
        allowNull: false,
        references: {
          model: 'Students',
          key: 'id',
        },
      },
      careerId: {
        type: DataTypes.UUID,
        allowNull: false,
        references: {
          model: 'Careers',
          key: 'id',
        },
      },
      matchScore: {
        type: DataTypes.FLOAT,
        defaultValue: 0.0,
      },
      confidence: {
        type: DataTypes.FLOAT,
        defaultValue: 0.0,
      },
    },
    {
      tableName: 'careerrecommendations',
      timestamps: true,
    }
  );

  CareerRecommendation.associate = (models) => {
    CareerRecommendation.belongsTo(models.Student, {
      foreignKey: 'studentId',
    });
    CareerRecommendation.belongsTo(models.Career, {
      foreignKey: 'careerId',
    });
  };

  return CareerRecommendation;
};