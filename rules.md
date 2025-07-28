# 🔧 Flutter Mobile App for Technicians (Supabase Backend)

## 🎯 Purpose
Build a mobile app in **Flutter** for **technicians** to:
- View their assigned work orders
- Update the status (in_progress, completed, delayed)
- Add notes about the job
- (Later) Upload photos

The app connects to an existing **Supabase backend** used by our web app (built with React + TypeScript).

---

## 📦 Tech Stack
- Backend: Supabase (PostgreSQL + Row Level Security)
- Auth: Supabase Auth (email/password)
- Database Table: `work_orders`
- Mobile App: Flutter
- State Management: Riverpod
- Networking: Use `supabase_flutter` SDK
- Folder structure: `lib/features/`, `lib/core/`, `lib/common/`

---

## ✅ Work Order Table (Simplified)
Table name: `work_orders`

Fields:
- `id: uuid`
- `title: string`
- `description: text`
- `status: enum (new, in_progress, completed, delayed)`
- `technician_id: uuid (FK to auth.users.id)`
- `notes: text`
- `updated_at: timestamp`

---

## 🔐 Security
- Technicians should **only see work orders assigned to them**
- RLS policies are already configured in Supabase for this

---

## ✅ MVP Features
- [ ] Login (Supabase Auth - email/password)
- [ ] View list of assigned work orders
- [ ] Tap work order to see details
- [ ] Update status and notes
- [ ] Logout

---

## 🧭 UI Design
Simple Material 3 layout:
- Login Screen
- Work Order List: cards showing title, short description, status
- Work Order Detail: full info + status dropdown + notes field
- Snackbar or toast for success/failure messages

---

## 📚 Libraries to Use
- `supabase_flutter`
- `flutter_riverpod`
- `flutter_hooks` (optional)
- `image_picker` (future)

---

## 🧩 Rules
- Use Riverpod for state management
- Use Supabase client directly (no Dio/REST for now)
- Token/session managed using Supabase SDK
- Store code in modular folders: `features/`, `core/`, etc.
- Handle loading and error states gracefully
- Code should be clean and readable

---

## 🔜 Optional (Future)
- Upload photos (using Supabase Storage)
- Push notifications (when new work order is assigned)
- Dark mode

