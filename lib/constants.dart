/// http request 等待時間
const kHttpRequestTimeout = Duration(seconds: 100);

/// http request 較短的等待時間, 可用於預期較快速且不想卡住 user 的 request
const kHttpRequestTimeoutShort = Duration(seconds: 10);

/// http ping 的間隔時間
const kHttpPingDuration = Duration(milliseconds: 100);

/// http download 的間隔時間
const kHttpPingDownload = Duration(seconds: 10);
