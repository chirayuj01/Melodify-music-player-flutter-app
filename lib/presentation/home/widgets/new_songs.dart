import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:moodhub/Core/Configs/Theme/App_colors.dart';

class NewSongs extends StatefulWidget {
  @override
  State<NewSongs> createState() => _NewSongsState();
}

class _NewSongsState extends State<NewSongs> {
  String? selectedSongName;
  String? selectedSongUrl;
  String? selectedSongImage;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration songDuration = Duration.zero;
  Duration currentPosition = Duration.zero;

  List<Map<String, String>> songsData = [];
  bool isLoading = false;
  bool hasMore = true;
  int limit = 5;
  String searchTerm = 'bollywood+latest+songs';
  String entityType = 'musicTrack';
  String country = 'in';
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _audioPlayer.onDurationChanged.listen((Duration d) {
      if (mounted) {
        setState(() {
          songDuration = d;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((Duration p) {
      if (mounted) {
        setState(() {
          currentPosition = p;
        });
      }
    });

    _scrollController.addListener(_scrollListener);
    fetchSongs();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!isLoading && hasMore) {
        fetchSongs();
      }
    }
  }

  Future<void> fetchSongs() async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url =
          'https://itunes.apple.com/search?term=$searchTerm&limit=$limit&country=$country&entity=$entityType';
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
            };
          }).toList();

          newSongs.shuffle();
          final uniqueSongs = newSongs.where((song) {
            return songsData.every((existingSong) => existingSong['name'] != song['name']);
          }).toList();

          if (mounted) {
            setState(() {
              songsData.addAll(uniqueSongs);
              hasMore = results.length == limit;
              isLoading = false;
              limit += 10;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              hasMore = false;
              isLoading = false;
            });
          }
        }
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error fetching songs: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
  Future<void> fetchRecommendedSongs(String songName) async {
    if (isLoading || !hasMore) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url = 'https://itunes.apple.com/search?term=$songName&limit=$limit&country=$country&entity=$entityType';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];

        if (results.isNotEmpty) {
          final recommendedSongs = results.map((song) {
            return {
              'image': song['artworkUrl100'] as String? ?? '',
              'name': song['trackName'] as String? ?? '',
              'url': song['previewUrl'] as String? ?? '',
              'artist': song['artistName'] as String? ?? 'Unknown Artist',
            };
          }).toList();

          recommendedSongs.shuffle();
          final uniqueSongs = recommendedSongs.where((song) {
            return songsData.every((existingSong) => existingSong['name'] != song['name']);
          }).toList();

          if (mounted) {
            setState(() {
              songsData.addAll(uniqueSongs);
              hasMore = results.length == limit;
              isLoading = false;
              limit += 10;
            });
          }
        } else {
          if (mounted) {
            setState(() {
              hasMore = false;
              isLoading = false;
            });
          }
        }
      } else {
        throw Exception('Failed to load songs');
      }
    } catch (e) {
      print('Error fetching recommended songs: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _playPauseSong(String url) async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.play(UrlSource(url));
      }
      if (mounted) {
        setState(() {
          isPlaying = !isPlaying;
        });
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
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0,right: 12.0),
            child: Text(
              '\" Let the music play and the good vibes take over... " ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Satoshi',
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            thickness: 1, // Thickness of the line
            color: Colors.grey.withOpacity(0.4), // Color of the line
            indent: 20, // Left indent
            endIndent: 10, // Right indent before text
          ),
          SizedBox(height: 10,),
          Text(
            '  Songs U\'d love ...',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              fontFamily: 'Satoshi',
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                controller: _scrollController,
                itemCount: songsData.length + 1,
                itemBuilder: (context, index) {
                  if (index == songsData.length) {
                    return isLoading
                        ? Center(child: CircularProgressIndicator(color: App_Colors.primary,))
                        : SizedBox.shrink(); // Empty widget when not loading
                  }

                  final song = songsData[index];
                  return Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                selectedSongName = song['name'];
                                selectedSongUrl = song['url'];
                                selectedSongImage = song['image'];
                                if (selectedSongUrl != null) {
                                  _playPauseSong(selectedSongUrl!);
                                }
                              });
                            }
                          },
                          child: song['image']!.isNotEmpty
                              ? Stack(
                            children: [
                              Image.network(
                                song['image']!,
                                width: 180,
                                height: 180,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade300,
                                    highlightColor: Colors.grey.shade100,
                                    child: Container(
                                      width: 200,
                                      height: 200,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey,
                                    width: 200,
                                    height: 200,
                                    child: Center(
                                      child: Icon(Icons.error, color: Colors.red),
                                    ),
                                  );
                                },
                              ),
                              Positioned(
                                top: 120,
                                left: 122,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: FaIcon(
                                      FontAwesomeIcons.solidPlayCircle,
                                      size: 45,
                                      color: App_Colors.Darkbackground,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Container(
                            width: 200,
                            height: 200,
                            color: Colors.grey,
                            child: Center(
                              child: Icon(Icons.error, color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          song['name']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          song['artist'] ?? 'Unknown Artist',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 6),
              ),
            ),
          ),
          if (selectedSongName != null)
            Container(
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
        ],
      ),
    );
  }
}
