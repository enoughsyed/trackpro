# Supabase Database Setup

## Steps to set up your database:

1. **Go to your Supabase Dashboard**: https://supabase.com/dashboard/projects

2. **Navigate to SQL Editor**: Click on "SQL Editor" in the left sidebar

3. **Run the SQL Script**: Copy and paste the contents of `backend/scripts/create_tables.sql` into the SQL editor and execute it.

4. **Verify Tables**: Go to "Table Editor" to verify all tables were created:
   - users
   - inspections  
   - finishing
   - quality_control
   - deliveries
   - tool_lists
   - notifications

## Default Users Created:
- **Admin**: testA1 / 1234
- **Supervisor**: testS1 / 1234  
- **Users**: testU1, testU2, testU3 / 1234

## Next Steps:
1. Run `flutter pub get` in the trackpro directory
2. Run `npm install` in the backend directory (if not done already)
3. Start the backend server: `npm start`
4. Run the Flutter app

## Key Changes Made:
- ✅ Replaced MongoDB with Supabase PostgreSQL
- ✅ Updated all backend routes to use Supabase
- ✅ Added Supabase Flutter dependency
- ✅ Created proper database schema with relationships
- ✅ Added Row Level Security policies
- ✅ Maintained all existing functionality

Your app is now ready to use Supabase!