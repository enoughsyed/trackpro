const jwt = require('jsonwebtoken');
const supabase = require('../config/supabase');

// Verify JWT token
const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization')?.replace('Bearer ', '');
    
    if (!token) {
      return res.status(401).json({ message: 'No token, authorization denied' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const { data: user, error } = await supabase
      .from('users')
      .select('id, name, username, role, is_active')
      .eq('id', decoded.userId)
      .single();
    
    if (error || !user) {
      return res.status(401).json({ message: 'Token is not valid' });
    }

    req.user = user;
    next();
  } catch (error) {
    res.status(401).json({ message: 'Token is not valid' });
  }
};

// Check if user is admin
const adminAuth = (req, res, next) => {
  if (req.user.role !== 'Admin') {
    return res.status(403).json({ message: 'Access denied. Admin required.' });
  }
  next();
};

// Check if user is supervisor or admin
const supervisorAuth = (req, res, next) => {
  if (req.user.role !== 'Supervisor' && req.user.role !== 'Admin') {
    return res.status(403).json({ message: 'Access denied. Supervisor or Admin required.' });
  }
  next();
};

module.exports = { auth, adminAuth, supervisorAuth };