import express, { Express, Request, Response, NextFunction } from "express";
import cors from "cors";
// import * as admin from "firebase-admin";
import * as admin from "firebase-admin";

export function setupMiddleware(): Express {
  const app = express();

  // CORS設定
  app.use(cors({ origin: true }));

  // JSONパーサー
  app.use(express.json({ limit: "10mb" }));
  app.use(express.urlencoded({ extended: true }));

  // 認証ミドルウェア
  app.use(authenticateUser);

  return app;
}

// 認証ミドルウェア
async function authenticateUser(
  req: Request,
  res: Response,
  next: NextFunction
) {
  // ヘルスチェックは認証不要
  if (req.path === "/api/health") {
    return next();
  }

  // 開発中は認証を一時的に無効化
  if (process.env.NODE_ENV === "development") {
    // ダミーユーザーを設定
    (req as any).user = {
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
    (req as any).user = decodedToken;
    next();
  } catch (error) {
    console.error("認証エラー:", error);
    return res.status(401).json({ error: "無効なトークンです" });
  }
}
