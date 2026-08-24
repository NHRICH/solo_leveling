/// Notion integration configuration
///
/// These constants are intentionally public so that app-level configurations
/// can be overridden by the build system using `--dart-define`:
///
/// ```bash
/// flutter run --dart-define=NOTION_API_KEY=your_key_here
/// ```
class NotionConfig {
  static const String apiKey = String.fromEnvironment('NOTION_API_KEY');
  static const String databaseId = String.fromEnvironment('NOTION_DATABASE_ID');
}