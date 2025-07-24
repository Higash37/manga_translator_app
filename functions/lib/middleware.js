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
exports.setupMiddleware = void 0;
const express_1 = __importDefault(require("express"));
const cors_1 = __importDefault(require("cors"));
// import * as admin from "firebase-admin";
const admin = __importStar(require("firebase-admin"));
function setupMiddleware() {
    const app = (0, express_1.default)();
    // CORS設定
    app.use((0, cors_1.default)({ origin: true }));
    // JSONパーサー
    app.use(express_1.default.json({ limit: "10mb" }));
    app.use(express_1.default.urlencoded({ extended: true }));
    // 認証ミドルウェア
    app.use(authenticateUser);
    return app;
}
exports.setupMiddleware = setupMiddleware;
// 認証ミドルウェア
async function authenticateUser(req, res, next) {
    // ヘルスチェックは認証不要
    if (req.path === "/api/health") {
        return next();
    }
    // 開発中は認証を一時的に無効化
    if (process.env.NODE_ENV === "development") {
        // ダミーユーザーを設定
        req.user = {
            uid: "dev_user_123",
            email: "dev@example.com",
        };
        return next();
    }
    const authHeader = req.headers.authorization;
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(401).json({ error: "認証が必要です" });
    }
    const token = authHeader.split("Bearer ")[1];
    try {
        const decodedToken = await admin.auth().verifyIdToken(token);
        req.user = decodedToken;
        next();
    }
    catch (error) {
        console.error("認証エラー:", error);
        return res.status(401).json({ error: "無効なトークンです" });
    }
}
//# sourceMappingURL=middleware.js.map