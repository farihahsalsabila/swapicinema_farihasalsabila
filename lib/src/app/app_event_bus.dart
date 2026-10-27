import 'package:event_bus/event_bus.dart';

final eventBus = EventBus();

class MovieReminderEvent {
  final String movieTitle;
  MovieReminderEvent(this.movieTitle);
}