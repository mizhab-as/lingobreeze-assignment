const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const { initFirestore, getWordsFromFirestore, addWordToFirestore } = require('./firestore');

const app = express();
app.use(cors());
app.use(bodyParser.json());

const PORT = process.env.PORT || 3000;
const useFirestore = process.env.USE_FIRESTORE === 'true';
const dbFile = path.resolve(__dirname, 'db.json');

if (useFirestore) {
  initFirestore();
}

function readLocalDb() {
  if (!fs.existsSync(dbFile)) return [];
  const txt = fs.readFileSync(dbFile, 'utf8');
  try {
    return JSON.parse(txt);
  } catch (e) {
    return [];
  }
}

function writeLocalDb(data) {
  fs.writeFileSync(dbFile, JSON.stringify(data, null, 2));
}

app.get('/words', async (req, res) => {
  try {
    if (useFirestore) {
      const words = await getWordsFromFirestore();
      return res.json(words);
    }
    const words = readLocalDb();
    res.json(words);
  } catch (err) {
    console.error('GET /words error', err);
    res.status(500).json({ error: 'Failed to retrieve words' });
  }
});

app.post('/words', async (req, res) => {
  try {
    const { word, meaning, translation } = req.body;
    if (!word || !meaning || !translation) {
      return res.status(400).json({ error: 'word, meaning and translation are required' });
    }

    const entry = { word, meaning, translation, createdAt: new Date().toISOString() };

    if (useFirestore) {
      const saved = await addWordToFirestore(entry);
      return res.status(201).json(saved);
    }

    const words = readLocalDb();
    words.push(entry);
    writeLocalDb(words);
    res.status(201).json(entry);
  } catch (err) {
    console.error('POST /words error', err);
    res.status(500).json({ error: 'Failed to save word' });
  }
});

app.listen(PORT, () => {
  console.log(`LingoBreeze backend listening on port ${PORT}`);
  console.log(`USE_FIRESTORE=${useFirestore ? 'true' : 'false'}`);
});
