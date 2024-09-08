import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:moodhub/presentation/home/widgets/Search_song.dart';
import 'package:moodhub/presentation/home/widgets/new_songs.dart';
import 'package:moodhub/presentation/intro/pages/GetStarted.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../Core/Configs/Theme/App_colors.dart';
import '../../ChooseMode/bloc/Theme_cubit.dart';
import '../../home/widgets/Helper_AI.dart';

class RootPage extends StatefulWidget {
  final String email;
  RootPage(this.email);

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _selectedIndex = 0;
  String? username;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool _showControls = false; // Track if controls should be shown
  Duration _currentPosition = Duration.zero;
  Duration _duration = Duration.zero;
  double iopacity = 1.0;

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  Future<void> loadUsername() async {
    String fetchedUsername = await getusername(widget.email);
    setState(() {
      username = fetchedUsername;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _playSong(String url) async {
    try {
      if (isPlaying) {
        await _audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      } else {
        await _audioPlayer.play(UrlSource(url));
        setState(() {
          isPlaying = true;
        });
      }

      _audioPlayer.onPositionChanged.listen((position) {
        setState(() {
          _currentPosition = position;
        });
      });

      _audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _duration = duration;
        });
      });
    } catch (e) {
      print('Error playing song: $e');
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.light
            ? App_Colors.lightbackground
            : Colors.black,
        title: Padding(
          padding: const EdgeInsets.only(top: 2.0),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo_melodify.png',
                height: 40,
                width: 45,
                color: App_Colors.primary,
              ),
              Text(
                'Melodify',
                style: TextStyle(
                    fontFamily: 'Satoshi',
                    color: App_Colors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    decoration: TextDecoration.none),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    context.read<ThemeCubit>().UpdateTheme(ThemeMode.light);
                  } else {
                    context.read<ThemeCubit>().UpdateTheme(ThemeMode.dark);
                  }
                },
                child: Icon(
                  Theme.of(context).brightness == Brightness.dark
                      ? Icons.light_mode_outlined
                      : Icons.nightlight_outlined,
                  size: 35,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? App_Colors.lightbackground
                      : App_Colors.Darkbackground,
                ),
              ),
              SizedBox(width: 20),
              InkWell(
                onTap: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GetStartedPage()),
                  );
                },
                child: Icon(
                  Icons.logout,
                  size: 35,
                  color: Theme.of(context).brightness == Brightness.dark
                      ? App_Colors.lightbackground
                      : App_Colors.Darkbackground,
                ),
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          if(_selectedIndex==0)
            Row(
              children: [
                SizedBox(width: 30),
                Text(
                  'Hello, ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    fontSize: 22,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? App_Colors.lightbackground
                        : App_Colors.Darkbackground,
                    fontFamily: 'Satoshi',
                  ),
                ),
                Expanded(
                  child: Text(
                    username ?? 'Loading...',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? App_Colors.lightbackground
                          : App_Colors.Darkbackground,
                      fontWeight: FontWeight.w900,
                      fontSize: 30,
                    ),
                  ),
                )
              ],
            ),
          if (_selectedIndex == 0) // Show mini player only on Songs page
            GestureDetector(
              onTap: () {
                setState(() {
                  iopacity = iopacity == 1.0 ? 0.5 : 1.0;
                });
                _toggleControls();
                _playSong(
                    'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/60/c7/42/60c742fd-00a9-0270-0f61-5a4aa8bb711b/mzaf_16002515420280823118.plus.aac.p.m4a');
              },
              child: Container(
                height: 180,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 160,
                        width: 350,
                        decoration: BoxDecoration(
                          color: App_Colors.primary.withOpacity(iopacity),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50,
                      top: 30,
                      child: Container(
                        width: 140,
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('New Album', style: TextStyle(fontWeight: FontWeight.w400)),
                            Text(
                              'Smoke ',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 28),
                            ),
                            Text(
                              'Up ',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 27),
                            ),
                            Text(
                              'Snoop Dogg',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 3,
                      left: 120,
                      child: Image.asset(
                        'assets/images/music_artist.png',
                        height: 182,
                        width: 300,
                      ),
                    ),
                    if (_showControls)
                      Positioned(
                        bottom: 10,
                        left: 20,
                        right: 20,
                        child: Column(
                          children: [
                            Slider(
                              value: _currentPosition.inSeconds.toDouble(),
                              min: 0.0,
                              max: _duration.inSeconds.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  _currentPosition = Duration(seconds: value.toInt());
                                });
                                _audioPlayer.seek(_currentPosition);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    isPlaying ? Icons.pause : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _playSong(
                                        'https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview211/v4/60/c7/42/60c742fd-00a9-0270-0f61-5a4aa8bb711b/mzaf_16002515420280823118.plus.aac.p.m4a');
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.stop,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await _audioPlayer.stop();
                                    setState(() {
                                      isPlaying = false;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: [
                NewSongs(),
                SearchPage(),
                helperAI(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showUnselectedLabels: false,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Songs',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.robot),
            label: 'AI',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: App_Colors.primary,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<String> getusername(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(email);
    return username ?? '';
  }
}
