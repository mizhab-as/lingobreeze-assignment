const admin = require('firebase-admin');

let db = null;

function initFirestore() {
  if (admin.apps.length) return;
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;

  if (emulatorHost) {
    // Connect to emulator without credentials
    admin.initializeApp();
    db = admin.firestore();
    // Configure settings to talk to emulator
    try {
      db.settings({ host: emulatorHost, ssl: false });
    } catch (e) {
      // ignore settings errors on older SDK versions
    }
    return;
  }

  const keyPath = process.env.GOOGLE_APPLICATION_CREDENTIALS || process.env.FIREBASE_SERVICE_ACCOUNT_PATH;
  if (!keyPath) {
    throw new Error('FIRESTORE init requires GOOGLE_APPLICATION_CREDENTIALS or FIREBASE_SERVICE_ACCOUNT_PATH env var, or set FIRESTORE_EMULATOR_HOST for emulator');
  }
  admin.initializeApp({
    credential: admin.credential.cert(require(keyPath))
  });
  db = admin.firestore();
}

async function getWordsFromFirestore() {
  if (!db) throw new Error('Firestore not initialized');
  const snapshot = await db.collection('words').orderBy('createdAt', 'desc').get();
  return snapshot.docs.map(d => ({ id: d.id, ...d.data() }));
}

async function addWordToFirestore(entry) {
  if (!db) throw new Error('Firestore not initialized');
  const docRef = await db.collection('words').add(entry);
  const doc = await docRef.get();
  return { id: doc.id, ...doc.data() };
}

module.exports = { initFirestore, getWordsFromFirestore, addWordToFirestore };
