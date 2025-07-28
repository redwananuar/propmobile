# PropManager Technician Mobile App

A Flutter mobile application for technicians to manage their assigned work orders. Built with Supabase backend and Riverpod for state management.

## 🎯 Features

- **Authentication**: Email/password login using Supabase Auth
- **Work Orders Management**: View and update assigned work orders
- **Status Updates**: Change work order status (new, in_progress, completed, delayed)
- **Notes**: Add and update notes for each work order
- **Real-time Updates**: Automatic refresh and state management
- **Modern UI**: Material 3 design with clean, intuitive interface

## 📦 Tech Stack

- **Frontend**: Flutter
- **Backend**: Supabase (PostgreSQL + Row Level Security)
- **Authentication**: Supabase Auth
- **State Management**: Riverpod
- **Database**: PostgreSQL with RLS policies
- **Architecture**: Feature-based folder structure

## 🗂️ Project Structure

```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart
│   ├── models/
│   │   ├── work_order.dart
│   │   └── contact.dart
│   ├── services/
│   │   ├── auth_service.dart
│   │   ├── work_orders_service.dart
│   │   └── contacts_service.dart
│   └── providers/
│       └── providers.dart
├── features/
│   ├── auth/
│   │   └── login_screen.dart
│   └── work_orders/
│       ├── work_orders_list_screen.dart
│       └── work_order_detail_screen.dart
└── common/
    ├── widgets/
    └── utils/
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Android Studio / VS Code
- Supabase account and project

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd flutter-propmanager
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   
   Create a `.env` file in the project root (optional) or set environment variables:
   ```bash
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

   Alternatively, update the values in `lib/core/config/supabase_config.dart`:
   ```dart
   static const String supabaseUrl = 'YOUR_SUPABASE_URL';
   static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
   ```

4. **Database Setup**

   Ensure your Supabase project has the following tables:

   **work_orders table:**
   ```sql
   CREATE TABLE work_orders (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     title TEXT NOT NULL,
     description TEXT NOT NULL,
     status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'in_progress', 'completed', 'delayed')),
     technician_id UUID REFERENCES auth.users(id),
     notes TEXT,
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );
   ```

   **contacts table:**
   ```sql
   CREATE TABLE contacts (
     id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
     name TEXT NOT NULL,
     email TEXT NOT NULL,
     type TEXT NOT NULL DEFAULT 'customer' CHECK (type IN ('customer', 'technician', 'admin')),
     phone TEXT,
     created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
     updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
   );
   ```

5. **Row Level Security (RLS) Policies**

   Enable RLS and create policies for work_orders:
   ```sql
   ALTER TABLE work_orders ENABLE ROW LEVEL SECURITY;
   
   CREATE POLICY "Technicians can view their own work orders"
   ON work_orders FOR SELECT
   USING (auth.uid() = technician_id);
   
   CREATE POLICY "Technicians can update their own work orders"
   ON work_orders FOR UPDATE
   USING (auth.uid() = technician_id);
   ```

6. **Run the app**
   ```bash
   flutter run
   ```

## 🔐 Authentication

The app uses Supabase Auth for authentication. Technicians should be created as users in Supabase Auth and their user ID should be referenced in the `work_orders.technician_id` field.

## 📱 App Flow

1. **Login Screen**: Technicians enter their email and password
2. **Work Orders List**: Shows all work orders assigned to the logged-in technician
3. **Work Order Detail**: View full details and update status/notes
4. **Logout**: Available from the app bar

## 🎨 UI Components

- **Login Screen**: Clean form with email/password fields
- **Work Order Cards**: Display title, description, status, and last updated time
- **Detail Screen**: Full work order information with status dropdown and notes field
- **Status Indicators**: Color-coded status badges
- **Loading States**: Proper loading indicators and error handling

## 🔧 Development

### Adding New Features

1. Create models in `lib/core/models/`
2. Add services in `lib/core/services/`
3. Create providers in `lib/core/providers/`
4. Build UI screens in `lib/features/`

### State Management

The app uses Riverpod for state management:
- `authServiceProvider`: Authentication service
- `workOrdersServiceProvider`: Work orders operations
- `contactsServiceProvider`: Contacts/technicians operations
- `currentUserProvider`: Current authenticated user
- `workOrdersProvider`: Work orders for current technician

## 🚀 Future Enhancements

- [ ] Photo upload functionality
- [ ] Push notifications for new work orders
- [ ] Offline support
- [ ] Dark mode
- [ ] Work order filtering and search
- [ ] Technician profile management

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support, please contact the development team or create an issue in the repository.
