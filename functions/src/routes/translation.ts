import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";
import axios from "axios";

const router = Router();

// 翻訳データ一覧取得
router.get("/:mangaId", async (req: Request, res: Response) => {
  try {
    const { mangaId } = req.params;
    const db = admin.firestore();
    const snapshot = await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .get();

    const translations = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(translations);
  } catch (error) {
    console.error("翻訳データ取得エラー:", error);
    res.status(500).json({ error: "翻訳データの取得に失敗しました" });
  }
});

// 翻訳データ作成
router.post("/:mangaId", async (req: Request, res: Response) => {
  try {
    const { mangaId } = req.params;
    const user = (req as any).user;
    const translationData = {
      ...req.body,
      createdBy: user.uid,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const db = admin.firestore();
    const docRef = await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .add(translationData);

    res.status(201).json({
      id: docRef.id,
      message: "翻訳データが作成されました",
    });
  } catch (error) {
    console.error("翻訳データ作成エラー:", error);
    res.status(500).json({ error: "翻訳データの作成に失敗しました" });
  }
});

// 翻訳データ更新
router.put("/:mangaId/:transId", async (req: Request, res: Response) => {
  try {
    const { mangaId, transId } = req.params;
    const user = (req as any).user;
    const updateData = {
      ...req.body,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    // 権限チェック
    const db = admin.firestore();
    const doc = await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .doc(transId)
      .get();
    if (!doc.exists) {
      return res.status(404).json({ error: "翻訳データが見つかりません" });
    }

    const translationData = doc.data();
    if (translationData?.createdBy !== user.uid) {
      return res.status(403).json({ error: "更新権限がありません" });
    }

    await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .doc(transId)
      .update(updateData);

    return res.json({ message: "翻訳データが更新されました" });
  } catch (error) {
    console.error("翻訳データ更新エラー:", error);
    return res.status(500).json({ error: "翻訳データの更新に失敗しました" });
  }
});

// 翻訳データ削除
router.delete("/:mangaId/:transId", async (req: Request, res: Response) => {
  try {
    const { mangaId, transId } = req.params;
    const user = (req as any).user;

    // 権限チェック
    const db = admin.firestore();
    const doc = await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .doc(transId)
      .get();
    if (!doc.exists) {
      return res.status(404).json({ error: "翻訳データが見つかりません" });
    }

    const translationData = doc.data();
    if (translationData?.createdBy !== user.uid) {
      return res.status(403).json({ error: "削除権限がありません" });
    }

    await db
      .collection("manga")
      .doc(mangaId)
      .collection("translations")
      .doc(transId)
      .delete();

    return res.json({ message: "翻訳データが削除されました" });
  } catch (error) {
    console.error("翻訳データ削除エラー:", error);
    return res.status(500).json({ error: "翻訳データの削除に失敗しました" });
  }
});

// テキスト翻訳（Google Translate API使用）
router.post("/translate/text", async (req: Request, res: Response) => {
  try {
    const { text, targetLang = "en" } = req.body;

    if (!text) {
      return res.status(400).json({ error: "翻訳するテキストが必要です" });
    }

    // Google Translate API呼び出し（実際のAPIキーは環境変数で管理）
    const response = await axios.post(
      `https://translation.googleapis.com/language/translate/v2?key=${process.env.GOOGLE_TRANSLATE_API_KEY}`,
      {
        q: text,
        target: targetLang,
        source: "ja", // 日本語から翻訳
      }
    );

    const translatedText = response.data.data.translations[0].translatedText;

    return res.json({
      originalText: text,
      translatedText,
      targetLang,
    });
  } catch (error) {
    console.error("テキスト翻訳エラー:", error);
    return res.status(500).json({ error: "テキストの翻訳に失敗しました" });
  }
});

export { router as translationRoutes };
