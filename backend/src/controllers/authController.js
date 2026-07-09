const { User, Parent, Student } = require('../models');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// Signup
exports.signup = async (req, res) => {
  try {
    const { fullName, email, password, role, adminCode } = req.body;

    console.log('========== SIGNUP START ==========');
    console.log('Full Name:', fullName);
    console.log('Email:', email);
    console.log('Role:', role);
    if (role === 'admin') {
      console.log('Admin Code:', adminCode);
    }

    // Validate inputs
    if (!fullName || !email || !password) {
      console.log('Missing required fields');
      return res.status(400).json({
        message: 'Full name, email, and password are required',
      });
    }

    // Validate admin code
    if (role === 'admin') {
      if (!adminCode || adminCode !== process.env.ADMIN_CODE) {
        console.log('Invalid admin code:', adminCode);
        return res.status(400).json({
          message: 'Invalid admin code',
        });
      }
    }

    // Check if email exists FOR THIS ROLE
    console.log(`Checking if ${email} exists for role ${role}`);
    const existingUser = await User.findOne({
      where: {
        email: email,
        role: role,
      },
    });

    if (existingUser) {
      console.log('User already exists for this role');
      return res.status(400).json({
        message: `Email already exists for ${role} role`,
      });
    }

    // Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);
    console.log('Password hashed');

    // Create user
    const user = await User.create({
      fullName,
      email,
      password: hashedPassword,
      role,
    });

    // Create a role-specific record for students and parents
    if (role === 'student') {
      const student = await Student.create({
        userId: user.id,
      });
      console.log('Student record created:', student.id);
    } else if (role === 'parent') {
      const parent = await Parent.create({
        userId: user.id,
        childrenCount: 0,
      });
      console.log('Parent record created:', parent.id);
    }

    console.log('========== SIGNUP SUCCESS ==========');
    console.log('User created:', user.fullName);
    console.log('Role:', user.role);
    console.log('ID:', user.id);

    return res.status(201).json({
      message: 'User created successfully',
      user: {
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.log('========== SIGNUP ERROR ==========');
    console.log('Error:', error.message);
    console.log('Stack:', error.stack);
    return res.status(500).json({
      message: 'Signup failed',
      error: error.message,
    });
  }
};

// Login
exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    console.log('========== LOGIN START ==========');
    console.log('Email:', email);

    // Validate inputs
    if (!email || !password) {
      console.log('Missing email or password');
      return res.status(400).json({
        message: 'Email and password are required',
      });
    }

    // Find user by email (will check all roles)
    const user = await User.findOne({
      where: { email: email },
    });

    if (!user) {
      console.log('User not found');
      return res.status(401).json({
        message: 'Invalid email or password',
      });
    }

    console.log('User found:');
    console.log('  Full Name:', user.fullName);
    console.log('  Role:', user.role);
    console.log('  ID:', user.id);

    // Check password
    const isPasswordValid = await bcrypt.compare(
      password,
      user.password
    );

    if (!isPasswordValid) {
      console.log('Invalid password');
      return res.status(401).json({
        message: 'Invalid email or password',
      });
    }

    console.log('Password valid');

    // Generate token
    const token = jwt.sign(
      {
        id: user.id,
        email: user.email,
        role: user.role,
      },
      process.env.JWT_SECRET || 'your_secret_key',
      {
        expiresIn: process.env.JWT_EXPIRY || '7d',
      }
    );

    console.log('========== LOGIN SUCCESS ==========');
    console.log('Token generated for:', user.fullName);
    console.log('Role:', user.role);

    return res.status(200).json({
      message: 'Login successful',
      token: token,
      user: {
        id: user.id,
        fullName: user.fullName,
        email: user.email,
        role: user.role,
      },
    });
  } catch (error) {
    console.log('========== LOGIN ERROR ==========');
    console.log('Error:', error.message);
    console.log('Stack:', error.stack);
    return res.status(500).json({
      message: 'Login failed',
      error: error.message,
    });
  }
};

// Get current user
exports.getCurrentUser = async (req, res) => {
  try {
    const user = await User.findByPk(req.user.id);

    if (!user) {
      return res.status(404).json({
        message: 'User not found',
      });
    }

    return res.status(200).json({
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Error fetching user',
      error: error.message,
    });
  }
};

// Logout
exports.logout = async (req, res) => {
  try {
    return res.status(200).json({
      message: 'Logout successful',
    });
  } catch (error) {
    return res.status(500).json({
      message: 'Logout failed',
      error: error.message,
    });
  }
};