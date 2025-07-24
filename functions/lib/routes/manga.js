"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.mangaRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
exports.mangaRoutes = router;
// 漫画一覧取得
router.get("/", async (req, res) => {
    try {
        const db = admin.firestore();
        const comicsSnapshot = await db.collection("comics").get();
        const comics = comicsSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json({
            success: true,
            data: comics,
            count: comics.length,
        });
    }
    catch (error) {
        console.error("漫画一覧取得エラー:", error);
        res.status(500).json({
            success: false,
            error: "漫画一覧の取得に失敗しました",
        });
    }
});
// 漫画詳細取得
router.get("/:comicId", async (req, res) => {
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
            data: Object.assign({ id: comicDoc.id }, comicDoc.data()),
        });
    }
    catch (error) {
        console.error("漫画詳細取得エラー:", error);
        return res.status(500).json({
            success: false,
            error: "漫画詳細の取得に失敗しました",
        });
    }
});
// 話一覧取得
router.get("/:comicId/episodes", async (req, res) => {
    try {
        const { comicId } = req.params;
        const db = admin.firestore();
        const episodesSnapshot = await db
            .collection("comics")
            .doc(comicId)
            .collection("episodes")
            .orderBy("episodeId")
            .get();
        const episodes = episodesSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json({
            success: true,
            data: episodes,
            count: episodes.length,
        });
    }
    catch (error) {
        console.error("話一覧取得エラー:", error);
        res.status(500).json({
            success: false,
            error: "話一覧の取得に失敗しました",
        });
    }
});
// ページ一覧取得
router.get("/:comicId/episodes/:episodeId/pages", async (req, res) => {
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
        const pages = pagesSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json({
            success: true,
            data: pages,
            count: pages.length,
        });
    }
    catch (error) {
        console.error("ページ一覧取得エラー:", error);
        res.status(500).json({
            success: false,
            error: "ページ一覧の取得に失敗しました",
        });
    }
});
// 吹き出しへの翻訳案追加
router.post("/bubble/:bubbleId/translation", async (req, res) => {
    var _a;
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
            userId: ((_a = req.user) === null || _a === void 0 ? void 0 : _a.uid) || "anonymous",
            lang,
            text,
            comment,
        });
        await pageRef.update({ bubbles: pageData.bubbles });
        return res.json({ success: true });
    }
    catch (error) {
        return res.status(500).json({ error: "翻訳案追加に失敗" });
    }
});
// 吹き出しへのレビュー追加
router.post("/bubble/:bubbleId/review", async (req, res) => {
    var _a;
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
            userId: ((_a = req.user) === null || _a === void 0 ? void 0 : _a.uid) || "anonymous",
            score,
            comment,
        });
        await pageRef.update({ bubbles: pageData.bubbles });
        return res.json({ success: true });
    }
    catch (error) {
        return res.status(500).json({ error: "レビュー追加に失敗" });
    }
});
//# sourceMappingURL=manga.js.map