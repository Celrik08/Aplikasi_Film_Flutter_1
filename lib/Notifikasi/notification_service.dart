import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/models.dart';
import 'package:latihan_5/home_page.dart';
import 'package:latihan_5/main.dart';

class NotificationService {
  List<Movie> upcomingMovies = [];
  List<Movie> nowPlayingMovies = [];

  // Inisialisasi notifikasi
  void initializeNotifications() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'movie_updates_channel',
          channelName: 'Movie Updates',
          channelDescription: 'Notification channel for movie updates',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          playSound: true,
        ),
      ],
      debug: true,
    );

    // Periksa update film secara berkala
    checkForMovieUpdates();
  }

  Future<void> checkForMovieUpdates() async {
    try {
      final upcomingResponse = await ApiService.getUpcomingMovies();
      final nowPlayingResponse = await ApiService.getNowPlayingMovies();

      upcomingMovies = upcomingResponse.results;
      nowPlayingMovies = nowPlayingResponse.results;

      // Periksa film yang sedang tayang tetapi tidak ada dalam daftar upcoming
      for (var nowPlayingMovie in nowPlayingMovies) {
        if (!upcomingMovies.any((upcomingMovie) => upcomingMovie.id == nowPlayingMovie.id)) {
          _showNotification(
            nowPlayingMovie.id,
            'Film "${nowPlayingMovie.title}" sudah tayang di bioskop terdekat anda!',
          );
        }
      }
    } catch (e) {
      print('Error fetching movie data: $e');
    }
  }

  Future<void> _showNotification(int id, String body) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: id,
        channelKey: 'movie_updates_channel',
        title: 'Now Playing!',
        body: body,
        notificationLayout: NotificationLayout.Default,
        autoDismissible: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'OPEN_HOME',
          label: 'Buka Aplikasi',
          actionType: ActionType.Default,
        ),
      ],
    );
  }
}