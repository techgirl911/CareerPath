const validateEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

const validatePassword = (password) => {
  return password && password.length >= 6;
};

const validateRole = (role) => {
  return ['student', 'parent', 'admin'].includes(role);
};

module.exports = {
  validateEmail,
  validatePassword,
  validateRole,
};