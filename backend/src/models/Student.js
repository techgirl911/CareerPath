'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const Student = sequelize.define(
    'Student',
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
      gpa: {
        type: DataTypes.FLOAT,
        defaultValue: 0.0,
      },
      grade: {
        type: DataTypes.STRING,
        defaultValue: 'A',
      },
      enrollmentDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
      },
    },
    {
      tableName: 'Students',
      timestamps: true,
    }
  );

  Student.associate = (models) => {
    Student.belongsTo(models.User, { foreignKey: 'userId' });
    Student.hasMany(models.AcademicResult, {
      foreignKey: 'studentId',
    });
    Student.hasMany(models.CareerRecommendation, {
      foreignKey: 'studentId',
    });
    Student.hasMany(models.QuizResponse, {
      foreignKey: 'studentId',
    });
  };

  return Student;
};