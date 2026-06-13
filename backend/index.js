const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const { initFirestore, getWordsFromFirestore, addWordToFirestore, deleteWordFromFirestore } = require('./firestore');

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Custom Logger Middleware
app.use((req, res, next) => {
  const start = Date.now();
  res.on('finish', () => {
    const duration = Date.now() - start;
    console.log(`[${new Date().toISOString()}] ${req.method} ${req.originalUrl} - ${res.statusCode} (${duration}ms)`);
  });
  next();
});

const PORT = process.env.PORT || 3000;
const useFirestore = process.env.USE_FIRESTORE === 'true';
const dbFile = path.resolve(__dirname, 'db.json');

// Initialize Firestore if selected
if (useFirestore) {
  try {
    initFirestore();
    console.log('Firestore initialized successfully.');
  } catch (err) {
    console.error('Failed to initialize Firestore:', err.message);
    process.exit(1);
  }
} else {
  // Ensure local db.json database exists and is valid
  if (!fs.existsSync(dbFile)) {
    fs.writeFileSync(dbFile, '[]', 'utf8');
  } else {
    try {
      const data = fs.readFileSync(dbFile, 'utf8');
      JSON.parse(data);
    } catch (e) {
      console.warn('Local database db.json was corrupt. Resetting database.');
      fs.writeFileSync(dbFile, '[]', 'utf8');
    }
  }
}

// Read from local json database helper
function readLocalDb() {
  try {
    if (!fs.existsSync(dbFile)) return [];
    const txt = fs.readFileSync(dbFile, 'utf8');
    return JSON.parse(txt);
  } catch (e) {
    console.error('Error reading local DB:', e);
    return [];
  }
}

// Write to local json database helper
function writeLocalDb(data) {
  try {
    fs.writeFileSync(dbFile, JSON.stringify(data, null, 2), 'utf8');
  } catch (e) {
    console.error('Error writing to local DB:', e);
  }
}

// Routes

/**
 * GET /words
 * Returns a list of saved words. Ordered newest first.
 */
app.get('/words', async (req, res) => {
  try {
    if (useFirestore) {
      const words = await getWordsFromFirestore();
      return res.json(words);
    }
    const words = readLocalDb();
    // Sort local words by createdAt descending
    const sortedWords = [...words].sort((a, b) => {
      return new Date(b.createdAt) - new Date(a.createdAt);
    });
    res.json(sortedWords);
  } catch (err) {
    console.error('Error handling GET /words:', err);
    res.status(500).json({ error: 'Failed to retrieve vocabulary entries' });
  }
});

/**
 * POST /words
 * Adds a new vocabulary entry.
 */
app.post('/words', async (req, res) => {
  try {
    let { word, meaning, translation } = req.body;

    // Validation
    if (!word || typeof word !== 'string' || !word.trim()) {
      return res.status(400).json({ error: 'Field "word" is required and must be a non-empty string' });
    }
    if (!meaning || typeof meaning !== 'string' || !meaning.trim()) {
      return res.status(400).json({ error: 'Field "meaning" is required and must be a non-empty string' });
    }
    if (!translation || typeof translation !== 'string' || !translation.trim()) {
      return res.status(400).json({ error: 'Field "translation" is required and must be a non-empty string' });
    }

    word = word.trim();
    meaning = meaning.trim();
    translation = translation.trim();

    const entry = {
      word,
      meaning,
      translation,
      createdAt: new Date().toISOString()
    };

    if (useFirestore) {
      const saved = await addWordToFirestore(entry);
      return res.status(201).json(saved);
    }

    // Assign mock ID for local items to match Firestore behavior
    const localEntry = {
      id: Math.random().toString(36).substr(2, 9),
      ...entry
    };

    const words = readLocalDb();
    words.push(localEntry);
    writeLocalDb(words);

    res.status(201).json(localEntry);
  } catch (err) {
    console.error('Error handling POST /words:', err);
    res.status(500).json({ error: 'Failed to save vocabulary entry' });
  }
});

/**
 * DELETE /words/:id
 * Deletes a vocabulary entry by ID.
 */
app.delete('/words/:id', async (req, res) => {
  try {
    const { id } = req.params;

    if (useFirestore) {
      await deleteWordFromFirestore(id);
      return res.json({ success: true, message: 'Word deleted' });
    }

    const words = readLocalDb();
    const filtered = words.filter(w => w.id !== id);

    if (words.length === filtered.length) {
      return res.status(404).json({ error: 'Word not found' });
    }

    writeLocalDb(filtered);
    res.json({ success: true, message: 'Word deleted' });
  } catch (err) {
    console.error(`Error handling DELETE /words/${req.params.id}:`, err);
    res.status(500).json({ error: 'Failed to delete vocabulary entry' });
  }
});

// Start Server
app.listen(PORT, () => {
  console.log(`LingoBreeze backend listening on port ${PORT}`);
  console.log(`Storage backend: ${useFirestore ? 'Firebase Firestore' : 'Local db.json file'}`);
});
