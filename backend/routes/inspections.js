const express = require('express');
const { body, validationResult } = require('express-validator');
const supabase = require('../config/supabase');
const { auth } = require('../middleware/auth');
const upload = require('../middleware/upload');

const router = express.Router();

// Create new inspection
router.post('/', auth, upload.single('image'), [
  body('unitNumber').isNumeric().withMessage('Unit number must be numeric'),
  body('componentName').notEmpty().withMessage('Component name is required'),
  body('supplierDetails').optional().isString(),
  body('remarks').optional().isString(),
  body('duration').optional().isString(),
  body('isCompleted').optional().isBoolean(),
  body('timerEvents').optional().isArray()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const inspectionData = {
      unit_number: parseInt(req.body.unitNumber),
      component_name: req.body.componentName,
      supplier_details: req.body.supplierDetails,
      remarks: req.body.remarks,
      duration: req.body.duration,
      is_completed: req.body.isCompleted === 'true',
      inspected_by: req.user.id
    };

    // Handle timerEvents if provided
    if (req.body.timerEvents) {
      try {
        inspectionData.timer_events = typeof req.body.timerEvents === 'string' 
          ? JSON.parse(req.body.timerEvents) 
          : req.body.timerEvents;
      } catch (e) {
        inspectionData.timer_events = [];
      }
    }

    if (req.file) {
      inspectionData.image_path = req.file.path;
    }

    if (req.body.isCompleted === 'true') {
      inspectionData.end_time = new Date().toISOString();
    }

    const { data: inspection, error } = await supabase
      .from('inspections')
      .insert(inspectionData)
      .select(`
        *,
        inspected_by_user:users!inspected_by(name, username)
      `)
      .single();

    if (error) {
      throw error;
    }

    res.status(201).json(inspection);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get all inspections
router.get('/', auth, async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const inspections = await Inspection.find()
      .populate('inspectedBy', 'name username')
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit);

    const total = await Inspection.countDocuments();

    res.json({
      inspections,
      totalPages: Math.ceil(total / limit),
      currentPage: page,
      total
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get inspection by ID
router.get('/:id', auth, async (req, res) => {
  try {
    const inspection = await Inspection.findById(req.params.id)
      .populate('inspectedBy', 'name username');

    if (!inspection) {
      return res.status(404).json({ message: 'Inspection not found' });
    }

    res.json(inspection);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Update inspection
router.put('/:id', auth, upload.single('image'), [
  body('componentName').optional().notEmpty().withMessage('Component name cannot be empty'),
  body('supplierDetails').optional().isString(),
  body('remarks').optional().isString(),
  body('duration').optional().isString(),
  body('isCompleted').optional().isBoolean()
], async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const updateData = { ...req.body };

    if (req.file) {
      updateData.imagePath = req.file.path;
    }

    if (req.body.isCompleted === 'true' && !updateData.endTime) {
      updateData.endTime = new Date();
    }

    const inspection = await Inspection.findByIdAndUpdate(
      req.params.id,
      updateData,
      { new: true }
    ).populate('inspectedBy', 'name username');

    if (!inspection) {
      return res.status(404).json({ message: 'Inspection not found' });
    }

    res.json(inspection);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Delete inspection
router.delete('/:id', auth, async (req, res) => {
  try {
    const inspection = await Inspection.findByIdAndDelete(req.params.id);

    if (!inspection) {
      return res.status(404).json({ message: 'Inspection not found' });
    }

    res.json({ message: 'Inspection deleted successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get inspections by user
router.get('/user/:userId', auth, async (req, res) => {
  try {
    const inspections = await Inspection.find({ inspectedBy: req.params.userId })
      .populate('inspectedBy', 'name username')
      .sort({ createdAt: -1 });

    res.json(inspections);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;