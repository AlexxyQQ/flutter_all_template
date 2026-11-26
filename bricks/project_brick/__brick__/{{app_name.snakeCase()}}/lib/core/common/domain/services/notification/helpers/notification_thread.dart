/// Some backends prefix conversation/thread ids with `th_` in push payloads
/// but not elsewhere. Normalising both sides lets the app compare the thread
/// currently on screen with the thread of an incoming push (to suppress
/// notifications for the conversation the user is already looking at).
const String threadIdPrefix = 'th_';

/// Payload key carrying the thread id.
const String threadIdPayloadKey = 'thread_id';

/// Returns [threadId] without the optional [threadIdPrefix].
String normalizeThreadId(String threadId) => threadId.startsWith(threadIdPrefix)
    ? threadId.substring(threadIdPrefix.length)
    : threadId;
