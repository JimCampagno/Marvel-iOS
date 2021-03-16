# Marvel-iOS

### Demo (video is unlisted).

[![](http://img.youtube.com/vi/mBMzgQygds0/0.jpg)](https://www.youtube.com/watch?v=mBMzgQygds0 "Marvel")

* When looking to run this project, make sure to run `pod install` as the `Pods/` directory is being ignored by the `.gitignore` file.
* The `MarvelInfo.swift` file is also in the `.gitignore` file. I can send you the `MarvelInfo.swift` file or you can create your own and plug in your own keys. This is how I structured that file:

```swift
struct MarvelInfo {
    
    static let publicKey = "PUBLIC_KEY"
    static let privateKey = "PRIVATE_KEY"
    
}
```


---