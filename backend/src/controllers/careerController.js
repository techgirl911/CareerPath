const pool = require('../config/dbPool');
const { v4: uuidv4 } = require('uuid');

// Get all careers
exports.getAllCareers = async (req, res) => {
  try {
    const page = req.query.page || 1;
    const limit = req.query.limit || 20;
    const offset = (page - 1) * limit;

    const [careers] = await pool.query(
      'SELECT * FROM careers LIMIT ? OFFSET ?',
      [parseInt(limit), offset]
    );

    const [countResult] = await pool.query('SELECT COUNT(*) as count FROM careers');
    const total = countResult[0].count;

    res.status(200).json({
      data: careers,
      pagination: {
        page: parseInt(page),
        limit: parseInt(limit),
        total,
        pages: Math.ceil(total / limit)
      }
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get career by ID
exports.getCareerById = async (req, res) => {
  try {
    const careerId = req.params.careerId;

    const [careers] = await pool.query(
      'SELECT * FROM careers WHERE id = ?',
      [careerId]
    );

    if (careers.length === 0) {
      return res.status(404).json({ message: 'Career not found' });
    }

    res.status(200).json({ data: careers[0] });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Search careers
exports.searchCareers = async (req, res) => {
  try {
    const query = req.query.q || '';

    const [careers] = await pool.query(
      'SELECT * FROM careers WHERE title LIKE ? OR description LIKE ?',
      [`%${query}%`, `%${query}%`]
    );

    res.status(200).json({ data: careers });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get trending careers
exports.getTrendingCareers = async (req, res) => {
  try {
    const limit = req.query.limit || 10;

    const [careers] = await pool.query(
      'SELECT * FROM careers ORDER BY demandIndex DESC LIMIT ?',
      [parseInt(limit)]
    );

    res.status(200).json({ data: careers });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get market demand
exports.getMarketDemand = async (req, res) => {
  try {
    const careerId = req.params.careerId;

    const [demand] = await pool.query(
      'SELECT * FROM market_demand WHERE careerId = ?',
      [careerId]
    );

    if (demand.length === 0) {
      return res.status(404).json({ message: 'Market demand data not found' });
    }

    res.status(200).json({ data: demand[0] });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create career (admin only)
exports.createCareer = async (req, res) => {
  try {
    const { title, description, salaryRange, requiredSkills, subjects, demandIndex, demandTrend } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: 'Title and description are required' });
    }

    const careerId = uuidv4();

    await pool.query(
      'INSERT INTO careers (id, title, description, salaryRange, requiredSkills, subjects, demandIndex, demandTrend) VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [careerId, title, description, salaryRange, JSON.stringify(requiredSkills), JSON.stringify(subjects), demandIndex, demandTrend]
    );

    res.status(201).json({
      message: 'Career created successfully',
      careerId
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};