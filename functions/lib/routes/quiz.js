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
exports.quizRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
exports.quizRoutes = router;
// クイズ一覧取得
router.get("/", async (req, res) => {
    try {
        const { comicId, episodeId } = req.query;
        const db = admin.firestore();
        let query = db.collection("quizzes");
        if (comicId) {
            query = query.where("comicId", "==", comicId);
        }
        if (episodeId) {
            query = query.where("episodeId", "==", episodeId);
        }
        const quizzesSnapshot = await query.get();
        const quizzes = quizzesSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json({
            success: true,
            data: quizzes,
            count: quizzes.length,
        });
    }
    catch (error) {
        console.error("クイズ一覧取得エラー:", error);
        res.status(500).json({
            success: false,
            error: "クイズ一覧の取得に失敗しました",
        });
    }
});
// クイズ結果送信
router.post("/results", async (req, res) => {
    try {
        const user = req.user;
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
    }
    catch (error) {
        console.error("クイズ結果送信エラー:", error);
        res.status(500).json({
            success: false,
            error: "クイズ結果の送信に失敗しました",
        });
    }
});
// ユーザーのクイズ結果取得
router.get("/results", async (req, res) => {
    try {
        const user = req.user;
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
        const results = resultsSnapshot.docs.map((doc) => (Object.assign({ id: doc.id }, doc.data())));
        res.json({
            success: true,
            data: results,
            count: results.length,
        });
    }
    catch (error) {
        console.error("クイズ結果取得エラー:", error);
        res.status(500).json({
            success: false,
            error: "クイズ結果の取得に失敗しました",
        });
    }
});
//# sourceMappingURL=quiz.js.map