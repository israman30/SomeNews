# SomeNews

[![Build](https://github.com/israman30/SomeNews/actions/workflows/build.yml/badge.svg)](https://github.com/israman30/SomeNews/actions/workflows/build.yml)

SomeNews is a SwiftUI iOS app that displays top headlines from [newsapi.org](https://newsapi.org/).

## Architecture

- **UI**: SwiftUI
- **Pattern**: MVVM
- **Async**: `async/await`
- **State**: a `LoadingState` enum drives the feed UI (`empty` → `loading` → `loaded` / `error`)
- **Navigation**: Coordinator + `NavigationStack` with typed routes (`Pages`)
- **Networking**: `NetworkServicesProtocol` + concrete `NetworkServices`

## Data flow (home feed)

- `HomeFeedView` starts loading with `.task { await vm.getArticles() }`
- `ArticlesViewModel` updates `@Published` `loadingState` on the main actor
- The view reacts to `loadingState` and renders:
  - loading indicator
  - list of articles
  - error + retry

## Navigation (Coordinator)

Navigation is handled by `CoordinatorView` + `Coordinator`:

- `CoordinatorView` hosts a `NavigationStack(path:)`
- `.navigationDestination(for: Pages.self, ...)` is registered **inside** the stack
- `Pages` has stable `Hashable`/`Equatable` conformance so pushing a detail route reliably shows the selected article

## API key setup

This project reads the NewsAPI key from plist files in the app bundle:

- `Some News/Some News/DEV-Key.plist` (Debug)
- `Some News/Some News/PROD-Key.plist` (Release)

Expected key:

- `NEWS_KEY`: your `newsapi.org` API key

## Error handling

The networking layer throws `APIError` for common failures:

```swift
enum APIError: Error {
    case wrongURLAddress
    case errorResponse
    case errorGettingDataFromNetworkLayer(_ message: Error)
    case failDecodingArticles(_ localized: String)
}
```

## CI

GitHub Actions runs a build workflow for PRs and the main branch.

_<sub>Created by Israel Manzo &copy;</sub>_