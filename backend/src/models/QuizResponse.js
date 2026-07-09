'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const QuizResponse = sequelize.define(
    'QuizResponse',
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
      quizId: {
        type: DataTypes.UUID,
        allowNull: false,
        references: {
          model: 'Quizzes',
          key: 'id',
        },
      },
      answers: {
        type: DataTypes.JSON,
        allowNull: false,
        defaultValue: {},
      },
      score: {
        type: DataTypes.FLOAT,
        defaultValue: 0,
      },
    },
    {
      tableName: 'quizresponses',
      timestamps: true,
    }
  );

  QuizResponse.associate = (models) => {
    QuizResponse.belongsTo(models.Student, {
      foreignKey: 'studentId',
    });
    QuizResponse.belongsTo(models.Quiz, {
      foreignKey: 'quizId',
    });
  };

  return QuizResponse;
};