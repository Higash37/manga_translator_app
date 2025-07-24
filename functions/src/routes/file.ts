import { Router, Request, Response } from "express";
import * as admin from "firebase-admin";
import multer from "multer";

const router = Router();

// Multer設定（メモリ上でファイル処理）
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 10 * 1024 * 1024, // 10MB制限
  },
  fileFilter: (req, file, cb) => {
    // 画像ファイルのみ許可
    if (file.mimetype.startsWith("image/")) {
      cb(null, true);
    } else {
      cb(new Error("画像ファイルのみアップロード可能です"));
    }
  },
});

// 画像アップロード
router.post(
  "/upload/image",
  upload.single("image"),
  async (req: Request, res: Response) => {
    try {
      const user = (req as any).user;
      const file = (req as any).file;

      if (!file) {
        return res.status(400).json({ error: "画像ファイルが必要です" });
      }

      // ファイル名生成
      const timestamp = Date.now();
      const filename = `images/${user.uid}/${timestamp}_${file.originalname}`;

      // Firebase Storageにアップロード
      const bucket = admin.storage().bucket();
      const fileBuffer = file.buffer;
      const fileUpload = bucket.file(filename);

      await fileUpload.save(fileBuffer, {
        metadata: {
          contentType: file.mimetype,
        },
      });

      // 公開URL取得
      const publicUrl = `https://storage.googleapis.com/${bucket.name}/${filename}`;

      return res.status(201).json({
        filename,
        url: publicUrl,
        message: "画像がアップロードされました",
      });
    } catch (error) {
      console.error("画像アップロードエラー:", error);
      return res
        .status(500)
        .json({ error: "画像のアップロードに失敗しました" });
    }
  }
);

// ファイル削除
router.delete("/:filename", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { filename } = req.params;

    // ユーザーのファイルかチェック
    if (!filename.startsWith(`images/${user.uid}/`)) {
      return res.status(403).json({ error: "削除権限がありません" });
    }

    const bucket = admin.storage().bucket();
    await bucket.file(filename).delete();

    return res.json({ message: "ファイルが削除されました" });
  } catch (error) {
    console.error("ファイル削除エラー:", error);
    return res.status(500).json({ error: "ファイルの削除に失敗しました" });
  }
});

// ファイル一覧取得
router.get("/list", async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const prefix = `images/${user.uid}/`;

    const bucket = admin.storage().bucket();
    const [files] = await bucket.getFiles({ prefix });

    const fileList = files.map((file) => ({
      name: file.name,
      url: `https://storage.googleapis.com/${bucket.name}/${file.name}`,
      size: file.metadata.size,
      contentType: file.metadata.contentType,
      createdAt: file.metadata.timeCreated,
    }));

    res.json(fileList);
  } catch (error) {
    console.error("ファイル一覧取得エラー:", error);
    res.status(500).json({ error: "ファイル一覧の取得に失敗しました" });
  }
});

export { router as fileRoutes };
