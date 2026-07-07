'use strict';

module.exports = {
  async up(queryInterface, Sequelize) {
    // Add unique constraint on (email, role) combination
    await queryInterface.addConstraint('Users', {
      fields: ['email', 'role'],
      type: 'unique',
      name: 'unique_email_per_role',
    });
  },

  async down(queryInterface, Sequelize) {
    // Remove the constraint
    await queryInterface.removeConstraint(
      'Users',
      'unique_email_per_role'
    );
  },
};