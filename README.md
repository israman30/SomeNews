# SomeNews

[![Build](https://github.com/israman30/SomeNews/actions/workflows/build.yml/badge.svg)](https://github.com/israman30/SomeNews/actions/workflows/build.yml)

#### Some news is a News application that uses a public API of news [newsapi.org](https://newsapi.org/)

Description of the project:
- Public API (hidden and unique)
- Using ```SwiftUI``` to layout the UI
- ```MVVM``` as Architecture structure
- Network layer for implementing the API
    - ```async/await```
    - SOLID principles

    ```swift
    final class NetworkServices: NetworkServicesProtocol { ... }
    ```
- ```protocols``` and ```delegate``` as blueprint of Network implementation
    ```swift
    protocol NetworkServicesProtocol {
        func fetchArticles() async throws -> [Articles]
    }
    ```
- Dependency Injection to submit data into the ```View```
    - Intializer injection ```init() { ... }```
- Error handling for different cases
    ```swift
    enum APIError: Error {
        case wrongURLAddress
        case errorResponse
        case errorGettingDataFromNetworkLayer(_ message: String)
        case failDecodingArticles(_ localized: String)
    }
    ```
- Persisting data locally after fetching from network native implemented using ```Core Data```
    - Saving data
    ```swift
    private func saveData(context: NSManagedObjectContext) { ... }
    ```
    - Fetching data
    ```swift
    @FetchRequest(entity: Article.entity(), sortDescriptors: []) var results: FetchedResults<Article>
    ```
- ``` Unit Testing``` for API 
    - Test on ```response```
    - Test on ```data```
    - Test on ```error```
    - Test on Mocking data

Build:
A <strong>CI</strong> build for PRs and main controbution 


_<sub>Created by Israel Manzo &copy;</sub>_