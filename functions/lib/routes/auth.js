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
exports.authRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const router = (0, express_1.Router)();
exports.authRoutes = router;
// ユーザープロフィール取得
router.get("/profile", async (req, res) => {
    try {
        const user = req.user;
        const userRecord = await admin.auth().getUser(user.uid);
        res.json({
            uid: userRecord.uid,
            email: userRecord.email,
            displayName: userRecord.displayName,
            photoURL: userRecord.photoURL,
            emailVerified: userRecord.emailVerified,
        });
    }
    catch (error) {
        console.error("プロフィール取得エラー:", error);
        res.status(500).json({ error: "プロフィールの取得に失敗しました" });
    }
});
// ユーザープロフィール更新
router.put("/profile", async (req, res) => {
    try {
        const user = req.user;
        const { displayName, photoURL } = req.body;
        await admin.auth().updateUser(user.uid, {
            displayName,
            photoURL,
        });
        res.json({ message: "プロフィールが更新されました" });
    }
    catch (error) {
        console.error("プロフィール更新エラー:", error);
        res.status(500).json({ error: "プロフィールの更新に失敗しました" });
    }
});
//# sourceMappingURL=auth.js.map