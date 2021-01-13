import UIKit

let tracks = ["a", "b", "c", "d", "e"]

let selectedTrack = "d"

func createPlaylistFromSelectedTrack(track: String, tracks: [String]) {
    var playlist = [String]()
    
    var priorTracks = [String]()
    
    for track in tracks {
        if track == selectedTrack || playlist.count > 0 {
            playlist.append(track)
            
        } else {
            priorTracks.append(track)
        }
    }
    
    return playlist = playlist + priorTracks
}

createPlaylistFromSelectedTrack(track: selectedTrack, tracks: tracks)


//func createPlaylistFromSelectedTrack2(track: String, tracks: [String]) {
//    var playlist = [String]()
//
//    if let index = tracks.firstIndex(of: selectedTrack) {
//        playlist = tracks.suffix(from: index) + tracks.prefix(upTo: index)
//    }
//
//    return
//}
//
//createPlaylistFromSelectedTrack2(track: selectedTrack, tracks: tracks)

