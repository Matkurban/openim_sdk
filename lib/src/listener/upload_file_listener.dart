/// 日志文件上传进度监听器。
///
/// Log file upload progress listener.
class OnUploadLogsListener {
  /// 日志上传进度回调 / Callback invoked with uploaded and total byte counts.
  void Function(int current, int size)? onUploadProgress;

  /// 创建日志上传监听器。
  ///
  /// Creates an [OnUploadLogsListener].
  ///
  /// - [onUploadProgress] 上传进度回调 / Upload progress callback.
  OnUploadLogsListener({this.onUploadProgress});

  /// 触发日志上传进度回调 / Dispatches [onUploadProgress].
  ///
  /// - [current] 当前已上传字节数 / Bytes uploaded so far.
  /// - [size] 文件总字节数 / Total file size in bytes.
  void onProgress(int current, int size) {
    onUploadProgress?.call(current, size);
  }
}

/// 分片文件上传全生命周期事件监听器。
///
/// Full lifecycle event listener for multipart file uploads.
class OnUploadFileListener {
  /// 创建文件上传事件监听器。
  ///
  /// Creates an [OnUploadFileListener] with optional upload lifecycle callbacks.
  ///
  /// - [onComplete] 上传完成回调 / Upload completed callback.
  /// - [onHashPartComplete] 全部切片哈希完成回调 / All part hashes completed callback.
  /// - [onHashPartProgress] 单片哈希进度回调 / Per-part hash progress callback.
  /// - [onOpen] 打开文件回调 / File opened callback.
  /// - [onPartSize] 分片规划回调 / Part size & count callback.
  /// - [onUploadID] 服务端分配 uploadID 回调 / Server-assigned uploadID callback.
  /// - [onUploadPartComplete] 单个分片上传完成回调 / Single part uploaded callback.
  /// - [onUploadProgress] 实时上传进度回调 / Realtime upload progress callback.
  OnUploadFileListener({
    this.onComplete,
    this.onHashPartComplete,
    this.onHashPartProgress,
    this.onOpen,
    this.onPartSize,
    this.onUploadID,
    this.onUploadPartComplete,
    this.onUploadProgress,
  });

  /// 文件上传完成回调 / Callback invoked when upload completes.
  Function(String id, int size, String url, int type)? onComplete;

  /// 所有分片哈希计算完成回调 / Callback invoked when all part hashes complete.
  Function(String id, String partHash, String fileHash)? onHashPartComplete;

  /// 单个分片哈希计算进度回调 / Callback invoked for each hashed part.
  Function(String id, int index, int size, String partHash)? onHashPartProgress;

  /// 文件打开回调 / Callback invoked when file size is determined.
  Function(String id, int size)? onOpen;

  /// 分片大小与数量确定回调 / Callback invoked when part size and count are resolved.
  Function(String id, int partSize, int num)? onPartSize;

  /// 上传进度回调 / Callback invoked on upload progress updates.
  Function(String id, int fileSize, int streamSize, int storageSize)? onUploadProgress;

  /// 服务端上传任务 ID 下发回调 / Callback invoked when upload ID is assigned.
  Function(String id, String uploadID)? onUploadID;

  /// 单个分片上传完成回调 / Callback invoked when a part finishes uploading.
  Function(String id, int index, int partSize, String partHash)? onUploadPartComplete;

  /// 触发上传完成回调 / Dispatches [onComplete].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [size] 文件总大小（字节） / Total file size in bytes.
  /// - [url] 文件访问 URL / Uploaded file access URL.
  /// - [type] 存储类型 / Storage type code.
  void complete(String id, int size, String url, int type) {
    onComplete?.call(id, size, url, type);
  }

  /// 触发全部切片哈希完成回调 / Dispatches [onHashPartComplete].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [partHash] 分片组合哈希 / Combined parts hash.
  /// - [fileHash] 整体文件哈希 / Full file hash.
  void hashPartComplete(String id, String partHash, String fileHash) {
    onHashPartComplete?.call(id, partHash, fileHash);
  }

  /// 触发单片哈希进度回调 / Dispatches [onHashPartProgress].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [index] 分片序号 / Part index.
  /// - [size] 分片字节数 / Part size in bytes.
  /// - [partHash] 该分片哈希值 / Part hash string.
  void hashPartProgress(String id, int index, int size, String partHash) {
    onHashPartProgress?.call(id, index, size, partHash);
  }

  /// 触发文件打开回调 / Dispatches [onOpen].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [size] 文件总大小（字节） / Total file size in bytes.
  void open(String id, int size) {
    onOpen?.call(id, size);
  }

  /// 触发分片规划回调 / Dispatches [onPartSize].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [partSize] 单个分片大小（字节） / Part size in bytes.
  /// - [num] 分片总数 / Total number of parts.
  void partSize(String id, int partSize, int num) {
    onPartSize?.call(id, partSize, num);
  }

  /// 触发上传进度回调 / Dispatches [onUploadProgress].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [fileSize] 文件总大小（字节） / Total file size in bytes.
  /// - [streamSize] 已传输字节数 / Streamed byte count.
  /// - [storageSize] 已确认落盘字节数 / Persisted byte count.
  void uploadProgress(String id, int fileSize, int streamSize, int storageSize) {
    onUploadProgress?.call(id, fileSize, streamSize, storageSize);
  }

  /// 触发上传任务 ID 回调 / Dispatches [onUploadID].
  ///
  /// - [id] 本地上传任务 ID / Local upload task ID.
  /// - [uploadID] 服务端分配的分片上传 ID / Server-assigned multipart upload ID.
  void uploadID(String id, String uploadID) {
    onUploadID?.call(id, uploadID);
  }

  /// 触发单个分片上传完成回调 / Dispatches [onUploadPartComplete].
  ///
  /// - [id] 上传任务标识 ID / Upload task ID.
  /// - [index] 分片序号 / Part index.
  /// - [partSize] 分片大小（字节） / Part size in bytes.
  /// - [partHash] 分片哈希值 / Part hash string.
  void uploadPartComplete(String id, int index, int partSize, String partHash) {
    onUploadPartComplete?.call(id, index, partSize, partHash);
  }
}
