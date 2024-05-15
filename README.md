> [!IMPORTANT]
> This package is presently in its alpha stage of development. 
>
> Please contact @vmanot directly for any queries.

# SwiftUIZ
Ambitious additions to SwiftUI. Work-in-progress, public API surface is production-ready.

# Acknowledgments

This library wouldn't be possible without these incredible OSS projects that I'm building upon.

<details>
<summary>MarkdownUI</summary>

- **Link**: (swift-markdown-ui)[https://github.com/gonzalezreal/swift-markdown-ui]
- **License**: [MIT License](https://github.com/gonzalezreal/swift-markdown-ui/blob/main/LICENSE)
- **Authors**: @gonzalezreal
- **Notes**: 
  - `BlockSequence` no longer uses a `VStack`, allowing for lazy loading of large Markdown content via `LazyVStack { ... }`.
  - Integration of SwiftUIX for advanced view caching and Nuke for efficient remote image loading.
  - The result builder DSL has been removed.

</details>

<details>
<summary>SwiftUI-Macros</summary>

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
