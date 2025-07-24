import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";

const router = Router();

// 漫画一覧取得
router.get("/", async (req: Request, res: Response) => {
  try {
    const db = admin.firestore();
    const comicsSnapshot = await db.collection("comics").get();

    const comics = comicsSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json({
      success: true,
      data: comics,
      count: comics.length,
    });
  } catch (error) {
    console.error("漫画一覧取得エラー:", error);
    res.status(500).json({
      success: false,
      error: "漫画一覧の取得に失敗しました",
    });
  }
});

// 漫画詳細取得
router.get("/:comicId", async (req: Request, res: Response) => {
  try {
    const { comicId } = req.params;
    const db = admin.firestore();
    const comicDoc = await db.collection("comics").doc(comicId).get();

    if (!comicDoc.exists) {
      return res.status(404).json({
        success: false,
        error: "漫画が見つかりません",
      });
    }

    return res.json({
      success: true,
      data: {
        id: comicDoc.id,
        ...comicDoc.data(),
      },
    });
  } catch (error) {
    console.error("漫画詳細取得エラー:", error);
    return res.status(500).json({
      success: false,
      error: "漫画詳細の取得に失敗しました",
    });
  }
});

// 話一覧取得
router.get("/:comicId/episodes", async (req: Request, res: Response) => {
  try {
    const { comicId } = req.params;
    const db = admin.firestore();
    const episodesSnapshot = await db
      .collection("comics")
      .doc(comicId)
      .collection("episodes")
      .orderBy("episodeId")
      .get();

    const episodes = episodesSnapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
    }));

    res.json({
      success: true,
      data: episodes,
      count: episodes.length,
    });
  } catch (error) {
    console.error("話一覧取得エラー:", error);
    res.status(500).json({
      success: false,
      error: "話一覧の取得に失敗しました",
    });
  }
});

// ページ一覧取得
router.get(
  "/:comicId/episodes/:episodeId/pages",
  async (req: Request, res: Response) => {
    try {
      const { comicId, episodeId } = req.params;
      const db = admin.firestore();
      const pagesSnapshot = await db
        .collection("comics")
        .doc(comicId)
        .collection("episodes")
        .doc(episodeId)
        .collection("pages")
        .orderBy("pageId")
        .get();

      const pages = pagesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));

      res.json({
        success: true,
        data: pages,
        count: pages.length,
      });
    } catch (error) {
      console.error("ページ一覧取得エラー:", error);
      res.status(500).json({
        success: false,
        error: "ページ一覧の取得に失敗しました",
      });
    }
  }
);

// 吹き出しへの翻訳案追加
router.post(
  "/bubble/:bubbleId/translation",
  async (req: Request, res: Response) => {
    try {
      const { bubbleId } = req.params;
      const [comicId, episodeId, pageId, bubbleIndexStr] = bubbleId.split("/");
      const bubbleIndex = parseInt(bubbleIndexStr, 10);
      const { lang, text, comment } = req.body;
      const db = admin.firestore();
      const pageRef = db
        .collection("comics")
        .doc(comicId)
        .collection("episodes")
        .doc(episodeId)
        .collection("pages")
        .doc(pageId);
      const pageDoc = await pageRef.get();
      if (!pageDoc.exists)
        return res.status(404).json({ error: "page not found" });
      const pageData = pageDoc.data();
      if (!pageData)
        return res.status(404).json({ error: "page data not found" });
      if (!pageData.bubbles || !pageData.bubbles[bubbleIndex])
        return res.status(404).json({ error: "bubble not found" });
      if (!pageData.bubbles[bubbleIndex].translations)
        pageData.bubbles[bubbleIndex].translations = [];
      pageData.bubbles[bubbleIndex].translations.push({
        userId: (req as any).user?.uid || "anonymous",
        lang,
        text,
        comment,
      });
      await pageRef.update({ bubbles: pageData.bubbles });
      return res.json({ success: true });
    } catch (error) {
      return res.status(500).json({ error: "翻訳案追加に失敗" });
    }
  }
);

// 吹き出しへのレビュー追加
router.post("/bubble/:bubbleId/review", async (req: Request, res: Response) => {
  try {
    const { bubbleId } = req.params;
    const [comicId, episodeId, pageId, bubbleIndexStr] = bubbleId.split("/");
    const bubbleIndex = parseInt(bubbleIndexStr, 10);
    const { score, comment } = req.body;
    const db = admin.firestore();
    const pageRef = db
      .collection("comics")
      .doc(comicId)
      .collection("episodes")
      .doc(episodeId)
      .collection("pages")
      .doc(pageId);
    const pageDoc = await pageRef.get();
    if (!pageDoc.exists)
      return res.status(404).json({ error: "page not found" });
    const pageData = pageDoc.data();
    if (!pageData)
      return res.status(404).json({ error: "page data not found" });
    if (!pageData.bubbles || !pageData.bubbles[bubbleIndex])
      return res.status(404).json({ error: "bubble not found" });
    if (!pageData.bubbles[bubbleIndex].reviews)
      pageData.bubbles[bubbleIndex].reviews = [];
    pageData.bubbles[bubbleIndex].reviews.push({
      userId: (req as any).user?.uid || "anonymous",
      score,
      comment,
    });
    await pageRef.update({ bubbles: pageData.bubbles });
    return res.json({ success: true });
  } catch (error) {
    return res.status(500).json({ error: "レビュー追加に失敗" });
  }
});

// 文字列のハッシュコード生成（bubble一意化用）

export { router as mangaRoutes };
