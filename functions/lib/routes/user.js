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
exports.userRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
exports.userRoutes = router;
// 読書履歴取得
router.get("/history", async (req, res) => {
    try {
        const user = req.user;
        const db = admin.firestore();
        const snapshot = await db
            .collection("users")
            .doc(user.uid)
            .collection("history")
            .get();
        const history = snapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json(history);
    }
    catch (error) {
        console.error("履歴取得エラー:", error);
        res.status(500).json({ error: "履歴の取得に失敗しました" });
    }
});
// 履歴保存
router.post("/history", async (req, res) => {
    try {
        const user = req.user;
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
    }
    catch (error) {
        console.error("履歴保存エラー:", error);
        res.status(500).json({ error: "履歴の保存に失敗しました" });
    }
});
// お気に入り一覧取得
router.get("/favorites", async (req, res) => {
    try {
        const user = req.user;
        const db = admin.firestore();
        const snapshot = await db
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .get();
        const favorites = snapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json(favorites);
    }
    catch (error) {
        console.error("お気に入り取得エラー:", error);
        res.status(500).json({ error: "お気に入りの取得に失敗しました" });
    }
});
// お気に入り追加
router.post("/favorites/:mangaId", async (req, res) => {
    try {
        const user = req.user;
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
    }
    catch (error) {
        console.error("お気に入り追加エラー:", error);
        res.status(500).json({ error: "お気に入りの追加に失敗しました" });
    }
});
// お気に入り削除
router.delete("/favorites/:mangaId", async (req, res) => {
    try {
        const user = req.user;
        const { mangaId } = req.params;
        const db = admin.firestore();
        await db
            .collection("users")
            .doc(user.uid)
            .collection("favorites")
            .doc(mangaId)
            .delete();
        res.json({ message: "お気に入りから削除されました" });
    }
    catch (error) {
        console.error("お気に入り削除エラー:", error);
        res.status(500).json({ error: "お気に入りの削除に失敗しました" });
    }
});
//# sourceMappingURL=user.js.map