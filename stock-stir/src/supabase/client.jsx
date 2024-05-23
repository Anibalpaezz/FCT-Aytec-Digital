import { createClient } from "@supabase/supabase-js";

export const client = createClient('https://ywtvzqvvjzzpkbduddux.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3dHZ6cXZ2anp6cGtiZHVkZHV4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTU2MDE4NjUsImV4cCI6MjAzMTE3Nzg2NX0.vnqRDAVv6i5FQwYnAx8BiXufAPqgmtvcC6uAhxJIwmw');

/* export const client = createClient(process.env.REACT_APP_SUPABASE_URL, process.env.REACT_APP_SUPABASE_URL_KEY); */