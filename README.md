# 06-Audio-Player

### Education project (No storyboard, No UITableView)

The audio player loads the songs from the bundle. 
Takes metadata (artwork, title, artist) from each song. 
Plays in the background. Displays the current song on the lock screen and in the control panel. 
Playback control from remote control panel. Change playback mode (once, repeat one, repeat playlist, shuffle). 
Change system volume. Seek slider changes current playing time

| Used UI Elements | Additionally |
--- | ---
| `UINavigationController` | `AVAudioPlayer`
| `UILabel` | `AVAsset`
| `UIButton` | `AVAudioSession`
| `UIImageView` | `MPVolumeView`
| `UIImage` | `MPNowPlayingInfoCenter`
| `UITapGestureRecognizer` | `CALayer`
| `UIView` | `NSLayoutConstraint`
| `UISlider` | `NSAttributedString`
| `UIStackView` | `UIButton.Configuration`
| `UIScrollView` | `DateFormatter`
| `UIEvent` | `NotificationCenter`
| `UIVisualEffectView` | `Timer`
| `UIBlurEffect` | `KVO`
<br>

<img src="https://user-images.githubusercontent.com/80542175/178109948-6081458f-79c6-4026-bb0d-0c925cfc21c3.gif" height=640 width=296><img src="https://user-images.githubusercontent.com/80542175/178109956-155bdd95-463d-4b3b-9e73-005b0669945b.gif" height=640 width=296><img src="https://user-images.githubusercontent.com/80542175/178109962-f792681b-6245-4e71-ac27-0c79e75796e2.gif" height=640 width=296><img src="https://user-images.githubusercontent.com/80542175/178110318-2ea8eae0-7c4d-4b1e-9773-abf727efbf24.gif" height=640 width=296>
