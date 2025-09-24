const User = require("../models/User");

exports.getUsers = async (req, res) => {
  try {
    const users = await User.find({ _id: { $ne: req.userId } }).select("_id email");
    res.json(users);
  } catch (err) {
    res.status(500).json({ message: "Server error" });
  }
};
