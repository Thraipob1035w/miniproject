const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// API สำหรับดึงข้อมูลผู้ใช้จาก Firebase Authentication
exports.getUserProfile = functions.https.onRequest(async (req, res) => {
  try {
    const uid = req.query.uid; // รับ uid จาก request

    // ตรวจสอบว่า uid มีอยู่หรือไม่
    if (!uid) {
      return res.status(400).send({ message: "User ID is required" });
    }

    // ดึงข้อมูลผู้ใช้จาก Firebase Authentication
    const userRecord = await admin.auth().getUser(uid);

    // ส่งข้อมูลที่ต้องการไปยัง client
    res.status(200).send({
      email: userRecord.email,
      displayName: userRecord.displayName,
      phoneNumber: userRecord.phoneNumber,
    });
  } catch (error) {
    console.error("Error fetching user data:", error);
    res.status(500).send({ message: "Error fetching user data", error: error.message });
  }
});
