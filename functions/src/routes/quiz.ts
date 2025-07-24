import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";

const router = Router();

// クイズ一覧取得
router.get("/", async (req: Request, res: Response) => {
  try {
    const { comicId, episodeId } = req.query;
    const db = admin.firestore();

    let query: FirebaseFirestore.Query = db.collection("quizzes");

    if (comicId) {
      query = query.where("comicId", "==", comicId);
    }

    if (episodeId) {
      query = query.where("episodeId", "==", episodeId);
    }

    const quizzesSnapshot = await query.get();

    const quizzes = quizzesSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json({
      success: true,
      data: quizzes,
      count: quizzes.length,
    });
  } catch (error) {
    console.error("クイズ一覧取得エラー:", error);
    res.status(500).json({
      success: false,
      error: "クイズ一覧の取得に失敗しました",
    });
  }
});

// クイズ結果送信
router.post("/results", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { quizId, selectedIndex, isCorrect, timeSpent } = req.body;

    const db = admin.firestore();
    await db.collection("quizResults").add({
      userId: user.uid,
      quizId,
      selectedIndex,
      isCorrect,
      timeSpent,
      answeredAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.json({
      success: true,
      message: "クイズ結果が保存されました",
    });
  } catch (error) {
    console.error("クイズ結果送信エラー:", error);
    res.status(500).json({
      success: false,
      error: "クイズ結果の送信に失敗しました",
    });
  }
});

// ユーザーのクイズ結果取得
router.get("/results", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { comicId, episodeId } = req.query;
    const db = admin.firestore();

    let query = db.collection("quizResults").where("userId", "==", user.uid);

    if (comicId) {
      query = query.where("comicId", "==", comicId);
    }

    if (episodeId) {
      query = query.where("episodeId", "==", episodeId);
    }

    const resultsSnapshot = await query.get();

    const results = resultsSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json({
      success: true,
      data: results,
      count: results.length,
    });
  } catch (error) {
    console.error("クイズ結果取得エラー:", error);
    res.status(500).json({
      success: false,
      error: "クイズ結果の取得に失敗しました",
    });
  }
});

export { router as quizRoutes };
