import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/api_service.dart';
import 'package:latihan_5/Notifikasi/ApiNotifikasi/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final ApiService1 apiService;
  final FirebaseFirestore firestore;

  NotificationService({required this.apiService, required this.firestore});

  // Inisialisasi notifikasi
  void initializeNotifications() {
    AwesomeNotifications().initialize('resource://drawable/res_app_icon', [
      NotificationChannel(
        channelKey: 'movie_updates_channel',
        channelName: 'Movie Updates',
        channelDescription: 'Notifications for movie updates',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
      )
    ]);
  }

  Future<void> checkForMovieUpdates() async {
    await checkAndNotifyUpcomingMovies();
    await checkAndNotifyNowPlayingMovies();
  }

  Future<void> checkAndNotifyUpcomingMovies() async {
    List<Movie> upcomingMovies = await ApiService1.getUpcomingMovies();
    for (var movie in upcomingMovies) {
      await _checkAndNotify(movie, 'upcoming');
    }
  }

  Future<void> checkAndNotifyNowPlayingMovies() async {
    List<Movie> nowPlayingMovies = await ApiService1.getNowPlayingMovies();
    for (var movie in nowPlayingMovies) {
      await _checkAndNotify(movie, 'now_playing');
    }
  }

  Future<void> _checkAndNotify(Movie movie, String type) async {
    bool notified = await _isMovieNotified(movie.id, type);
    bool isNowPlaying = type == 'now_playing';

    if (!notified && isNowPlaying) {
      await showNotification(movie.title);
      await _markMovieAsNotified(movie.id, type);
    } else if (!notified && !isNowPlaying) {
      await _markMovieAsNotified(movie.id, type);
    }
  }

  Future<bool> _isMovieNotified(int movieId, String type) async {
    DocumentSnapshot doc = await firestore.collection(type).doc(movieId.toString()).get();
    return doc.exists;
  }

  Future<void> _markMovieAsNotified(int movieId, String type) async {
    await firestore.collection(type).doc(movieId.toString()).set({'notified': true});
  }

  Future<void> showNotification(String title) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'movie_updates_channel',
        title: 'Film ${title} telah tayang di bioskop terdekat!',
        body: 'Ayo saksikan segera film yang Anda tunggu-tunggu!',
        notificationLayout: NotificationLayout.Default,
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