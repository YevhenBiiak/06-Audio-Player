## 06-Audio-Player 
(No Storyboard, no UITableView)

<p align=center>
  <img width=30% src="https://user-images.githubusercontent.com/80542175/226969885-b2cb5e59-f79c-4b80-b6c3-5a5e6ff09606.png">
  <img width=30% src="https://user-images.githubusercontent.com/80542175/226969896-4b445a83-0dc8-4ca8-8cb0-c39f74843e43.png">
  <img width=30% src="https://user-images.githubusercontent.com/80542175/226969903-533a6554-abff-49f9-b609-d80abb25a3e8.png">
</p>

#### Description:
This project is an audio player app that allows users to play music from their device's local storage. The app loads songs from the main bundle using the Storage class, which uses the `AVFoundation` framework to extract metadata from the songs, such as title, artist, and artwork. The app supports remote control events, such as play, pause, next, and previous.

## Features:

- Play/pause, skip forward/backward;
- Play music in the background;
- Change the system volume;
- Supports remote control;
- Display the current song's title, artist, and artwork;
- Display a playlist of all available songs;
- Choose from four different play modes: repeat playlist, repeat song, shuffle, and once;
- Seek through a song using a slider.

## Used Frameworks:

- `UIKit` for creating the user interface and handling user interactions;
- `AVFoundation` for playing audio and extracting metadata from audio files;
- `MediaPlayer` for controlling the system's audio output volume.

<details><summary>Used classes</summary>

| UI Elements | Additionally |
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
</details>

## Used Technology Stack:

- `Swift` programming language (lazy variables, closures, and extensions);
- Model-View-Controller (`MVC`) application architecture;
- `AVAudioPlayer` for playing music;
- Delegation pattern for communicating between classes and passing data;
- Observer pattern (`NSKeyValueObservation`) for monitoring changes in sound volume.

<details><summary><h2>GIF DEMO</h2></summary>
  <p align=center>
    <img width=23% src="https://user-images.githubusercontent.com/80542175/178109948-6081458f-79c6-4026-bb0d-0c925cfc21c3.gif">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/178109956-155bdd95-463d-4b3b-9e73-005b0669945b.gif">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/178109962-f792681b-6245-4e71-ac27-0c79e75796e2.gif">
    <img width=23% src="https://user-images.githubusercontent.com/80542175/178110318-2ea8eae0-7c4d-4b1e-9773-abf727efbf24.gif">
  </p>
</details>
