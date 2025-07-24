import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";

const router = Router();

// 読書履歴取得
router.get("/history", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const db = admin.firestore();
    const snapshot = await db
      .collection("users")
      .doc(user.uid)
      .collection("history")
      .get();

    const history = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(history);
  } catch (error) {
    console.error("履歴取得エラー:", error);
    res.status(500).json({ error: "履歴の取得に失敗しました" });
  }
});

// 履歴保存
router.post("/history", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { mangaId, pageId, progress } = req.body;

    const historyData = {
      mangaId,
      pageId,
      progress,
      readAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(user.uid)
      .collection("history")
      .add(historyData);

    res.status(201).json({ message: "履歴が保存されました" });
  } catch (error) {
    console.error("履歴保存エラー:", error);
    res.status(500).json({ error: "履歴の保存に失敗しました" });
  }
});

// お気に入り一覧取得
router.get("/favorites", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const db = admin.firestore();
    const snapshot = await db
      .collection("users")
      .doc(user.uid)
      .collection("favorites")
      .get();

    const favorites = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json(favorites);
  } catch (error) {
    console.error("お気に入り取得エラー:", error);
    res.status(500).json({ error: "お気に入りの取得に失敗しました" });
  }
});

// お気に入り追加
router.post("/favorites/:mangaId", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { mangaId } = req.params;

    const favoriteData = {
      mangaId,
      addedAt: admin.firestore.FieldValue.serverTimestamp(),
    };

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(user.uid)
      .collection("favorites")
      .doc(mangaId)
      .set(favoriteData);

    res.status(201).json({ message: "お気に入りに追加されました" });
  } catch (error) {
    console.error("お気に入り追加エラー:", error);
    res.status(500).json({ error: "お気に入りの追加に失敗しました" });
  }
});

// お気に入り削除
router.delete("/favorites/:mangaId", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { mangaId } = req.params;

    const db = admin.firestore();
    await db
      .collection("users")
      .doc(user.uid)
      .collection("favorites")
      .doc(mangaId)
      .delete();

    res.json({ message: "お気に入りから削除されました" });
  } catch (error) {
    console.error("お気に入り削除エラー:", error);
    res.status(500).json({ error: "お気に入りの削除に失敗しました" });
  }
});

export { router as userRoutes };
