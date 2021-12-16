//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by TTN on 03/12/21.
//

import UIKit
import AVFoundation

class PlayerViewController: UIViewController {
    
    public var position: Int = 0
    public var songs: [Song] = []
    
    // singleton
    static let shared = PlayerViewController()
    
    @IBOutlet var holderView: UIView!
    
    var player: AVAudioPlayer?
    
    var queuePlayer: AVQueuePlayer?
    
    // user interface elements
    
    ///Also this pattern to create this is called anonymous closure
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0 //line wrap
        return label
    }()
    
    
    let playPauseButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if holderView.subviews.count == 0 {
            configure()
        }
    }
    
    func playerConfiguration(for songAtIndex: Int) {
        //MARK:- Player
        
        if songs.count == 0 {
            print("The songs are not present.")
            return
        }
        let song = songs[songAtIndex]
        
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else {
                return
            }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            
            guard let player = player else {
                return
            }
            
            player.volume = 0.5
            
            player.play()
            
        } catch {
            print("Error Occured")
        }
    }
    
    func configure() {
        
        let song = songs[position]
        
        // this is for AVAudioPlayer
        // playerConfiguration(for: position)
        
        // this for AVQueuePlayer
        configurationAVQueuePlayer(forSongAt: position)
        
        //MARK:- User Interface Elements
        
        // album cover
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holderView.frame.size.width - 20,
                                      height: holderView.frame.size.width - 20)
        
        albumImageView.image = UIImage(named: song.songCover)
        holderView.addSubview(albumImageView)
        
        // labels: order - song name, album, artist
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: holderView.frame.size.width - 20,
                                     height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height + 10 + 70,
                                      width: holderView.frame.size.width - 20,
                                      height: 70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 140,
                                       width: holderView.frame.size.width - 20,
                                       height: 70)
        
        songNameLabel.text = song.songName
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
        holderView.addSubview(songNameLabel)
        holderView.addSubview(albumNameLabel)
        holderView.addSubview(artistNameLabel)
        
        //player controls
        
        
        let nextButton =  UIButton()
        let backButton =  UIButton()
        
        // Button Frames
        
        let yPosition = artistNameLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        
        playPauseButton.frame = CGRect(x: (holderView.frame.size.width - size) / 2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: holderView.frame.size.width - size - 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        // Add Actions
        playPauseButton.addTarget(self, action: #selector(didTapPlayPauseButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        
        // Button Styling
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        
        playPauseButton.tintColor = .black
        backButton.tintColor = .black
        nextButton.tintColor = .black
        
        holderView.addSubview(playPauseButton)
        holderView.addSubview(nextButton)
        holderView.addSubview(backButton)
        
        //slider
        let slider = UISlider(
            frame: CGRect(x: 20,
                          y: holderView.frame.size.height - 60,
                          width: holderView.frame.size.height - 40,
                          height: 50
            ))
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
        
        holderView.addSubview(slider)
    }
    
    @objc func didTapBackButton() {
        if position > 0{
            position -= 1
            player?.stop()
            
            for subview in holderView.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextButton() {
        if position < (songs.count - 1) {
            position += 1
            player?.stop()
            
            for subview in holderView.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayPauseButton() {
        if player?.isPlaying == true {
            player?.pause()
            
            // show play button
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            
            // shrink image on pause
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holderView.frame.size.width - 60,
                                                   height: self.holderView.frame.size.width - 60)
            })
            
        } else {
            player?.play()
            
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
            
            // increase image size
            UIView.animate(withDuration: 0.2, animations: {
                self.albumImageView.frame = CGRect(x: 10,
                                                   y: 10,
                                                   width: self.holderView.frame.size.width - 20,
                                                   height: self.holderView.frame.size.width - 20)
            })
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        
        //adjust player audio
        
        player?.volume = value
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if let player = player {
            player.stop()
        }
    }
}

//MARK:- Implementation for AVQueuePlayer

extension PlayerViewController {
    func convertToAVMediaItems(forSongs songs: [Song]) -> [AVPlayerItem] { // return an array of AVMediaItems
        
        var avPlayerItems: [AVPlayerItem] = []
        
        
        
        for song in songs {
            let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
            
            avPlayerItems.append(AVPlayerItem(url: URL(fileURLWithPath: urlString!)))
        }
        print("These are the player items ========================")
        print(avPlayerItems)
        return avPlayerItems
    }
    
    func configurationAVQueuePlayer(forSongAt index: Int) {
        
        let avPlayerItems = convertToAVMediaItems(forSongs: songs)
        
        if queuePlayer == nil {
            queuePlayer = AVQueuePlayer(items: avPlayerItems)
        } else {
            // stop the player and remove all items
            queuePlayer?.removeAllItems()
            
            for item in avPlayerItems {
                queuePlayer?.insert(item, after: nil)
            }
        }
        
        // print("These are the player items ==========")
        // print(queuePlayer?.items())
        
        queuePlayer?.seek(to: .zero)
        
        queuePlayer?.play()
        
    }
}



// MARK:- PlayerController class for AVQueuePlayer

class PlayerControl: UIView {
    var player: AVQueuePlayer? {
            get {
                return playerLayer.player as? AVQueuePlayer
            }
            set {
                playerLayer.player = newValue
            }
        }
        
        var playerLayer: AVPlayerLayer {
            return layer as! AVPlayerLayer
        }
        
        // Override UIView property
        override static var layerClass: AnyClass {
            return AVPlayerLayer.self
        }
}
