import * as admin from "firebase-admin";
import * as path from "path";

// サービスアカウントキーのパス
const serviceAccount = require("./serviceAccountKey.json");

// Firebase初期化
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "mangatranslatorapp.firebasestorage.app", // ここを自分のバケット名に
});

const db = admin.firestore();
const bucket = admin.storage().bucket();

// サンプルデータ
const comicId = "manga001";
const langList = ["ja", "en", "zh"];
const pageFileName = "page001.png";

// comicsコレクション
async function seedComics() {
  await db
    .collection("comics")
    .doc(comicId)
    .set({
      comicId,
      title: {
        ja: "冒険の始まり",
        en: "The Beginning of the Adventure",
        zh: "冒險的開始",
      },
      pages: [1],
      languages: langList,
    });
  console.log("comics投入完了");
}

// episodesコレクション
async function seedEpisodes() {
  const episodeData = {
    episodeId: 1,
    title: {
      ja: "第1話 冒険の始まり",
      en: "Episode 1: The Beginning of Adventure",
      zh: "第1話 冒險的開始",
    },
    description: {
      ja: "主人公の冒険が始まる第1話です。",
      en: "Episode 1 where the hero's adventure begins.",
      zh: "主角冒險開始的第1話。",
    },
    pageCount: 3,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await db
    .collection("comics")
    .doc(comicId)
    .collection("episodes")
    .doc("episode_1")
    .set(episodeData);

  console.log("episodes投入完了");
}

// pagesコレクション
async function seedPages() {
  const pagesData = [
    {
      pageId: 1,
      imageUrl: "assets/pages/page001.png",
      bubbles: [
        {
          position: [100, 200],
          size: [120, 60],
          text: {
            ja: "こんにちは！",
            en: "Hello!",
            zh: "你好！",
          },
          translations: [
            {
              userId: "user_1",
              lang: "en",
              text: "Hi!",
              comment: "カジュアルにしました",
            },
          ],
          reviews: [{ userId: "user_2", score: 5, comment: "自然な訳！" }],
        },
      ],
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {
      pageId: 2,
      imageUrl: "assets/pages/page002.png",
      bubbles: [
        {
          position: [150, 180],
          size: [140, 70],
          text: {
            ja: "冒険の始まりだ！",
            en: "The adventure begins!",
            zh: "冒險開始了！",
          },
          translations: [
            {
              userId: "user_3",
              lang: "en",
              text: "Let the adventure start!",
              comment: "意訳です",
            },
          ],
          reviews: [{ userId: "user_4", score: 4, comment: "良い表現！" }],
        },
      ],
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    {
      pageId: 3,
      imageUrl: "assets/pages/page003.png",
      bubbles: [
        {
          position: [200, 220],
          size: [160, 80],
          text: {
            ja: "一緒に冒険しよう！",
            en: "Let's go on an adventure together!",
            zh: "一起冒險吧！",
          },
          translations: [
            {
              userId: "user_5",
              lang: "zh",
              text: "让我们一起冒险吧！",
              comment: "中国語ネイティブ訳",
            },
          ],
          reviews: [{ userId: "user_6", score: 5, comment: "完璧！" }],
        },
      ],
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    },
  ];

  for (const pageData of pagesData) {
    await db
      .collection("comics")
      .doc(comicId)
      .collection("episodes")
      .doc("episode_1")
      .collection("pages")
      .doc(`page_${pageData.pageId}`)
      .set(pageData);
  }

  console.log("pages投入完了");
}

// quizzesコレクション
async function seedQuizzes() {
  const quizData = [
    {
      comicId,
      episodeId: "episode_1",
      question:
        "「行きたい！！私を海に連れてって！！」の「行きたい」の正しい文法は？",
      choices: [
        "行きたい（正しい）",
        "行きしたい（間違い）",
        "行くたい（間違い）",
        "行きたがる（間違い）",
      ],
      correctIndex: 0,
      explanation:
        "「行きたい」は「行く」の連用形「行き」＋「たい」の正しい形です。「行きしたい」は文法的に間違いです。",
      type: "grammar",
      context: {
        dialogue: "行きたい！！私を海に連れてって！！",
        character: "主人公",
        scene: "海に行きたいと訴える場面",
      },
      createdBy: "user_1234",
    },
    {
      comicId,
      episodeId: "episode_1",
      question: "「私を海に連れてって！！」の「連れてって」の正しい表記は？",
      choices: [
        "連れてって（正しい）",
        "連れて行って（正しい）",
        "連れてって（間違い）",
        "連れてって（間違い）",
      ],
      correctIndex: 1,
      explanation:
        "「連れてって」は「連れて行って」の口語的表現です。正式な表記では「連れて行って」が正しいです。",
      type: "grammar",
      context: {
        dialogue: "行きたい！！私を海に連れてって！！",
        character: "主人公",
        scene: "海に行きたいと訴える場面",
      },
      createdBy: "user_1234",
    },
    {
      comicId,
      episodeId: "episode_1",
      question: "「冒険の始まりだ！」の「だ」の品詞は？",
      choices: ["助動詞", "形容詞", "動詞", "副詞"],
      correctIndex: 0,
      explanation:
        "「だ」は断定の助動詞です。「冒険の始まりだ」は「冒険の始まりである」という意味を表します。",
      type: "grammar",
      context: {
        dialogue: "冒険の始まりだ！",
        character: "主人公",
        scene: "冒険が始まる場面",
      },
      createdBy: "user_1234",
    },
  ];

  for (const quiz of quizData) {
    await db.collection("quizzes").add(quiz);
  }
  console.log("quizzes投入完了");
}

// Storageに画像アップロード
async function uploadSampleImage() {
  const localPath = path.join(__dirname, "sample_images", pageFileName);
  const destPath = `comics/${comicId}/ja/${pageFileName}`;
  await bucket.upload(localPath, { destination: destPath });
  console.log("画像アップロード完了");
}

// 実行
(async () => {
  await seedComics();
  await seedEpisodes();
  await seedPages();
  await seedQuizzes();
  await uploadSampleImage();
  console.log("全て完了！");
  process.exit(0);
})();
