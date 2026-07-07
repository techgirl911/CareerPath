'use strict';
const { DataTypes } = require('sequelize');

module.exports = (sequelize, DataTypes) => {
  const AcademicResult = sequelize.define(
    'AcademicResult',
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
      subjectName: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      grade: {
        type: DataTypes.FLOAT,
        allowNull: false,
      },
      semester: {
        type: DataTypes.STRING,
        allowNull: false,
      },
    },
    {
      tableName: 'AcademicResults',
      timestamps: true,
    }
  );

  AcademicResult.associate = (models) => {
    AcademicResult.belongsTo(models.Student, {
      foreignKey: 'studentId',
    });
  };

  return AcademicResult;
};