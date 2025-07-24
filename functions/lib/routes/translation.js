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
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.translationRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const axios_1 = __importDefault(require("axios"));
const router = (0, express_1.Router)();
exports.translationRoutes = router;
// 翻訳データ一覧取得
router.get("/:mangaId", async (req, res) => {
    try {
        const { mangaId } = req.params;
        const db = admin.firestore();
        const snapshot = await db
            .collection("manga")
            .doc(mangaId)
            .collection("translations")
            .get();
        const translations = snapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json(translations);
    }
    catch (error) {
        console.error("翻訳データ取得エラー:", error);
        res.status(500).json({ error: "翻訳データの取得に失敗しました" });
    }
});
// 翻訳データ作成
router.post("/:mangaId", async (req, res) => {
    try {
        const { mangaId } = req.params;
        const user = req.user;
        const translationData = Object.assign(Object.assign({}, req.body), { createdBy: user.uid, createdAt: admin.firestore.FieldValue.serverTimestamp(), updatedAt: admin.firestore.FieldValue.serverTimestamp() });
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
    }
    catch (error) {
        console.error("翻訳データ作成エラー:", error);
        res.status(500).json({ error: "翻訳データの作成に失敗しました" });
    }
});
// 翻訳データ更新
router.put("/:mangaId/:transId", async (req, res) => {
    try {
        const { mangaId, transId } = req.params;
        const user = req.user;
        const updateData = Object.assign(Object.assign({}, req.body), { updatedAt: admin.firestore.FieldValue.serverTimestamp() });
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
        if ((translationData === null || translationData === void 0 ? void 0 : translationData.createdBy) !== user.uid) {
            return res.status(403).json({ error: "更新権限がありません" });
        }
        await db
            .collection("manga")
            .doc(mangaId)
            .collection("translations")
            .doc(transId)
            .update(updateData);
        return res.json({ message: "翻訳データが更新されました" });
    }
    catch (error) {
        console.error("翻訳データ更新エラー:", error);
        return res.status(500).json({ error: "翻訳データの更新に失敗しました" });
    }
});
// 翻訳データ削除
router.delete("/:mangaId/:transId", async (req, res) => {
    try {
        const { mangaId, transId } = req.params;
        const user = req.user;
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
        if ((translationData === null || translationData === void 0 ? void 0 : translationData.createdBy) !== user.uid) {
            return res.status(403).json({ error: "削除権限がありません" });
        }
        await db
            .collection("manga")
            .doc(mangaId)
            .collection("translations")
            .doc(transId)
            .delete();
        return res.json({ message: "翻訳データが削除されました" });
    }
    catch (error) {
        console.error("翻訳データ削除エラー:", error);
        return res.status(500).json({ error: "翻訳データの削除に失敗しました" });
    }
});
// テキスト翻訳（Google Translate API使用）
router.post("/translate/text", async (req, res) => {
    try {
        const { text, targetLang = "en" } = req.body;
        if (!text) {
            return res.status(400).json({ error: "翻訳するテキストが必要です" });
        }
        // Google Translate API呼び出し（実際のAPIキーは環境変数で管理）
        const response = await axios_1.default.post(`https://translation.googleapis.com/language/translate/v2?key=${process.env.GOOGLE_TRANSLATE_API_KEY}`, {
            q: text,
            target: targetLang,
            source: "ja", // 日本語から翻訳
        });
        const translatedText = response.data.data.translations[0].translatedText;
        return res.json({
            originalText: text,
            translatedText,
            targetLang,
        });
    }
    catch (error) {
        console.error("テキスト翻訳エラー:", error);
        return res.status(500).json({ error: "テキストの翻訳に失敗しました" });
    }
});
//# sourceMappingURL=translation.js.map