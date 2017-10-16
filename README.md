# PlayListPlayer
<a href="https://travis-ci.org/nerd0geek1/PlayListPlayer"><img src="https://img.shields.io/travis/nerd0geek1/PlayListPlayer/master.svg"></a>
<a href="https://github.com/Carthage/Carthage/"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat"></a>
<a href="http://cocoadocs.org/docsets/PlayListPlayer"><img src="https://img.shields.io/cocoapods/v/PlayListPlayer.svg?style=flat"></a>

PlayListPlayer is `AVPlayer` wrapper module to simplify playing audio/movie file using `AVPlayer` and `AVPlayerLayer`.

## How to use
```Swift
//assign audio movie files to Player
let url1: URL = URL(string: "...")!
let url2: URL = URL(string: "...")!
let url3: URL = URL(string: "...")!
PlayListPlayer.shared.set(playList: [url1, url2, url3])

//setup MovieRenderingView(If you want to play video file)
let movieRenderingView: MovieRenderingView = MovieRenderingView()
view.addSubView(movieRenderingView)
movieRenderingView.set(player: player)

//start playing
PlayListPlayer.shared.play()
```

`PlayListPlayerSample` is sample project which includes above files, so please refer it if needed.  
You can confirm screen like below with sample project.  
<img src="https://raw.githubusercontent.com/nerd0geek1/PlayListPlayer/master/images/sample_project.png" width="320px">

## Requirements
- iOS 10.0+
- Xcode 9.0 or above

PlayListPlayer is now supporting Swift4.

## Installation

### CocoaPods
To integrate PlayListPlayer into your Xcode project using CocoaPods, specify it in your Podfile:
```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

project 'YOUR_PROJECT_NAME'

target 'YOUR_TARGET_NAME' do
  use_frameworks!

  pod 'PlayListPlayer'
end
```

Then, run the following command:

``` bash
$ pod install
```


### Carthage
To integrate PlayListPlayer into your Xcode project using Carthage, specify it in your Cartfile:
```
github "nerd0geek1/PlayListPlayer"
```

Then, run the following command:
```
$ carthage update
```

## Audio/Movie file License
Sample Audio files in this project are provided by Bensound:  
http://www.bensound.com/royalty-free-music

Sample Movie files in this project are provided by PEXELS VIDEOS  
https://videos.pexels.com/

For sample audio/movie files, please obey these sites license.  
[Bensound Licensing](http://www.bensound.com/licensing)  
[PEXELS VIDEOS Video License](https://videos.pexels.com/video-license)

## License
This software is Open Source under the MIT license, see LICENSE for details.
