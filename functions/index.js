/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onCall} = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// Notification Handling
exports.sendNotification = onCall(async (data, context) => {
  const {userId, title, body, dataPayload} = data;

  if (!context.auth) {
    throw new Error("Authentication required");
  }

  const message = {
    notification: {
      title,
      body,
    },
    data: dataPayload,
    token: await getUserFcmToken(userId),
  };

  try {
    await admin.messaging().send(message);
    return {success: true};
  } catch (error) {
    console.error("Error sending notification:", error);
    throw new Error("Notification failed");
  }
});

/**
 * Retrieves the FCM token for a user.
 * @param {string} userId - The ID of the user.
 * @return {Promise<string|null>} The FCM token or null if not found.
 */
async function getUserFcmToken(userId) {
  const userDoc = await admin.firestore().collection("users").doc(userId).get();
  const userData = userDoc.data();
  return userData && userData.fcmToken ? userData.fcmToken : null;
}

// Compatibility Calculation
exports.calculateCompatibility = onCall(async (data, context) => {
  const {user1Id, user2Id} = data;

  if (!context.auth) {
    throw new Error("Authentication required");
  }

  const user1 = await admin.firestore().collection("users").doc(user1Id).get();
  const user2 = await admin.firestore().collection("users").doc(user2Id).get();

  if (!user1.exists || !user2.exists) {
    throw new Error("One or both users not found");
  }

  const compatibilityScore = computeCompatibility(user1.data(), user2.data());
  return {compatibilityScore};
});

/**
 * Computes the compatibility score between two users.
 * @param {Object} user1 - Data of the first user.
 * @param {Object} user2 - Data of the second user.
 * @return {number} The compatibility score.
 */
function computeCompatibility(user1, user2) {
  // Example compatibility logic
  return Math.random() * 100; // Replace with actual logic
}

// Exploration Journey Management
exports.manageExploration = onCall(async (data, context) => {
  const {explorationId, action, payload} = data;

  if (!context.auth) {
    throw new Error("Authentication required");
  }

  const explorationRef = admin.firestore()
      .collection("explorations")
      .doc(explorationId);

  switch (action) {
    case "start":
      await explorationRef.set(payload);
      break;
    case "update":
      await explorationRef.update(payload);
      break;
    case "delete":
      await explorationRef.delete();
      break;
    default:
      throw new Error("Invalid action");
  }

  return {success: true};
});
