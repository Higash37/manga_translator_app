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
exports.fileRoutes = void 0;
const express_1 = require("express");
const admin = __importStar(require("firebase-admin"));
const multer_1 = __importDefault(require("multer"));
const router = (0, express_1.Router)();
exports.fileRoutes = router;
// Multer設定（メモリ上でファイル処理）
const upload = (0, multer_1.default)({
    storage: multer_1.default.memoryStorage(),
    limits: {
        fileSize: 10 * 1024 * 1024, // 10MB制限
    },
    fileFilter: (req, file, cb) => {
        // 画像ファイルのみ許可
        if (file.mimetype.startsWith("image/")) {
            cb(null, true);
        }
        else {
            cb(new Error("画像ファイルのみアップロード可能です"));
        }
    },
});
// 画像アップロード
router.post("/upload/image", upload.single("image"), async (req, res) => {
    try {
        const user = req.user;
        const file = req.file;
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
    }
    catch (error) {
        console.error("画像アップロードエラー:", error);
        return res
            .status(500)
            .json({ error: "画像のアップロードに失敗しました" });
    }
});
// ファイル削除
router.delete("/:filename", async (req, res) => {
    try {
        const user = req.user;
        const { filename } = req.params;
        // ユーザーのファイルかチェック
        if (!filename.startsWith(`images/${user.uid}/`)) {
            return res.status(403).json({ error: "削除権限がありません" });
        }
        const bucket = admin.storage().bucket();
        await bucket.file(filename).delete();
        return res.json({ message: "ファイルが削除されました" });
    }
    catch (error) {
        console.error("ファイル削除エラー:", error);
        return res.status(500).json({ error: "ファイルの削除に失敗しました" });
    }
});
// ファイル一覧取得
router.get("/list", async (req, res) => {
    try {
        const user = req.user;
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
    }
    catch (error) {
        console.error("ファイル一覧取得エラー:", error);
        res.status(500).json({ error: "ファイル一覧の取得に失敗しました" });
    }
});
//# sourceMappingURL=file.js.map