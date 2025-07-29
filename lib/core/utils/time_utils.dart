class TimeUtils {
  static String getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${(difference.inDays / 7).floor()} weeks ago';
      }
    } else if (difference.inHours > 0) {
      if (difference.inHours == 1) {
        return '1 hour ago';
      } else {
        return '${difference.inHours} hours ago';
      }
    } else if (difference.inMinutes > 0) {
      if (difference.inMinutes == 1) {
        return '1 minute ago';
      } else {
        return '${difference.inMinutes} minutes ago';
      }
    } else {
      return 'Just now';
    }
  }

  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String getFormattedDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
} 