# 06-Audio-Player

### No Storyboard, no UITableView

The audio player loads songs from the bundle and takes metadata (artwork, title, artist) from each song.  
The audio player plays songs in the background and displays the current song on the lock screen and in the control panel.  
It also allows for playback control from the remote control panel.  
Users can change playback mode (once, repeat one, repeat playlist, shuffle) and system volume.  
The time slider changes the current playing time.

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
