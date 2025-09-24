const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
const cors = require("cors");
const http = require("http");
const { Server } = require("socket.io");
const jwt = require("jsonwebtoken");
const Message = require("./models/Message");

dotenv.config();
const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: "*" } });

app.use(cors());
app.use(express.json());

app.use("/api/auth", require("./routes/auth"));
app.use("/api/users", require("./routes/users"));
app.use("/api/messages", require("./routes/messages"));

mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// Socket.IO JWT auth
io.use((socket, next) => {
  const token = socket.handshake.auth?.token;
  if (!token) return next(new Error("Auth failed"));

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    socket.userId = decoded.id;
    next();
  } catch (err) {
    next(new Error("Auth failed"));
  }
});

// Map to store connected sockets by userId
const onlineUsers = new Map();

io.on("connection", (socket) => {
  console.log("User connected:", socket.userId);
  onlineUsers.set(socket.userId, socket.id);

  // socket.on("private-message", async ({ to, content }) => {
  //   const message = new Message({ senderId: socket.userId, receiverId: to, content });
  //   await message.save();

  //   const receiverSocketId = onlineUsers.get(to);
  //   if (receiverSocketId) {
  //     io.to(receiverSocketId).emit("private-message", { from: socket.userId, content, timestamp: message.timestamp });
  //   }
  // });
socket.on("private-message", async ({ to, content }) => {
    const message = new Message({ senderId: socket.userId, receiverId: to, content });
    await message.save();
    const receiverSocketId = onlineUsers.get(to);
    if (receiverSocketId) {
        io.to(receiverSocketId).emit("private-message", { from: socket.userId, content, timestamp: message.timestamp });
    }
});

  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.userId);
    onlineUsers.delete(socket.userId);
  });
});

server.listen(process.env.PORT, () => console.log(`Server running on ${process.env.PORT}`));
