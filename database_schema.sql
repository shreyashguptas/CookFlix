-- Recipes table
create table recipes (
  id uuid primary key default uuid_generate_v4(),
  title text not null,
  summary text,
  image_name text,
  preparation_time text,
  cooking_time text,
  servings text,
  created_at timestamp with time zone default timezone('utc'::text, now()),
  user_id uuid references auth.users(id)
);

-- Ingredients table
create table ingredients (
  id uuid primary key default uuid_generate_v4(),
  recipe_id uuid references recipes(id) on delete cascade,
  name text not null,
  quantity double precision not null,
  unit text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);

-- Instructions table
create table instructions (
  id uuid primary key default uuid_generate_v4(),
  recipe_id uuid references recipes(id) on delete cascade,
  step_number integer not null,
  instruction text not null,
  created_at timestamp with time zone default timezone('utc'::text, now())
);