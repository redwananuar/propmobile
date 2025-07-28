# 🔗 Technician Authentication Setup Guide

## 🎯 **Goal**
Use the email from your `contacts` table where `type` is 'technician' for authentication in the mobile app.

## 📋 **How It Works**
1. **Contacts Table** - Contains technician information with email and type='technician'
2. **Supabase Auth** - Users log in with email/password
3. **Validation** - App checks if the email exists in contacts table as a technician
4. **Work Orders** - App uses the contact ID to fetch assigned work orders

## 🔧 **Setup Steps**

### Step 1: Verify Your Contacts Table
Make sure your `contacts` table has technicians with these fields:
- `id` (UUID)
- `name` (TEXT)
- `email` (TEXT) 
- `type` (TEXT) = 'technician'
- `phone` (TEXT, optional)

### Step 2: Create Supabase Auth Users
For each technician in your contacts table, create a corresponding user in Supabase Auth:

1. **Go to Supabase Dashboard**
2. **Navigate to Authentication → Users**
3. **Click "Add User"** for each technician
4. **Use the same email** that exists in your contacts table
5. **Set a password** for each technician

**Example:**
```
Contacts Table:
- Name: "John Smith"
- Email: "john.smith@company.com" 
- Type: "technician"

Supabase Auth:
- Email: "john.smith@company.com"
- Password: "password123"
```

### Step 3: Update Work Order Table (if needed)
Make sure your `work_order` table uses the contact ID from the contacts table:

```sql
-- Check current technician IDs in work_order table
SELECT DISTINCT "technicianId" FROM work_order;

-- Update if needed to match contact IDs
UPDATE work_order 
SET "technicianId" = 'contact-id-from-contacts-table'
WHERE "technicianId" = 'old-technician-id';
```

## 🧪 **Testing the Setup**

### Step 1: Test Login
1. Open the Flutter app
2. Login with a technician's email from your contacts table
3. Use the password you set in Supabase Auth

### Step 2: Verify Work Orders
- After login, you should see work orders assigned to that technician
- The app automatically validates the user is a technician
- Only technicians can access the app

## 🔍 **Troubleshooting**

### Issue: "Access denied. Only technicians can use this app."
- Check that the email exists in your contacts table
- Verify the contact has `type = 'technician'`
- Ensure the email matches exactly (case-sensitive)

### Issue: "Authentication failed"
- Verify the user exists in Supabase Auth
- Check email/password is correct
- Ensure email is confirmed in Supabase Auth

### Issue: "No work orders found"
- Check that the `technicianId` in work_order table matches the contact ID
- Verify RLS policies allow the user to see their work orders

### Issue: "Technician not found"
- Check that the email exists in contacts table
- Verify the contact has type='technician'
- Check for typos in email addresses

## 📱 **App Features After Setup**

✅ **Login** - Technicians use email/password from contacts table  
✅ **Validation** - Only technicians can access the app  
✅ **Work Orders** - See only assigned work orders  
✅ **Status Updates** - Update work order status  
✅ **Comments** - Add comments to work orders  
✅ **Security** - RLS ensures technicians only see their work  

## 🚀 **Next Steps**

1. **Verify your contacts table** has technicians with correct emails
2. **Create Supabase Auth users** with matching emails
3. **Test the login** with technician credentials
4. **Verify work orders** are displayed correctly

## 📋 **Example Contacts Table Structure**

```sql
-- Example technician records in contacts table
INSERT INTO contacts (id, name, email, type, phone) VALUES
('tech-1-id', 'John Smith', 'john.smith@company.com', 'technician', '+1234567890'),
('tech-2-id', 'Jane Doe', 'jane.doe@company.com', 'technician', '+1234567891'),
('tech-3-id', 'Bob Wilson', 'bob.wilson@company.com', 'technician', '+1234567892');
```

The app is now ready to use with your contacts table for authentication! 