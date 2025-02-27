# flutter_starter_clean_bloc

## About

This project is a Flutter starter template implementing **Clean Architecture** with **BLoC** (Business Logic Component) pattern for state management. It demonstrates scalable structure for building Flutter applications with **up-to-date** 3rd package. Api intergrate with mock backend running with **json_server**.

## Process

- [x] Complete json server + test file
- [x] Implements app: theme, colors, flavor, locale, logs
- [x] Implements prototype ui: simple Display UI, routes
- [x] Complete prototype test
- [x] Complete prototype feature
- [x] Fixing test
- [x] Complete all feature
- [x] Complete all test (not adapt ui yet)
- [-] Complete ui
- [ ] Complete all test

## Packages Used

go_router, flutter_bloc, shared_preferences, flutter_secure_storage, get_it, dio, equatable, dartz, logger, cached_network_image, internet_connection_checker_plus, path_provider, google_fonts

| Package                            | Description                                                                                                                                         |
| ---------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| `go_router`                        | Declarative routing for Flutter.                                                                                                                    |
| `flutter_bloc`                     | State management library built on top of `Stream`s and `Sink`s.                                                                                     |
| `shared_preferences`               | Persistent key-value storage for simple data (e.g., user preferences).                                                                              |
| `flutter_secure_storage`           | Secure storage for sensitive data (e.g., API tokens, user secrets).                                                                                 |
| `get_it`                           | Service locator for dependency injection.                                                                                                           |
| `dio`                              | Powerful HTTP client for making network requests.                                                                                                   |
| `google_fonts`                     | Provide Google Fonts using in this app.                                                                                                             |
| `equatable`                        | Simplifies value equality comparisons for classes.                                                                                                  |
| `dartz`                            | Functional programming library providing features like `Either` for error handling.                                                                 |
| `logger`                           | Logging library for debugging and monitoring application behavior.                                                                                  |
| `cached_network_image`             | Library for efficiently caching and displaying images from the network.                                                                             |
| `internet_connection_checker_plus` | Checks for internet connectivity.                                                                                                                   |
| `path_provider`                    | Provides access to commonly used file system locations (documents directory, etc.). _(Note: `path_provider` versions < 2.1.5 did not support web.)_ |
| `mocktail` (dev dependency)        | Mocking library for unit and widget testing.                                                                                                        |
| `bloc_test` (dev dependency)       | Utilities for testing BLoCs.                                                                                                                        |
| `flutter_lorem` (dev dependency)   | Library for generating lorem ipsum placeholder text for UI development.                                                                             |
| `device_preview` (dev dependency)  | Library for help mock device size for develop ui                                                                                                    |

## Setup

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/vemines/flutter_starter_clean_bloc
    cd flutter_starter_clean_bloc
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Run json-server**

    ```bash
    cd json-server
    npm run gen
    npm run dev     or npm start
    ```

4.  **Run the application (choose your flavor):**

        - **Development:**
          flutter run lib/main_development.dart

        - **Staging:**
          flutter run lib/main_staging.dart

        - **Production:**
          `flutter run lib/main_production.dart

    Different`main*\*` files are used for different build configurations [flavors](lib/configs/flavor_config.dart).

## App Structure

The project follows a Clean Architecture structure, separating concerns into layers:

- **`app`:** Contains core application-level components.

  - `cubits`: Global `Cubit`s for theme, locale, and logging.
  - `colors.dart`: Defines application colors.
  - `flavor.dart`: Handles environment-specific configurations (development, staging, production).
  - `locale.dart`: Manages localization and internationalization (translations).
  - `logs.dart`: Provides a logging service for debugging and error tracking.
  - `routes.dart`: Defines application routes using `go_router`.
  - `theme.dart`: Defines application themes (light, dark, custom).

- **`configs`:** Configuration files.

  - `app_config.dart`: General app constants.
  - `flavor_config.dart`: Configuration for different build environments.
  - `locale_config.dart`: Supported locales.

- **`core`:** Reusable components and utilities.

  - `constants`: Constants used throughout the application (API endpoints, error messages, etc.).
  - `errors`: Custom exception and failure classes.
  - `extensions`: Extension methods for added functionality (e.g., `ColorExt` for opacity, `DoubleWidgetExt` for SizedBox shortcuts).
  - `network`: Network-related classes (e.g., `NetworkInfo` for connectivity checks).
  - `pages`: General-purpose pages (e.g., `NotFoundPage`).
  - `usecase`: Base `UseCase` class and common parameter classes (e.g., `NoParams`, `PaginationParams`).
  - `utils`: Utility functions (e.g., `num_utils.dart`, `string_utils.dart`).
  - `widgets`: Reusable widgets (e.g., `CachedImage`).

- **`features`:** Contains the application's features, each organized into its own directory (e.g., `auth`, `post`, `user`, `comment`).

  - `data`:
    - `datasources`: Handles data retrieval and storage (local and remote).
    - `models`: Data models that extend the domain entities and include methods for serialization/deserialization (e.g., `fromJson`, `toJson`, `fromEntity`, `copyWith`).
    - `repositories`: Implementation of the repository interfaces, handling data access logic.
  - `domain`:
    - `entities`: Business objects representing core concepts (e.g., `Auth`, `User`, `Post`, `Comment`).
    - `repositories`: Abstract interfaces defining how data should be accessed.
    - `usecases`: Specific business logic operations (e.g., `LoginUseCase`, `GetAllPostsUseCase`).
  - `presentation`:
    - `bloc`: BLoCs that manage the state of the feature's UI.
    - `pages`: UI screens for the feature.
    - `widgets`: UI widgets specific to the feature.

- **`injection_container.dart`:** Sets up dependency injection using `get_it`.

- **`main_*.dart`:** Entry points for different build configurations (development, staging, production).

### Flavors

The project uses flavors to manage different build configurations. This allows you to have different settings (e.g., API endpoints, request Timeout) for development, staging, and production environments. The `FlavorService` and `FlavorConfig` classes handle this.

```dart
// Usage:
FlavorService.instance.config.nameConfig
```

## Localization

The project supports internationalization. Language files are stored in `assets/lang/` (or the renamed `app_assets/lang` if you are building for the web) as JSON files (e.g., `en.json`, `vi.json`). The `AppLocalizations` class handles loading and translating strings.

```dart
// Usage:
Text(context.tr(I18nKeys.greeting, {'name': 'Flutter Dev'}))
```

## Logging

The `LogService` class provides logging functionality, writing logs to both the console and a file (except on the web, where it only logs to the console).

```dart
// Usage:
final logService = await LogService.instance();
logService.d("Debug message");
logService.i("Info message");
logService.w("Warning message");
logService.e("Error message", error: exception, stackTrace: stackTrace);
```

## Testing

The `test` folder contains unit and integration tests for the data and domain layers of each feature. It uses `mocktail` for mocking dependencies and `bloc_test` for testing BLoCs. The tests cover:

- **Data Sources:** Testing interactions with `shared_preferences`, `flutter_secure_storage`, and `dio`.
- **Repositories:** Testing data retrieval, caching, and error handling.
- **Use Cases:** Testing business logic.
- **BLoCs:** Testing state changes in response to events.

To run the tests:

```bash
flutter test
```

## Note

**This Code Write with "dart.lineLength": 100 Settings. Sorry if code weird after format files**
