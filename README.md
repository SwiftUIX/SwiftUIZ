> [!IMPORTANT]
> This package is presently in its alpha stage of development. 
>
> Please contact @vmanot directly for any queries.

# SwiftUIZ
Ambitious additions to SwiftUI. Work-in-progress, public API surface is production-ready.

## Features

### PreviewCatalogGroup
Instantly create a simple List Navigation UI in any Mac app for multiple views without managing the NavigationView.

<img width="890" alt="Screenshot 2024-06-12 at 10 17 10 AM" src="https://github.com/SwiftUIX/SwiftUIZ/assets/1157147/0aeae7e8-2f47-4d0e-a41a-6c36745fd717"><br />

Simply `import SwiftUIZ` and add `PreviewCatalogGroup()` to your main `App` file: 
```swift
import SwiftUIZ

@main
struct MyProjectApp: App {
    var body: some Scene {
         // replace the WidowsGroup code with PreviewCatalogGroup()
         // WindowGroup {
         //     ContentView()
         // }
        PreviewCatalogGroup()
    }
}
```

Now just add the `@RuntimeDiscoverable` property wrapper to any view with a `ViewPreview` (instead of `View`) conformance:

```swift
import SwiftUIZ

@RuntimeDiscoverable // property wrapper
struct MyView1: ViewPreview { // conforms to ViewPreview instead of View
    // Optional - set custom title
    // Name of the view (e.g. MyView1) is default
    static var title: String {
        "Custom Title for My View 1"
    }
    
    var body: some View {
        Text("My View 1")
    }
}

@RuntimeDiscoverable
struct MyView2: ViewPreview {
    var body: some View {
        Text("My View 2")
    }
}

@RuntimeDiscoverable
struct MyView3: ViewPreview {
    var body: some View {
        Text("My View 3")
    }
}
```

# Acknowledgments

This library wouldn't be possible without these incredible OSS projects that I'm building upon.

<details>
<summary>MarkdownUI by @gonzalezreal</summary>

- **Link**: (swift-markdown-ui)[https://github.com/gonzalezreal/swift-markdown-ui]
- **License**: [MIT License](https://github.com/gonzalezreal/swift-markdown-ui/blob/main/LICENSE)
- **Authors**: @gonzalezreal
- **Notes**: 
  - `BlockSequence` no longer uses a `VStack`, allowing for lazy loading of large Markdown content via `LazyVStack { ... }`.
  - Integration of SwiftUIX for advanced view caching and Nuke for efficient remote image loading.
  - The result builder DSL has been removed.

</details>

<details>
<summary>SwiftUI-Macros by @Wouter01</summary>

- **Link**: [SwiftUI-Macros-ui](https://github.com/Wouter01/SwiftUI-Macros)
- **License**: [MIT License](https://github.com/Wouter01/SwiftUI-Macros/blob/main/LICENSE)
- **Authors**: @Wouter01
- **Notes**:
  - `EnvironmentValues`, `EnvironmentKey`, `EnvironmentStorage` and `EnvironmentValues` are used.
  - Rather than add `Wouter01`'s (fantastic!) library to **SwiftUIZ** as a dependency, I chose to inline it for a couple of reasons:
    - `swift-syntax` does not have a stable API surface as of writing this, resulting in irreconcilable conflicts during dependency resolution.
    - SwiftPM is slow as f*** at package resolution, I'm going to avoid adding any dependencies for 1-3 file packages.
    - The implementation is going to fork ways and leverage `SwiftSyntaxUtilities` from [Swallow](http://github.com/vmanot/Swallow) to make it even more concise.
 
</details>
