const express = require('express');
const router = express.Router();

const authMiddleware = (req, res, next) => next();
router.use(authMiddleware);

router.get('/:parentId/child', (req, res) => {
  res.json({ id: 'child-1', fullName: 'Child', email: 'child@example.com' });
});

router.get('/:parentId/child-recommendations', (req, res) => {
  res.json({ recommendations: [] });
});

router.get('/:parentId/child-academic', (req, res) => {
  res.json({ academicResults: [] });
});

module.exports = router;