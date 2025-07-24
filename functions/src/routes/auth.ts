import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";

const router = Router();

// ユーザープロフィール取得
router.get("/profile", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const userRecord = await admin.auth().getUser(user.uid);

    res.json({
      uid: userRecord.uid,
      email: userRecord.email,
      displayName: userRecord.displayName,
      photoURL: userRecord.photoURL,
      emailVerified: userRecord.emailVerified,
    });
  } catch (error) {
    console.error("プロフィール取得エラー:", error);
    res.status(500).json({ error: "プロフィールの取得に失敗しました" });
  }
});

// ユーザープロフィール更新
router.put("/profile", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { displayName, photoURL } = req.body;

    await admin.auth().updateUser(user.uid, {
      displayName,
      photoURL,
    });

    res.json({ message: "プロフィールが更新されました" });
  } catch (error) {
    console.error("プロフィール更新エラー:", error);
    res.status(500).json({ error: "プロフィールの更新に失敗しました" });
  }
});

export { router as authRoutes };
