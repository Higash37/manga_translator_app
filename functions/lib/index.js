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
exports.api = void 0;
const functions = __importStar(require("firebase-functions"));
const admin = __importStar(require("firebase-admin"));
const manga_1 = require("./routes/manga");
const auth_1 = require("./routes/auth");
const translation_1 = require("./routes/translation");
const user_1 = require("./routes/user");
const file_1 = require("./routes/file");
const quiz_1 = require("./routes/quiz");
const middleware_1 = require("./middleware");
// Firebase Admin初期化
if (admin.apps.length === 0) {
    admin.initializeApp();
}
// Express アプリケーション作成
const app = (0, middleware_1.setupMiddleware)();
// ルート設定
app.use("/api/manga", manga_1.mangaRoutes);
app.use("/api/auth", auth_1.authRoutes);
app.use("/api/translation", translation_1.translationRoutes);
app.use("/api/user", user_1.userRoutes);
app.use("/api/file", file_1.fileRoutes);
app.use("/api/quizzes", quiz_1.quizRoutes);
// ヘルスチェック
app.get("/api/health", (req, res) => {
    res.json({ status: "OK", timestamp: new Date().toISOString() });
});
// Cloud Functionsとしてエクスポート
exports.api = functions.https.onRequest(app);
//# sourceMappingURL=index.js.map