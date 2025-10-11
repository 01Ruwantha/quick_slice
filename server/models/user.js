const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name:{
    required:true,
    type:String,
    trim:true,
  },
  phone: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (val) => {
      // Accepts 07xxxxxxxx OR +94xxxxxxxxx
      return /^(?:0\d{9}|\+94\d{9})$/.test(val);
    },
    message: "Please enter a valid Sri Lankan phone number",
    },
  },
  email: {
    required: true,
    type: String,
    trim: true,
    validate: {
      validator: (val) => {
        const re =
          /^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$/i;
        return re.test(val);
      },
      message: "Please enter a valid email address",
    },
  },
  role: {
    type: String,
    default: "customer",
  },
  password: {
    required: true,
    type: String,
  },
});

const User = mongoose.model("User", userSchema);
module.exports = User;
