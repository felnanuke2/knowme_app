abstract class StreamEvent {}

class StreamEventCancel implements StreamEvent {}

class StreamEventUpdate implements StreamEvent {
  dynamic data;
}
