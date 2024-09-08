import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool flag=false;
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? selectedSongName;
  String? selectedSongUrl;
  String? selectedSongImage;
  Color? likedcolor;
  bool isPlaying = false;
  Duration songDuration = Duration.zero;
  Duration currentPosition = Duration.zero;
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  bool hasResults = true;
  var favouritesongs=[];
  @override
  void initState() {
    super.initState();
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        songDuration = d;
      });
    });
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() {
        currentPosition = p;
      });
    });
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> searchSongs(String query) async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = 'https://itunes.apple.com/search?term=$query&limit=10&entity=musicTrack';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];

        if (results.isNotEmpty) {
          final newSongs = results.map((song) {
            return {
              'image': song['artworkUrl100'] as String? ?? '',
              'name': song['trackName'] as String? ?? '',
              'url': song['previewUrl'] as String? ?? '',
              'artist': song['artistName'] as String? ?? 'Unknown Artist',
              'liked':Colors.grey
            };
          }).toList();

          setState(() {
            searchResults = newSongs;
            hasResults = newSongs.isNotEmpty;
          });
        } else {
          setState(() {
            hasResults = false;
          });
        }
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error searching songs: $e');
      setState(() {
        hasResults = false;
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _playPauseSong(String url) async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(url));
      }
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void _seekToPosition(double seconds) {
    _audioPlayer.seek(Duration(seconds: seconds.toInt()));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 13.0,right: 12),
      child: Column(
        children: [
          TextField(
            cursorOpacityAnimates: true,
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for songs',
              labelStyle: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: App_Colors.primary
                  )
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(
                      color: App_Colors.primary
                  )
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  if (_searchController.text.isNotEmpty) {
                    searchSongs(_searchController.text);
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator(color: App_Colors.primary,))
                : hasResults
                ? ListView.builder(
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final song = searchResults[index];
                return Card(
                  child: ListTile(

                    leading: song['image']!.isNotEmpty
                        ? Image.network(
                      song['image']!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        );
                      },
                    )
                        : Icon(Icons.music_note, size: 50, color: Colors.grey),
                    title: Text(song['name']!,style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(song['artist'] ?? 'Unknown Artist'),
                      trailing: InkWell(
                        onTap: () {
                          setState((){
                            if (song['liked'] == Colors.grey) {
                              favouritesongs.add(song);
                              song['liked'] = Colors.red;
                              savefavourites(favouritesongs);
                            } else {
                              song['liked'] = Colors.grey;
                              favouritesongs.remove(song);
                              savefavourites(favouritesongs);
                            }
                          });
                        },
                        child: FaIcon(FontAwesomeIcons.solidHeart, color: song['liked']),
                      ),

                    onTap: () {
                      setState(() {
                        selectedSongName = song['name'];
                        selectedSongUrl = song['url'];
                        selectedSongImage = song['image'];
                        if (selectedSongUrl != null) {
                          _playPauseSong(selectedSongUrl!);
                        }
                      });
                    },
                  ),
                );
              },
            )
                : Center(child: Text('No song found')),
          ),
          if (selectedSongName != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    if (selectedSongImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          selectedSongImage!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '   '+selectedSongName!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,
                            ),
                          ),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              trackHeight: 2.0,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
                              overlayShape: RoundSliderOverlayShape(overlayRadius: 14.0),
                            ),
                            child: Slider(
                              value: currentPosition.inSeconds.toDouble(),
                              min: 0,
                              max: songDuration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _seekToPosition(value);
                              },
                              activeColor: App_Colors.primary,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "    ${currentPosition.inMinutes}:${(currentPosition.inSeconds % 60).toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 12, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                              ),
                              Text(
                                "${songDuration.inMinutes}:${(songDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                                style: TextStyle(fontSize: 12, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.black,
                      ),
                      iconSize: 24,
                      onPressed: () {
                        if (selectedSongUrl != null) {
                          _playPauseSong(selectedSongUrl!);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void savefavourites(var list) async{
    var prefs=await SharedPreferences.getInstance();
    String favourite=jsonEncode(list);
    prefs.setString('Favourites',favourite);
  }
}
