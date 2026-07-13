'use strict';

const Sequelize = require('sequelize');
const config = require('../config/database');

const dbConfig = config.development;

const sequelize = new Sequelize(
  dbConfig.database,
  dbConfig.username,
  dbConfig.password,
  {
    host: dbConfig.host,
    dialect: dbConfig.dialect,
    logging: dbConfig.logging,
  }
);

const db = {};

// Manually load models
try {
  db.User = require('./User')(sequelize, Sequelize.DataTypes);
  db.Student = require('./Student')(sequelize, Sequelize.DataTypes);
  db.Parent = require('./Parent')(sequelize, Sequelize.DataTypes);
  db.Career = require('./Career')(sequelize, Sequelize.DataTypes);
  db.CareerRecommendation = require('./CareerRecommendation')(sequelize, Sequelize.DataTypes);
  db.AcademicResult = require('./AcademicResult')(sequelize, Sequelize.DataTypes);
  db.Quiz = require('./Quiz')(sequelize, Sequelize.DataTypes);
  db.QuizResponse = require('./QuizResponse')(sequelize, Sequelize.DataTypes);
  db.Admin = require('./Admin')(sequelize, Sequelize.DataTypes);

  // Associate
  Object.keys(db).forEach(modelName => {
    if (db[modelName].associate) {
      db[modelName].associate(db);
    }
  });

  console.log('✅ All models loaded successfully');
} catch (error) {
  console.log('❌ Error loading models:', error.message);
}

db.sequelize = sequelize;
db.Sequelize = Sequelize;

// Test connection
sequelize.authenticate()
  .then(() => {
    console.log('✅ Database connection successful');
    return sequelize.sync({ alter: true });
  })
  .then(() => {
    console.log('✅ Database synced successfully');
  })
  .catch(err => {
    console.log('❌ Database error:', err.message);
  });

module.exports = db;