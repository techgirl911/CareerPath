const pool = require('../config/dbPool');
const { v4: uuidv4 } = require('uuid');

// Get all quizzes
exports.getAllQuizzes = async (req, res) => {
  try {
    const page = req.query.page || 1;
    const limit = req.query.limit || 20;
    const offset = (page - 1) * limit;

    const [quizzes] = await pool.query(
      'SELECT * FROM quizzes LIMIT ? OFFSET ?',
      [parseInt(limit), offset]
    );

    const parsedQuizzes = quizzes.map((quiz) => ({
      ...quiz,
      questions: typeof quiz.questions === 'string'
        ? JSON.parse(quiz.questions)
        : quiz.questions || []
    }));

    const [countResult] = await pool.query('SELECT COUNT(*) as count FROM quizzes');
    const total = countResult[0].count;

    res.status(200).json({
      data: parsedQuizzes,
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

// Get quiz by ID
exports.getQuizById = async (req, res) => {
  try {
    const quizId = req.params.quizId;

    const [quizzes] = await pool.query(
      'SELECT * FROM quizzes WHERE id = ?',
      [quizId]
    );

    if (quizzes.length === 0) {
      return res.status(404).json({ message: 'Quiz not found' });
    }

    const quiz = quizzes[0];
    quiz.questions = typeof quiz.questions === 'string'
      ? JSON.parse(quiz.questions)
      : quiz.questions || [];

    res.status(200).json({ data: quiz });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Get quiz questions
exports.getQuizQuestions = async (req, res) => {
  try {
    const quizId = req.params.quizId;

    const [quizzes] = await pool.query(
      'SELECT questions FROM quizzes WHERE id = ?',
      [quizId]
    );

    if (quizzes.length === 0) {
      return res.status(404).json({ message: 'Quiz not found' });
    }

    const questions = typeof quizzes[0].questions === 'string'
      ? JSON.parse(quizzes[0].questions)
      : quizzes[0].questions || [];

    res.status(200).json(questions);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Submit quiz response
exports.submitQuizResponse = async (req, res) => {
  try {
    const studentId = req.params.studentId;
    const { quizId, answers } = req.body;

    if (!quizId || !answers) {
      return res.status(400).json({ message: 'Quiz ID and answers are required' });
    }

    const resultId = uuidv4();
    const totalScore = Object.keys(answers).length * 10; // Simple scoring

    await pool.query(
      'INSERT INTO quizresponses (id, studentId, quizId, answers, score, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [resultId, studentId, quizId, JSON.stringify(answers), totalScore, new Date(), new Date()]
    );

    res.status(201).json({
      message: 'Quiz submitted successfully',
      resultId,
      totalScore
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// Create quiz (admin only)
exports.createQuiz = async (req, res) => {
  try {
    const { title, description, questions, year } = req.body;

    if (!title || !description) {
      return res.status(400).json({ message: 'Title and description are required' });
    }

    const quizId = uuidv4();

    await pool.query(
      'INSERT INTO quizzes (id, title, description, year) VALUES (?, ?, ?, ?)',
      [quizId, title, description, year || new Date().getFullYear()]
    );

    // Save questions as JSON in the quizzes table
    const questionsPayload = questions && Array.isArray(questions) ? questions : [];
    await pool.query(
      'UPDATE quizzes SET questions = ? WHERE id = ?',
      [JSON.stringify(questionsPayload), quizId]
    );

    res.status(201).json({
      message: 'Quiz created successfully',
      quizId
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};