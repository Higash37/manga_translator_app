import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { Express, Request, Response } from "express";
import { mangaRoutes } from "./routes/manga";
import { authRoutes } from "./routes/auth";
import { translationRoutes } from "./routes/translation";
import { userRoutes } from "./routes/user";
import { fileRoutes } from "./routes/file";
import { quizRoutes } from "./routes/quiz";
import { setupMiddleware } from "./middleware";

// Firebase Admin初期化
if (admin.apps.length === 0) {
  admin.initializeApp();
}

// Express アプリケーション作成
const app: Express = setupMiddleware();

// ルート設定
app.use("/api/manga", mangaRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/translation", translationRoutes);
app.use("/api/user", userRoutes);
app.use("/api/file", fileRoutes);
app.use("/api/quizzes", quizRoutes);

// ヘルスチェック
app.get("/api/health", (req: Request, res: Response) => {
  res.json({ status: "OK", timestamp: new Date().toISOString() });
});

// Cloud Functionsとしてエクスポート
export const api = functions.https.onRequest(app);
