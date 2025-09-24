const express = require("express");
const router = express.Router();
const authMiddleware = require("../middleware/auth");
const Message = require("../models/Message");

// Get 1-on-1 chat history with a user
router.get("/:userId", authMiddleware, async (req, res) => {
  const { userId } = req.params;
  try {
    const messages = await Message.find({
      $or: [
        { senderId: req.userId, receiverId: userId },
        { senderId: userId, receiverId: req.userId },
      ],
    }).sort("timestamp");
    res.json(messages);
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;
