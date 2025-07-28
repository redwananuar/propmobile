import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://mxipptbikxycyloxispz.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im14aXBwdGJpa3h5Y3lsb3hpc3B6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTI1NDE4MzYsImV4cCI6MjA2ODExNzgzNn0.i7ULgU7sCHq6XJAEQdMxrkezublpkx6NVU9_mFVTsiw';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
} 